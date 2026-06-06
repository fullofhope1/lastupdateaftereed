<?php
// includes/classes/SaleService.php

class SaleService extends BaseService
{
    private $saleRepo;
    private $purchaseRepo;
    private $customerRepo;
    private $leftoverRepo;
    private $unitService;

    public function __construct(
        SaleRepository $saleRepo,
        PurchaseRepository $purchaseRepo,
        CustomerRepository $customerRepo,
        LeftoverRepository $leftoverRepo,
        UnitSalesService $unitService
    ) {
        $this->saleRepo = $saleRepo;
        $this->purchaseRepo = $purchaseRepo;
        $this->customerRepo = $customerRepo;
        $this->leftoverRepo = $leftoverRepo;
        $this->unitService = $unitService;
    }

    public function getTodaysStock($date)
    {
        // 1. Fresh purchases for today
        $purchases = $this->purchaseRepo->getFreshStockByDate($date);
        $purchaseSales = $this->saleRepo->getSalesMap($date);
        
        $pSalesMap = [];
        foreach ($purchaseSales as $s) {
            $pSalesMap[$s['purchase_id']] = [
                'sold_kg' => (float)$s['sold_kg'],
                'sold_units' => (int)$s['sold_units']
            ];
        }

        $unified = [];
        foreach ($purchases as $p) {
            $sold = $pSalesMap[$p['id']] ?? ['sold_kg' => 0, 'sold_units' => 0];
            $unified[] = [
                'id' => $p['id'],
                'type' => 'purchase',
                'qat_type_id' => $p['qat_type_id'],
                'provider_name' => $p['provider_name'],
                'unit_type' => $p['unit_type'],
                'remaining_kg' => round((float)$p['quantity_kg'] - $sold['sold_kg'], 3),
                'remaining_units' => (int)$p['received_units'] - $sold['sold_units'],
                'status_label' => 'جديد (Fresh)'
            ];
        }

        // 2. Active leftovers available for today
        $leftovers = $this->leftoverRepo->getTransferredLeftovers();
        foreach ($leftovers as $l) {
            $soldKg    = (float)$this->saleRepo->getSoldKgByLeftoverId($l['id']);
            $soldUnits = (int)$this->saleRepo->getSoldUnitsByLeftoverId($l['id']);

            $remKg    = (float)$l['weight_kg'] - $soldKg;
            $remUnits = (int)$l['quantity_units'] - $soldUnits;

            if ($remKg > 0.001 || $remUnits > 0) {
                $label = 'بقايا';
                if ($l['status'] === 'Momsi_Day_1') { $label = 'المبيعة الأولى'; }
                if ($l['status'] === 'Momsi_Day_2') { $label = 'المبيعة الثانية'; }

                $unified[] = [
                    'id'              => $l['id'],
                    'type'            => 'leftover',
                    'status'          => $l['status'],
                    'qat_type_id'     => $l['qat_type_id'],
                    'provider_name'   => ($l['provider_name'] ?: 'بقايا عامة'),
                    'unit_type'       => $l['unit_type'],
                    'remaining_kg'    => round($remKg, 3),
                    'remaining_units' => $remUnits,
                    'status_label'    => $label,
                    'sale_date'       => $l['sale_date'],
                    'source_date'     => $l['source_date']
                ];
            }
        }

        return $unified;
    }

    public function getAvailableLeftoverStock()
    {
        return array_values(array_filter($this->getTodaysStock(getOperationalDate()), function($item) {
            return $item['type'] === 'leftover';
        }));
    }

    public function processSale(array $data)
    {
        $this->saleRepo->beginTransaction();
        try {
            $data['unit_type'] = $data['unit_type'] ?? 'weight';
            $data['quantity_units'] = (int)($data['quantity_units'] ?? 0);
            $data['due_date'] = $data['due_date'] ?? $data['sale_date']; // Default to today

            if ($data['unit_type'] === 'weight') {
                $weightKg = (float)($data['weight_grams'] ?? 0) / 1000;
                $data['weight_kg'] = $weightKg;

                // 1. Inventory Check (Weight)
                if (!empty($data['purchase_id'])) {
                    $totalPurchased = (float)$this->purchaseRepo->getStockQuantity($data['purchase_id'], true);
                    $totalSold = (float)$this->saleRepo->getSoldKgByPurchaseId($data['purchase_id']);
                    $available = round($totalPurchased - $totalSold, 3);

                    if ($weightKg > $available) {
                        $msg = "InventoryExceeded|Avail:{$available}|Req:{$weightKg}|TotalPurchased:{$totalPurchased}|TotalSold:{$totalSold}";
                        throw new Exception($msg);
                    }
                } elseif (!empty($data['leftover_id'])) {
                    $leftover = $this->leftoverRepo->getById($data['leftover_id']);
                    if (!$leftover) throw new Exception("LeftoverNotFound");
                    
                    // Logic Improvement: Automatically link this sale to the original purchase for performance tracking
                    if (!empty($leftover['purchase_id'])) {
                        $data['purchase_id'] = $leftover['purchase_id'];
                    }

                    $totalLeftover = (float)$leftover['weight_kg'];
                    $totalSold = (float)$this->saleRepo->getSoldKgByLeftoverId($data['leftover_id']);
                    $available = round($totalLeftover - $totalSold, 3);
                    
                    if ($weightKg > $available) {
                        throw new Exception("LeftoverExceeded|{$available}|{$weightKg}");
                    }
                }
            } else {
                // Unit-based sale (Qabdah / Qartas)
                $sourceType = !empty($data['purchase_id']) ? 'purchase' : 'leftover';
                $sourceId = !empty($data['purchase_id']) ? $data['purchase_id'] : $data['leftover_id'];

                $this->unitService->validateInventory($sourceType, $sourceId, $data['quantity_units']);
                $this->unitService->prepareSaleData($data);
            }

            // 2. Credit Limit Check
            // If no paid_amount is provided, determine default based on payment method
            if (!isset($data['paid_amount'])) {
                $data['paid_amount'] = ($data['payment_method'] === 'Debt') ? 0 : $data['price'];
            }
            
            $isPartial = (float)$data['price'] > (float)($data['paid_amount'] ?? 0);
            $debtAmount = 0;
            
            if ($isPartial) {
                if (($data['remaining_method'] ?? '') === 'Transfer' || $data['payment_method'] === 'Internal Transfer') {
                    // It's a Split Transfer (Cash + Transfer)
                    $data['payment_method'] = 'Split_Transfer';
                    $data['is_paid'] = 1;
                } else {
                    // It's a Split Debt (Cash + Debt) or pure Debt
                    $data['payment_method'] = 'Debt'; 
                    $data['is_paid'] = 0;
                    $debtAmount = (float)$data['price'] - (float)($data['paid_amount'] ?? 0);
                }
            } elseif ($data['payment_method'] === 'Debt') {
                $data['is_paid'] = 0;
                $debtAmount = (float)$data['price'];
            } else {
                $data['is_paid'] = 1;
            }

            if ($debtAmount > 0 && !empty($data['customer_id'])) {
                $cust = $this->customerRepo->getById($data['customer_id']);
                if ($cust) {
                    $newDebt = (float)$cust['total_debt'] + $debtAmount;
                    if ($cust['debt_limit'] !== null && $newDebt > $cust['debt_limit']) {
                        throw new Exception("CreditLimitExceeded|{$cust['debt_limit']}|{$cust['total_debt']}");
                    }
                }
            }

            // 3. Create Sale
            $saleId = $this->saleRepo->create($data);

            // 4. Update Customer Debt
            if ($debtAmount > 0 && !empty($data['customer_id'])) {
                $this->customerRepo->incrementDebt($data['customer_id'], $debtAmount);
            }
            
            // 5. Process Split Transfer
            if ($isPartial && $data['payment_method'] === 'Split_Transfer' && !empty($data['customer_id'])) {
                $transferAmount = (float)$data['price'] - (float)$data['paid_amount'];
                $this->saleRepo->insertTransferPayment(
                    $data['customer_id'],
                    $transferAmount,
                    $saleId,
                    $data['sale_date'],
                    $data['transfer_sender'] ?? null,
                    $data['transfer_receiver'] ?? null,
                    $data['transfer_number'] ?? null,
                    $data['transfer_company'] ?? null
                );
            }

            $this->saleRepo->commit();
            return $saleId;
        } catch (Exception $e) {
            $this->saleRepo->rollBack();
            throw $e;
        }
    }

    public function processReturn($saleId, $reason = "Manual Return")
    {
        $this->saleRepo->beginTransaction();
        try {
            $sale = $this->saleRepo->getById($saleId);
            if (!$sale) throw new Exception("SaleNotFound");
            if ($sale['is_returned']) throw new Exception("AlreadyReturned");

            // FIX #4: Same-day restriction — returns only allowed on today's sales
            $saleDate = date('Y-m-d', strtotime($sale['sale_date']));
            $today    = date('Y-m-d');
            if ($saleDate !== $today) {
                throw new Exception(
                    "المرتجعات مقبولة في نفس يوم البيع فقط. " .
                    "تاريخ الفاتورة: {$saleDate} — اليوم: {$today}"
                );
            }

            // 1. Restore Inventory
            $weightKg = (float)($sale['weight_grams'] ?? 0) / 1000;
            if (!empty($sale['purchase_id'])) {
                $this->purchaseRepo->restoreInventory($sale['purchase_id'], $weightKg, (int)$sale['quantity_units']);
            } elseif (!empty($sale['leftover_id'])) {
                $this->leftoverRepo->restoreInventory($sale['leftover_id'], $weightKg, (int)$sale['quantity_units']);
            }

            // FIX #6: Only reverse the REMAINING (unpaid) portion of the debt, not the full price
            if ($sale['payment_method'] === 'Debt' && !empty($sale['customer_id'])) {
                $remainingDebt = (float)$sale['price']
                    - (float)($sale['paid_amount'] ?? 0)
                    - (float)($sale['refund_amount'] ?? 0);
                $debtToReverse = max(0, $remainingDebt);
                if ($debtToReverse > 0) {
                    $this->customerRepo->decrementDebt($sale['customer_id'], $debtToReverse);
                }
            }

            // 3. Mark as Returned
            $this->saleRepo->markAsReturned($saleId);

            // 4. Log to refunds table
            $this->saleRepo->logReturn([
                'customer_id'    => $sale['customer_id'],
                'sale_id'        => $saleId,
                'refund_type'    => $sale['payment_method'],
                'amount'         => $sale['price'],
                'reason'         => $reason,
                'weight_kg'      => $weightKg,
                'quantity_units' => (int)$sale['quantity_units']
            ]);

            $this->saleRepo->commit();
            return true;
        } catch (Exception $e) {
            $this->saleRepo->rollBack();
            throw $e;
        }
    }

    public function editSale($saleId, array $newData)
    {
        $oldSale = $this->saleRepo->getById($saleId);
        if (!$oldSale) throw new Exception("SaleNotFound");
        
        $saleDate = date('Y-m-d', strtotime($oldSale['sale_date']));
        $today    = date('Y-m-d');
        if ($saleDate !== $today) {
            throw new Exception("التعديل مسموح فقط لمبيعات اليوم الحالي.");
        }

        // Return the old sale (this restores inventory and reverses debt)
        $this->processReturn($saleId, "تعديل فاتورة - إرجاع آلي للنسخة السابقة");

        // Construct new sale data by merging old fixed data with new editable data
        $saleData = [
            'purchase_id' => $oldSale['purchase_id'],
            'leftover_id' => $oldSale['leftover_id'],
            'qat_type_id' => $oldSale['qat_type_id'],
            'customer_id' => !empty($newData['customer_id']) ? $newData['customer_id'] : $oldSale['customer_id'],
            'weight_grams' => isset($newData['weight_grams']) ? $newData['weight_grams'] : $oldSale['weight_grams'],
            'quantity_units' => isset($newData['quantity_units']) ? $newData['quantity_units'] : $oldSale['quantity_units'],
            'unit_type' => !empty($newData['unit_type']) ? $newData['unit_type'] : $oldSale['unit_type'],
            'price' => isset($newData['price']) ? $newData['price'] : $oldSale['price'],
            'payment_method' => !empty($newData['payment_method']) ? $newData['payment_method'] : $oldSale['payment_method'],
            'paid_amount' => isset($newData['paid_amount']) ? $newData['paid_amount'] : $oldSale['paid_amount'],
            'remaining_method' => $newData['remaining_method'] ?? null,
            'debt_type' => !empty($newData['debt_type']) ? $newData['debt_type'] : $oldSale['debt_type'],
            'sale_date' => $oldSale['sale_date'],
            'qat_status' => $oldSale['qat_status']
        ];

        foreach (['transfer_sender', 'transfer_receiver', 'transfer_number', 'transfer_company'] as $tField) {
            if (isset($newData[$tField])) {
                $saleData[$tField] = $newData[$tField];
            } elseif (isset($oldSale[$tField])) {
                $saleData[$tField] = $oldSale[$tField];
            }
        }

        // processSale handles reducing inventory, adding new debt, and logging transfer info.
        return $this->processSale($saleData);
    }
}

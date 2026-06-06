<?php
require_once '../config/db.php';
require_once '../includes/Autoloader.php';
require_once '../includes/error_page.php';
require_once '../includes/require_auth.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $repo = new SaleRepository($pdo);
        $purchaseRepo = new PurchaseRepository($pdo);
        $customerRepo = new CustomerRepository($pdo);
        $leftoverRepo = new LeftoverRepository($pdo);
        $unitSalesService = new UnitSalesService($purchaseRepo, $leftoverRepo, $repo);
        $service = new SaleService($repo, $purchaseRepo, $customerRepo, $leftoverRepo, $unitSalesService);

        if (empty($_POST['sale_id'])) {
            showErrorPage("رقم الفاتورة مفقود", "لا يمكن تعديل فاتورة بدون رقمها المرجعي.");
            exit;
        }

        $saleId = (int)$_POST['sale_id'];

        $data = [
            'customer_id'      => !empty($_POST['customer_id']) ? (int)$_POST['customer_id'] : null,
            'unit_type'        => $_POST['unit_type'] ?? null,
            'weight_grams'     => isset($_POST['weight_grams']) ? (float)$_POST['weight_grams'] : null,
            'quantity_units'   => isset($_POST['quantity_units']) ? (int)$_POST['quantity_units'] : null,
            'price'            => isset($_POST['price']) ? (float)$_POST['price'] : null,
            'payment_method'   => $_POST['payment_method'] ?? null,
            'paid_amount'      => isset($_POST['paid_amount']) && $_POST['paid_amount'] !== '' ? (float)$_POST['paid_amount'] : null,
            'remaining_method' => $_POST['remaining_method'] ?? null,
            'transfer_sender'  => !empty($_POST['transfer_sender'])  ? $_POST['transfer_sender']  : null,
            'transfer_receiver'=> !empty($_POST['transfer_receiver']) ? $_POST['transfer_receiver']: null,
            'transfer_number'  => !empty($_POST['transfer_number'])  ? $_POST['transfer_number']  : null,
            'transfer_company' => !empty($_POST['transfer_company'])  ? $_POST['transfer_company'] : null,
            'debt_type'        => ($_POST['payment_method'] === 'Debt') ? (!empty($_POST['debt_type']) ? $_POST['debt_type'] : 'Daily') : null,
        ];

        if ($data['price'] !== null && $data['price'] <= 0) {
            showErrorPage("سعر غير صالح", "لا يمكن إتمام البيع بسعر صفر أو أقل. يرجى إدخال السعر الصحيح.");
            exit;
        }

        $newSaleId = $service->editSale($saleId, $data);

        // Redirect back
        $redirectTo = !empty($_POST['redirect_to']) ? $_POST['redirect_to'] : '../reports.php?view=Sales';
        
        // Ensure redirect has success message
        if (strpos($redirectTo, '?') !== false) {
            $redirectTo .= "&success=edited&new_id=" . $newSaleId;
        } else {
            $redirectTo .= "?success=edited&new_id=" . $newSaleId;
        }
        
        header("Location: " . $redirectTo);
        exit;

    } catch (Exception $e) {
        showErrorPage("خطأ في التعديل", $e->getMessage());
        exit;
    }
}

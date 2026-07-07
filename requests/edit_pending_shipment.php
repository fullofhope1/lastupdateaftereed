<?php
require_once '../config/db.php';
require_once '../includes/Autoloader.php';
require_once '../includes/require_auth.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $purchaseRepo = new PurchaseRepository($pdo);
        $purchaseId = (int)$_POST['purchase_id'];
        $unitType = $_POST['unit_type'] ?? 'weight';

        $purchase = $purchaseRepo->getById($purchaseId);

        if (!$purchase) {
            throw new Exception("الشحنة غير موجودة");
        }

        if ($purchase['is_received'] == 1) {
            throw new Exception("لا يمكن تعديل الشحنة، لقد تم استلامها بالفعل.");
        }

        $updateData = [];

        if ($unitType === 'weight') {
            $sourceWeightGrams = (float)($_POST['source_weight_grams'] ?? 0);
            if ($sourceWeightGrams <= 0) {
                throw new Exception("يجب أن يكون الوزن أكبر من صفر");
            }
            $weightKg = $sourceWeightGrams / 1000;
            $agreedPrice = $weightKg * (float)$purchase['price_per_kilo'];
            
            $updateData['source_weight_grams'] = $sourceWeightGrams;
            $updateData['agreed_price'] = $agreedPrice;
        } else {
            $sourceUnits = (int)($_POST['source_units'] ?? 0);
            if ($sourceUnits <= 0) {
                throw new Exception("يجب أن يكون العدد أكبر من صفر");
            }
            $agreedPrice = $sourceUnits * (float)$purchase['price_per_unit'];
            
            $updateData['source_units'] = $sourceUnits;
            $updateData['agreed_price'] = $agreedPrice;
        }

        $purchaseRepo->update($purchaseId, $updateData);

        header("Location: ../purchases.php?success=edited");
        exit;
    } catch (Exception $e) {
        $errorMsg = urlencode($e->getMessage());
        header("Location: ../purchases.php?error=$errorMsg");
        exit;
    }
} else {
    header("Location: ../purchases.php");
    exit;
}

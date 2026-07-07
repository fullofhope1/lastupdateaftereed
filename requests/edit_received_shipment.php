<?php
require_once '../config/db.php';
require_once '../includes/Autoloader.php';
require_once '../includes/require_auth.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $purchaseRepo = new PurchaseRepository($pdo);
        $productRepo = new ProductRepository($pdo);
        $service = new PurchaseService($purchaseRepo, $productRepo);

        $purchaseId = (int)$_POST['purchase_id'];
        $unitType = $_POST['unit_type'] ?? 'weight';
        $receivedWeight = (float)($_POST['received_weight_grams'] ?? 0);
        $receivedUnits = (int)($_POST['received_units'] ?? 0);

        if ($unitType === 'weight' && $receivedWeight <= 0) {
            throw new Exception("الوزن المستلم يجب أن يكون أكبر من صفر.");
        }
        if ($unitType !== 'weight' && $receivedUnits <= 0) {
            throw new Exception("العدد المستلم يجب أن يكون أكبر من صفر.");
        }

        $service->editReceivedQuantity($purchaseId, $receivedWeight, $receivedUnits);

        header("Location: ../purchases.php?success=edited_received");
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

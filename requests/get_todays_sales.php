<?php
require_once '../config/db.php';
require_once '../includes/Autoloader.php';
require_once '../includes/require_auth.php';

header('Content-Type: application/json');

try {
    $today = getOperationalDate();
    $reportRepo = new ReportRepository($pdo);
    
    // Fetch sales for today
    $sales = $reportRepo->getSalesList('Daily', $today, date('Y-m'), date('Y'));
    
    // Filter out returned items
    $sales = array_filter($sales, function($s) {
        return empty($s['is_returned']);
    });

    echo json_encode(['success' => true, 'sales' => array_values($sales)]);
} catch (Exception $e) {
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}

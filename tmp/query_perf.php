<?php
require 'config/db.php';
$stmt = $pdo->query('SELECT * FROM purchases ORDER BY id DESC LIMIT 1');
$p = $stmt->fetch(PDO::FETCH_ASSOC);

// Get sold amounts
$salesStmt = $pdo->prepare("SELECT SUM(weight_kg) as sold_kg, SUM(price) as total_revenue FROM sales WHERE purchase_id = ? AND is_returned = 0");
$salesStmt->execute([$p['id']]);
$sales = $salesStmt->fetch(PDO::FETCH_ASSOC);

$sold_kg = $sales['sold_kg'] ?? 0;
$total_revenue = $sales['total_revenue'] ?? 0;
$remaining_kg = $p['quantity_kg'] - $sold_kg;
$cost = $p['total_price'];
$profit = $total_revenue - $cost;

echo "Shipment ID: {$p['id']}\n";
echo "Provider: {$p['provider_name']}\n";
echo "Date: {$p['purchase_date']}\n";
echo "Cost: " . number_format($cost) . "\n";
echo "Quantity: {$p['quantity_kg']} kg\n";
echo "Sold: {$sold_kg} kg\n";
echo "Remaining: {$remaining_kg} kg\n";
echo "Revenue: " . number_format($total_revenue) . "\n";
echo "Profit/Loss: " . number_format($profit) . "\n";

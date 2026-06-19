<?php
require 'config/db.php';
$stmt = $pdo->prepare("SELECT COALESCE(SUM(COALESCE(weight_kg, weight_grams/1000) - COALESCE(returned_kg, 0)), 0) as sold_kg FROM sales WHERE purchase_id = ? AND is_returned = 0");
$stmt->execute([104]);
print_r($stmt->fetch(PDO::FETCH_ASSOC));

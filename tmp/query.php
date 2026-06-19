<?php
require 'config/db.php';
$stmt = $pdo->query('SELECT id, price, paid_amount, payment_method FROM sales ORDER BY id DESC LIMIT 5');
print_r($stmt->fetchAll(PDO::FETCH_ASSOC));

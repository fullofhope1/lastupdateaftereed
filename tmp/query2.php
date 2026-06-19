<?php
require 'config/db.php';
$stmt = $pdo->query("SHOW COLUMNS FROM sales WHERE Field = 'payment_method'");
print_r($stmt->fetchAll(PDO::FETCH_ASSOC));

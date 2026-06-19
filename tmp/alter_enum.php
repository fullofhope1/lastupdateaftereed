<?php
require 'config/db.php';
try {
    $pdo->exec("ALTER TABLE sales MODIFY payment_method ENUM('Cash', 'Debt', 'Internal Transfer', 'Kuraimi Deposit', 'Jayb Deposit', 'Split_Transfer') NOT NULL DEFAULT 'Cash'");
    $pdo->exec("UPDATE sales SET payment_method = 'Split_Transfer' WHERE payment_method = ''");
    echo "Success";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}

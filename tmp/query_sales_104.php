<?php
require 'config/db.php';
$stmt = $pdo->query('SELECT id, weight_kg, returned_kg, is_returned FROM sales WHERE purchase_id = 104');
print_r($stmt->fetchAll(PDO::FETCH_ASSOC));

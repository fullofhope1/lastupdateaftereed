<?php
require 'config/db.php';
$stmt = $pdo->query('SELECT * FROM sales WHERE leftover_id = 150');
print_r($stmt->fetchAll(PDO::FETCH_ASSOC));

<?php
require 'config/db.php';
$stmt = $pdo->query('SHOW COLUMNS FROM purchases');
print_r($stmt->fetchAll(PDO::FETCH_ASSOC));
$stmt = $pdo->query('SELECT p.*, pv.name as provider_name FROM purchases p JOIN providers pv ON p.provider_id = pv.id ORDER BY p.id DESC LIMIT 1');
print_r($stmt->fetch(PDO::FETCH_ASSOC));

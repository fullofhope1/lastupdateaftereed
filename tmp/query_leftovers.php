<?php
require 'config/db.php';
$stmt = $pdo->query('SELECT * FROM leftovers ORDER BY id DESC LIMIT 5');
print_r($stmt->fetchAll(PDO::FETCH_ASSOC));

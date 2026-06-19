<?php
require 'config/db.php';
$stmt = $pdo->query("SELECT * FROM leftovers WHERE status = 'Momsi_Day_1'");
print_r($stmt->fetchAll(PDO::FETCH_ASSOC));

<?php
require 'config/db.php';
try {
    $pdo->exec('ALTER TABLE staff ADD COLUMN phone VARCHAR(20) DEFAULT NULL');
    echo "Success";
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}

<?php
require 'c:/xampp/htdocs/qat/config/db.php';

$tablesToTruncate = [
    'advertisements',
    'attendance',
    'closed_shifts',
    'customers',
    'expenses',
    'leftovers',
    'payments',
    'providers',
    'purchases',
    'qat_deposits',
    'refunds',
    'sales',
    'staff',
    'staff_attendance',
    'unknown_transfers'
];

try {
    $pdo->exec('SET FOREIGN_KEY_CHECKS = 0');
    
    foreach ($tablesToTruncate as $table) {
        $pdo->exec("TRUNCATE TABLE $table");
        echo "Truncated $table\n";
    }
    
    $pdo->exec('SET FOREIGN_KEY_CHECKS = 1');
    echo "Database successfully formatted. Only 'users' and 'qat_types' were kept.\n";
} catch (Exception $e) {
    $pdo->exec('SET FOREIGN_KEY_CHECKS = 1');
    echo "Error: " . $e->getMessage() . "\n";
}

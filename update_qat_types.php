<?php
require 'config/db.php';

$types = [
    1 => 'جمام نقوة',
    2 => 'جمام كالف',
    3 => 'جمام قصار',
    4 => 'قطل',
    5 => 'جمام نقوة اكس',
    6 => 'صدور',
    7 => 'جمام نقوة اكس جوزات صنعاء',
    8 => 'صدور نقوة'
];

foreach ($types as $id => $name) {
    $stmt = $pdo->prepare("UPDATE qat_types SET name = ? WHERE id = ?");
    $stmt->execute([$name, $id]);
}

// Check if ID 9 has any sales, if not, delete it
$stmt = $pdo->query("SELECT COUNT(*) FROM sales WHERE qat_type_id = 9");
$count = $stmt->fetchColumn();
if ($count == 0) {
    $pdo->query("DELETE FROM qat_types WHERE id = 9");
    echo "Deleted duplicate ID 9\n";
} else {
    echo "ID 9 has sales, keeping it.\n";
}

echo "Database updated successfully.\n";

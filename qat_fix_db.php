<?php
require 'config/db.php';
$stmt = $pdo->query('SELECT id, name FROM qat_types');
$out = "";
while ($r = $stmt->fetch()) {
    $decoded1 = @iconv('Windows-1252', 'UTF-8', $r['name']);
    $decoded2 = @mb_convert_encoding($r['name'], 'Windows-1252', 'UTF-8');
    $decoded3 = @iconv('CP1256', 'UTF-8', $r['name']);
    $out .= $r['id'] . ' : ' . $decoded1 . " | " . $decoded2 . " | " . $decoded3 . "\n";
}
file_put_contents('qat_types_decoded.txt', $out);

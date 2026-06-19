<?php
require_once 'config/db.php';

// Include base classes
require_once 'includes/classes/BaseRepository.php';
require_once 'includes/classes/BaseService.php';
require_once 'includes/classes/ReportRepository.php';
require_once 'includes/classes/ReportService.php';

$repo = new ReportRepository($pdo);
$totals = $repo->getTotals('Daily', '2026-06-04', '2026-06', '2026', null, 'super_admin');

echo "Daily Profit Breakdown for 2026-06-04:\n";
print_r($totals);

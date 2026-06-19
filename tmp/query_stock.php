<?php
session_start();
$_SESSION['operational_date'] = date('Y-m-d');
require 'config/db.php';
function getOperationalDate() { return $_SESSION['operational_date']; }
require 'includes/classes/BaseRepository.php';
require 'includes/classes/BaseService.php';
require 'includes/classes/LeftoverRepository.php';
require 'includes/classes/PurchaseRepository.php';
require 'includes/classes/SaleRepository.php';
require 'includes/classes/SaleService.php';

$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$saleRepo = new SaleRepository($pdo);
$purchaseRepo = new PurchaseRepository($pdo);
$leftoverRepo = new LeftoverRepository($pdo);
$saleService = new SaleService($saleRepo, $purchaseRepo, $leftoverRepo);

print_r($saleService->getAvailableLeftoverStock());

-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: qat_erp
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `advertisements`
--

DROP TABLE IF EXISTS `advertisements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `advertisements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_name` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image_url` text DEFAULT NULL,
  `link_url` text DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `media_path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `advertisements`
--

LOCK TABLES `advertisements` WRITE;
/*!40000 ALTER TABLE `advertisements` DISABLE KEYS */;
/*!40000 ALTER TABLE `advertisements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendance`
--

DROP TABLE IF EXISTS `attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attendance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `closed_shifts`
--

DROP TABLE IF EXISTS `closed_shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `closed_shifts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `closing_date` date NOT NULL,
  `closed_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `closing_date` (`closing_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `closed_shifts`
--

LOCK TABLES `closed_shifts` WRITE;
/*!40000 ALTER TABLE `closed_shifts` DISABLE KEYS */;
/*!40000 ALTER TABLE `closed_shifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `opening_balance` decimal(15,2) DEFAULT 0.00,
  `paid_opening_balance` decimal(15,2) DEFAULT 0.00,
  `total_debt` decimal(10,2) DEFAULT 0.00,
  `debt_limit` decimal(10,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_deleted` tinyint(1) DEFAULT 0,
  `created_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'┘ç┘ä╪º',NULL,0.00,0.00,25000.00,NULL,'2026-05-20 07:38:47',0,NULL);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `expenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `expense_date` date DEFAULT curdate(),
  `description` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` enum('Cash','Transfer') DEFAULT 'Cash',
  `category` varchar(100) NOT NULL,
  `staff_id` int(11) DEFAULT NULL,
  `provider_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `provider_id` (`provider_id`),
  CONSTRAINT `fk_expense_provider` FOREIGN KEY (`provider_id`) REFERENCES `providers` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leftovers`
--

DROP TABLE IF EXISTS `leftovers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `leftovers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_date` date NOT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `qat_type_id` int(11) DEFAULT NULL,
  `unit_type` enum('weight','┘é╪¿╪╢╪⌐','┘é╪▒╪╖╪º╪│') NOT NULL DEFAULT 'weight',
  `weight_kg` decimal(10,2) NOT NULL,
  `quantity_units` int(11) NOT NULL DEFAULT 0,
  `status` enum('Pending','Dropped','Transferred_Next_Day','Sold','Auto_Momsi','Auto_Dropped','Momsi_Day_1','Momsi_Day_2','Closed','Reception_Loss','Staff_Consumption','Returned_Damaged') DEFAULT 'Pending',
  `decision_date` date DEFAULT NULL,
  `sale_date` date DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `life_day` int(11) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `qat_type_id` (`qat_type_id`),
  CONSTRAINT `leftovers_ibfk_1` FOREIGN KEY (`qat_type_id`) REFERENCES `qat_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leftovers`
--

LOCK TABLES `leftovers` WRITE;
/*!40000 ALTER TABLE `leftovers` DISABLE KEYS */;
INSERT INTO `leftovers` VALUES (1,'2026-05-20',1,1,'┘é╪¿╪╢╪⌐',0.00,2,'Dropped','2026-05-20','2026-05-20','','2026-05-20 07:37:13',1,32),(2,'2026-05-20',1,1,'┘é╪¿╪╢╪⌐',0.00,2,'','2026-05-20','2026-05-20','╪¬╪«╪▓┘è┘å╪⌐ ╪╣┘à╪º┘ä ┘à┘å ┘ê╪º╪¼┘ç╪⌐ ╪º┘ä┘à╪¿┘è╪╣╪º╪¬','2026-05-20 07:37:32',1,32),(3,'2026-05-20',1,1,'┘é╪¿╪╢╪⌐',0.00,1,'','2026-05-20','2026-05-20','╪¬╪«╪▓┘è┘å╪⌐ ╪╣┘à╪º┘ä ┘à┘å ┘ê╪º╪¼┘ç╪⌐ ╪º┘ä┘à╪¿┘è╪╣╪º╪¬','2026-05-20 07:39:57',1,32),(4,'2026-05-20',1,1,'┘é╪¿╪╢╪⌐',0.00,1,'Dropped','2026-05-20','2026-05-20','','2026-05-20 07:43:51',1,32),(5,'2026-05-20',1,1,'┘é╪¿╪╢╪⌐',0.00,1,'','2026-05-20','2026-05-20','╪¬╪«╪▓┘è┘å╪⌐ ╪╣┘à╪º┘ä ┘à┘å ┘ê╪º╪¼┘ç╪⌐ ╪º┘ä┘à╪¿┘è╪╣╪º╪¬','2026-05-20 07:44:25',1,32);
/*!40000 ALTER TABLE `leftovers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payment_date` date DEFAULT curdate(),
  `customer_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` enum('Cash','Transfer') DEFAULT 'Cash',
  `note` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `transfer_sender` varchar(255) DEFAULT NULL,
  `transfer_receiver` varchar(255) DEFAULT NULL,
  `transfer_number` varchar(255) DEFAULT NULL,
  `transfer_company` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `providers`
--

DROP TABLE IF EXISTS `providers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `providers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `providers`
--

LOCK TABLES `providers` WRITE;
/*!40000 ALTER TABLE `providers` DISABLE KEYS */;
INSERT INTO `providers` VALUES (1,'╪¬╪│╪¬','','2026-05-20 07:36:28',31);
/*!40000 ALTER TABLE `providers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchases`
--

DROP TABLE IF EXISTS `purchases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `purchases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `purchase_date` date NOT NULL,
  `qat_type_id` int(11) DEFAULT NULL,
  `source_weight_grams` decimal(10,2) DEFAULT 0.00,
  `received_weight_grams` decimal(10,2) DEFAULT 0.00,
  `provider_id` int(11) DEFAULT NULL,
  `expected_quantity_kg` decimal(10,2) DEFAULT 0.00,
  `vendor_name` varchar(100) DEFAULT NULL,
  `agreed_price` decimal(10,2) NOT NULL,
  `discount_amount` decimal(10,2) DEFAULT 0.00,
  `price_per_kilo` decimal(10,2) DEFAULT 0.00,
  `unit_type` enum('weight','┘é╪¿╪╢╪⌐','┘é╪▒╪╖╪º╪│') NOT NULL DEFAULT 'weight',
  `source_units` int(11) NOT NULL DEFAULT 0,
  `received_units` int(11) DEFAULT 0,
  `price_per_unit` decimal(10,2) NOT NULL DEFAULT 0.00,
  `discount` decimal(10,2) DEFAULT 0.00,
  `net_cost` decimal(10,2) GENERATED ALWAYS AS (`agreed_price` - `discount`) STORED,
  `quantity_kg` decimal(10,2) DEFAULT NULL,
  `status` enum('Fresh','Momsi','Closed') DEFAULT 'Fresh',
  `media_path` varchar(255) DEFAULT NULL,
  `is_received` tinyint(1) DEFAULT 1,
  `received_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `original_purchase_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `qat_type_id` (`qat_type_id`),
  KEY `idx_purchases_date` (`purchase_date`),
  KEY `fk_original_purchase` (`original_purchase_id`),
  CONSTRAINT `fk_original_purchase` FOREIGN KEY (`original_purchase_id`) REFERENCES `purchases` (`id`) ON DELETE SET NULL,
  CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`qat_type_id`) REFERENCES `qat_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchases`
--

LOCK TABLES `purchases` WRITE;
/*!40000 ALTER TABLE `purchases` DISABLE KEYS */;
INSERT INTO `purchases` VALUES (1,'2026-05-20',1,0.00,0.00,1,0.00,NULL,10000.00,0.00,0.00,'┘é╪¿╪╢╪⌐',10,10,1000.00,0.00,10000.00,0.00,'Fresh',NULL,1,'2026-05-20 10:36:56','2026-05-20 07:36:40',31,NULL);
/*!40000 ALTER TABLE `purchases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qat_deposits`
--

DROP TABLE IF EXISTS `qat_deposits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qat_deposits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deposit_date` date NOT NULL,
  `currency` enum('YER','SAR','USD') NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `recipient` varchar(100) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qat_deposits`
--

LOCK TABLES `qat_deposits` WRITE;
/*!40000 ALTER TABLE `qat_deposits` DISABLE KEYS */;
/*!40000 ALTER TABLE `qat_deposits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qat_types`
--

DROP TABLE IF EXISTS `qat_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qat_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `unit_type` enum('weight','units') DEFAULT 'weight',
  `description` text DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `media_path` varchar(255) DEFAULT NULL,
  `price_weight` decimal(10,2) DEFAULT 0.00,
  `price_qabdah` decimal(10,2) DEFAULT 0.00,
  `price_qartas` decimal(10,2) DEFAULT 0.00,
  `created_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qat_types`
--

LOCK TABLES `qat_types` WRITE;
/*!40000 ALTER TABLE `qat_types` DISABLE KEYS */;
INSERT INTO `qat_types` VALUES (1,'╪¼┘à╪º┘à ┘å┘é┘ê╪⌐','weight','Auto-created from sourcing',0,NULL,0.00,0.00,0.00,NULL),(2,'╪¼┘à╪º┘à ┘â╪º┘ä┘ü','weight','Auto-created from sourcing',0,NULL,0.00,0.00,0.00,NULL),(3,'╪¼┘à╪º┘à ┘é╪╡╪º╪▒','weight','Auto-created from sourcing',0,NULL,0.00,0.00,0.00,NULL),(4,'┘é╪╖┘ä','weight','Auto-created from sourcing',0,'uploads/1777825118_Gemini_Generated_Image_djtqq0djtqq0djtq.png',0.00,0.00,0.00,NULL),(5,'╪¼┘à╪º┘à ┘å┘é┘ê╪⌐3╪º┘â╪│','weight','Auto-created from sourcing',0,'uploads/1778555093_1000166184.jpg',0.00,0.00,0.00,NULL),(6,'╪╡╪»┘ê╪▒','weight','Auto-created from sourcing',0,NULL,0.00,0.00,0.00,NULL),(7,'╪¼┘à╪º┘à ┘å┘é┘ê╪⌐3╪º┘â╪│ ╪¼┘ê╪▓╪º╪¬ ╪╡┘å╪╣╪º╪í','weight','Auto-created from sourcing',0,NULL,0.00,0.00,0.00,NULL),(8,'╪╡╪»┘ê╪▒ ┘å┘é┘ê┘ç','weight','Auto-created from sourcing',0,'uploads/1778555551_1000166159.jpg',0.00,0.00,0.00,NULL);
/*!40000 ALTER TABLE `qat_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refunds`
--

DROP TABLE IF EXISTS `refunds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `refunds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `refund_type` varchar(20) NOT NULL DEFAULT 'Debt',
  `unit_type` enum('weight','units') DEFAULT 'weight',
  `reason` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `weight_kg` decimal(10,3) DEFAULT 0.000,
  `quantity_units` int(11) DEFAULT 0,
  `sale_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `refunds_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refunds`
--

LOCK TABLES `refunds` WRITE;
/*!40000 ALTER TABLE `refunds` DISABLE KEYS */;
INSERT INTO `refunds` VALUES (1,1,40000.00,'Cash','','┘à╪▒╪¬╪¼╪╣ ┘à┘å ┘ü╪º╪¬┘ê╪▒╪⌐ 2026-05-20','2026-05-20 07:59:01',32,0.000,1,1);
/*!40000 ALTER TABLE `refunds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_date` date DEFAULT curdate(),
  `due_date` date DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `qat_type_id` int(11) DEFAULT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `leftover_id` int(11) DEFAULT NULL,
  `qat_status` enum('Tari','Momsi','Leftover','Leftover1','Leftover2') DEFAULT 'Tari',
  `weight_grams` decimal(10,2) NOT NULL,
  `weight_kg` decimal(10,3) GENERATED ALWAYS AS (`weight_grams` / 1000) STORED,
  `returned_kg` decimal(10,3) DEFAULT 0.000,
  `unit_type` enum('weight','┘é╪¿╪╢╪⌐','┘é╪▒╪╖╪º╪│','units') NOT NULL DEFAULT 'weight',
  `quantity_units` int(11) NOT NULL DEFAULT 0,
  `returned_units` int(11) DEFAULT 0,
  `price` decimal(10,2) NOT NULL,
  `paid_amount` decimal(10,2) DEFAULT 0.00,
  `discount` decimal(10,2) DEFAULT 0.00,
  `refund_amount` decimal(10,2) DEFAULT 0.00,
  `payment_method` enum('Cash','Debt','Internal Transfer','Kuraimi Deposit','Jayb Deposit','Split_Transfer') NOT NULL DEFAULT 'Cash',
  `transfer_sender` varchar(100) DEFAULT NULL,
  `transfer_receiver` varchar(100) DEFAULT NULL,
  `transfer_number` varchar(100) DEFAULT NULL,
  `transfer_company` varchar(100) DEFAULT NULL,
  `is_paid` tinyint(1) DEFAULT 1,
  `is_returned` tinyint(1) DEFAULT 0,
  `debt_type` enum('Daily','Monthly','Yearly','Deferred') DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  KEY `qat_type_id` (`qat_type_id`),
  KEY `idx_sales_date` (`sale_date`),
  KEY `fk_sales_leftover` (`leftover_id`),
  CONSTRAINT `fk_sales_leftover` FOREIGN KEY (`leftover_id`) REFERENCES `leftovers` (`id`),
  CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`qat_type_id`) REFERENCES `qat_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
INSERT INTO `sales` VALUES (1,'2026-05-20','2026-05-20',1,1,1,NULL,'Tari',0.00,0.000,0.000,'┘é╪¿╪╢╪⌐',1,1,40000.00,15000.00,0.00,40000.00,'Debt',NULL,NULL,NULL,NULL,0,0,'Daily','','2026-05-20 07:41:10',NULL);
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `role` varchar(50) DEFAULT NULL,
  `daily_salary` decimal(10,2) DEFAULT 0.00,
  `withdrawal_limit` decimal(10,2) DEFAULT NULL,
  `base_salary` decimal(10,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `join_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_attendance`
--

DROP TABLE IF EXISTS `staff_attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff_attendance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) NOT NULL,
  `work_date` date NOT NULL,
  `status` enum('Present','Absent') DEFAULT 'Present',
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_staff_date` (`staff_id`,`work_date`),
  CONSTRAINT `staff_attendance_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_attendance`
--

LOCK TABLES `staff_attendance` WRITE;
/*!40000 ALTER TABLE `staff_attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unknown_transfers`
--

DROP TABLE IF EXISTS `unknown_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unknown_transfers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transfer_date` date NOT NULL,
  `receipt_number` varchar(100) DEFAULT NULL,
  `sender_name` varchar(100) NOT NULL,
  `receiver_name` varchar(255) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `currency` varchar(5) DEFAULT 'YER',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unknown_transfers`
--

LOCK TABLES `unknown_transfers` WRITE;
/*!40000 ALTER TABLE `unknown_transfers` DISABLE KEYS */;
/*!40000 ALTER TABLE `unknown_transfers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','super_admin','user') NOT NULL,
  `sub_role` varchar(50) DEFAULT 'full',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (21,'super','╪ú┘è┘ç┘à','','$2y$10$S7a3KLk1GzQLt4V44FRstuB4no5PY9laVURGrVFkLQ4Mxi5SRO0kC','super_admin','verifier','2026-03-07 09:22:29'),(22,'sales','╪╣╪¿╪»╪º┘ä┘ä┘ç ╪º┘ä┘å┘ç╪º╪▒┘è','partner','$2y$10$6fCxtkgdFbnF.yvdzRZdremFyyOhgqLGK4BB72oE.bVSARJEcoErG','super_admin','seller','2026-03-07 09:25:00'),(23,'accountant','╪╣╪¿╪»┘ç ╪º┘ä╪º╪¿┘è╪╢','','$2y$10$4bVHNY6siV.J0KNFndPYK.XjczeZtEhjKZExBBXOXBSWJC8An6xDm','super_admin','accountant','2026-03-07 09:32:27'),(24,'partner','╪¿┘å ┘ü╪º╪▒╪╣','superadmin','$2y$10$YjboWjqzqplAh57oitiAg.LxcCpouY1C6HQcXdgfbW5ONSKqO6WBK','super_admin','partner','2026-03-07 09:37:07'),(31,'admin','admin',NULL,'$2y$10$vGb1uLT757sQZAHXVAlyvOYa0frk7OeKFHJz6ZdDv5rcYbKuKAZsO','admin','full','2026-03-08 19:21:26'),(32,'superadmin','superadmin',NULL,'$2y$10$vGb1uLT757sQZAHXVAlyvOYa0frk7OeKFHJz6ZdDv5rcYbKuKAZsO','super_admin','full','2026-03-08 19:21:26');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-20  1:03:25

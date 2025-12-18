-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 18, 2025 at 01:09 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `deliti_app`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts_payable`
--

CREATE TABLE `accounts_payable` (
  `id` int(11) NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `kode` varchar(50) NOT NULL,
  `jumlah_barang` int(11) NOT NULL DEFAULT 0,
  `satuan_kuantitas` varchar(20) NOT NULL,
  `lokasi_barang` varchar(100) DEFAULT NULL,
  `expired_date` date DEFAULT NULL,
  `harga` decimal(15,2) NOT NULL,
  `vendor` varchar(255) NOT NULL,
  `tanggal_transaksi` date DEFAULT curdate(),
  `status` enum('unpaid','partial','paid','overdue') DEFAULT 'unpaid',
  `tanggal_bayar` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accounts_payable`
--

INSERT INTO `accounts_payable` (`id`, `nama_barang`, `kode`, `jumlah_barang`, `satuan_kuantitas`, `lokasi_barang`, `expired_date`, `harga`, `vendor`, `tanggal_transaksi`, `status`, `tanggal_bayar`, `created_at`, `updated_at`) VALUES
(1, 'Tomat', 'PUR-1', 100, 'kg', 'Jurang', '2027-01-31', 10000.00, '..', '2025-12-17', 'paid', '2025-12-18', '2025-12-16 18:23:12', '2025-12-17 22:02:34'),
(2, 'Kentang Banget', 'PUR-2', 10, 'kg', 'Dapur GAK', '2027-01-31', 15000.00, 'T_T', '2025-12-17', 'paid', '2025-12-18', '2025-12-17 14:12:08', '2025-12-17 22:06:36');

-- --------------------------------------------------------

--
-- Table structure for table `accounts_receivable`
--

CREATE TABLE `accounts_receivable` (
  `id` int(11) NOT NULL,
  `nama` varchar(200) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `jumlah` decimal(15,2) NOT NULL,
  `tanggal` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accounts_receivable`
--

INSERT INTO `accounts_receivable` (`id`, `nama`, `deskripsi`, `jumlah`, `tanggal`, `created_at`) VALUES
(1, 'Customer A', 'Pembayaran catering meeting', 5000000.00, '2024-01-20', '2025-12-10 18:26:38'),
(2, 'Customer B', 'DP wedding package', 3000000.00, '2024-01-19', '2025-12-10 18:26:38');

-- --------------------------------------------------------

--
-- Stand-in structure for view `all_inventory_data`
-- (See below for the actual view)
--
CREATE TABLE `all_inventory_data` (
`source_table` varchar(16)
,`id` int(11)
,`nama_barang` varchar(255)
,`kode` varchar(50)
,`jumlah_barang` int(11)
,`satuan_kuantitas` varchar(20)
,`lokasi_barang` varchar(100)
,`expired_date` date
,`harga` decimal(15,2)
,`vendor` varchar(255)
,`tanggal_transaksi` date
,`status` enum('unpaid','partial','paid','overdue')
,`tanggal_bayar` date
,`created_at` timestamp
);

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE `articles` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `author` varchar(100) DEFAULT 'Admin',
  `category` varchar(50) DEFAULT 'General',
  `image_path` varchar(255) DEFAULT NULL,
  `views` int(11) DEFAULT 0,
  `is_published` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`id`, `title`, `content`, `author`, `category`, `image_path`, `views`, `is_published`, `created_at`, `updated_at`) VALUES
(1, 'Welcome to Deliti Restaurant', 'Welcome to our restaurant! We serve delicious meals...', 'Admin', 'Announcement', NULL, 0, 1, '2025-12-17 23:54:58', '2025-12-17 23:54:58'),
(2, 'Healthy Eating Tips', 'Here are 10 tips for healthy eating...', 'Nutritionist', 'Tips', NULL, 0, 1, '2025-12-17 23:54:58', '2025-12-17 23:54:58'),
(3, 'Our New Menu Items', 'Check out our new vegetarian specials...', 'Chef', 'Menu', NULL, 0, 1, '2025-12-17 23:54:58', '2025-12-17 23:54:58');

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `menu_item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart_items`
--

INSERT INTO `cart_items` (`id`, `user_id`, `menu_item_id`, `quantity`, `created_at`, `updated_at`) VALUES
(34, 4, 2, 1, '2025-12-17 23:00:05', '2025-12-17 23:00:05');

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `id` int(11) NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `kode` varchar(50) NOT NULL,
  `jumlah_barang` int(11) NOT NULL DEFAULT 0,
  `satuan_kuantitas` varchar(20) NOT NULL,
  `lokasi_barang` varchar(100) DEFAULT NULL,
  `expired_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`id`, `nama_barang`, `kode`, `jumlah_barang`, `satuan_kuantitas`, `lokasi_barang`, `expired_date`, `created_at`, `updated_at`) VALUES
(2, 'Kentang Banget', 'PUR-2', 100, 'kg', 'Dapur GAK', '2027-01-31', '2025-12-17 14:12:08', '2025-12-17 20:54:47');

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

CREATE TABLE `menu_items` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `category` varchar(50) NOT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `calories` int(11) DEFAULT NULL,
  `protein` decimal(5,2) DEFAULT NULL,
  `carbs` decimal(5,2) DEFAULT NULL,
  `fat` decimal(5,2) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_items`
--

INSERT INTO `menu_items` (`id`, `name`, `description`, `price`, `category`, `image_path`, `calories`, `protein`, `carbs`, `fat`, `is_available`, `created_at`) VALUES
(1, 'Test Burger', 'Delicious test burger', 35000.00, 'beast', 'assets/gambar/MENU-BEAST/dish1.jpeg', 450, NULL, NULL, NULL, 1, '2025-11-06 18:15:07'),
(2, 'Test Salad', 'Healthy test salad', 25000.00, 'vegetarian', 'assets/gambar/MENU-VEGE/dish1.jpeg', 150, NULL, NULL, NULL, 1, '2025-11-06 18:15:07'),
(3, 'Green Power Smoothie', 'Fresh spinach, banana, almond milk, and protein powder blend', 32000.00, 'healthy', 'assets/gambar/MENU-HEALTHY/dish1.jpeg', 180, 15.00, 25.00, 5.00, 1, '2025-11-06 19:45:34'),
(4, 'Avocado Toast', 'Whole grain toast with smashed avocado, cherry tomatoes, and microgreens', 28000.00, 'vegetarian', 'assets/gambar/MENU-VEGE/dish2.jpeg', 220, 8.00, 30.00, 12.00, 1, '2025-11-06 19:45:34'),
(5, 'Protein Power Bowl', 'Quinoa, grilled chicken, roasted vegetables, and tahini dressing', 48000.00, 'healthy', 'assets/gambar/MENU-HEALTHY/dish2.jpeg', 420, 35.00, 45.00, 15.00, 1, '2025-11-06 19:45:34'),
(6, 'Mega Beef Burger', 'Double beef patty with cheese, bacon, and special sauce', 68000.00, 'beast', 'assets/gambar/MENU-BEAST/dish3.jpeg', 650, 40.00, 35.00, 35.00, 1, '2025-11-06 19:45:34'),
(7, 'Vegan Buddha Bowl', 'Brown rice, roasted vegetables, chickpeas, and turmeric dressing', 35000.00, 'vegetarian', 'assets/gambar/MENU-VEGE/dish3.jpeg', 380, 12.00, 55.00, 10.00, 1, '2025-11-06 19:45:34'),
(8, 'Grilled Salmon', 'Atlantic salmon with lemon butter sauce and seasonal vegetables', 55000.00, 'healthy', 'assets/gambar/MENU-HEALTHY/dish3.jpeg', 320, 30.00, 8.00, 20.00, 1, '2025-11-06 19:45:34');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` enum('pending','preparing','cooking','ready','delivering','completed','cancelled') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `total_price`, `status`, `created_at`) VALUES
(1, 4, 98000.00, 'completed', '2025-12-16 18:55:11'),
(2, 4, 63000.00, 'completed', '2025-12-16 18:58:27'),
(3, 4, 28000.00, 'completed', '2025-12-16 19:13:10'),
(4, 4, 1514000.00, 'cancelled', '2025-12-16 19:13:41'),
(5, 4, 63000.00, 'cancelled', '2025-12-16 19:29:55');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `menu_item_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `menu_item_id`, `quantity`, `price`) VALUES
(1, 1, 7, 2, 35000.00),
(2, 1, 4, 1, 28000.00),
(3, 2, 7, 1, 35000.00),
(4, 2, 4, 1, 28000.00),
(5, 3, 4, 1, 28000.00),
(6, 4, 7, 13, 35000.00),
(7, 4, 5, 5, 48000.00),
(8, 4, 8, 5, 55000.00),
(9, 4, 6, 8, 68000.00),
(10, 5, 4, 1, 28000.00),
(11, 5, 7, 1, 35000.00);

-- --------------------------------------------------------

--
-- Table structure for table `purchasing`
--

CREATE TABLE `purchasing` (
  `id` int(11) NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `kode` varchar(50) DEFAULT NULL,
  `jumlah_barang` int(11) NOT NULL DEFAULT 0,
  `satuan_kuantitas` varchar(20) NOT NULL,
  `lokasi_barang` varchar(100) DEFAULT NULL,
  `expired_date` date DEFAULT NULL,
  `harga` decimal(15,2) NOT NULL,
  `vendor` varchar(255) NOT NULL,
  `tanggal_transaksi` date DEFAULT curdate(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchasing`
--

INSERT INTO `purchasing` (`id`, `nama_barang`, `kode`, `jumlah_barang`, `satuan_kuantitas`, `lokasi_barang`, `expired_date`, `harga`, `vendor`, `tanggal_transaksi`, `created_at`) VALUES
(1, 'Tomat', 'PUR-1', 100, 'kg', 'Jurang', '2027-01-31', 10000.00, '..', '2025-12-17', '2025-12-16 18:23:12'),
(2, 'Kentang Banget', 'PUR-2', 10, 'kg', 'Dapur GAK', '2027-01-31', 15000.00, 'T_T', '2025-12-17', '2025-12-17 14:12:08');

--
-- Triggers `purchasing`
--
DELIMITER $$
CREATE TRIGGER `after_purchasing_insert` AFTER INSERT ON `purchasing` FOR EACH ROW BEGIN
    -- Auto-insert into inventory
    INSERT INTO inventory (
        nama_barang, kode, jumlah_barang, satuan_kuantitas,
        lokasi_barang, expired_date
    ) VALUES (
        NEW.nama_barang, NEW.kode, NEW.jumlah_barang, NEW.satuan_kuantitas,
        NEW.lokasi_barang, NEW.expired_date
    );
    
    -- Auto-insert into accounts_payable
    INSERT INTO accounts_payable (
        nama_barang, kode, jumlah_barang, satuan_kuantitas,
        lokasi_barang, expired_date, harga, vendor,
        tanggal_transaksi, status
    ) VALUES (
        NEW.nama_barang, NEW.kode, NEW.jumlah_barang, NEW.satuan_kuantitas,
        NEW.lokasi_barang, NEW.expired_date, NEW.harga, NEW.vendor,
        NEW.tanggal_transaksi, 'unpaid'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `auto_generate_kode_before_purchase` BEFORE INSERT ON `purchasing` FOR EACH ROW BEGIN
    DECLARE last_number BIGINT DEFAULT 0;
    
    -- If user provides a code, use it
    IF NEW.kode IS NOT NULL AND NEW.kode != '' THEN
        SET NEW.kode = NEW.kode;
    ELSE
        -- Get the highest number after 'PUR-'
        SELECT COALESCE(MAX(
            CAST(SUBSTRING(kode, 5) AS UNSIGNED)
        ), 0) INTO last_number
        FROM purchasing 
        WHERE kode LIKE 'PUR-%';
        
        -- No padding, just sequential number = UNLIMITED!
        -- PUR-1, PUR-2, PUR-100, PUR-1000, PUR-999999, PUR-1000000, etc.
        SET NEW.kode = CONCAT('PUR-', (last_number + 1));
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `category` varchar(50) NOT NULL,
  `subject` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `status` enum('pending','in_progress','resolved') DEFAULT 'pending',
  `admin_response` text DEFAULT NULL,
  `responded_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`id`, `name`, `email`, `category`, `subject`, `description`, `status`, `admin_response`, `responded_at`, `created_at`, `updated_at`) VALUES
(1, 'a', 'b@gmail.com', 'other', 'a', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'pending', NULL, NULL, '2025-11-24 18:44:40', '2025-11-24 18:44:40');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL COMMENT 'Link ke table orders',
  `total_harga` decimal(15,2) NOT NULL,
  `tanggal` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `role` varchar(20) NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `phone`, `profile_picture`, `created_at`, `role`) VALUES
(1, 'Test User', 'test@gmail.com', '$2y$10$VYR5m3/18DLE51jS4cDXF.WmkUCyZGQJPeWayyrS2P7kN14FUFu.u', '08123456789', NULL, '2025-11-06 17:54:05', 'user'),
(4, 'i am a', 'a@gmail.com', '$2y$10$X1Q26Zpk5eDLQE4WgmccMePrR51bGfpFFjOUVKynfr08C57sJJHwa', '000', NULL, '2025-11-06 18:37:46', 'admin'),
(5, 'aaa', 'aaa@gmail.com', '$2y$10$9J2tlrHli7H29BBjRacofO0h9hRIi9T8e49EuKL.DmBQVjJsxa.rO', '123', NULL, '2025-11-12 06:29:21', 'user');

-- --------------------------------------------------------

--
-- Table structure for table `vendors`
--

CREATE TABLE `vendors` (
  `id` int(11) NOT NULL,
  `kode_vendor` varchar(20) NOT NULL,
  `nama_toko` varchar(100) NOT NULL,
  `nama_pemilik` varchar(100) DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `jenis_vendor` enum('supplier','distributor') DEFAULT 'supplier',
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vendors`
--

INSERT INTO `vendors` (`id`, `kode_vendor`, `nama_toko`, `nama_pemilik`, `telepon`, `email`, `jenis_vendor`, `status`, `created_at`, `updated_at`) VALUES
(1, 'VEN001', 'Supplier Beras Jaya', 'Budi Santoso', '081234567890', 'beras@jaya.com', 'supplier', 'active', '2025-12-10 17:16:12', '2025-12-10 17:16:12'),
(2, 'VEN002', 'Distributor Minyak', 'Siti Aminah', '081298765432', 'minyak@distro.com', 'distributor', 'active', '2025-12-10 17:16:12', '2025-12-10 17:16:12'),
(3, 'VEN003', 'Pabrik Gula Manis', 'Agus Wijaya', '081277788899', 'gula@manis.com', '', 'active', '2025-12-10 17:16:12', '2025-12-10 17:16:12');

-- --------------------------------------------------------

--
-- Structure for view `all_inventory_data`
--
DROP TABLE IF EXISTS `all_inventory_data`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `all_inventory_data`  AS SELECT 'Purchasing' AS `source_table`, `purchasing`.`id` AS `id`, `purchasing`.`nama_barang` AS `nama_barang`, `purchasing`.`kode` AS `kode`, `purchasing`.`jumlah_barang` AS `jumlah_barang`, `purchasing`.`satuan_kuantitas` AS `satuan_kuantitas`, `purchasing`.`lokasi_barang` AS `lokasi_barang`, `purchasing`.`expired_date` AS `expired_date`, `purchasing`.`harga` AS `harga`, `purchasing`.`vendor` AS `vendor`, `purchasing`.`tanggal_transaksi` AS `tanggal_transaksi`, NULL AS `status`, NULL AS `tanggal_bayar`, `purchasing`.`created_at` AS `created_at` FROM `purchasing`union all select 'Inventory' AS `source_table`,`inventory`.`id` AS `id`,`inventory`.`nama_barang` AS `nama_barang`,`inventory`.`kode` AS `kode`,`inventory`.`jumlah_barang` AS `jumlah_barang`,`inventory`.`satuan_kuantitas` AS `satuan_kuantitas`,`inventory`.`lokasi_barang` AS `lokasi_barang`,`inventory`.`expired_date` AS `expired_date`,NULL AS `harga`,NULL AS `vendor`,NULL AS `tanggal_transaksi`,NULL AS `status`,NULL AS `tanggal_bayar`,`inventory`.`created_at` AS `created_at` from `inventory` union all select 'Accounts Payable' AS `source_table`,`accounts_payable`.`id` AS `id`,`accounts_payable`.`nama_barang` AS `nama_barang`,`accounts_payable`.`kode` AS `kode`,`accounts_payable`.`jumlah_barang` AS `jumlah_barang`,`accounts_payable`.`satuan_kuantitas` AS `satuan_kuantitas`,`accounts_payable`.`lokasi_barang` AS `lokasi_barang`,`accounts_payable`.`expired_date` AS `expired_date`,`accounts_payable`.`harga` AS `harga`,`accounts_payable`.`vendor` AS `vendor`,`accounts_payable`.`tanggal_transaksi` AS `tanggal_transaksi`,`accounts_payable`.`status` AS `status`,`accounts_payable`.`tanggal_bayar` AS `tanggal_bayar`,`accounts_payable`.`created_at` AS `created_at` from `accounts_payable`  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts_payable`
--
ALTER TABLE `accounts_payable`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `accounts_receivable`
--
ALTER TABLE `accounts_receivable`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `SORTED_USER_ID` (`user_id`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `menu_item_id` (`menu_item_id`);

--
-- Indexes for table `purchasing`
--
ALTER TABLE `purchasing`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode` (`kode`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_id` (`order_id`),
  ADD KEY `idx_tanggal` (`tanggal`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `vendors`
--
ALTER TABLE `vendors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kode_vendor` (`kode_vendor`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts_payable`
--
ALTER TABLE `accounts_payable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `accounts_receivable`
--
ALTER TABLE `accounts_receivable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `purchasing`
--
ALTER TABLE `purchasing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `vendors`
--
ALTER TABLE `vendors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`);

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

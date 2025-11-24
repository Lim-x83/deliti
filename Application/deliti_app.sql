-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 24, 2025 at 08:08 PM
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
  `status` varchar(50) DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `total_price`, `status`, `created_at`) VALUES
(1, 4, 32000.00, 'cancelled', '2025-11-24 18:03:14'),
(2, 4, 28000.00, 'cancelled', '2025-11-24 18:21:32'),
(3, 4, 35000.00, 'cancelled', '2025-11-24 18:25:20');

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
(1, 1, 3, 1, 32000.00),
(2, 2, 4, 1, 28000.00),
(3, 3, 7, 1, 35000.00);

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
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `phone`, `profile_picture`, `created_at`) VALUES
(1, 'Test User', 'test@gmail.com', '$2y$10$VYR5m3/18DLE51jS4cDXF.WmkUCyZGQJPeWayyrS2P7kN14FUFu.u', '08123456789', NULL, '2025-11-06 17:54:05'),
(4, 'i am a', 'a@gmail.com', '$2y$10$X1Q26Zpk5eDLQE4WgmccMePrR51bGfpFFjOUVKynfr08C57sJJHwa', '000', NULL, '2025-11-06 18:37:46'),
(5, 'aaa', 'aaa@gmail.com', '$2y$10$9J2tlrHli7H29BBjRacofO0h9hRIi9T8e49EuKL.DmBQVjJsxa.rO', '123', NULL, '2025-11-12 06:29:21');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
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
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

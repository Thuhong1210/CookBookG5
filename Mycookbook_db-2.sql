-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 05, 2025 at 11:30 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Mycookbook_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`

create database Mycookbook_db;
use Mycookbook_db;
--

CREATE TABLE `audit_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `resource_type` varchar(50) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `changes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`changes`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `color` varchar(20) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`, `slug`, `description`, `icon`, `color`, `created_by`, `created_at`) VALUES
(1, 'Món Ăn Việt Nam', 'mon-an-viet-nam', 'Các món ăn truyền thống Việt Nam', 'fa-bowl-rice', '#FF6B6B', 16, '2025-12-02 08:02:06'),
(2, 'Món Ý', 'mon-y', 'Pizza, pasta và các món ăn Italy', 'fa-pizza-slice', '#4ECDC4', 16, '2025-12-02 08:02:06'),
(3, 'Món Nhật', 'mon-nhat', 'Sushi, ramen và các món ăn Nhật Bản', 'fa-fish', '#95E1D3', 16, '2025-12-02 08:02:06'),
(4, 'Healthy Food', 'healthy-food', 'Món ăn healthy, ít calo', 'fa-leaf', '#45B7D1', 16, '2025-12-02 08:02:06'),
(5, 'Desserts', 'desserts', 'Các loại bánh ngọt, tráng miệng', 'fa-ice-cream', '#FFA07A', 16, '2025-12-02 08:02:06'),
(6, 'Đồ Uống', 'do-uong', 'Sinh tố, nước ép, cocktails', 'fa-mug-hot', '#9B59B6', 16, '2025-12-02 08:02:06'),
(7, 'Món Thái', 'món-thái', 'Đồ ăn Thái, pad Thái', '', '#ff7b00', 16, '2025-12-02 08:20:15');

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

CREATE TABLE `comment` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `recipe_id` int(11) NOT NULL,
  `comment` text NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `comment`
--

INSERT INTO `comment` (`id`, `user_id`, `recipe_id`, `comment`, `created_at`) VALUES
(1, 12, 1, 'My kids actually ate this! Miracle!', '2025-11-30 21:02:29'),
(2, 9, 1, 'Added some extra chili and it was perfect!', '2025-11-30 21:02:29'),
(3, 4, 1, 'Best recipe for this dish I\'ve found so far.', '2025-11-30 21:02:29'),
(4, 11, 3, 'The sauce is the real star here.', '2025-11-30 21:02:29'),
(5, 5, 4, 'Simple and quick, perfect for weeknight dinner.', '2025-11-30 21:02:29'),
(6, 10, 4, 'My kids actually ate this! Miracle!', '2025-11-30 21:02:29'),
(7, 15, 4, 'Wow, the presentation is beautiful.', '2025-11-30 21:02:29'),
(8, 13, 4, 'Instructions were clear and easy to follow.', '2025-11-30 21:02:29'),
(9, 15, 6, 'Looks professional! Great job.', '2025-11-30 21:02:29'),
(10, 13, 6, 'Simple and quick, perfect for weeknight dinner.', '2025-11-30 21:02:29'),
(11, 6, 7, 'Instructions were clear and easy to follow.', '2025-11-30 21:02:29'),
(12, 15, 7, 'Best recipe for this dish I\'ve found so far.', '2025-11-30 21:02:29'),
(13, 11, 8, 'Best recipe for this dish I\'ve found so far.', '2025-11-30 21:02:29'),
(14, 2, 8, 'Looks professional! Great job.', '2025-11-30 21:02:29'),
(15, 9, 8, 'Added some extra chili and it was perfect!', '2025-11-30 21:02:29'),
(16, 12, 8, 'What can I substitute for the main ingredient?', '2025-11-30 21:02:29'),
(17, 14, 8, 'Instructions were clear and easy to follow.', '2025-11-30 21:02:29'),
(18, 5, 8, 'My kids actually ate this! Miracle!', '2025-11-30 21:02:29'),
(19, 6, 9, 'Added some extra chili and it was perfect!', '2025-11-30 21:02:29'),
(20, 4, 9, 'Wow, the presentation is beautiful.', '2025-11-30 21:02:29'),
(21, 9, 9, 'What can I substitute for the main ingredient?', '2025-11-30 21:02:29'),
(22, 12, 9, 'This looks amazing! Can\'t wait to try it.', '2025-11-30 21:02:29'),
(23, 3, 10, 'This looks amazing! Can\'t wait to try it.', '2025-11-30 21:02:29'),
(24, 9, 10, 'The sauce is the real star here.', '2025-11-30 21:02:29'),
(25, 11, 10, 'I made this yesterday and my family loved it.', '2025-11-30 21:02:29'),
(26, 14, 11, 'Simple and quick, perfect for weeknight dinner.', '2025-11-30 21:02:29'),
(27, 9, 11, 'Best recipe for this dish I\'ve found so far.', '2025-11-30 21:02:29'),
(28, 16, 11, 'Best recipe for this dish I\'ve found so far.', '2025-11-30 21:02:29'),
(29, 15, 11, 'The sauce is the real star here.', '2025-11-30 21:02:29'),
(30, 6, 12, 'My kids actually ate this! Miracle!', '2025-11-30 21:02:29'),
(31, 5, 12, 'Best recipe for this dish I\'ve found so far.', '2025-11-30 21:02:29'),
(32, 8, 12, 'A bit too salty for my taste, but good overall.', '2025-11-30 21:02:29'),
(33, 1, 13, 'Wow, the presentation is beautiful.', '2025-11-30 21:02:29'),
(34, 13, 13, 'Instructions were clear and easy to follow.', '2025-11-30 21:02:29'),
(35, 2, 14, 'My kids actually ate this! Miracle!', '2025-11-30 21:02:29'),
(36, 15, 14, 'Added some extra chili and it was perfect!', '2025-11-30 21:02:29'),
(37, 12, 14, 'A bit too salty for my taste, but good overall.', '2025-11-30 21:02:29'),
(38, 3, 14, 'Best recipe for this dish I\'ve found so far.', '2025-11-30 21:02:29'),
(39, 16, 15, 'Delicious! 10/10 would make again.', '2025-11-30 21:02:29'),
(40, 12, 16, 'Looks professional! Great job.', '2025-11-30 21:02:29'),
(41, 3, 16, 'Best recipe for this dish I\'ve found so far.', '2025-11-30 21:02:29'),
(42, 12, 17, 'Added some extra chili and it was perfect!', '2025-11-30 21:02:29'),
(43, 8, 17, 'My kids actually ate this! Miracle!', '2025-11-30 21:02:29'),
(44, 11, 17, 'Wow, the presentation is beautiful.', '2025-11-30 21:02:29'),
(45, 8, 19, 'Thanks for sharing!', '2025-11-30 21:02:29'),
(46, 16, 19, 'The sauce is the real star here.', '2025-11-30 21:02:29'),
(47, 9, 19, 'A bit too salty for my taste, but good overall.', '2025-11-30 21:02:29'),
(48, 14, 19, 'Wow, the presentation is beautiful.', '2025-11-30 21:02:29'),
(49, 6, 20, 'Wow, the presentation is beautiful.', '2025-11-30 21:02:29'),
(50, 5, 20, 'Looks professional! Great job.', '2025-11-30 21:02:29'),
(51, 13, 20, 'The sauce is the real star here.', '2025-11-30 21:02:29'),
(52, 5, 21, 'The sauce is the real star here.', '2025-11-30 21:02:29'),
(53, 3, 21, 'What can I substitute for the main ingredient?', '2025-11-30 21:02:29'),
(54, 12, 22, 'Best recipe for this dish I\'ve found so far.', '2025-11-30 21:02:29'),
(55, 4, 22, 'Instructions were clear and easy to follow.', '2025-11-30 21:02:29'),
(56, 6, 23, 'I made this yesterday and my family loved it.', '2025-11-30 21:02:29'),
(57, 7, 23, 'A bit too salty for my taste, but good overall.', '2025-11-30 21:02:29'),
(58, 4, 24, 'What can I substitute for the main ingredient?', '2025-11-30 21:02:29'),
(59, 8, 24, 'Best recipe for this dish I\'ve found so far.', '2025-11-30 21:02:29'),
(60, 16, 25, 'Added some extra chili and it was perfect!', '2025-11-30 21:02:29'),
(61, 16, 26, 'The sauce is the real star here.', '2025-11-30 21:02:29'),
(62, 3, 26, 'A bit too salty for my taste, but good overall.', '2025-11-30 21:02:29'),
(63, 4, 27, 'What can I substitute for the main ingredient?', '2025-11-30 21:02:29'),
(64, 12, 27, 'What can I substitute for the main ingredient?', '2025-11-30 21:02:29'),
(65, 16, 28, 'Simple and quick, perfect for weeknight dinner.', '2025-11-30 21:02:29'),
(66, 6, 29, 'The sauce is the real star here.', '2025-11-30 21:02:29'),
(67, 1, 29, 'My kids actually ate this! Miracle!', '2025-11-30 21:02:29'),
(68, 9, 29, 'My kids actually ate this! Miracle!', '2025-11-30 21:02:29'),
(69, 2, 29, 'Thanks for sharing!', '2025-11-30 21:02:29'),
(70, 8, 29, 'Best recipe for this dish I\'ve found so far.', '2025-11-30 21:02:29'),
(71, 15, 29, 'This looks amazing! Can\'t wait to try it.', '2025-11-30 21:02:29'),
(72, 6, 30, 'Wow, the presentation is beautiful.', '2025-11-30 21:02:29'),
(73, 15, 30, 'This looks amazing! Can\'t wait to try it.', '2025-11-30 21:02:29'),
(74, 13, 31, 'Added some extra chili and it was perfect!', '2025-11-30 21:02:29'),
(75, 15, 32, 'The sauce is the real star here.', '2025-11-30 21:02:29'),
(76, 12, 32, 'I made this yesterday and my family loved it.', '2025-11-30 21:02:29'),
(77, 1, 32, 'Thanks for sharing!', '2025-11-30 21:02:29'),
(78, 11, 32, 'Looks professional! Great job.', '2025-11-30 21:02:29'),
(79, 12, 33, 'Best recipe for this dish I\'ve found so far.', '2025-11-30 21:02:29'),
(80, 15, 33, 'Thanks for sharing!', '2025-11-30 21:02:29'),
(81, 16, 33, 'A bit too salty for my taste, but good overall.', '2025-11-30 21:02:29'),
(82, 15, 34, 'Looks professional! Great job.', '2025-11-30 21:02:29'),
(83, 14, 34, 'Delicious! 10/10 would make again.', '2025-11-30 21:02:29'),
(84, 3, 34, 'I made this yesterday and my family loved it.', '2025-11-30 21:02:29'),
(85, 4, 35, 'What can I substitute for the main ingredient?', '2025-11-30 21:02:29'),
(86, 13, 35, 'This looks amazing! Can\'t wait to try it.', '2025-11-30 21:02:29'),
(87, 9, 35, 'Simple and quick, perfect for weeknight dinner.', '2025-11-30 21:02:29'),
(88, 15, 37, 'My kids actually ate this! Miracle!', '2025-11-30 21:02:29'),
(89, 10, 37, 'My kids actually ate this! Miracle!', '2025-11-30 21:02:29'),
(90, 14, 38, 'Wow, the presentation is beautiful.', '2025-11-30 21:02:29'),
(91, 13, 38, 'A bit too salty for my taste, but good overall.', '2025-11-30 21:02:29'),
(92, 5, 38, 'Simple and quick, perfect for weeknight dinner.', '2025-11-30 21:02:29'),
(93, 2, 39, 'Thanks for sharing!', '2025-11-30 21:02:29'),
(94, 1, 40, 'This looks amazing! Can\'t wait to try it.', '2025-11-30 21:02:29'),
(95, 3, 41, 'Wow, the presentation is beautiful.', '2025-11-30 21:02:29'),
(96, 15, 42, 'My kids actually ate this! Miracle!', '2025-11-30 21:02:29'),
(97, 6, 42, 'A bit too salty for my taste, but good overall.', '2025-11-30 21:02:29');

-- --------------------------------------------------------

--
-- Table structure for table `email_template`
--

CREATE TABLE `email_template` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `subject` varchar(200) NOT NULL,
  `body_html` text NOT NULL,
  `body_text` text DEFAULT NULL,
  `variables` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`variables`)),
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `favorite`
--

CREATE TABLE `favorite` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `recipe_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `favorite`
--

INSERT INTO `favorite` (`id`, `user_id`, `recipe_id`) VALUES
(1, 7, 1),
(2, 5, 1),
(3, 14, 2),
(4, 5, 4),
(5, 15, 4),
(6, 1, 4),
(7, 13, 4),
(8, 5, 5),
(9, 8, 6),
(10, 11, 6),
(11, 6, 7),
(12, 14, 8),
(13, 6, 9),
(14, 12, 9),
(15, 13, 10),
(16, 7, 10),
(17, 15, 11),
(18, 3, 11),
(19, 6, 12),
(20, 5, 12),
(21, 8, 12),
(22, 13, 13),
(23, 2, 14),
(24, 12, 14),
(25, 16, 15),
(26, 2, 17),
(27, 8, 17),
(28, 9, 19),
(29, 10, 19),
(30, 14, 19),
(31, 1, 20),
(32, 7, 20),
(33, 2, 23),
(34, 4, 24),
(35, 3, 25),
(36, 8, 26),
(37, 14, 26),
(38, 9, 26),
(39, 4, 27),
(40, 2, 29),
(41, 15, 29),
(42, 16, 33),
(43, 15, 34),
(44, 15, 36),
(45, 13, 36),
(46, 15, 37),
(47, 5, 37),
(48, 11, 38),
(49, 4, 39),
(50, 16, 40),
(51, 13, 40),
(52, 12, 41),
(53, 3, 41),
(54, 4, 41),
(55, 5, 41),
(56, 14, 41),
(57, 15, 42),
(58, 6, 42),
(59, 2, 36),
(60, 17, 1);

-- --------------------------------------------------------

--
-- Table structure for table `follow`
--

CREATE TABLE `follow` (
  `id` int(11) NOT NULL,
  `follower_id` int(11) NOT NULL,
  `followed_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `follow`
--

INSERT INTO `follow` (`id`, `follower_id`, `followed_id`, `created_at`) VALUES
(2, 1, 2, '2025-11-30 21:02:29'),
(3, 2, 11, '2025-11-30 21:02:29'),
(5, 2, 13, '2025-11-30 21:02:29'),
(6, 2, 8, '2025-11-30 21:02:29'),
(7, 2, 9, '2025-11-30 21:02:29'),
(8, 3, 14, '2025-11-30 21:02:29'),
(9, 3, 1, '2025-11-30 21:02:29'),
(10, 4, 9, '2025-11-30 21:02:29'),
(11, 4, 11, '2025-11-30 21:02:29'),
(12, 4, 13, '2025-11-30 21:02:29'),
(13, 5, 7, '2025-11-30 21:02:29'),
(14, 5, 3, '2025-11-30 21:02:29'),
(15, 5, 4, '2025-11-30 21:02:29'),
(16, 5, 15, '2025-11-30 21:02:29'),
(17, 5, 16, '2025-11-30 21:02:29'),
(18, 6, 1, '2025-11-30 21:02:29'),
(19, 6, 2, '2025-11-30 21:02:29'),
(20, 7, 9, '2025-11-30 21:02:29'),
(21, 7, 14, '2025-11-30 21:02:29'),
(22, 7, 11, '2025-11-30 21:02:29'),
(23, 7, 8, '2025-11-30 21:02:29'),
(24, 8, 15, '2025-11-30 21:02:29'),
(25, 8, 1, '2025-11-30 21:02:29'),
(26, 8, 3, '2025-11-30 21:02:29'),
(27, 8, 16, '2025-11-30 21:02:29'),
(28, 9, 4, '2025-11-30 21:02:29'),
(29, 9, 16, '2025-11-30 21:02:29'),
(30, 9, 8, '2025-11-30 21:02:29'),
(31, 9, 11, '2025-11-30 21:02:29'),
(32, 10, 4, '2025-11-30 21:02:29'),
(33, 10, 11, '2025-11-30 21:02:29'),
(34, 10, 5, '2025-11-30 21:02:29'),
(35, 11, 7, '2025-11-30 21:02:29'),
(36, 11, 15, '2025-11-30 21:02:29'),
(37, 11, 13, '2025-11-30 21:02:29'),
(38, 11, 14, '2025-11-30 21:02:29'),
(39, 12, 16, '2025-11-30 21:02:29'),
(40, 12, 5, '2025-11-30 21:02:29'),
(41, 13, 3, '2025-11-30 21:02:29'),
(42, 14, 9, '2025-11-30 21:02:29'),
(43, 14, 11, '2025-11-30 21:02:29'),
(44, 14, 1, '2025-11-30 21:02:29'),
(45, 15, 2, '2025-11-30 21:02:29'),
(46, 15, 16, '2025-11-30 21:02:29'),
(47, 15, 7, '2025-11-30 21:02:29'),
(48, 15, 11, '2025-11-30 21:02:29'),
(49, 15, 5, '2025-11-30 21:02:29'),
(50, 16, 4, '2025-11-30 21:02:29'),
(51, 16, 6, '2025-11-30 21:02:29'),
(52, 2, 3, '2025-11-30 21:04:45'),
(53, 1, 7, '2025-12-01 23:53:25'),
(54, 1, 15, '2025-12-01 23:53:32'),
(55, 1, 16, '2025-12-01 23:53:35'),
(56, 17, 2, '2025-12-01 23:56:09'),
(58, 17, 3, '2025-12-01 23:56:11'),
(59, 17, 6, '2025-12-01 23:56:12');

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `actor_id` int(11) NOT NULL,
  `recipe_id` int(11) DEFAULT NULL,
  `notification_type` varchar(20) NOT NULL,
  `message` varchar(255) NOT NULL,
  `is_read` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`id`, `user_id`, `actor_id`, `recipe_id`, `notification_type`, `message`, `is_read`, `created_at`) VALUES
(1, 2, 12, 1, 'comment', 'đã bình luận về Strawberry Cheesecake', 0, '2025-11-30 21:02:29'),
(2, 2, 9, 1, 'comment', 'đã bình luận về Strawberry Cheesecake', 0, '2025-11-30 21:02:29'),
(3, 2, 4, 1, 'comment', 'đã bình luận về Strawberry Cheesecake', 0, '2025-11-30 21:02:29'),
(4, 3, 11, 3, 'comment', 'đã bình luận về Margherita Pizza', 0, '2025-11-30 21:02:29'),
(5, 6, 5, 4, 'comment', 'đã bình luận về Bánh Mì Thịt Nướng', 0, '2025-11-30 21:02:29'),
(6, 6, 10, 4, 'comment', 'đã bình luận về Bánh Mì Thịt Nướng', 0, '2025-11-30 21:02:29'),
(7, 6, 15, 4, 'comment', 'đã bình luận về Bánh Mì Thịt Nướng', 0, '2025-11-30 21:02:29'),
(8, 6, 13, 4, 'comment', 'đã bình luận về Bánh Mì Thịt Nướng', 0, '2025-11-30 21:02:29'),
(9, 10, 15, 6, 'comment', 'đã bình luận về Bún Chả Hà Nội', 0, '2025-11-30 21:02:29'),
(10, 10, 13, 6, 'comment', 'đã bình luận về Bún Chả Hà Nội', 0, '2025-11-30 21:02:29'),
(11, 13, 6, 7, 'comment', 'đã bình luận về Tonkatsu Ramen', 0, '2025-11-30 21:02:29'),
(12, 13, 15, 7, 'comment', 'đã bình luận về Tonkatsu Ramen', 0, '2025-11-30 21:02:29'),
(13, 6, 11, 8, 'comment', 'đã bình luận về Greek Salad', 0, '2025-11-30 21:02:29'),
(14, 6, 2, 8, 'comment', 'đã bình luận về Greek Salad', 0, '2025-11-30 21:02:29'),
(15, 6, 9, 8, 'comment', 'đã bình luận về Greek Salad', 0, '2025-11-30 21:02:29'),
(16, 6, 12, 8, 'comment', 'đã bình luận về Greek Salad', 0, '2025-11-30 21:02:29'),
(17, 6, 14, 8, 'comment', 'đã bình luận về Greek Salad', 0, '2025-11-30 21:02:29'),
(18, 6, 5, 8, 'comment', 'đã bình luận về Greek Salad', 0, '2025-11-30 21:02:29'),
(19, 14, 6, 9, 'comment', 'đã bình luận về Spaghetti Carbonara', 0, '2025-11-30 21:02:29'),
(20, 14, 4, 9, 'comment', 'đã bình luận về Spaghetti Carbonara', 0, '2025-11-30 21:02:29'),
(21, 14, 9, 9, 'comment', 'đã bình luận về Spaghetti Carbonara', 0, '2025-11-30 21:02:29'),
(22, 14, 12, 9, 'comment', 'đã bình luận về Spaghetti Carbonara', 0, '2025-11-30 21:02:29'),
(23, 6, 3, 10, 'comment', 'đã bình luận về Gỏi Cuốn (Spring Rolls)', 0, '2025-11-30 21:02:29'),
(24, 6, 9, 10, 'comment', 'đã bình luận về Gỏi Cuốn (Spring Rolls)', 0, '2025-11-30 21:02:29'),
(25, 6, 11, 10, 'comment', 'đã bình luận về Gỏi Cuốn (Spring Rolls)', 0, '2025-11-30 21:02:29'),
(26, 5, 14, 11, 'comment', 'đã bình luận về Classic Mojito', 0, '2025-11-30 21:02:29'),
(27, 5, 9, 11, 'comment', 'đã bình luận về Classic Mojito', 0, '2025-11-30 21:02:29'),
(28, 5, 16, 11, 'comment', 'đã bình luận về Classic Mojito', 0, '2025-11-30 21:02:29'),
(29, 5, 15, 11, 'comment', 'đã bình luận về Classic Mojito', 0, '2025-11-30 21:02:29'),
(30, 14, 6, 12, 'comment', 'đã bình luận về Matcha Latte', 0, '2025-11-30 21:02:29'),
(31, 14, 5, 12, 'comment', 'đã bình luận về Matcha Latte', 0, '2025-11-30 21:02:29'),
(32, 14, 8, 12, 'comment', 'đã bình luận về Matcha Latte', 0, '2025-11-30 21:02:29'),
(33, 15, 1, 13, 'comment', 'đã bình luận về Chocolate Lava Cake', 0, '2025-11-30 21:02:29'),
(34, 15, 13, 13, 'comment', 'đã bình luận về Chocolate Lava Cake', 0, '2025-11-30 21:02:29'),
(35, 16, 2, 14, 'comment', 'đã bình luận về Avocado Toast', 0, '2025-11-30 21:02:29'),
(36, 16, 15, 14, 'comment', 'đã bình luận về Avocado Toast', 0, '2025-11-30 21:02:29'),
(37, 16, 12, 14, 'comment', 'đã bình luận về Avocado Toast', 0, '2025-11-30 21:02:29'),
(38, 16, 3, 14, 'comment', 'đã bình luận về Avocado Toast', 0, '2025-11-30 21:02:29'),
(39, 4, 16, 15, 'comment', 'đã bình luận về Margherita Pizza', 0, '2025-11-30 21:02:29'),
(40, 7, 12, 16, 'comment', 'đã bình luận về Classic Mojito', 0, '2025-11-30 21:02:29'),
(41, 7, 3, 16, 'comment', 'đã bình luận về Classic Mojito', 0, '2025-11-30 21:02:29'),
(42, 6, 12, 17, 'comment', 'đã bình luận về Bún Chả Hà Nội', 0, '2025-11-30 21:02:29'),
(43, 6, 8, 17, 'comment', 'đã bình luận về Bún Chả Hà Nội', 0, '2025-11-30 21:02:29'),
(44, 6, 11, 17, 'comment', 'đã bình luận về Bún Chả Hà Nội', 0, '2025-11-30 21:02:29'),
(45, 5, 8, 19, 'comment', 'đã bình luận về Matcha Latte', 0, '2025-11-30 21:02:29'),
(46, 5, 16, 19, 'comment', 'đã bình luận về Matcha Latte', 0, '2025-11-30 21:02:29'),
(47, 5, 9, 19, 'comment', 'đã bình luận về Matcha Latte', 0, '2025-11-30 21:02:29'),
(48, 5, 14, 19, 'comment', 'đã bình luận về Matcha Latte', 0, '2025-11-30 21:02:29'),
(49, 10, 6, 20, 'comment', 'đã bình luận về Bánh Mì Thịt Nướng', 0, '2025-11-30 21:02:29'),
(50, 10, 5, 20, 'comment', 'đã bình luận về Bánh Mì Thịt Nướng', 0, '2025-11-30 21:02:29'),
(51, 10, 13, 20, 'comment', 'đã bình luận về Bánh Mì Thịt Nướng', 0, '2025-11-30 21:02:29'),
(52, 13, 5, 21, 'comment', 'đã bình luận về Phở Bò Tái Nạm', 0, '2025-11-30 21:02:29'),
(53, 13, 3, 21, 'comment', 'đã bình luận về Phở Bò Tái Nạm', 0, '2025-11-30 21:02:29'),
(54, 1, 12, 22, 'comment', 'đã bình luận về Avocado Toast', 0, '2025-11-30 21:02:29'),
(55, 1, 4, 22, 'comment', 'đã bình luận về Avocado Toast', 0, '2025-11-30 21:02:29'),
(56, 15, 6, 23, 'comment', 'đã bình luận về Strawberry Cheesecake', 0, '2025-11-30 21:02:29'),
(57, 15, 7, 23, 'comment', 'đã bình luận về Strawberry Cheesecake', 0, '2025-11-30 21:02:29'),
(58, 14, 4, 24, 'comment', 'đã bình luận về Greek Salad', 0, '2025-11-30 21:02:29'),
(59, 14, 8, 24, 'comment', 'đã bình luận về Greek Salad', 0, '2025-11-30 21:02:29'),
(60, 11, 16, 25, 'comment', 'đã bình luận về Tonkatsu Ramen', 0, '2025-11-30 21:02:29'),
(61, 4, 16, 26, 'comment', 'đã bình luận về Gỏi Cuốn (Spring Rolls)', 0, '2025-11-30 21:02:29'),
(62, 4, 3, 26, 'comment', 'đã bình luận về Gỏi Cuốn (Spring Rolls)', 0, '2025-11-30 21:02:29'),
(63, 13, 4, 27, 'comment', 'đã bình luận về Sushi Platter', 0, '2025-11-30 21:02:29'),
(64, 13, 12, 27, 'comment', 'đã bình luận về Sushi Platter', 0, '2025-11-30 21:02:29'),
(65, 4, 16, 28, 'comment', 'đã bình luận về Chocolate Lava Cake', 0, '2025-11-30 21:02:29'),
(66, 10, 6, 29, 'comment', 'đã bình luận về Bún Chả Hà Nội', 0, '2025-11-30 21:02:29'),
(67, 10, 1, 29, 'comment', 'đã bình luận về Bún Chả Hà Nội', 0, '2025-11-30 21:02:29'),
(68, 10, 9, 29, 'comment', 'đã bình luận về Bún Chả Hà Nội', 0, '2025-11-30 21:02:29'),
(69, 10, 2, 29, 'comment', 'đã bình luận về Bún Chả Hà Nội', 0, '2025-11-30 21:02:29'),
(70, 10, 8, 29, 'comment', 'đã bình luận về Bún Chả Hà Nội', 0, '2025-11-30 21:02:29'),
(71, 10, 15, 29, 'comment', 'đã bình luận về Bún Chả Hà Nội', 0, '2025-11-30 21:02:29'),
(72, 3, 6, 30, 'comment', 'đã bình luận về Classic Mojito', 0, '2025-11-30 21:02:29'),
(73, 3, 15, 30, 'comment', 'đã bình luận về Classic Mojito', 0, '2025-11-30 21:02:29'),
(74, 1, 13, 31, 'comment', 'đã bình luận về Chocolate Lava Cake', 0, '2025-11-30 21:02:29'),
(75, 3, 15, 32, 'comment', 'đã bình luận về Bánh Mì Thịt Nướng', 0, '2025-11-30 21:02:29'),
(76, 3, 12, 32, 'comment', 'đã bình luận về Bánh Mì Thịt Nướng', 0, '2025-11-30 21:02:29'),
(77, 3, 1, 32, 'comment', 'đã bình luận về Bánh Mì Thịt Nướng', 0, '2025-11-30 21:02:29'),
(78, 3, 11, 32, 'comment', 'đã bình luận về Bánh Mì Thịt Nướng', 0, '2025-11-30 21:02:29'),
(79, 3, 12, 33, 'comment', 'đã bình luận về Spaghetti Carbonara', 0, '2025-11-30 21:02:29'),
(80, 3, 15, 33, 'comment', 'đã bình luận về Spaghetti Carbonara', 0, '2025-11-30 21:02:29'),
(81, 3, 16, 33, 'comment', 'đã bình luận về Spaghetti Carbonara', 0, '2025-11-30 21:02:29'),
(82, 8, 15, 34, 'comment', 'đã bình luận về Phở Bò Tái Nạm', 0, '2025-11-30 21:02:29'),
(83, 8, 14, 34, 'comment', 'đã bình luận về Phở Bò Tái Nạm', 0, '2025-11-30 21:02:29'),
(84, 8, 3, 34, 'comment', 'đã bình luận về Phở Bò Tái Nạm', 0, '2025-11-30 21:02:29'),
(85, 2, 4, 35, 'comment', 'đã bình luận về Sushi Platter', 0, '2025-11-30 21:02:29'),
(86, 2, 13, 35, 'comment', 'đã bình luận về Sushi Platter', 0, '2025-11-30 21:02:29'),
(87, 2, 9, 35, 'comment', 'đã bình luận về Sushi Platter', 0, '2025-11-30 21:02:29'),
(88, 2, 15, 37, 'comment', 'đã bình luận về Greek Salad', 0, '2025-11-30 21:02:29'),
(89, 2, 10, 37, 'comment', 'đã bình luận về Greek Salad', 0, '2025-11-30 21:02:29'),
(90, 12, 14, 38, 'comment', 'đã bình luận về Matcha Latte', 0, '2025-11-30 21:02:29'),
(91, 12, 13, 38, 'comment', 'đã bình luận về Matcha Latte', 0, '2025-11-30 21:02:29'),
(92, 12, 5, 38, 'comment', 'đã bình luận về Matcha Latte', 0, '2025-11-30 21:02:29'),
(93, 1, 2, 39, 'comment', 'đã bình luận về Tonkatsu Ramen', 0, '2025-11-30 21:02:29'),
(94, 4, 1, 40, 'comment', 'đã bình luận về Margherita Pizza', 0, '2025-11-30 21:02:29'),
(95, 13, 3, 41, 'comment', 'đã bình luận về Avocado Toast', 0, '2025-11-30 21:02:29'),
(96, 10, 15, 42, 'comment', 'đã bình luận về Strawberry Cheesecake', 0, '2025-11-30 21:02:29'),
(97, 10, 6, 42, 'comment', 'đã bình luận về Strawberry Cheesecake', 0, '2025-11-30 21:02:29'),
(98, 7, 1, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(99, 2, 1, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(100, 11, 2, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(101, 6, 2, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(102, 13, 2, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(103, 8, 2, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(104, 9, 2, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(105, 14, 3, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(106, 1, 3, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(107, 9, 4, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(108, 11, 4, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(109, 13, 4, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(110, 7, 5, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(111, 3, 5, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(112, 4, 5, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(113, 15, 5, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(114, 16, 5, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(115, 1, 6, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(116, 2, 6, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(117, 9, 7, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(118, 14, 7, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(119, 11, 7, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(120, 8, 7, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(121, 15, 8, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(122, 1, 8, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(123, 3, 8, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(124, 16, 8, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(125, 4, 9, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(126, 16, 9, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(127, 8, 9, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(128, 11, 9, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(129, 4, 10, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(130, 11, 10, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(131, 5, 10, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(132, 7, 11, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(133, 15, 11, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(134, 13, 11, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(135, 14, 11, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(136, 16, 12, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(137, 5, 12, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(138, 3, 13, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(139, 9, 14, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(140, 11, 14, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(141, 1, 14, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(142, 2, 15, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(143, 16, 15, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(144, 7, 15, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(145, 11, 15, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(146, 5, 15, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(147, 4, 16, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(148, 6, 16, NULL, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:02:29'),
(149, 3, 2, 3, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:04:46'),
(150, 7, 1, 16, 'follow', 'đã theo dõi bạn', 0, '2025-12-01 23:53:25'),
(151, 15, 1, 5, 'follow', 'đã theo dõi bạn', 0, '2025-12-01 23:53:32'),
(152, 16, 1, 14, 'follow', 'đã theo dõi bạn', 0, '2025-12-01 23:53:35'),
(153, 2, 17, 1, 'follow', 'đã theo dõi bạn', 0, '2025-12-01 23:56:09'),
(154, 5, 17, 2, 'follow', 'đã theo dõi bạn', 0, '2025-12-01 23:56:10'),
(155, 3, 17, 3, 'follow', 'đã theo dõi bạn', 0, '2025-12-01 23:56:11'),
(156, 6, 17, 4, 'follow', 'đã theo dõi bạn', 0, '2025-12-01 23:56:12');

-- --------------------------------------------------------

--
-- Table structure for table `rating`
--

CREATE TABLE `rating` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `recipe_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `rating`
--

INSERT INTO `rating` (`id`, `user_id`, `recipe_id`, `rating`, `created_at`) VALUES
(1, 12, 1, 4, '2025-11-30 21:02:29'),
(2, 7, 1, 4, '2025-11-30 21:02:29'),
(3, 9, 1, 5, '2025-11-30 21:02:29'),
(4, 10, 1, 5, '2025-11-30 21:02:29'),
(5, 4, 1, 5, '2025-11-30 21:02:29'),
(6, 5, 1, 5, '2025-11-30 21:02:29'),
(7, 6, 1, 5, '2025-11-30 21:02:29'),
(8, 6, 2, 5, '2025-11-30 21:02:29'),
(9, 14, 2, 4, '2025-11-30 21:02:29'),
(10, 8, 3, 4, '2025-11-30 21:02:29'),
(11, 11, 3, 3, '2025-11-30 21:02:29'),
(12, 5, 4, 3, '2025-11-30 21:02:29'),
(13, 10, 4, 5, '2025-11-30 21:02:29'),
(14, 15, 4, 4, '2025-11-30 21:02:29'),
(15, 1, 4, 5, '2025-11-30 21:02:29'),
(16, 7, 4, 3, '2025-11-30 21:02:29'),
(17, 13, 4, 5, '2025-11-30 21:02:29'),
(18, 6, 5, 4, '2025-11-30 21:02:29'),
(19, 10, 5, 4, '2025-11-30 21:02:29'),
(20, 8, 5, 5, '2025-11-30 21:02:29'),
(21, 5, 5, 5, '2025-11-30 21:02:29'),
(22, 9, 6, 5, '2025-11-30 21:02:29'),
(23, 14, 6, 5, '2025-11-30 21:02:29'),
(24, 15, 6, 5, '2025-11-30 21:02:29'),
(25, 13, 6, 5, '2025-11-30 21:02:29'),
(26, 8, 6, 4, '2025-11-30 21:02:29'),
(27, 11, 6, 3, '2025-11-30 21:02:29'),
(28, 6, 7, 4, '2025-11-30 21:02:29'),
(29, 16, 7, 5, '2025-11-30 21:02:29'),
(30, 7, 7, 5, '2025-11-30 21:02:29'),
(31, 12, 7, 3, '2025-11-30 21:02:29'),
(32, 15, 7, 3, '2025-11-30 21:02:29'),
(33, 11, 8, 4, '2025-11-30 21:02:29'),
(34, 2, 8, 5, '2025-11-30 21:02:29'),
(35, 9, 8, 5, '2025-11-30 21:02:29'),
(36, 12, 8, 5, '2025-11-30 21:02:29'),
(37, 14, 8, 4, '2025-11-30 21:02:29'),
(38, 8, 8, 3, '2025-11-30 21:02:29'),
(39, 5, 8, 4, '2025-11-30 21:02:29'),
(40, 3, 9, 5, '2025-11-30 21:02:29'),
(41, 10, 9, 5, '2025-11-30 21:02:29'),
(42, 1, 9, 4, '2025-11-30 21:02:29'),
(43, 6, 9, 5, '2025-11-30 21:02:29'),
(44, 4, 9, 5, '2025-11-30 21:02:29'),
(45, 9, 9, 5, '2025-11-30 21:02:29'),
(46, 12, 9, 5, '2025-11-30 21:02:29'),
(47, 13, 10, 5, '2025-11-30 21:02:29'),
(48, 3, 10, 4, '2025-11-30 21:02:29'),
(49, 9, 10, 5, '2025-11-30 21:02:29'),
(50, 11, 10, 5, '2025-11-30 21:02:29'),
(51, 7, 10, 4, '2025-11-30 21:02:29'),
(52, 14, 11, 4, '2025-11-30 21:02:29'),
(53, 9, 11, 5, '2025-11-30 21:02:29'),
(54, 16, 11, 5, '2025-11-30 21:02:29'),
(55, 12, 11, 3, '2025-11-30 21:02:29'),
(56, 15, 11, 5, '2025-11-30 21:02:29'),
(57, 3, 11, 5, '2025-11-30 21:02:29'),
(58, 6, 12, 5, '2025-11-30 21:02:29'),
(59, 5, 12, 3, '2025-11-30 21:02:29'),
(60, 4, 12, 5, '2025-11-30 21:02:29'),
(61, 10, 12, 5, '2025-11-30 21:02:29'),
(62, 8, 12, 4, '2025-11-30 21:02:29'),
(63, 5, 13, 5, '2025-11-30 21:02:29'),
(64, 1, 13, 4, '2025-11-30 21:02:29'),
(65, 13, 13, 4, '2025-11-30 21:02:29'),
(66, 2, 14, 3, '2025-11-30 21:02:29'),
(67, 13, 14, 4, '2025-11-30 21:02:29'),
(68, 14, 14, 5, '2025-11-30 21:02:29'),
(69, 15, 14, 4, '2025-11-30 21:02:29'),
(70, 12, 14, 4, '2025-11-30 21:02:29'),
(71, 4, 14, 4, '2025-11-30 21:02:29'),
(72, 3, 14, 5, '2025-11-30 21:02:29'),
(73, 16, 15, 5, '2025-11-30 21:02:29'),
(74, 11, 15, 5, '2025-11-30 21:02:29'),
(75, 10, 15, 5, '2025-11-30 21:02:29'),
(76, 12, 16, 5, '2025-11-30 21:02:29'),
(77, 6, 16, 5, '2025-11-30 21:02:29'),
(78, 5, 16, 4, '2025-11-30 21:02:29'),
(79, 13, 16, 5, '2025-11-30 21:02:29'),
(80, 15, 16, 5, '2025-11-30 21:02:29'),
(81, 1, 16, 5, '2025-11-30 21:02:29'),
(82, 2, 16, 5, '2025-11-30 21:02:29'),
(83, 3, 16, 4, '2025-11-30 21:02:29'),
(84, 15, 17, 4, '2025-11-30 21:02:29'),
(85, 1, 17, 5, '2025-11-30 21:02:29'),
(86, 16, 17, 5, '2025-11-30 21:02:29'),
(87, 12, 17, 5, '2025-11-30 21:02:29'),
(88, 2, 17, 5, '2025-11-30 21:02:29'),
(89, 8, 17, 5, '2025-11-30 21:02:29'),
(90, 11, 17, 3, '2025-11-30 21:02:29'),
(91, 4, 18, 5, '2025-11-30 21:02:29'),
(92, 5, 18, 4, '2025-11-30 21:02:29'),
(93, 7, 18, 5, '2025-11-30 21:02:29'),
(94, 8, 19, 4, '2025-11-30 21:02:29'),
(95, 16, 19, 3, '2025-11-30 21:02:29'),
(96, 9, 19, 5, '2025-11-30 21:02:29'),
(97, 10, 19, 4, '2025-11-30 21:02:29'),
(98, 7, 19, 5, '2025-11-30 21:02:29'),
(99, 3, 19, 5, '2025-11-30 21:02:29'),
(100, 14, 19, 5, '2025-11-30 21:02:29'),
(101, 2, 20, 4, '2025-11-30 21:02:29'),
(102, 15, 20, 4, '2025-11-30 21:02:29'),
(103, 6, 20, 4, '2025-11-30 21:02:29'),
(104, 5, 20, 5, '2025-11-30 21:02:29'),
(105, 1, 20, 5, '2025-11-30 21:02:29'),
(106, 7, 20, 4, '2025-11-30 21:02:29'),
(107, 13, 20, 4, '2025-11-30 21:02:29'),
(108, 5, 21, 5, '2025-11-30 21:02:29'),
(109, 7, 21, 5, '2025-11-30 21:02:29'),
(110, 16, 21, 3, '2025-11-30 21:02:29'),
(111, 4, 21, 5, '2025-11-30 21:02:29'),
(112, 3, 21, 4, '2025-11-30 21:02:29'),
(113, 11, 21, 5, '2025-11-30 21:02:29'),
(114, 12, 22, 5, '2025-11-30 21:02:29'),
(115, 4, 22, 5, '2025-11-30 21:02:29'),
(116, 16, 23, 5, '2025-11-30 21:02:29'),
(117, 6, 23, 4, '2025-11-30 21:02:29'),
(118, 7, 23, 5, '2025-11-30 21:02:29'),
(119, 2, 23, 5, '2025-11-30 21:02:29'),
(120, 4, 24, 3, '2025-11-30 21:02:29'),
(121, 8, 24, 5, '2025-11-30 21:02:29'),
(122, 9, 24, 4, '2025-11-30 21:02:29'),
(123, 6, 24, 4, '2025-11-30 21:02:29'),
(124, 3, 25, 5, '2025-11-30 21:02:29'),
(125, 1, 25, 3, '2025-11-30 21:02:29'),
(126, 16, 25, 5, '2025-11-30 21:02:29'),
(127, 9, 25, 4, '2025-11-30 21:02:29'),
(128, 1, 26, 5, '2025-11-30 21:02:29'),
(129, 15, 26, 4, '2025-11-30 21:02:29'),
(130, 8, 26, 5, '2025-11-30 21:02:29'),
(131, 16, 26, 5, '2025-11-30 21:02:29'),
(132, 14, 26, 5, '2025-11-30 21:02:29'),
(133, 3, 26, 5, '2025-11-30 21:02:29'),
(134, 9, 26, 4, '2025-11-30 21:02:29'),
(135, 8, 27, 5, '2025-11-30 21:02:29'),
(136, 4, 27, 5, '2025-11-30 21:02:29'),
(137, 16, 27, 3, '2025-11-30 21:02:29'),
(138, 6, 27, 4, '2025-11-30 21:02:29'),
(139, 12, 27, 4, '2025-11-30 21:02:29'),
(140, 13, 28, 4, '2025-11-30 21:02:29'),
(141, 11, 28, 4, '2025-11-30 21:02:29'),
(142, 16, 28, 5, '2025-11-30 21:02:29'),
(143, 10, 28, 5, '2025-11-30 21:02:29'),
(144, 6, 29, 5, '2025-11-30 21:02:29'),
(145, 1, 29, 4, '2025-11-30 21:02:29'),
(146, 9, 29, 3, '2025-11-30 21:02:29'),
(147, 2, 29, 4, '2025-11-30 21:02:29'),
(148, 16, 29, 5, '2025-11-30 21:02:29'),
(149, 8, 29, 5, '2025-11-30 21:02:29'),
(150, 15, 29, 5, '2025-11-30 21:02:29'),
(151, 12, 30, 5, '2025-11-30 21:02:29'),
(152, 6, 30, 5, '2025-11-30 21:02:29'),
(153, 15, 30, 3, '2025-11-30 21:02:29'),
(154, 6, 31, 4, '2025-11-30 21:02:29'),
(155, 13, 31, 5, '2025-11-30 21:02:29'),
(156, 7, 31, 5, '2025-11-30 21:02:29'),
(157, 15, 32, 4, '2025-11-30 21:02:29'),
(158, 12, 32, 4, '2025-11-30 21:02:29'),
(159, 1, 32, 5, '2025-11-30 21:02:29'),
(160, 2, 32, 4, '2025-11-30 21:02:29'),
(161, 14, 32, 5, '2025-11-30 21:02:29'),
(162, 11, 32, 5, '2025-11-30 21:02:29'),
(163, 13, 32, 4, '2025-11-30 21:02:29'),
(164, 12, 33, 5, '2025-11-30 21:02:29'),
(165, 15, 33, 5, '2025-11-30 21:02:29'),
(166, 16, 33, 4, '2025-11-30 21:02:29'),
(167, 15, 34, 4, '2025-11-30 21:02:29'),
(168, 14, 34, 3, '2025-11-30 21:02:29'),
(169, 3, 34, 5, '2025-11-30 21:02:29'),
(170, 6, 34, 4, '2025-11-30 21:02:29'),
(171, 5, 34, 5, '2025-11-30 21:02:29'),
(172, 9, 34, 5, '2025-11-30 21:02:29'),
(173, 8, 35, 5, '2025-11-30 21:02:29'),
(174, 4, 35, 4, '2025-11-30 21:02:29'),
(175, 13, 35, 4, '2025-11-30 21:02:29'),
(176, 9, 35, 4, '2025-11-30 21:02:29'),
(177, 1, 35, 4, '2025-11-30 21:02:29'),
(178, 15, 36, 5, '2025-11-30 21:02:29'),
(179, 9, 36, 3, '2025-11-30 21:02:29'),
(180, 12, 36, 4, '2025-11-30 21:02:29'),
(181, 6, 36, 5, '2025-11-30 21:02:29'),
(182, 13, 36, 4, '2025-11-30 21:02:29'),
(183, 15, 37, 5, '2025-11-30 21:02:29'),
(184, 14, 37, 3, '2025-11-30 21:02:29'),
(185, 10, 37, 5, '2025-11-30 21:02:29'),
(186, 5, 37, 5, '2025-11-30 21:02:29'),
(187, 14, 38, 4, '2025-11-30 21:02:29'),
(188, 13, 38, 4, '2025-11-30 21:02:29'),
(189, 5, 38, 4, '2025-11-30 21:02:29'),
(190, 3, 38, 4, '2025-11-30 21:02:29'),
(191, 6, 38, 5, '2025-11-30 21:02:29'),
(192, 11, 38, 5, '2025-11-30 21:02:29'),
(193, 9, 38, 3, '2025-11-30 21:02:29'),
(194, 16, 39, 5, '2025-11-30 21:02:29'),
(195, 8, 39, 5, '2025-11-30 21:02:29'),
(196, 4, 39, 4, '2025-11-30 21:02:29'),
(197, 2, 39, 5, '2025-11-30 21:02:29'),
(198, 12, 40, 5, '2025-11-30 21:02:29'),
(199, 16, 40, 5, '2025-11-30 21:02:29'),
(200, 1, 40, 4, '2025-11-30 21:02:29'),
(201, 3, 40, 5, '2025-11-30 21:02:29'),
(202, 13, 40, 5, '2025-11-30 21:02:29'),
(203, 12, 41, 3, '2025-11-30 21:02:29'),
(204, 3, 41, 3, '2025-11-30 21:02:29'),
(205, 4, 41, 3, '2025-11-30 21:02:29'),
(206, 5, 41, 4, '2025-11-30 21:02:29'),
(207, 14, 41, 5, '2025-11-30 21:02:29'),
(208, 3, 42, 4, '2025-11-30 21:02:29'),
(209, 1, 42, 4, '2025-11-30 21:02:29'),
(210, 4, 42, 3, '2025-11-30 21:02:29'),
(211, 11, 42, 5, '2025-11-30 21:02:29'),
(212, 15, 42, 5, '2025-11-30 21:02:29'),
(213, 6, 42, 4, '2025-11-30 21:02:29');

-- --------------------------------------------------------

--
-- Table structure for table `recipe`
--

CREATE TABLE `recipe` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `ingredients` text NOT NULL,
  `instructions` text NOT NULL,
  `cooking_time` int(11) NOT NULL,
  `difficulty` varchar(20) NOT NULL,
  `category` varchar(50) NOT NULL,
  `recipe_type` varchar(20) NOT NULL,
  `image_url` varchar(200) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'approved',
  `created_at` datetime DEFAULT current_timestamp(),
  `category_id` int(11) DEFAULT NULL,
  `view_count` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `recipe`
--

INSERT INTO `recipe` (`id`, `title`, `description`, `ingredients`, `instructions`, `cooking_time`, `difficulty`, `category`, `recipe_type`, `image_url`, `user_id`, `status`, `created_at`, `category_id`, `view_count`) VALUES
(1, 'Strawberry Cheesecake', 'Creamy no-bake cheesecake with fresh strawberry topping.', 'Cream cheese\r\nHeavy cream\r\nGraham crackers\r\nButter\r\nStrawberries\r\nSugar\r\nGelatin', '1. Make crust\r\n2. Whip cream and cheese\r\n3. Set in fridge\r\n4. Make strawberry sauce\r\n5. Top and serve', 300, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1565958011703-44f9829ba187', 2, 'approved', '2025-12-01 23:50:53', NULL, 0),
(2, 'Phở Bò Tái Nạm', 'Traditional Vietnamese beef noodle soup with rare beef and brisket.', 'Beef bones\nRice noodles\nBeef tenderloin\nBrisket\nStar anise\nCinnamon\nGinger\nOnion\nFish sauce', '1. Simmer bones for 6 hours\n2. Char ginger and onion\n3. Add spices\n4. Blanch noodles\n5. Slice beef thin\n6. Pour hot broth over noodles and beef', 180, 'Hard', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43', 5, 'approved', '2025-12-01 23:50:53', NULL, 0),
(3, 'Margherita Pizza', 'Neapolitan style pizza with San Marzano tomatoes and buffalo mozzarella.', '00 Flour\nYeast\nSan Marzano tomatoes\nBuffalo mozzarella\nBasil\nOlive oil', '1. Make dough and proof\n2. Stretch dough\n3. Top with sauce and cheese\n4. Bake at max temp\n5. Garnish with basil', 90, 'Hard', 'Italian', 'food', 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400', 3, 'approved', '2025-12-01 23:50:53', NULL, 0),
(4, 'Bánh Mì Thịt Nướng', 'Crispy baguette filled with grilled pork, pâté, and pickled vegetables.', 'Baguette\nPork shoulder\nLemongrass\nFish sauce\nPickled carrots\nCilantro\nChili\nPâté\nMayo', '1. Marinate pork with lemongrass\n2. Grill pork until charred\n3. Toast baguette\n4. Spread pâté and mayo\n5. Assemble with meat and veggies', 45, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1626804475297-411dbe6314c9', 6, 'approved', '2025-12-01 23:50:53', NULL, 0),
(5, 'Sushi Platter', 'Assorted nigiri and maki rolls with fresh fish.', 'Sushi rice\nVinegar\nSalmon\nTuna\nNori\nCucumber\nAvocado\nWasabi', '1. Cook and season rice\n2. Slice fish\n3. Form nigiri\n4. Roll maki\n5. Arrange on platter', 60, 'Hard', 'Japanese', 'food', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c', 15, 'approved', '2025-12-01 23:50:53', NULL, 0),
(6, 'Bún Chả Hà Nội', 'Grilled pork meatballs and belly served with vermicelli and dipping sauce.', 'Ground pork\nPork belly\nFish sauce\nSugar\nGarlic\nVinegar\nPapaya\nVermicelli\nHerbs', '1. Marinate ground pork and belly separately\n2. Grill over charcoal\n3. Make dipping sauce with papaya\n4. Serve with fresh herbs and noodles', 60, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1585325701165-351af916e581', 10, 'approved', '2025-12-01 23:50:53', NULL, 0),
(7, 'Tonkatsu Ramen', 'Rich pork bone broth ramen with chashu pork.', 'Pork bones\nRamen noodles\nChashu pork\nEgg\nMenma\nGreen onions\nNori', '1. Boil bones for 12 hours\n2. Make tare\n3. Cook noodles\n4. Assemble bowl\n5. Top with toppings', 720, 'Hard', 'Japanese', 'food', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400', 13, 'approved', '2025-12-01 23:50:53', NULL, 0),
(8, 'Greek Salad', 'Fresh salad with cucumber, tomato, olives, and feta.', 'Cucumber\nTomato\nRed onion\nKalamata olives\nFeta cheese\nOregano\nOlive oil', '1. Chop veggies chunks\n2. Slice onion thin\n3. Combine in bowl\n4. Top with feta block\n5. Drizzle oil and oregano', 15, 'Easy', 'Healthy', 'food', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', 6, 'approved', '2025-12-01 23:50:53', NULL, 0),
(9, 'Spaghetti Carbonara', 'Classic Roman pasta with eggs, cheese, guanciale, and black pepper.', 'Spaghetti\nEggs\nPecorino Romano\nGuanciale\nBlack pepper', '1. Cook pasta\n2. Fry guanciale\n3. Mix eggs and cheese\n4. Toss pasta with fat\n5. Mix in egg mixture off heat\n6. Top with pepper', 25, 'Medium', 'Italian', 'food', 'https://images.unsplash.com/photo-1612874742237-98280d20748b?w=400', 14, 'approved', '2025-12-01 23:50:53', NULL, 0),
(10, 'Gỏi Cuốn (Spring Rolls)', 'Fresh summer rolls with shrimp, pork, herbs, and vermicelli.', 'Rice paper\nShrimp\nPork belly\nVermicelli\nLettuce\nMint\nChives\nPeanut sauce', '1. Boil shrimp and pork\n2. Cook vermicelli\n3. Wet rice paper\n4. Layer ingredients\n5. Roll tightly\n6. Serve with peanut sauce', 30, 'Easy', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb', 6, 'approved', '2025-12-01 23:50:53', NULL, 0),
(11, 'Classic Mojito', 'Refreshing Cuban cocktail with mint and lime.', 'White rum\nMint leaves\nLime\nSugar\nSoda water\nIce', '1. Muddle mint and lime\n2. Add rum and sugar\n3. Fill with ice\n4. Top with soda\n5. Garnish', 5, 'Easy', 'Drinks', 'drink', 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd', 5, 'approved', '2025-12-01 23:50:53', NULL, 0),
(12, 'Matcha Latte', 'Creamy iced matcha latte.', 'Matcha powder\nMilk\nSugar syrup\nIce\nHot water', '1. Whisk matcha with hot water\n2. Fill glass with ice and milk\n3. Pour matcha over milk\n4. Sweeten to taste', 10, 'Easy', 'Drinks', 'drink', 'https://images.unsplash.com/photo-1515825838458-f2a94b20105a', 14, 'approved', '2025-12-01 23:50:53', NULL, 0),
(13, 'Chocolate Lava Cake', 'Warm chocolate cake with a molten center.', 'Dark chocolate\nButter\nEggs\nSugar\nFlour\nVanilla', '1. Melt chocolate and butter\n2. Whisk eggs and sugar\n3. Combine and add flour\n4. Bake 12 mins at 200C\n5. Serve warm', 20, 'Medium', 'Dessert', 'food', 'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=400', 15, 'approved', '2025-12-01 23:50:53', NULL, 0),
(14, 'Avocado Toast', 'Sourdough toast with smashed avocado and poached egg.', 'Sourdough bread\nAvocado\nEgg\nChili flakes\nLemon\nSalt', '1. Toast bread\n2. Smash avocado with lemon\n3. Poach egg\n4. Assemble\n5. Season', 10, 'Easy', 'Healthy', 'food', 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=400', 16, 'approved', '2025-12-01 23:50:53', NULL, 0),
(15, 'Margherita Pizza', 'Neapolitan style pizza with San Marzano tomatoes and buffalo mozzarella.', '00 Flour\nYeast\nSan Marzano tomatoes\nBuffalo mozzarella\nBasil\nOlive oil', '1. Make dough and proof\n2. Stretch dough\n3. Top with sauce and cheese\n4. Bake at max temp\n5. Garnish with basil', 90, 'Hard', 'Italian', 'food', 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400', 4, 'approved', '2025-12-01 23:50:53', NULL, 0),
(16, 'Classic Mojito', 'Refreshing Cuban cocktail with mint and lime.', 'White rum\nMint leaves\nLime\nSugar\nSoda water\nIce', '1. Muddle mint and lime\n2. Add rum and sugar\n3. Fill with ice\n4. Top with soda\n5. Garnish', 5, 'Easy', 'Drinks', 'drink', 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd', 7, 'approved', '2025-12-01 23:50:53', NULL, 0),
(17, 'Bún Chả Hà Nội', 'Grilled pork meatballs and belly served with vermicelli and dipping sauce.', 'Ground pork\nPork belly\nFish sauce\nSugar\nGarlic\nVinegar\nPapaya\nVermicelli\nHerbs', '1. Marinate ground pork and belly separately\n2. Grill over charcoal\n3. Make dipping sauce with papaya\n4. Serve with fresh herbs and noodles', 60, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1585325701165-351af916e581', 6, 'approved', '2025-12-01 23:50:53', NULL, 0),
(18, 'Spaghetti Carbonara', 'Classic Roman pasta with eggs, cheese, guanciale, and black pepper.', 'Spaghetti\nEggs\nPecorino Romano\nGuanciale\nBlack pepper', '1. Cook pasta\n2. Fry guanciale\n3. Mix eggs and cheese\n4. Toss pasta with fat\n5. Mix in egg mixture off heat\n6. Top with pepper', 25, 'Medium', 'Italian', 'food', 'https://images.unsplash.com/photo-1612874742237-98280d20748b?w=400', 15, 'approved', '2025-12-01 23:50:53', NULL, 0),
(19, 'Matcha Latte', 'Creamy iced matcha latte.', 'Matcha powder\nMilk\nSugar syrup\nIce\nHot water', '1. Whisk matcha with hot water\n2. Fill glass with ice and milk\n3. Pour matcha over milk\n4. Sweeten to taste', 10, 'Easy', 'Drinks', 'drink', 'https://images.unsplash.com/photo-1515825838458-f2a94b20105a', 5, 'approved', '2025-12-01 23:50:53', NULL, 0),
(20, 'Bánh Mì Thịt Nướng', 'Crispy baguette filled with grilled pork, pâté, and pickled vegetables.', 'Baguette\nPork shoulder\nLemongrass\nFish sauce\nPickled carrots\nCilantro\nChili\nPâté\nMayo', '1. Marinate pork with lemongrass\n2. Grill pork until charred\n3. Toast baguette\n4. Spread pâté and mayo\n5. Assemble with meat and veggies', 45, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1626804475297-411dbe6314c9', 10, 'approved', '2025-12-01 23:50:53', NULL, 0),
(21, 'Phở Bò Tái Nạm', 'Traditional Vietnamese beef noodle soup with rare beef and brisket.', 'Beef bones\nRice noodles\nBeef tenderloin\nBrisket\nStar anise\nCinnamon\nGinger\nOnion\nFish sauce', '1. Simmer bones for 6 hours\n2. Char ginger and onion\n3. Add spices\n4. Blanch noodles\n5. Slice beef thin\n6. Pour hot broth over noodles and beef', 180, 'Hard', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43', 13, 'approved', '2025-12-01 23:50:53', NULL, 0),
(22, 'Avocado Toast', 'Sourdough toast with smashed avocado and poached egg.', 'Sourdough bread\nAvocado\nEgg\nChili flakes\nLemon\nSalt', '1. Toast bread\n2. Smash avocado with lemon\n3. Poach egg\n4. Assemble\n5. Season', 10, 'Easy', 'Healthy', 'food', 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=400', 1, 'approved', '2025-12-01 23:50:53', NULL, 0),
(23, 'Strawberry Cheesecake', 'Creamy no-bake cheesecake with fresh strawberry topping.', 'Cream cheese\nHeavy cream\nGraham crackers\nButter\nStrawberries\nSugar\nGelatin', '1. Make crust\n2. Whip cream and cheese\n3. Set in fridge\n4. Make strawberry sauce\n5. Top and serve', 300, 'Medium', 'Dessert', 'food', 'https://images.unsplash.com/photo-1565958011703-44f9829ba187', 15, 'approved', '2025-12-01 23:50:53', NULL, 0),
(24, 'Greek Salad', 'Fresh salad with cucumber, tomato, olives, and feta.', 'Cucumber\nTomato\nRed onion\nKalamata olives\nFeta cheese\nOregano\nOlive oil', '1. Chop veggies chunks\n2. Slice onion thin\n3. Combine in bowl\n4. Top with feta block\n5. Drizzle oil and oregano', 15, 'Easy', 'Healthy', 'food', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', 14, 'approved', '2025-12-01 23:50:53', NULL, 0),
(25, 'Tonkatsu Ramen', 'Rich pork bone broth ramen with chashu pork.', 'Pork bones\nRamen noodles\nChashu pork\nEgg\nMenma\nGreen onions\nNori', '1. Boil bones for 12 hours\n2. Make tare\n3. Cook noodles\n4. Assemble bowl\n5. Top with toppings', 720, 'Hard', 'Japanese', 'food', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400', 11, 'approved', '2025-12-01 23:50:53', NULL, 0),
(26, 'Gỏi Cuốn (Spring Rolls)', 'Fresh summer rolls with shrimp, pork, herbs, and vermicelli.', 'Rice paper\nShrimp\nPork belly\nVermicelli\nLettuce\nMint\nChives\nPeanut sauce', '1. Boil shrimp and pork\n2. Cook vermicelli\n3. Wet rice paper\n4. Layer ingredients\n5. Roll tightly\n6. Serve with peanut sauce', 30, 'Easy', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb', 4, 'approved', '2025-12-01 23:50:53', NULL, 0),
(27, 'Sushi Platter', 'Assorted nigiri and maki rolls with fresh fish.', 'Sushi rice\nVinegar\nSalmon\nTuna\nNori\nCucumber\nAvocado\nWasabi', '1. Cook and season rice\n2. Slice fish\n3. Form nigiri\n4. Roll maki\n5. Arrange on platter', 60, 'Hard', 'Japanese', 'food', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c', 13, 'approved', '2025-12-01 23:50:53', NULL, 0),
(28, 'Chocolate Lava Cake', 'Warm chocolate cake with a molten center.', 'Dark chocolate\nButter\nEggs\nSugar\nFlour\nVanilla', '1. Melt chocolate and butter\n2. Whisk eggs and sugar\n3. Combine and add flour\n4. Bake 12 mins at 200C\n5. Serve warm', 20, 'Medium', 'Dessert', 'food', 'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=400', 4, 'approved', '2025-12-01 23:50:53', NULL, 0),
(29, 'Bún Chả Hà Nội', 'Grilled pork meatballs and belly served with vermicelli and dipping sauce.', 'Ground pork\nPork belly\nFish sauce\nSugar\nGarlic\nVinegar\nPapaya\nVermicelli\nHerbs', '1. Marinate ground pork and belly separately\n2. Grill over charcoal\n3. Make dipping sauce with papaya\n4. Serve with fresh herbs and noodles', 60, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1585325701165-351af916e581', 10, 'approved', '2025-12-01 23:50:53', NULL, 0),
(30, 'Classic Mojito', 'Refreshing Cuban cocktail with mint and lime.', 'White rum\nMint leaves\nLime\nSugar\nSoda water\nIce', '1. Muddle mint and lime\n2. Add rum and sugar\n3. Fill with ice\n4. Top with soda\n5. Garnish', 5, 'Easy', 'Drinks', 'drink', 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd', 3, 'approved', '2025-12-01 23:50:53', NULL, 0),
(31, 'Chocolate Lava Cake', 'Warm chocolate cake with a molten center.', 'Dark chocolate\nButter\nEggs\nSugar\nFlour\nVanilla', '1. Melt chocolate and butter\n2. Whisk eggs and sugar\n3. Combine and add flour\n4. Bake 12 mins at 200C\n5. Serve warm', 20, 'Medium', 'Dessert', 'food', 'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=400', 1, 'approved', '2025-12-01 23:50:53', NULL, 0),
(32, 'Bánh Mì Thịt Nướng', 'Crispy baguette filled with grilled pork, pâté, and pickled vegetables.', 'Baguette\nPork shoulder\nLemongrass\nFish sauce\nPickled carrots\nCilantro\nChili\nPâté\nMayo', '1. Marinate pork with lemongrass\n2. Grill pork until charred\n3. Toast baguette\n4. Spread pâté and mayo\n5. Assemble with meat and veggies', 45, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1626804475297-411dbe6314c9', 3, 'approved', '2025-12-01 23:50:53', NULL, 0),
(33, 'Spaghetti Carbonara', 'Classic Roman pasta with eggs, cheese, guanciale, and black pepper.', 'Spaghetti\nEggs\nPecorino Romano\nGuanciale\nBlack pepper', '1. Cook pasta\n2. Fry guanciale\n3. Mix eggs and cheese\n4. Toss pasta with fat\n5. Mix in egg mixture off heat\n6. Top with pepper', 25, 'Medium', 'Italian', 'food', 'https://images.unsplash.com/photo-1612874742237-98280d20748b?w=400', 3, 'approved', '2025-12-01 23:50:53', NULL, 0),
(34, 'Phở Bò Tái Nạm', 'Traditional Vietnamese beef noodle soup with rare beef and brisket.', 'Beef bones\nRice noodles\nBeef tenderloin\nBrisket\nStar anise\nCinnamon\nGinger\nOnion\nFish sauce', '1. Simmer bones for 6 hours\n2. Char ginger and onion\n3. Add spices\n4. Blanch noodles\n5. Slice beef thin\n6. Pour hot broth over noodles and beef', 180, 'Hard', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43', 8, 'approved', '2025-12-01 23:50:53', NULL, 0),
(35, 'Sushi Platter', 'Assorted nigiri and maki rolls with fresh fish.', 'Sushi rice\nVinegar\nSalmon\nTuna\nNori\nCucumber\nAvocado\nWasabi', '1. Cook and season rice\n2. Slice fish\n3. Form nigiri\n4. Roll maki\n5. Arrange on platter', 60, 'Hard', 'Japanese', 'food', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c', 2, 'approved', '2025-12-01 23:50:53', NULL, 0),
(36, 'Gỏi Cuốn (Spring Rolls)', 'Fresh summer rolls with shrimp, pork, herbs, and vermicelli.', 'Rice paper\nShrimp\nPork belly\nVermicelli\nLettuce\nMint\nChives\nPeanut sauce', '1. Boil shrimp and pork\n2. Cook vermicelli\n3. Wet rice paper\n4. Layer ingredients\n5. Roll tightly\n6. Serve with peanut sauce', 30, 'Easy', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb', 8, 'approved', '2025-12-01 23:50:53', NULL, 0),
(37, 'Greek Salad', 'Fresh salad with cucumber, tomato, olives, and feta.', 'Cucumber\nTomato\nRed onion\nKalamata olives\nFeta cheese\nOregano\nOlive oil', '1. Chop veggies chunks\n2. Slice onion thin\n3. Combine in bowl\n4. Top with feta block\n5. Drizzle oil and oregano', 15, 'Easy', 'Healthy', 'food', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', 2, 'approved', '2025-12-01 23:50:53', NULL, 0),
(38, 'Matcha Latte', 'Creamy iced matcha latte.', 'Matcha powder\nMilk\nSugar syrup\nIce\nHot water', '1. Whisk matcha with hot water\n2. Fill glass with ice and milk\n3. Pour matcha over milk\n4. Sweeten to taste', 10, 'Easy', 'Drinks', 'drink', 'https://images.unsplash.com/photo-1515825838458-f2a94b20105a', 12, 'approved', '2025-12-01 23:50:53', NULL, 0),
(39, 'Tonkatsu Ramen', 'Rich pork bone broth ramen with chashu pork.', 'Pork bones\nRamen noodles\nChashu pork\nEgg\nMenma\nGreen onions\nNori', '1. Boil bones for 12 hours\n2. Make tare\n3. Cook noodles\n4. Assemble bowl\n5. Top with toppings', 720, 'Hard', 'Japanese', 'food', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400', 1, 'approved', '2025-12-01 23:50:53', NULL, 0),
(40, 'Margherita Pizza', 'Neapolitan style pizza with San Marzano tomatoes and buffalo mozzarella.', '00 Flour\nYeast\nSan Marzano tomatoes\nBuffalo mozzarella\nBasil\nOlive oil', '1. Make dough and proof\n2. Stretch dough\n3. Top with sauce and cheese\n4. Bake at max temp\n5. Garnish with basil', 90, 'Hard', 'Italian', 'food', 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400', 4, 'approved', '2025-12-01 23:50:53', NULL, 0),
(41, 'Avocado Toast', 'Sourdough toast with smashed avocado and poached egg.', 'Sourdough bread\nAvocado\nEgg\nChili flakes\nLemon\nSalt', '1. Toast bread\n2. Smash avocado with lemon\n3. Poach egg\n4. Assemble\n5. Season', 10, 'Easy', 'Healthy', 'food', 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=400', 13, 'approved', '2025-12-01 23:50:53', NULL, 0),
(42, 'Strawberry Cheesecake', 'Creamy no-bake cheesecake with fresh strawberry topping.', 'Cream cheese\nHeavy cream\nGraham crackers\nButter\nStrawberries\nSugar\nGelatin', '1. Make crust\n2. Whip cream and cheese\n3. Set in fridge\n4. Make strawberry sauce\n5. Top and serve', 300, 'Medium', 'Dessert', 'food', 'https://images.unsplash.com/photo-1565958011703-44f9829ba187', 10, 'approved', '2025-12-01 23:50:53', NULL, 0),
(43, 'Blueberry Bliss Pancakes', 'Fluffy pancakes loaded with fresh blueberries', 'Flour, Eggs, Milk, Blueberries, Sugar, Baking Powder', '1. Mix dry ingredients\n2. Add wet ingredients\n3. Fold in blueberries\n4. Cook on griddle', 20, 'Easy', 'Breakfast', 'breakfast', 'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?w=400', 1, 'approved', '2025-12-03 10:45:17', NULL, 0),
(44, 'Seared Salmon with Herbs', 'Perfectly seared salmon with fresh herbs and lemon', 'Salmon Fillet, Olive Oil, Garlic, Lemon, Fresh Herbs, Salt, Pepper', '1. Season salmon\n2. Heat oil in pan\n3. Sear salmon 4 min per side\n4. Garnish with herbs', 15, 'Medium', 'Seafood', 'main', 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400', 1, 'approved', '2025-12-03 10:45:17', NULL, 0),
(45, 'Avocado Toast with Poached Egg', 'Healthy breakfast with creamy avocado and perfectly poached egg', 'Bread, Avocado, Eggs, Lemon, Salt, Pepper, Red Pepper Flakes', '1. Toast bread\n2. Mash avocado with lemon\n3. Poach eggs\n4. Assemble and season', 10, 'Easy', 'Breakfast', 'breakfast', 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=400', 1, 'pending', '2025-12-03 10:45:17', NULL, 0),
(46, 'Spicy Miso Ramen', 'Rich and flavorful Japanese ramen with spicy miso broth', 'Ramen Noodles, Miso Paste, Chicken Broth, Pork Belly, Eggs, Green Onions, Nori', '1. Prepare broth\n2. Cook noodles\n3. Prepare toppings\n4. Assemble bowl', 30, 'Hard', 'Asian', 'main', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400', 1, 'approved', '2025-12-03 10:45:17', NULL, 0),
(47, 'Classic Margherita Pizza', 'Traditional Italian pizza with fresh mozzarella and basil', 'Pizza Dough, Tomato Sauce, Mozzarella, Fresh Basil, Olive Oil', '1. Stretch dough\n2. Add sauce\n3. Top with cheese\n4. Bake at 450°F', 15, 'Medium', 'Italian', 'main', 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400', 1, 'approved', '2025-12-03 10:45:17', NULL, 0),
(48, 'Creamy Carbonara Pasta', 'Rich and creamy Roman pasta with pancetta', 'Spaghetti, Eggs, Pancetta, Parmesan, Black Pepper', '1. Cook pasta\n2. Fry pancetta\n3. Mix eggs and cheese\n4. Combine all', 20, 'Medium', 'Italian', 'main', 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=400', 1, 'approved', '2025-12-03 10:45:17', NULL, 0),
(49, 'Chicken Tacos al Pastor', 'Flavorful Mexican tacos with marinated chicken', 'Chicken, Pineapple, Onion, Cilantro, Tortillas, Spices', '1. Marinate chicken\n2. Grill chicken\n3. Prepare toppings\n4. Assemble tacos', 15, 'Easy', 'Mexican', 'main', 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400', 1, 'approved', '2025-12-03 10:45:17', NULL, 0),
(50, 'Beef Enchiladas', 'Cheesy beef enchiladas with red sauce', 'Ground Beef, Tortillas, Cheese, Enchilada Sauce, Onions', '1. Cook beef\n2. Fill tortillas\n3. Add sauce\n4. Bake with cheese', 30, 'Medium', 'Mexican', 'main', 'https://images.unsplash.com/photo-1534352956036-c01ac18bd985?w=400', 1, 'pending', '2025-12-03 10:45:17', NULL, 0),
(51, 'Tiramisu', 'Classic Italian coffee-flavored dessert', 'Ladyfingers, Mascarpone, Espresso, Cocoa Powder, Eggs, Sugar', '1. Brew espresso\n2. Make cream\n3. Layer ingredients\n4. Refrigerate overnight', 0, 'Medium', 'Desserts', 'dessert', 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400', 1, 'approved', '2025-12-03 10:45:17', NULL, 0),
(52, 'Quinoa Buddha Bowl', 'Nutritious bowl with quinoa and roasted vegetables', 'Quinoa, Sweet Potato, Chickpeas, Kale, Tahini Dressing', '1. Cook quinoa\n2. Roast vegetables\n3. Prepare dressing\n4. Assemble bowl', 30, 'Easy', 'Healthy', 'main', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400', 1, 'approved', '2025-12-03 10:45:17', NULL, 0),
(53, 'Green Smoothie Bowl', 'Refreshing smoothie bowl packed with nutrients', 'Spinach, Banana, Mango, Chia Seeds, Almond Milk, Granola', '1. Blend ingredients\n2. Pour into bowl\n3. Add toppings\n4. Serve immediately', 0, 'Easy', 'Healthy', 'breakfast', 'https://images.unsplash.com/photo-1638176311291-36123011387d?w=400', 1, 'pending', '2025-12-03 10:45:17', NULL, 0),
(54, 'Test Recipe 1', 'This is a hidden test recipe', 'Test ingredients', 'Test instructions', 20, 'Easy', 'Other', 'other', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400', 1, 'hidden', '2025-12-03 10:45:17', NULL, 0),
(55, 'Test Recipe 2', 'Another hidden test recipe', 'Test ingredients', 'Test instructions', 25, 'Medium', 'Other', 'other', 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=400', 1, 'hidden', '2025-12-03 10:45:17', NULL, 0),
(56, 'Pending Pasta Dish', 'Awaiting approval', 'Pasta, Sauce', 'Cook pasta, add sauce', 15, 'Easy', 'Italian', 'main', 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=400', 1, 'pending', '2025-12-03 10:45:17', NULL, 0),
(57, 'Pending Asian Stir Fry', 'Awaiting approval', 'Vegetables, Soy Sauce, Rice', 'Stir fry vegetables, serve with rice', 10, 'Easy', 'Asian', 'main', 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400', 1, 'pending', '2025-12-03 10:45:17', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `recipe_tag`
--

CREATE TABLE `recipe_tag` (
  `id` int(11) NOT NULL,
  `recipe_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `recipe_tags`
--

CREATE TABLE `recipe_tags` (
  `recipe_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `report`
--

CREATE TABLE `report` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `recipe_id` int(11) DEFAULT NULL,
  `reported_user_id` int(11) DEFAULT NULL,
  `report_type` varchar(20) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `resolved_by` int(11) DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `report`
--

INSERT INTO `report` (`id`, `user_id`, `recipe_id`, `reported_user_id`, `report_type`, `title`, `description`, `status`, `resolved_by`, `resolved_at`, `created_at`) VALUES
(1, 16, 22, NULL, 'recipe', 'Hình ảnh không phù hợp', 'Công thức này có hình ảnh không liên quan', 'resolved', 16, '2025-12-02 01:56:48', '2025-12-02 08:02:06'),
(2, 16, 22, NULL, 'recipe', 'Thông tin sai lệch', 'Nguyên liệu và cách làm không chính xác', 'pending', NULL, NULL, '2025-12-02 08:02:06'),
(3, 16, NULL, NULL, 'comment', 'Bình luận spam', 'Spam quảng cáo', 'dismissed', NULL, NULL, '2025-12-02 08:02:06');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `key` varchar(100) NOT NULL,
  `value` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `key`, `value`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, 'site_name', 'FlavorVerse', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(2, 'site_tagline', 'Share and Discover Amazing Recipes', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(3, 'theme_color', '#e392fe', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(4, 'allow_registration', 'on', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(5, 'public_access', 'on', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(6, 'recipes_per_page', '12', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(7, 'auto_approve_recipes', 'false', '2025-12-02 12:09:04', '2025-12-02 12:09:04', NULL, NULL),
(8, 'allow_comments', 'on', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(9, 'allow_ratings', 'on', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(10, 'email_notifications', 'on', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(11, 'new_recipe_alerts', 'on', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(12, 'report_alerts', 'on', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(13, 'maintenance_mode', 'false', '2025-12-02 12:09:04', '2025-12-02 12:09:04', NULL, NULL),
(14, 'backup_frequency', 'weekly', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(15, 'debug_mode', 'false', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(16, 'log_level', 'INFO', '2025-12-02 12:09:04', '2025-12-02 05:13:38', NULL, 16),
(17, 'admin_email', 'admin@flavorverse.com', '2025-12-02 05:13:38', NULL, 16, NULL),
(18, 'site_logo', '', '2025-12-02 05:13:38', NULL, 16, NULL),
(19, 'theme_mode', 'auto', '2025-12-02 05:13:38', NULL, 16, NULL),
(20, 'font_family', '\'Inter\', sans-serif', '2025-12-02 05:13:38', NULL, 16, NULL),
(21, 'comments_per_page', '10', '2025-12-02 05:13:38', NULL, 16, NULL),
(22, 'smtp_server', 'smtp.gmail.com', '2025-12-02 05:13:38', NULL, 16, NULL),
(23, 'smtp_port', '587', '2025-12-02 05:13:38', NULL, 16, NULL),
(24, 'smtp_username', '', '2025-12-02 05:13:38', NULL, 16, NULL),
(25, 'session_timeout', '60', '2025-12-02 05:13:38', NULL, 16, NULL),
(26, 'max_login_attempts', '5', '2025-12-02 05:13:38', NULL, 16, NULL),
(27, 'password_reset_expiry', '24', '2025-12-02 05:13:38', NULL, 16, NULL),
(28, 'maintenance_message', '                                        Website is under maintenance. Please check back later.\r\n                                    ', '2025-12-02 05:13:38', NULL, 16, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `system_settings`
--

CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL,
  `key` varchar(100) NOT NULL,
  `value` text DEFAULT NULL,
  `value_type` varchar(20) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `system_settings`
--

INSERT INTO `system_settings` (`id`, `key`, `value`, `value_type`, `category`, `description`, `is_public`, `updated_by`, `updated_at`) VALUES
(1, 'max_upload_size', '16', 'int', 'upload', 'Maximum upload size in MB', 0, NULL, '2025-12-02 00:42:32'),
(2, 'allowed_extensions', 'png,jpg,jpeg,gif,webp', 'string', 'upload', NULL, 0, NULL, '2025-12-02 00:42:32'),
(3, 'recipes_per_page', '12', 'int', 'general', NULL, 0, NULL, '2025-12-02 00:42:32'),
(4, 'enable_registration', 'true', 'bool', 'security', NULL, 0, NULL, '2025-12-02 00:42:32'),
(5, 'require_email_verification', 'false', 'bool', 'security', NULL, 0, NULL, '2025-12-02 00:42:32');

-- --------------------------------------------------------

--
-- Table structure for table `tag`
--

CREATE TABLE `tag` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `slug` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tag`
--

INSERT INTO `tag` (`id`, `name`, `slug`, `description`, `created_at`) VALUES
(1, 'Vegetarian', 'vegetarian', 'Món chay, không thịt', '2025-12-02 08:02:06'),
(2, 'Vegan', 'vegan', 'Hoàn toàn thuần chay', '2025-12-02 08:02:06'),
(3, 'Quick & Easy', 'quick-easy', 'Nấu nhanh dưới 30 phút', '2025-12-02 08:02:06'),
(4, 'Spicy', 'spicy', 'Món ăn cay', '2025-12-02 08:02:06'),
(5, 'Gluten-Free', 'gluten-free', 'Không chứa gluten', '2025-12-02 08:02:06'),
(6, 'Low Carb', 'low-carb', 'Ít tinh bột', '2025-12-02 08:02:06'),
(7, 'High Protein', 'high-protein', 'Nhiều protein', '2025-12-02 08:02:06'),
(8, 'Budget-Friendly', 'budget-friendly', 'Tiết kiệm chi phí', '2025-12-02 08:02:06'),
(9, 'Party Food', 'party-food', 'Món ăn tiệc tùng', '2025-12-02 08:02:06'),
(10, 'Comfort Food', 'comfort-food', 'Món ăn dân dã', '2025-12-02 08:02:06');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(80) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `profile_picture` varchar(200) DEFAULT NULL,
  `bio` varchar(500) DEFAULT NULL,
  `is_admin` tinyint(1) NOT NULL,
  `is_online` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `email`, `password_hash`, `profile_picture`, `bio`, `is_admin`, `is_online`) VALUES
(1, 'ChefGordon', 'gordon@example.com', 'pbkdf2:sha256:150000$vGFGnXYy$638b5a4da9b1116c3ab72c3a2a79c2fee50eaa75f66b249ab8438c3182552f25', 'https://images.unsplash.com/photo-1583394293214-28ded15ee548', 'Professional chef with a temper.', 0, 0),
(2, 'Thu Hà', 'jamie@example.com', 'pbkdf2:sha256:150000$QU9VoW9w$ca572c384c8c9c341c19bc967620fca411685db45c978e5915d79ccea5295280', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6', 'Simple, rustic cooking is my passion.', 0, 0),
(3, 'Trần Thị Hạnh', 'nigella@example.com', 'pbkdf2:sha256:150000$JUUcFpsO$dc18a09cabdeb7785dec965ae39d0ff0b7dda5da5bd67ab442396402dd61ad2a', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330', 'Indulgent desserts and comfort food.', 0, 0),
(4, 'Thỏ Xinh Gái', 'roger@example.com', 'pbkdf2:sha256:150000$VzVoeeye$1b0f384787efced61e68dfce85f20c8c38e74bf15d994c0c043675153d9adb39', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d', 'Haiyaa! Use MSG!', 0, 0),
(5, 'Tùng Lâm', 'maangchi@example.com', 'pbkdf2:sha256:150000$XUoUTx3V$08f3d91b6ebc47cc6bc8b8d6a87f7e4e6afbd8b3f608a661203ed61c6c01bd99', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80', 'Korean cooking superstar.', 0, 0),
(6, 'Thu Trang', 'babish@example.com', 'pbkdf2:sha256:150000$7BmntOfL$99aa532ca431d90d51515170b05977c957cf189e5b169215859042d7132d9bbe', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e', 'Recreating movies in the kitchen.', 0, 0),
(7, 'Ngọc Anh', 'joshua@example.com', 'pbkdf2:sha256:150000$3aAMDuNB$a074747a66ac563c1557845b313a7b216a6ef9d5f4990ecbfec3992f90fed472', 'https://images.unsplash.com/photo-1527980965255-d3b416303d12', 'Papa kiss!', 0, 0),
(8, 'Phạm Trà My', 'kenji@example.com', 'pbkdf2:sha256:150000$RKlRcZnj$22eef3fe9f7ee0ac55ddd5dbf1e2b243cf134e702b38111f1a193c1727b736b5', 'https://images.unsplash.com/photo-1522075469751-3a3694fb60ed', 'Science-based home cooking.', 0, 0),
(9, 'Nguyễn Thị Huế', 'samin@example.com', 'pbkdf2:sha256:150000$rtwVoAgY$388693e44f620aa19f2af0eadf270df560ae4a8c60d60423cf5a7934edf5d512', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2', 'Salt, Fat, Acid, Heat.', 0, 0),
(10, 'Nguyễn Thị Hà Anh', 'david@example.com', 'pbkdf2:sha256:150000$sEQHfEEq$3eb9c094e96b02b2e71f376938fabad6746f4cb02e2561ae752c69f03087e117', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d', 'Ugly delicious.', 0, 0),
(11, 'Nguyễn Tường Vy', 'julia@example.com', 'pbkdf2:sha256:150000$1MXPVQ4T$059df69ac36069ff3f89a70bcd55036cf05ef1f070da57e7b9c831c240862b7c', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb', 'Bon Appétit!', 0, 0),
(12, 'AnthonyB Mike', 'anthony@example.com', 'pbkdf2:sha256:150000$227KFCx6$1856a35e69a2ef17d131ee47bf059c2efa195f3fa90f725b8f56108c19b9527d', 'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79', 'Travel and eat.', 0, 0),
(13, 'Trần Thị Hồng Ngân', 'martha@example.com', 'pbkdf2:sha256:150000$NNpDZlPP$e87983c74b4c1333acb9dd572d4a4ffc102328a7d596f991f3f13f685ca05f65', 'https://images.unsplash.com/photo-1548142813-c348350df52b', 'Perfection in every detail.', 0, 0),
(14, 'GuyFieri', 'guy@example.com', 'pbkdf2:sha256:150000$SzBdRvgG$2b96bff3c200a563438e0515ed2e57c53c99072ce8967465ed1147bd81458f28', 'https://images.unsplash.com/photo-1542909168-82c3e7fdca5c', 'Welcome to Flavortown!', 0, 0),
(15, 'RachaelRay', 'rachael@example.com', 'pbkdf2:sha256:150000$5Vx8xjDK$e68baa95515ffc60aa30f4fca0e0c366c0f973583cc19733cebb16d3ef11ca5d', 'https://images.unsplash.com/photo-1517841905240-472988babdf9', '30 minute meals.', 0, 0),
(16, 'admin', 'admin@example.com', 'pbkdf2:sha256:150000$5rwWLOdy$de8f7ba571f5abebf77980f2c5b7ffa088251370450af78342345ec9fbd0e8c3', '/static/uploads/profiles/54fe98c5-9583-45cc-9465-3bc1baea03d6_20251203_181726_DSCF7123.jpeg', 'System Administrator', 1, 0),
(17, 'thuhong', 'thuhong@gmail.com', 'pbkdf2:sha256:150000$6CKUiUVZ$647835face6c6d3ebf697e115ec4d29692dc5776f8b1c4cfdbbceaa95b65c8fb', '', 'Food enthusiast & Home cook', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `user_activity`
--

CREATE TABLE `user_activity` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `activity_type` varchar(50) NOT NULL,
  `target_type` varchar(50) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `recipe_id` (`recipe_id`);

--
-- Indexes for table `email_template`
--
ALTER TABLE `email_template`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `favorite`
--
ALTER TABLE `favorite`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `recipe_id` (`recipe_id`);

--
-- Indexes for table `follow`
--
ALTER TABLE `follow`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_following` (`follower_id`,`followed_id`),
  ADD KEY `followed_id` (`followed_id`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `actor_id` (`actor_id`),
  ADD KEY `recipe_id` (`recipe_id`);

--
-- Indexes for table `rating`
--
ALTER TABLE `rating`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `recipe_id` (`recipe_id`);

--
-- Indexes for table `recipe`
--
ALTER TABLE `recipe`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `fk_recipe_category` (`category_id`);

--
-- Indexes for table `recipe_tag`
--
ALTER TABLE `recipe_tag`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_recipe_tag` (`recipe_id`,`tag_id`),
  ADD KEY `tag_id` (`tag_id`);

--
-- Indexes for table `recipe_tags`
--
ALTER TABLE `recipe_tags`
  ADD PRIMARY KEY (`recipe_id`,`tag_id`),
  ADD KEY `tag_id` (`tag_id`);

--
-- Indexes for table `report`
--
ALTER TABLE `report`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `recipe_id` (`recipe_id`),
  ADD KEY `reported_user_id` (`reported_user_id`),
  ADD KEY `resolved_by` (`resolved_by`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `key` (`key`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `updated_by` (`updated_by`);

--
-- Indexes for table `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `key` (`key`),
  ADD KEY `updated_by` (`updated_by`);

--
-- Indexes for table `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_activity`
--
ALTER TABLE `user_activity`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `comment`
--
ALTER TABLE `comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT for table `email_template`
--
ALTER TABLE `email_template`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `favorite`
--
ALTER TABLE `favorite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `follow`
--
ALTER TABLE `follow`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=157;

--
-- AUTO_INCREMENT for table `rating`
--
ALTER TABLE `rating`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=214;

--
-- AUTO_INCREMENT for table `recipe`
--
ALTER TABLE `recipe`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `recipe_tag`
--
ALTER TABLE `recipe_tag`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `report`
--
ALTER TABLE `report`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tag`
--
ALTER TABLE `tag`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `user_activity`
--
ALTER TABLE `user_activity`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD CONSTRAINT `audit_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `category`
--
ALTER TABLE `category`
  ADD CONSTRAINT `category_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`);

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`);

--
-- Constraints for table `favorite`
--
ALTER TABLE `favorite`
  ADD CONSTRAINT `favorite_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `favorite_ibfk_2` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`);

--
-- Constraints for table `follow`
--
ALTER TABLE `follow`
  ADD CONSTRAINT `follow_ibfk_1` FOREIGN KEY (`follower_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `follow_ibfk_2` FOREIGN KEY (`followed_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `notification`
--
ALTER TABLE `notification`
  ADD CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `notification_ibfk_2` FOREIGN KEY (`actor_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `notification_ibfk_3` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`);

--
-- Constraints for table `rating`
--
ALTER TABLE `rating`
  ADD CONSTRAINT `rating_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `rating_ibfk_2` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`);

--
-- Constraints for table `recipe`
--
ALTER TABLE `recipe`
  ADD CONSTRAINT `fk_recipe_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
  ADD CONSTRAINT `recipe_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Constraints for table `recipe_tag`
--
ALTER TABLE `recipe_tag`
  ADD CONSTRAINT `recipe_tag_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`),
  ADD CONSTRAINT `recipe_tag_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`);

--
-- Constraints for table `recipe_tags`
--
ALTER TABLE `recipe_tags`
  ADD CONSTRAINT `recipe_tags_ibfk_1` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `recipe_tags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tag` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `report`
--
ALTER TABLE `report`
  ADD CONSTRAINT `report_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `report_ibfk_2` FOREIGN KEY (`recipe_id`) REFERENCES `recipe` (`id`),
  ADD CONSTRAINT `report_ibfk_3` FOREIGN KEY (`reported_user_id`) REFERENCES `user` (`id`),
  ADD CONSTRAINT `report_ibfk_4` FOREIGN KEY (`resolved_by`) REFERENCES `user` (`id`);

--
-- Constraints for table `settings`
--
ALTER TABLE `settings`
  ADD CONSTRAINT `settings_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `settings_ibfk_2` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `system_settings`
--
ALTER TABLE `system_settings`
  ADD CONSTRAINT `system_settings_ibfk_1` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`);

--
-- Constraints for table `user_activity`
--
ALTER TABLE `user_activity`
  ADD CONSTRAINT `user_activity_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

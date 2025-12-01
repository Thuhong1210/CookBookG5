-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 01, 2025 at 02:58 AM
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
(59, 2, 36);

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
(1, 1, 7, '2025-11-30 21:02:29'),
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
(52, 2, 3, '2025-11-30 21:04:45');

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
(149, 3, 2, 3, 'follow', 'đã theo dõi bạn', 0, '2025-11-30 21:04:46');

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
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `recipe`
--

INSERT INTO `recipe` (`id`, `title`, `description`, `ingredients`, `instructions`, `cooking_time`, `difficulty`, `category`, `recipe_type`, `image_url`, `user_id`) VALUES
(1, 'Strawberry Cheesecake', 'Creamy no-bake cheesecake with fresh strawberry topping.', 'Cream cheese\r\nHeavy cream\r\nGraham crackers\r\nButter\r\nStrawberries\r\nSugar\r\nGelatin', '1. Make crust\r\n2. Whip cream and cheese\r\n3. Set in fridge\r\n4. Make strawberry sauce\r\n5. Top and serve', 300, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1565958011703-44f9829ba187', 2),
(2, 'Phở Bò Tái Nạm', 'Traditional Vietnamese beef noodle soup with rare beef and brisket.', 'Beef bones\nRice noodles\nBeef tenderloin\nBrisket\nStar anise\nCinnamon\nGinger\nOnion\nFish sauce', '1. Simmer bones for 6 hours\n2. Char ginger and onion\n3. Add spices\n4. Blanch noodles\n5. Slice beef thin\n6. Pour hot broth over noodles and beef', 180, 'Hard', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43', 5),
(3, 'Margherita Pizza', 'Neapolitan style pizza with San Marzano tomatoes and buffalo mozzarella.', '00 Flour\nYeast\nSan Marzano tomatoes\nBuffalo mozzarella\nBasil\nOlive oil', '1. Make dough and proof\n2. Stretch dough\n3. Top with sauce and cheese\n4. Bake at max temp\n5. Garnish with basil', 90, 'Hard', 'Italian', 'food', 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002', 3),
(4, 'Bánh Mì Thịt Nướng', 'Crispy baguette filled with grilled pork, pâté, and pickled vegetables.', 'Baguette\nPork shoulder\nLemongrass\nFish sauce\nPickled carrots\nCilantro\nChili\nPâté\nMayo', '1. Marinate pork with lemongrass\n2. Grill pork until charred\n3. Toast baguette\n4. Spread pâté and mayo\n5. Assemble with meat and veggies', 45, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1626804475297-411dbe6314c9', 6),
(5, 'Sushi Platter', 'Assorted nigiri and maki rolls with fresh fish.', 'Sushi rice\nVinegar\nSalmon\nTuna\nNori\nCucumber\nAvocado\nWasabi', '1. Cook and season rice\n2. Slice fish\n3. Form nigiri\n4. Roll maki\n5. Arrange on platter', 60, 'Hard', 'Japanese', 'food', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c', 15),
(6, 'Bún Chả Hà Nội', 'Grilled pork meatballs and belly served with vermicelli and dipping sauce.', 'Ground pork\nPork belly\nFish sauce\nSugar\nGarlic\nVinegar\nPapaya\nVermicelli\nHerbs', '1. Marinate ground pork and belly separately\n2. Grill over charcoal\n3. Make dipping sauce with papaya\n4. Serve with fresh herbs and noodles', 60, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1585325701165-351af916e581', 10),
(7, 'Tonkatsu Ramen', 'Rich pork bone broth ramen with chashu pork.', 'Pork bones\nRamen noodles\nChashu pork\nEgg\nMenma\nGreen onions\nNori', '1. Boil bones for 12 hours\n2. Make tare\n3. Cook noodles\n4. Assemble bowl\n5. Top with toppings', 720, 'Hard', 'Japanese', 'food', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624', 13),
(8, 'Greek Salad', 'Fresh salad with cucumber, tomato, olives, and feta.', 'Cucumber\nTomato\nRed onion\nKalamata olives\nFeta cheese\nOregano\nOlive oil', '1. Chop veggies chunks\n2. Slice onion thin\n3. Combine in bowl\n4. Top with feta block\n5. Drizzle oil and oregano', 15, 'Easy', 'Healthy', 'food', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', 6),
(9, 'Spaghetti Carbonara', 'Classic Roman pasta with eggs, cheese, guanciale, and black pepper.', 'Spaghetti\nEggs\nPecorino Romano\nGuanciale\nBlack pepper', '1. Cook pasta\n2. Fry guanciale\n3. Mix eggs and cheese\n4. Toss pasta with fat\n5. Mix in egg mixture off heat\n6. Top with pepper', 25, 'Medium', 'Italian', 'food', 'https://images.unsplash.com/photo-1612874742237-6526221588e3', 14),
(10, 'Gỏi Cuốn (Spring Rolls)', 'Fresh summer rolls with shrimp, pork, herbs, and vermicelli.', 'Rice paper\nShrimp\nPork belly\nVermicelli\nLettuce\nMint\nChives\nPeanut sauce', '1. Boil shrimp and pork\n2. Cook vermicelli\n3. Wet rice paper\n4. Layer ingredients\n5. Roll tightly\n6. Serve with peanut sauce', 30, 'Easy', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb', 6),
(11, 'Classic Mojito', 'Refreshing Cuban cocktail with mint and lime.', 'White rum\nMint leaves\nLime\nSugar\nSoda water\nIce', '1. Muddle mint and lime\n2. Add rum and sugar\n3. Fill with ice\n4. Top with soda\n5. Garnish', 5, 'Easy', 'Drinks', 'drink', 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd', 5),
(12, 'Matcha Latte', 'Creamy iced matcha latte.', 'Matcha powder\nMilk\nSugar syrup\nIce\nHot water', '1. Whisk matcha with hot water\n2. Fill glass with ice and milk\n3. Pour matcha over milk\n4. Sweeten to taste', 10, 'Easy', 'Drinks', 'drink', 'https://images.unsplash.com/photo-1515825838458-f2a94b20105a', 14),
(13, 'Chocolate Lava Cake', 'Warm chocolate cake with a molten center.', 'Dark chocolate\nButter\nEggs\nSugar\nFlour\nVanilla', '1. Melt chocolate and butter\n2. Whisk eggs and sugar\n3. Combine and add flour\n4. Bake 12 mins at 200C\n5. Serve warm', 20, 'Medium', 'Dessert', 'food', 'https://images.unsplash.com/photo-1606313564200-e75d5e30476d', 15),
(14, 'Avocado Toast', 'Sourdough toast with smashed avocado and poached egg.', 'Sourdough bread\nAvocado\nEgg\nChili flakes\nLemon\nSalt', '1. Toast bread\n2. Smash avocado with lemon\n3. Poach egg\n4. Assemble\n5. Season', 10, 'Easy', 'Healthy', 'food', 'https://images.unsplash.com/photo-1588137372308-15f75323ca8d', 16),
(15, 'Margherita Pizza', 'Neapolitan style pizza with San Marzano tomatoes and buffalo mozzarella.', '00 Flour\nYeast\nSan Marzano tomatoes\nBuffalo mozzarella\nBasil\nOlive oil', '1. Make dough and proof\n2. Stretch dough\n3. Top with sauce and cheese\n4. Bake at max temp\n5. Garnish with basil', 90, 'Hard', 'Italian', 'food', 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002', 4),
(16, 'Classic Mojito', 'Refreshing Cuban cocktail with mint and lime.', 'White rum\nMint leaves\nLime\nSugar\nSoda water\nIce', '1. Muddle mint and lime\n2. Add rum and sugar\n3. Fill with ice\n4. Top with soda\n5. Garnish', 5, 'Easy', 'Drinks', 'drink', 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd', 7),
(17, 'Bún Chả Hà Nội', 'Grilled pork meatballs and belly served with vermicelli and dipping sauce.', 'Ground pork\nPork belly\nFish sauce\nSugar\nGarlic\nVinegar\nPapaya\nVermicelli\nHerbs', '1. Marinate ground pork and belly separately\n2. Grill over charcoal\n3. Make dipping sauce with papaya\n4. Serve with fresh herbs and noodles', 60, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1585325701165-351af916e581', 6),
(18, 'Spaghetti Carbonara', 'Classic Roman pasta with eggs, cheese, guanciale, and black pepper.', 'Spaghetti\nEggs\nPecorino Romano\nGuanciale\nBlack pepper', '1. Cook pasta\n2. Fry guanciale\n3. Mix eggs and cheese\n4. Toss pasta with fat\n5. Mix in egg mixture off heat\n6. Top with pepper', 25, 'Medium', 'Italian', 'food', 'https://images.unsplash.com/photo-1612874742237-6526221588e3', 15),
(19, 'Matcha Latte', 'Creamy iced matcha latte.', 'Matcha powder\nMilk\nSugar syrup\nIce\nHot water', '1. Whisk matcha with hot water\n2. Fill glass with ice and milk\n3. Pour matcha over milk\n4. Sweeten to taste', 10, 'Easy', 'Drinks', 'drink', 'https://images.unsplash.com/photo-1515825838458-f2a94b20105a', 5),
(20, 'Bánh Mì Thịt Nướng', 'Crispy baguette filled with grilled pork, pâté, and pickled vegetables.', 'Baguette\nPork shoulder\nLemongrass\nFish sauce\nPickled carrots\nCilantro\nChili\nPâté\nMayo', '1. Marinate pork with lemongrass\n2. Grill pork until charred\n3. Toast baguette\n4. Spread pâté and mayo\n5. Assemble with meat and veggies', 45, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1626804475297-411dbe6314c9', 10),
(21, 'Phở Bò Tái Nạm', 'Traditional Vietnamese beef noodle soup with rare beef and brisket.', 'Beef bones\nRice noodles\nBeef tenderloin\nBrisket\nStar anise\nCinnamon\nGinger\nOnion\nFish sauce', '1. Simmer bones for 6 hours\n2. Char ginger and onion\n3. Add spices\n4. Blanch noodles\n5. Slice beef thin\n6. Pour hot broth over noodles and beef', 180, 'Hard', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43', 13),
(22, 'Avocado Toast', 'Sourdough toast with smashed avocado and poached egg.', 'Sourdough bread\nAvocado\nEgg\nChili flakes\nLemon\nSalt', '1. Toast bread\n2. Smash avocado with lemon\n3. Poach egg\n4. Assemble\n5. Season', 10, 'Easy', 'Healthy', 'food', 'https://images.unsplash.com/photo-1588137372308-15f75323ca8d', 1),
(23, 'Strawberry Cheesecake', 'Creamy no-bake cheesecake with fresh strawberry topping.', 'Cream cheese\nHeavy cream\nGraham crackers\nButter\nStrawberries\nSugar\nGelatin', '1. Make crust\n2. Whip cream and cheese\n3. Set in fridge\n4. Make strawberry sauce\n5. Top and serve', 300, 'Medium', 'Dessert', 'food', 'https://images.unsplash.com/photo-1565958011703-44f9829ba187', 15),
(24, 'Greek Salad', 'Fresh salad with cucumber, tomato, olives, and feta.', 'Cucumber\nTomato\nRed onion\nKalamata olives\nFeta cheese\nOregano\nOlive oil', '1. Chop veggies chunks\n2. Slice onion thin\n3. Combine in bowl\n4. Top with feta block\n5. Drizzle oil and oregano', 15, 'Easy', 'Healthy', 'food', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', 14),
(25, 'Tonkatsu Ramen', 'Rich pork bone broth ramen with chashu pork.', 'Pork bones\nRamen noodles\nChashu pork\nEgg\nMenma\nGreen onions\nNori', '1. Boil bones for 12 hours\n2. Make tare\n3. Cook noodles\n4. Assemble bowl\n5. Top with toppings', 720, 'Hard', 'Japanese', 'food', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624', 11),
(26, 'Gỏi Cuốn (Spring Rolls)', 'Fresh summer rolls with shrimp, pork, herbs, and vermicelli.', 'Rice paper\nShrimp\nPork belly\nVermicelli\nLettuce\nMint\nChives\nPeanut sauce', '1. Boil shrimp and pork\n2. Cook vermicelli\n3. Wet rice paper\n4. Layer ingredients\n5. Roll tightly\n6. Serve with peanut sauce', 30, 'Easy', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb', 4),
(27, 'Sushi Platter', 'Assorted nigiri and maki rolls with fresh fish.', 'Sushi rice\nVinegar\nSalmon\nTuna\nNori\nCucumber\nAvocado\nWasabi', '1. Cook and season rice\n2. Slice fish\n3. Form nigiri\n4. Roll maki\n5. Arrange on platter', 60, 'Hard', 'Japanese', 'food', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c', 13),
(28, 'Chocolate Lava Cake', 'Warm chocolate cake with a molten center.', 'Dark chocolate\nButter\nEggs\nSugar\nFlour\nVanilla', '1. Melt chocolate and butter\n2. Whisk eggs and sugar\n3. Combine and add flour\n4. Bake 12 mins at 200C\n5. Serve warm', 20, 'Medium', 'Dessert', 'food', 'https://images.unsplash.com/photo-1606313564200-e75d5e30476d', 4),
(29, 'Bún Chả Hà Nội', 'Grilled pork meatballs and belly served with vermicelli and dipping sauce.', 'Ground pork\nPork belly\nFish sauce\nSugar\nGarlic\nVinegar\nPapaya\nVermicelli\nHerbs', '1. Marinate ground pork and belly separately\n2. Grill over charcoal\n3. Make dipping sauce with papaya\n4. Serve with fresh herbs and noodles', 60, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1585325701165-351af916e581', 10),
(30, 'Classic Mojito', 'Refreshing Cuban cocktail with mint and lime.', 'White rum\nMint leaves\nLime\nSugar\nSoda water\nIce', '1. Muddle mint and lime\n2. Add rum and sugar\n3. Fill with ice\n4. Top with soda\n5. Garnish', 5, 'Easy', 'Drinks', 'drink', 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd', 3),
(31, 'Chocolate Lava Cake', 'Warm chocolate cake with a molten center.', 'Dark chocolate\nButter\nEggs\nSugar\nFlour\nVanilla', '1. Melt chocolate and butter\n2. Whisk eggs and sugar\n3. Combine and add flour\n4. Bake 12 mins at 200C\n5. Serve warm', 20, 'Medium', 'Dessert', 'food', 'https://images.unsplash.com/photo-1606313564200-e75d5e30476d', 1),
(32, 'Bánh Mì Thịt Nướng', 'Crispy baguette filled with grilled pork, pâté, and pickled vegetables.', 'Baguette\nPork shoulder\nLemongrass\nFish sauce\nPickled carrots\nCilantro\nChili\nPâté\nMayo', '1. Marinate pork with lemongrass\n2. Grill pork until charred\n3. Toast baguette\n4. Spread pâté and mayo\n5. Assemble with meat and veggies', 45, 'Medium', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1626804475297-411dbe6314c9', 3),
(33, 'Spaghetti Carbonara', 'Classic Roman pasta with eggs, cheese, guanciale, and black pepper.', 'Spaghetti\nEggs\nPecorino Romano\nGuanciale\nBlack pepper', '1. Cook pasta\n2. Fry guanciale\n3. Mix eggs and cheese\n4. Toss pasta with fat\n5. Mix in egg mixture off heat\n6. Top with pepper', 25, 'Medium', 'Italian', 'food', 'https://images.unsplash.com/photo-1612874742237-6526221588e3', 3),
(34, 'Phở Bò Tái Nạm', 'Traditional Vietnamese beef noodle soup with rare beef and brisket.', 'Beef bones\nRice noodles\nBeef tenderloin\nBrisket\nStar anise\nCinnamon\nGinger\nOnion\nFish sauce', '1. Simmer bones for 6 hours\n2. Char ginger and onion\n3. Add spices\n4. Blanch noodles\n5. Slice beef thin\n6. Pour hot broth over noodles and beef', 180, 'Hard', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43', 8),
(35, 'Sushi Platter', 'Assorted nigiri and maki rolls with fresh fish.', 'Sushi rice\nVinegar\nSalmon\nTuna\nNori\nCucumber\nAvocado\nWasabi', '1. Cook and season rice\n2. Slice fish\n3. Form nigiri\n4. Roll maki\n5. Arrange on platter', 60, 'Hard', 'Japanese', 'food', 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c', 2),
(36, 'Gỏi Cuốn (Spring Rolls)', 'Fresh summer rolls with shrimp, pork, herbs, and vermicelli.', 'Rice paper\nShrimp\nPork belly\nVermicelli\nLettuce\nMint\nChives\nPeanut sauce', '1. Boil shrimp and pork\n2. Cook vermicelli\n3. Wet rice paper\n4. Layer ingredients\n5. Roll tightly\n6. Serve with peanut sauce', 30, 'Easy', 'Vietnamese', 'food', 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb', 8),
(37, 'Greek Salad', 'Fresh salad with cucumber, tomato, olives, and feta.', 'Cucumber\nTomato\nRed onion\nKalamata olives\nFeta cheese\nOregano\nOlive oil', '1. Chop veggies chunks\n2. Slice onion thin\n3. Combine in bowl\n4. Top with feta block\n5. Drizzle oil and oregano', 15, 'Easy', 'Healthy', 'food', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', 2),
(38, 'Matcha Latte', 'Creamy iced matcha latte.', 'Matcha powder\nMilk\nSugar syrup\nIce\nHot water', '1. Whisk matcha with hot water\n2. Fill glass with ice and milk\n3. Pour matcha over milk\n4. Sweeten to taste', 10, 'Easy', 'Drinks', 'drink', 'https://images.unsplash.com/photo-1515825838458-f2a94b20105a', 12),
(39, 'Tonkatsu Ramen', 'Rich pork bone broth ramen with chashu pork.', 'Pork bones\nRamen noodles\nChashu pork\nEgg\nMenma\nGreen onions\nNori', '1. Boil bones for 12 hours\n2. Make tare\n3. Cook noodles\n4. Assemble bowl\n5. Top with toppings', 720, 'Hard', 'Japanese', 'food', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624', 1),
(40, 'Margherita Pizza', 'Neapolitan style pizza with San Marzano tomatoes and buffalo mozzarella.', '00 Flour\nYeast\nSan Marzano tomatoes\nBuffalo mozzarella\nBasil\nOlive oil', '1. Make dough and proof\n2. Stretch dough\n3. Top with sauce and cheese\n4. Bake at max temp\n5. Garnish with basil', 90, 'Hard', 'Italian', 'food', 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002', 4),
(41, 'Avocado Toast', 'Sourdough toast with smashed avocado and poached egg.', 'Sourdough bread\nAvocado\nEgg\nChili flakes\nLemon\nSalt', '1. Toast bread\n2. Smash avocado with lemon\n3. Poach egg\n4. Assemble\n5. Season', 10, 'Easy', 'Healthy', 'food', 'https://images.unsplash.com/photo-1588137372308-15f75323ca8d', 13),
(42, 'Strawberry Cheesecake', 'Creamy no-bake cheesecake with fresh strawberry topping.', 'Cream cheese\nHeavy cream\nGraham crackers\nButter\nStrawberries\nSugar\nGelatin', '1. Make crust\n2. Whip cream and cheese\n3. Set in fridge\n4. Make strawberry sauce\n5. Top and serve', 300, 'Medium', 'Dessert', 'food', 'https://images.unsplash.com/photo-1565958011703-44f9829ba187', 10);

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
  `is_admin` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `email`, `password_hash`, `profile_picture`, `bio`, `is_admin`) VALUES
(1, 'ChefGordon', 'gordon@example.com', 'scrypt:32768:8:1$sCnst34Y9ODJJs3O$9bd33e03ca02ae947e0a244bef0c9306ffb407bd2344e9a70eb33cbba5c1fec12fc0aab52e9b83fa3585bde3cb13b64116241e97591a7de59c2da9b90a40d4ef', 'https://images.unsplash.com/photo-1583394293214-28ded15ee548', 'Professional chef with a temper.', 0),
(2, 'JamieO', 'jamie@example.com', 'scrypt:32768:8:1$AeE00nTGgKyioW18$adb6c9e8d8344a4568f94ceeb3d7e60c087ca03886ef69be0360c727fbf81837cea963ed45fe0221f43e132c206b6f172af0f00c4b540904f0a5f904210e8e89', 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6', 'Simple, rustic cooking is my passion.', 0),
(3, 'NigellaB', 'nigella@example.com', 'scrypt:32768:8:1$ZqZ2PzwzAlxqBT9H$061fc24572bec98a2eea5b535755278230008dbf63ddb93cded1c96546850ba3034b83718e0f2ff70768df59559da1c179f3772bc551438fe81f647e24b03e68', 'https://images.unsplash.com/photo-1494790108377-be9c29b29330', 'Indulgent desserts and comfort food.', 0),
(4, 'UncleRoger', 'roger@example.com', 'scrypt:32768:8:1$wPGWsilwwIIQH3rq$647ea0391609a41133b1e07143a2121e6f1987a204a8dbe07db5db52b09d90fb46470790df26e9e845900e758bef71d80ae873a8cad7dba09d336fd7d1ee7567', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d', 'Haiyaa! Use MSG!', 0),
(5, 'Maangchi', 'maangchi@example.com', 'scrypt:32768:8:1$4wIF8CnKGzCwXGbd$de4a6d79f2424d5515015e66354085da5e8fbead0af680ba0044ee0b9e6d376c2102f5e8f6b08d505e3119020fe812aceede6a1d6c9dd985ee8e153b90050cc0', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80', 'Korean cooking superstar.', 0),
(6, 'Babish', 'babish@example.com', 'scrypt:32768:8:1$JMv6wG2J05Qetx69$b6c147c7499d8436b36b4eecac0ff8cac1952ef0ae0ad65feff0c42db3aea67c1ee9e786102f5296c779540b39e85c439af22c65d3f11ab9efc1017ba45a2c40', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e', 'Recreating movies in the kitchen.', 0),
(7, 'JoshuaW', 'joshua@example.com', 'scrypt:32768:8:1$msI8yGh5XXpjWHgv$ea7856b14d51aab088d8cdd16273a0df9cdc3391dd042c88ca31915da2789d4179ff8a58ae9577178d3eb3a82749884f9cf19251e043ef18a2ff2a7ffc9ecf75', 'https://images.unsplash.com/photo-1527980965255-d3b416303d12', 'Papa kiss!', 0),
(8, 'KenjiL', 'kenji@example.com', 'scrypt:32768:8:1$zIWngbMkYZb0OEZl$98e5e965af2f9c71b7b2c22e3a9ac83e601c9d1e282acc7463ad229463ef833e841532053da547547fda552f2a1a50f73678b03498349cfb2e7a27b2e57c74ed', 'https://images.unsplash.com/photo-1522075469751-3a3694fb60ed', 'Science-based home cooking.', 0),
(9, 'SaminN', 'samin@example.com', 'scrypt:32768:8:1$zRCfV3K0XRSZY65X$d6f8202a95915c840394ae4b32ce15cf11403924560af5a8175710e9fc4dc584619a1be681bfe90731402001089ae64d6f6b7d12b3eb12119fb6a36dc8f13170', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2', 'Salt, Fat, Acid, Heat.', 0),
(10, 'DavidChang', 'david@example.com', 'scrypt:32768:8:1$lKCVvbj3etsgkVhz$d40aa028b911af3d9d1a35a85ac2587c9a6d9d20d1b0f3f2ab901a2eb7353a44966642878c65fadebeb828595714fe4a78f6e94e1d95a2e160183e354b66efa0', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d', 'Ugly delicious.', 0),
(11, 'JuliaChild', 'julia@example.com', 'scrypt:32768:8:1$ke12ebwg3lffzZ1w$78706cac22e5d12ef2b02126a64417dd33a8ca3996a88237ba957496de389249a007123d7b60fbd457bbd0077852ccea6d7cf1626b7fad42131b62e6a8dbabf5', 'https://images.unsplash.com/photo-1534528741775-53994a69daeb', 'Bon Appétit!', 0),
(12, 'AnthonyB', 'anthony@example.com', 'scrypt:32768:8:1$69hQsYi8y5NoHPrY$db961374fb053befde73b2ee16478e2571e916caa46610b44e622242c271b20912b2a1fc594a10c0b8afca916e98d2a36fc87c6523c5a2a7abe8748f032e4b53', 'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79', 'Travel and eat.', 0),
(13, 'MarthaS', 'martha@example.com', 'scrypt:32768:8:1$KzpBmnCJLU1AsMZ3$668edd9ad80a858020efb0a84641ba4d51768f15d5fb96411915965335ce98db8f4768ac9c42839168713df004115bb50801c84bad533abeec14bcf7000559d2', 'https://images.unsplash.com/photo-1548142813-c348350df52b', 'Perfection in every detail.', 0),
(14, 'GuyFieri', 'guy@example.com', 'scrypt:32768:8:1$ZZ4V3LVSyE161eMZ$b111d41d85849908f75e446f2e4a80e18f5623a5ab1cda5646720ff038058e7a67d81cf2d7b78c83aa8874c47b853d4e120cbab7a3100a655bc7989f50131b0e', 'https://images.unsplash.com/photo-1542909168-82c3e7fdca5c', 'Welcome to Flavortown!', 0),
(15, 'RachaelRay', 'rachael@example.com', 'scrypt:32768:8:1$pTVkDdaAWhxnNfrc$61ca3b50f487588ba57c0b40a74305c164a3a800a2ecede0f58fdf1db30bdd3c2ec47b9e9b3bd9d6d69d56f4e357ceb7e97ec6b963fe3dedc19a4d896978edde', 'https://images.unsplash.com/photo-1517841905240-472988babdf9', '30 minute meals.', 0),
(16, 'admin', 'admin@example.com', 'scrypt:32768:8:1$xdjVFVVOpIjvawtR$454d5fce2aeb9e97e2a2bad8de9782aab3b501c422d6554fbfab46a9d00a629708bc0729e8958ffad857a40b3231dfb15c4605997e86d45026393f3b400c49fb', '', 'System Administrator', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `recipe_id` (`recipe_id`);

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
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `comment`
--
ALTER TABLE `comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT for table `favorite`
--
ALTER TABLE `favorite`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `follow`
--
ALTER TABLE `follow`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=150;

--
-- AUTO_INCREMENT for table `rating`
--
ALTER TABLE `rating`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=214;

--
-- AUTO_INCREMENT for table `recipe`
--
ALTER TABLE `recipe`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Constraints for dumped tables
--

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
  ADD CONSTRAINT `recipe_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

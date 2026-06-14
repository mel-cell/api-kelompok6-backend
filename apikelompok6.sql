/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: apikelompok6
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB-0+deb12u2

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
-- Table structure for table `bookmarks`
--

DROP TABLE IF EXISTS `bookmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookmarks` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `post_id` char(36) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `bookmarks_user_id_post_id_unique` (`user_id`,`post_id`),
  KEY `bookmarks_post_id_foreign` (`post_id`),
  CONSTRAINT `bookmarks_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `bookmarks_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks`
--

LOCK TABLES `bookmarks` WRITE;
/*!40000 ALTER TABLE `bookmarks` DISABLE KEYS */;
INSERT INTO `bookmarks` VALUES
('31082e89-7888-4cc3-8a6b-87b0250a3a3f','774642ed-4119-48b9-931d-63dfcbdcffaa','02c33a66-2d6a-4e1b-8530-646a72b048c4','2026-06-13 05:59:37'),
('3664e3c3-b0dc-4b1a-b188-bd9853b3cde4','fe811823-f15f-4720-8ca1-4dc8c361fc5d','02c33a66-2d6a-4e1b-8530-646a72b048c4','2026-06-14 11:10:34'),
('7662eaba-b148-4aed-b820-78b72705bfa9','57d57121-800a-49b2-a261-9648d5f64d57','ec211521-33e3-496f-890e-2534d53e9eed','2026-06-04 09:15:32'),
('7a4ee102-9cfd-4645-ab7f-81f4f5266386','845d3436-2275-46bb-b4d3-7f47dbef9ea0','ec211521-33e3-496f-890e-2534d53e9eed','2026-06-13 07:14:42'),
('99f7596a-9728-42ba-8a08-577f595cd3bb','4c324d24-f559-4567-a9f6-b425c1e481ab','ec211521-33e3-496f-890e-2534d53e9eed','2026-06-12 07:10:17'),
('bb4646d2-386d-434c-af6d-4b514bc41325','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','ec211521-33e3-496f-890e-2534d53e9eed','2026-06-13 01:00:48'),
('e5bf89d1-e0ea-40f5-bb81-a125c6e34f12','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','02c33a66-2d6a-4e1b-8530-646a72b048c4','2026-06-14 11:22:30');
/*!40000 ALTER TABLE `bookmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` char(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(120) NOT NULL,
  `description` text DEFAULT NULL,
  `parent_id` char(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `categories_slug_unique` (`slug`),
  KEY `categories_parent_id_foreign` (`parent_id`),
  CONSTRAINT `categories_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES
('06cac1de-f0c5-4c6f-8bae-1c9ffa360865','Database','database',NULL,NULL,'2026-06-04 03:40:28'),
('165e0346-05af-447d-9b79-fa0f9a9393cd','Programming','programming',NULL,NULL,'2026-06-04 03:40:28'),
('3682a7c1-49e0-4d69-980a-04af0f4caa7d','Security','security',NULL,NULL,'2026-06-04 03:40:28'),
('523bdbf6-4546-4d40-8494-7b747958699d','Web Development','web-development',NULL,NULL,'2026-06-04 03:40:28'),
('5ba758b9-4841-4266-9bfb-907bb9f300b7','Design & UX','design-ux',NULL,NULL,'2026-06-04 03:40:28'),
('78932714-d0f6-42bf-8666-b59cdc7a6143','DevOps & Infrastructure','devops',NULL,NULL,'2026-06-04 03:40:28'),
('a3ec6c90-48e3-4948-8b97-5f751a9c0614','Mobile Development','mobile-development',NULL,NULL,'2026-06-04 03:40:28'),
('a6f0d58a-b4ff-4837-a13b-f5eee099ff40','Career & Discussion','career',NULL,NULL,'2026-06-04 03:40:28'),
('d153fa9b-ca35-4615-952c-31be4560c19c','Artificial Intelligence','ai',NULL,NULL,'2026-06-04 03:40:28');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_edit_history`
--

DROP TABLE IF EXISTS `comment_edit_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment_edit_history` (
  `id` char(36) NOT NULL,
  `comment_id` char(36) NOT NULL,
  `edited_by` char(36) NOT NULL,
  `body_before` text NOT NULL,
  `body_after` text NOT NULL,
  `edited_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `comment_edit_history_comment_id_foreign` (`comment_id`),
  KEY `comment_edit_history_edited_by_foreign` (`edited_by`),
  CONSTRAINT `comment_edit_history_comment_id_foreign` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comment_edit_history_edited_by_foreign` FOREIGN KEY (`edited_by`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_edit_history`
--

LOCK TABLES `comment_edit_history` WRITE;
/*!40000 ALTER TABLE `comment_edit_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment_edit_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` char(36) NOT NULL,
  `post_id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `parent_id` char(36) DEFAULT NULL,
  `body` text NOT NULL,
  `vote_score` int(11) NOT NULL DEFAULT 0,
  `is_accepted` tinyint(1) NOT NULL DEFAULT 0,
  `status` varchar(20) NOT NULL DEFAULT 'visible',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `comments_post_id_index` (`post_id`),
  KEY `comments_user_id_index` (`user_id`),
  KEY `comments_parent_id_index` (`parent_id`),
  KEY `comments_status_index` (`status`),
  CONSTRAINT `comments_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES
('05dd4a0c-4a92-4118-be2f-b0e826b80b98','02c33a66-2d6a-4e1b-8530-646a72b048c4','fb501bb5-6f4a-4d2d-a0ec-36f61c053067',NULL,'wow',1,0,'visible','2026-06-14 04:22:37','2026-06-14 04:22:44'),
('06f428cd-47c7-4bc6-b457-3e9f20d03462','50707173-ef95-4888-a5d0-26cf58962eda','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',NULL,'Saya sudah menggunakan approach ini di production selama 6 bulan, dan works well.',4,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('176c4645-4838-48ab-a3d0-26e7332b5896','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'Saya sudah menggunakan approach ini di production selama 6 bulan, dan works well.',-2,0,'hidden','2026-06-03 20:40:29','2026-06-13 00:16:03'),
('1c4824e3-6fdd-4a4f-9c0f-83c26bbf968a','02c33a66-2d6a-4e1b-8530-646a72b048c4','845d3436-2275-46bb-b4d3-7f47dbef9ea0','86db0afe-897f-4141-8edc-fda291169197','Setuju dengan pendapat kamu. Saya juga mengalami hal yang sama.',0,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('21a94a9d-989f-4501-9901-323e1a097380','9ac03af5-e39e-48cc-9887-dd63b18793f2','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'Kalau menurut saya, tergantung use case masing-masing. Tidak ada solusi satu ukuran untuk semua.',4,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('2a898ca9-5905-42c3-bffa-1d03d70f6f26','eaf84ea9-a074-43d1-b2de-b3571bb902df','33e66497-159c-482b-9dec-dd2cea22548c',NULL,'Saya punya pengalaman berbeda. Menurut saya, yang terpenting adalah konsistensi tim.',1,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('34f01297-157d-47a2-be68-425e00b9d9bd','ec211521-33e3-496f-890e-2534d53e9eed','33e66497-159c-482b-9dec-dd2cea22548c',NULL,'haloo',0,0,'visible','2026-06-14 03:53:31','2026-06-14 03:53:31'),
('3acd181b-03fc-4fc2-9afd-4cfff70b507a','b812d824-f65e-49ca-8be6-c79c76616465','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'Jangan lupa pertimbangkan aspek scalability ketika memilih approach.',1,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('3c1c874f-1bf1-4701-a7cf-782f5d6974ce','eaf84ea9-a074-43d1-b2de-b3571bb902df','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',NULL,'Jangan lupa pertimbangkan aspek scalability ketika memilih approach.',4,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('3d088345-15de-4098-9446-87ed05575dda','515df151-1076-499a-b66f-b51796f3741d','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','6dad4dfe-4cb9-4b1c-b178-bc6637f374ff','Setuju dengan pendapat kamu. Saya juga mengalami hal yang sama.',3,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('3d18f0a5-8080-41d1-8f66-17bc46e46374','38329261-3952-4262-a039-31c17d32db07','33e66497-159c-482b-9dec-dd2cea22548c',NULL,'Artikel yang bagus! Saya setuju dengan poin-poin yang disampaikan.',3,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('3e308518-445e-402d-8901-62e0c55cce66','6b1ddda9-116f-408f-b441-bd9d2b608538','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','672a5eb0-402c-41ef-a06a-b91bb362fb10','Setuju dengan pendapat kamu. Saya juga mengalami hal yang sama.',4,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('3f36d9d4-af83-4269-991a-0651d35a3624','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'Jangan lupa pertimbangkan aspek scalability ketika memilih approach.',9,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('447277e8-aa67-4d23-b90f-85a25dd455da','02c33a66-2d6a-4e1b-8530-646a72b048c4','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'Saya sudah menggunakan approach ini di production selama 6 bulan, dan works well.',9,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('460da80b-af49-4934-81c2-583dab04769b','515df151-1076-499a-b66f-b51796f3741d','33e66497-159c-482b-9dec-dd2cea22548c',NULL,'Pengalaman saya pribadi, mending pelajari konsep dasarnya dulu sebelum masuk ke framework.',5,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('4a507e7a-e229-44a7-b4e6-be2c1aeb667a','f5bea9ca-69b4-4e07-9113-190a1a3b25ed','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',NULL,'Saya recommend cek repo GitHub berikut untuk referensi implementasi.',0,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('4be974bd-730b-4b15-b33a-93070a87f514','38329261-3952-4262-a039-31c17d32db07','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'adwada',0,0,'visible','2026-06-12 22:59:35','2026-06-12 22:59:35'),
('54c258b6-d076-4d48-a78a-aa79b91458b1','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c','774642ed-4119-48b9-931d-63dfcbdcffaa',NULL,'hey',0,0,'visible','2026-06-12 23:03:44','2026-06-12 23:03:44'),
('57e72981-dac6-4d5f-a55b-b27f2358482c','02c33a66-2d6a-4e1b-8530-646a72b048c4','fe811823-f15f-4720-8ca1-4dc8c361fc5d','447277e8-aa67-4d23-b90f-85a25dd455da','gud',0,0,'visible','2026-06-12 17:11:25','2026-06-12 17:11:25'),
('5a7ea8b4-e149-4d07-96da-cb50f477daa6','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',NULL,'Terima kasih sudah berbagi. Sangat membantu!',2,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('672a5eb0-402c-41ef-a06a-b91bb362fb10','6b1ddda9-116f-408f-b441-bd9d2b608538','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'Saya dulu juga bingung, tapi setelah baca dokumentasi resmi jadi lebih paham.',1,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('6a9f674d-f498-4c1e-8d9b-3d964a2b4451','ec211521-33e3-496f-890e-2534d53e9eed','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'kontol',-2,0,'visible','2026-06-12 23:20:10','2026-06-14 03:53:26'),
('6cf01ab9-4230-4cb2-8d3a-a8f066b8ed75','02c33a66-2d6a-4e1b-8530-646a72b048c4','c5b020c2-0a38-426c-9a7c-662d7f35bcb0','fdf3c8af-0db6-457c-8cbb-f1b0722307b0','bener tuh',0,0,'visible','2026-06-12 22:40:14','2026-06-12 22:40:14'),
('6dad4dfe-4cb9-4b1c-b178-bc6637f374ff','515df151-1076-499a-b66f-b51796f3741d','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'Terima kasih sudah berbagi. Sangat membantu!',4,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('83f031b9-4215-44b0-86a8-403c7f7bec3d','515df151-1076-499a-b66f-b51796f3741d','845d3436-2275-46bb-b4d3-7f47dbef9ea0','460da80b-af49-4934-81c2-583dab04769b','Setuju dengan pendapat kamu. Saya juga mengalami hal yang sama.',3,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('86db0afe-897f-4141-8edc-fda291169197','02c33a66-2d6a-4e1b-8530-646a72b048c4','33e66497-159c-482b-9dec-dd2cea22548c',NULL,'Artikel yang bagus! Saya setuju dengan poin-poin yang disampaikan.',1,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('9101338f-c2af-47d4-b683-a3a10791397b','02c33a66-2d6a-4e1b-8530-646a72b048c4','774642ed-4119-48b9-931d-63dfcbdcffaa',NULL,'halow',1,0,'visible','2026-06-14 03:50:09','2026-06-14 03:51:17'),
('93b07291-5a2a-4ec5-9ea8-18bfbe89fa05','b812d824-f65e-49ca-8be6-c79c76616465','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',NULL,'Saya sudah menggunakan approach ini di production selama 6 bulan, dan works well.',7,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('94c15ffb-cc50-41bf-97a0-a97286b10aca','9ac03af5-e39e-48cc-9887-dd63b18793f2','33e66497-159c-482b-9dec-dd2cea22548c',NULL,'Terima kasih sudah berbagi. Sangat membantu!',4,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('a056f4db-28d3-479b-9c6d-893dd8090453','515df151-1076-499a-b66f-b51796f3741d','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',NULL,'Saya recommend cek repo GitHub berikut untuk referensi implementasi.',9,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('a3aa26c4-0dcf-40ba-94a4-978ed8197a70','38329261-3952-4262-a039-31c17d32db07','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',NULL,'Artikel yang bagus! Saya setuju dengan poin-poin yang disampaikan.',0,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('a82093a7-0539-4f5f-b570-c030fe4d1921','f5bea9ca-69b4-4e07-9113-190a1a3b25ed','33e66497-159c-482b-9dec-dd2cea22548c',NULL,'Saya dulu juga bingung, tapi setelah baca dokumentasi resmi jadi lebih paham.',4,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('aa0dfcee-8ae7-4a23-b3b6-bf1157eb46f0','02c33a66-2d6a-4e1b-8530-646a72b048c4','774642ed-4119-48b9-931d-63dfcbdcffaa','9101338f-c2af-47d4-b683-a3a10791397b','halo juga',1,0,'visible','2026-06-14 03:51:02','2026-06-14 03:51:20'),
('aead32c7-755c-46bc-ac39-cbf6ed6a5e1e','eaf84ea9-a074-43d1-b2de-b3571bb902df','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','afed9590-c13e-4bb4-b434-e804271dfd70','Setuju dengan pendapat kamu. Saya juga mengalami hal yang sama.',4,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('afed9590-c13e-4bb4-b434-e804271dfd70','eaf84ea9-a074-43d1-b2de-b3571bb902df','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'Jangan lupa pertimbangkan aspek scalability ketika memilih approach.',8,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('b1c0d7f9-82da-4988-bfc9-c4e2b2a08147','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c','33e66497-159c-482b-9dec-dd2cea22548c',NULL,'Pengalaman saya pribadi, mending pelajari konsep dasarnya dulu sebelum masuk ke framework.',10,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('baf43c0e-0662-4a77-9145-b648b2f678d3','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c','33e66497-159c-482b-9dec-dd2cea22548c','5a7ea8b4-e149-4d07-96da-cb50f477daa6','Setuju dengan pendapat kamu. Saya juga mengalami hal yang sama.',1,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('bc0f809a-bb7f-4859-bd7f-274998d0e3ec','6b1ddda9-116f-408f-b441-bd9d2b608538','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',NULL,'Kalau menurut saya, tergantung use case masing-masing. Tidak ada solusi satu ukuran untuk semua.',5,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('bc34cb10-85a8-4a2b-b2c8-386b2731841e','515df151-1076-499a-b66f-b51796f3741d','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'anjing',0,0,'visible','2026-06-12 23:14:30','2026-06-12 23:14:30'),
('c0f3d5d4-113f-4aca-a864-c09a895f3030','02c33a66-2d6a-4e1b-8530-646a72b048c4','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','447277e8-aa67-4d23-b90f-85a25dd455da','Setuju dengan pendapat kamu. Saya juga mengalami hal yang sama.',5,0,'visible','2026-06-03 20:40:29','2026-06-13 22:23:04'),
('c2f319d9-431f-4b89-b4e7-b5cd561edc6c','6b1ddda9-116f-408f-b441-bd9d2b608538','33e66497-159c-482b-9dec-dd2cea22548c',NULL,'Artikel yang bagus! Saya setuju dengan poin-poin yang disampaikan.',3,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('c698f1ea-d135-4c21-8d40-3d3e8bb22451','38329261-3952-4262-a039-31c17d32db07','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',NULL,'Saya punya pengalaman berbeda. Menurut saya, yang terpenting adalah konsistensi tim.',0,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('d2d74836-f5ab-4d92-bd9c-445edfab0dec','6b1ddda9-116f-408f-b441-bd9d2b608538','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'Terima kasih sudah berbagi. Sangat membantu!',-1,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('d8372d3d-97b1-46f4-8b30-b4e9612f5f96','38329261-3952-4262-a039-31c17d32db07','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'Terima kasih sudah berbagi. Sangat membantu!',8,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('d8a3c17f-6c54-49f9-805f-c992c2f1bc5a','f5bea9ca-69b4-4e07-9113-190a1a3b25ed','845d3436-2275-46bb-b4d3-7f47dbef9ea0',NULL,'Saya dulu juga bingung, tapi setelah baca dokumentasi resmi jadi lebih paham.',6,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('d9c37e38-9a34-4350-80e2-721893cf22db','02c33a66-2d6a-4e1b-8530-646a72b048c4','c5b020c2-0a38-426c-9a7c-662d7f35bcb0',NULL,'wawww',0,0,'visible','2026-06-12 22:39:59','2026-06-12 22:39:59'),
('f1cfcd60-e1cb-4b7d-85fa-b9812958061e','02c33a66-2d6a-4e1b-8530-646a72b048c4','33e66497-159c-482b-9dec-dd2cea22548c',NULL,'Jangan lupa pertimbangkan aspek scalability ketika memilih approach.',2,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('fbee78e9-e718-4441-b733-fcafb098a12f','f5bea9ca-69b4-4e07-9113-190a1a3b25ed','845d3436-2275-46bb-b4d3-7f47dbef9ea0','a82093a7-0539-4f5f-b570-c030fe4d1921','Setuju dengan pendapat kamu. Saya juga mengalami hal yang sama.',2,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29'),
('fdf3c8af-0db6-457c-8cbb-f1b0722307b0','02c33a66-2d6a-4e1b-8530-646a72b048c4','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',NULL,'Saya punya pengalaman berbeda. Menurut saya, yang terpenting adalah konsistensi tim.',2,0,'visible','2026-06-03 20:40:29','2026-06-03 20:40:29');
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
INSERT INTO `failed_jobs` VALUES
(1,'a4d1fb43-2c82-48f3-bd50-a887f7d749a7','redis','default','{\"uuid\":\"a4d1fb43-2c82-48f3-bd50-a887f7d749a7\",\"displayName\":\"App\\\\Listeners\\\\AwardPoints\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Events\\\\CallQueuedListener\",\"command\":\"O:36:\\\"Illuminate\\\\Events\\\\CallQueuedListener\\\":26:{s:5:\\\"class\\\";s:25:\\\"App\\\\Listeners\\\\AwardPoints\\\";s:6:\\\"method\\\";s:6:\\\"handle\\\";s:4:\\\"data\\\";a:1:{i:0;O:25:\\\"App\\\\Events\\\\CommentCreated\\\":1:{s:7:\\\"comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"f7df521b-b3ed-4455-b0fa-86a77fd0379a\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}}}s:5:\\\"tries\\\";N;s:13:\\\"maxExceptions\\\";N;s:7:\\\"backoff\\\";N;s:10:\\\"retryUntil\\\";N;s:7:\\\"timeout\\\";N;s:13:\\\"failOnTimeout\\\";b:0;s:17:\\\"shouldBeEncrypted\\\";b:0;s:14:\\\"shouldBeUnique\\\";b:0;s:29:\\\"shouldBeUniqueUntilProcessing\\\";b:0;s:8:\\\"uniqueId\\\";N;s:9:\\\"uniqueFor\\\";N;s:3:\\\"job\\\";N;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781330566,\"id\":\"a4d1fb43-2c82-48f3-bd50-a887f7d749a7\",\"attempts\":0,\"delay\":null,\"type\":\"event\",\"tags\":[\"App\\\\Models\\\\Comment:f7df521b-b3ed-4455-b0fa-86a77fd0379a\"],\"silenced\":false,\"pushedAt\":\"1781330566.504\"}','Illuminate\\Database\\Eloquent\\ModelNotFoundException: No query results for model [App\\Models\\Comment]. in /var/www/html/vendor/laravel/framework/src/Illuminate/Database/Eloquent/Builder.php:780\nStack trace:\n#0 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/SerializesAndRestoresModelIdentifiers.php(112): Illuminate\\Database\\Eloquent\\Builder->firstOrFail()\n#1 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/SerializesAndRestoresModelIdentifiers.php(63): App\\Events\\CommentCreated->restoreModel(Object(Illuminate\\Contracts\\Database\\ModelIdentifier))\n#2 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/SerializesModels.php(97): App\\Events\\CommentCreated->getRestoredPropertyValue(Object(Illuminate\\Contracts\\Database\\ModelIdentifier))\n#3 [internal function]: App\\Events\\CommentCreated->__unserialize(Array)\n#4 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(97): unserialize(\'O:36:\"Illuminat...\')\n#5 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(64): Illuminate\\Queue\\CallQueuedHandler->getCommand(Array)\n#6 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#7 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(504): Illuminate\\Queue\\Jobs\\Job->fire()\n#8 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(454): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#9 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(212): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#10 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(149): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#11 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(132): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#12 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#13 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#14 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#15 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#16 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#17 /var/www/html/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#18 /var/www/html/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#19 /var/www/html/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#20 /var/www/html/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#21 /var/www/html/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#22 /var/www/html/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#23 /var/www/html/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#24 /var/www/html/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#25 /var/www/html/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#26 {main}','2026-06-13 22:28:11'),
(2,'3ebfd51d-508d-4102-9ca4-25e181bcc748','redis','default','{\"uuid\":\"3ebfd51d-508d-4102-9ca4-25e181bcc748\",\"displayName\":\"App\\\\Listeners\\\\AwardPoints\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Events\\\\CallQueuedListener\",\"command\":\"O:36:\\\"Illuminate\\\\Events\\\\CallQueuedListener\\\":26:{s:5:\\\"class\\\";s:25:\\\"App\\\\Listeners\\\\AwardPoints\\\";s:6:\\\"method\\\";s:6:\\\"handle\\\";s:4:\\\"data\\\";a:1:{i:0;O:25:\\\"App\\\\Events\\\\CommentCreated\\\":1:{s:7:\\\"comment\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:18:\\\"App\\\\Models\\\\Comment\\\";s:2:\\\"id\\\";s:36:\\\"f7df521b-b3ed-4455-b0fa-86a77fd0379a\\\";s:9:\\\"relations\\\";a:1:{i:0;s:4:\\\"user\\\";}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}}}s:5:\\\"tries\\\";N;s:13:\\\"maxExceptions\\\";N;s:7:\\\"backoff\\\";N;s:10:\\\"retryUntil\\\";N;s:7:\\\"timeout\\\";N;s:13:\\\"failOnTimeout\\\";b:0;s:17:\\\"shouldBeEncrypted\\\";b:0;s:14:\\\"shouldBeUnique\\\";b:0;s:29:\\\"shouldBeUniqueUntilProcessing\\\";b:0;s:8:\\\"uniqueId\\\";N;s:9:\\\"uniqueFor\\\";N;s:3:\\\"job\\\";N;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"batchId\":null},\"createdAt\":1781330566,\"id\":\"3ebfd51d-508d-4102-9ca4-25e181bcc748\",\"attempts\":0,\"delay\":null,\"type\":\"event\",\"tags\":[\"App\\\\Models\\\\Comment:f7df521b-b3ed-4455-b0fa-86a77fd0379a\"],\"silenced\":false,\"pushedAt\":\"1781330566.5057\"}','Illuminate\\Database\\Eloquent\\ModelNotFoundException: No query results for model [App\\Models\\Comment]. in /var/www/html/vendor/laravel/framework/src/Illuminate/Database/Eloquent/Builder.php:780\nStack trace:\n#0 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/SerializesAndRestoresModelIdentifiers.php(112): Illuminate\\Database\\Eloquent\\Builder->firstOrFail()\n#1 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/SerializesAndRestoresModelIdentifiers.php(63): App\\Events\\CommentCreated->restoreModel(Object(Illuminate\\Contracts\\Database\\ModelIdentifier))\n#2 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/SerializesModels.php(97): App\\Events\\CommentCreated->getRestoredPropertyValue(Object(Illuminate\\Contracts\\Database\\ModelIdentifier))\n#3 [internal function]: App\\Events\\CommentCreated->__unserialize(Array)\n#4 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(97): unserialize(\'O:36:\"Illuminat...\')\n#5 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/CallQueuedHandler.php(64): Illuminate\\Queue\\CallQueuedHandler->getCommand(Array)\n#6 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Jobs/Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\RedisJob), Array)\n#7 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(504): Illuminate\\Queue\\Jobs\\Job->fire()\n#8 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(454): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#9 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(212): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#10 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(149): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#11 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(132): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#12 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#13 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#14 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#15 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#16 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#17 /var/www/html/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#18 /var/www/html/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#19 /var/www/html/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#20 /var/www/html/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#21 /var/www/html/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#22 /var/www/html/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#23 /var/www/html/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#24 /var/www/html/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#25 /var/www/html/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#26 {main}','2026-06-13 22:28:11'),
(3,'106d8696-b772-4a50-a9a3-65f0ac2bfc59','redis','default','{\"data\":{\"command\":\"O:36:\\\"Illuminate\\\\Events\\\\CallQueuedListener\\\":26:{s:5:\\\"class\\\";s:25:\\\"App\\\\Listeners\\\\AwardPoints\\\";s:6:\\\"method\\\";s:6:\\\"handle\\\";s:4:\\\"data\\\";a:1:{i:0;O:19:\\\"App\\\\Events\\\\VoteCast\\\":5:{s:11:\\\"targetOwner\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"774642ed-4119-48b9-931d-63dfcbdcffaa\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"actionType\\\";s:17:\\\"downvote_received\\\";s:11:\\\"pointsDelta\\\";i:-1;s:11:\\\"referenceId\\\";s:36:\\\"9101338f-c2af-47d4-b683-a3a10791397b\\\";s:13:\\\"referenceType\\\";s:7:\\\"comment\\\";}}s:5:\\\"tries\\\";N;s:13:\\\"maxExceptions\\\";N;s:7:\\\"backoff\\\";N;s:10:\\\"retryUntil\\\";N;s:7:\\\"timeout\\\";N;s:13:\\\"failOnTimeout\\\";b:0;s:17:\\\"shouldBeEncrypted\\\";b:0;s:14:\\\"shouldBeUnique\\\";b:0;s:29:\\\"shouldBeUniqueUntilProcessing\\\";b:0;s:8:\\\"uniqueId\\\";N;s:9:\\\"uniqueFor\\\";N;s:3:\\\"job\\\";N;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"commandName\":\"Illuminate\\\\Events\\\\CallQueuedListener\",\"batchId\":null},\"maxTries\":null,\"createdAt\":1781434270,\"failOnTimeout\":false,\"attempts\":3,\"type\":\"event\",\"timeout\":null,\"tags\":[\"App\\\\Models\\\\User:774642ed-4119-48b9-931d-63dfcbdcffaa\"],\"id\":\"106d8696-b772-4a50-a9a3-65f0ac2bfc59\",\"displayName\":\"App\\\\Listeners\\\\AwardPoints\",\"maxExceptions\":null,\"pushedAt\":\"1781434270.4238\",\"uuid\":\"106d8696-b772-4a50-a9a3-65f0ac2bfc59\",\"silenced\":false,\"retryUntil\":null,\"backoff\":null,\"delay\":null,\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\"}','Illuminate\\Queue\\MaxAttemptsExceededException: App\\Listeners\\AwardPoints has been attempted too many times. in /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/MaxAttemptsExceededException.php:24\nStack trace:\n#0 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(883): Illuminate\\Queue\\MaxAttemptsExceededException::forJob(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#1 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(592): Illuminate\\Queue\\Worker->maxAttemptsExceededException(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#2 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(493): Illuminate\\Queue\\Worker->markJobAsFailedIfAlreadyExceedsMaxAttempts(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), 3)\n#3 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(454): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#4 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(212): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#5 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(149): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#6 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(132): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#7 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#8 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#9 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#10 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#11 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#12 /var/www/html/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#13 /var/www/html/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#14 /var/www/html/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#15 /var/www/html/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#16 /var/www/html/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#17 /var/www/html/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#18 /var/www/html/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#19 /var/www/html/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#20 /var/www/html/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#21 {main}','2026-06-14 03:56:00'),
(4,'55604418-727a-4d10-a8ae-35d2f4d74d27','redis','default','{\"data\":{\"command\":\"O:36:\\\"Illuminate\\\\Events\\\\CallQueuedListener\\\":26:{s:5:\\\"class\\\";s:25:\\\"App\\\\Listeners\\\\AwardPoints\\\";s:6:\\\"method\\\";s:6:\\\"handle\\\";s:4:\\\"data\\\";a:1:{i:0;O:19:\\\"App\\\\Events\\\\VoteCast\\\":5:{s:11:\\\"targetOwner\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"774642ed-4119-48b9-931d-63dfcbdcffaa\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"actionType\\\";s:15:\\\"upvote_received\\\";s:11:\\\"pointsDelta\\\";i:10;s:11:\\\"referenceId\\\";s:36:\\\"9101338f-c2af-47d4-b683-a3a10791397b\\\";s:13:\\\"referenceType\\\";s:7:\\\"comment\\\";}}s:5:\\\"tries\\\";N;s:13:\\\"maxExceptions\\\";N;s:7:\\\"backoff\\\";N;s:10:\\\"retryUntil\\\";N;s:7:\\\"timeout\\\";N;s:13:\\\"failOnTimeout\\\";b:0;s:17:\\\"shouldBeEncrypted\\\";b:0;s:14:\\\"shouldBeUnique\\\";b:0;s:29:\\\"shouldBeUniqueUntilProcessing\\\";b:0;s:8:\\\"uniqueId\\\";N;s:9:\\\"uniqueFor\\\";N;s:3:\\\"job\\\";N;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"commandName\":\"Illuminate\\\\Events\\\\CallQueuedListener\",\"batchId\":null},\"maxTries\":null,\"createdAt\":1781434272,\"failOnTimeout\":false,\"attempts\":3,\"type\":\"event\",\"timeout\":null,\"tags\":[\"App\\\\Models\\\\User:774642ed-4119-48b9-931d-63dfcbdcffaa\"],\"id\":\"55604418-727a-4d10-a8ae-35d2f4d74d27\",\"displayName\":\"App\\\\Listeners\\\\AwardPoints\",\"maxExceptions\":null,\"pushedAt\":\"1781434272.8291\",\"uuid\":\"55604418-727a-4d10-a8ae-35d2f4d74d27\",\"silenced\":false,\"retryUntil\":null,\"backoff\":null,\"delay\":null,\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\"}','Illuminate\\Queue\\MaxAttemptsExceededException: App\\Listeners\\AwardPoints has been attempted too many times. in /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/MaxAttemptsExceededException.php:24\nStack trace:\n#0 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(883): Illuminate\\Queue\\MaxAttemptsExceededException::forJob(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#1 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(592): Illuminate\\Queue\\Worker->maxAttemptsExceededException(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#2 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(493): Illuminate\\Queue\\Worker->markJobAsFailedIfAlreadyExceedsMaxAttempts(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), 3)\n#3 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(454): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#4 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(212): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#5 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(149): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#6 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(132): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#7 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#8 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#9 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#10 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#11 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#12 /var/www/html/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#13 /var/www/html/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#14 /var/www/html/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#15 /var/www/html/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#16 /var/www/html/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#17 /var/www/html/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#18 /var/www/html/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#19 /var/www/html/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#20 /var/www/html/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#21 {main}','2026-06-14 03:56:11'),
(5,'fde3a54d-6f79-4e67-ad1c-85fc912936eb','redis','default','{\"data\":{\"command\":\"O:36:\\\"Illuminate\\\\Events\\\\CallQueuedListener\\\":26:{s:5:\\\"class\\\";s:25:\\\"App\\\\Listeners\\\\AwardPoints\\\";s:6:\\\"method\\\";s:6:\\\"handle\\\";s:4:\\\"data\\\";a:1:{i:0;O:19:\\\"App\\\\Events\\\\VoteCast\\\":5:{s:11:\\\"targetOwner\\\";O:45:\\\"Illuminate\\\\Contracts\\\\Database\\\\ModelIdentifier\\\":5:{s:5:\\\"class\\\";s:15:\\\"App\\\\Models\\\\User\\\";s:2:\\\"id\\\";s:36:\\\"774642ed-4119-48b9-931d-63dfcbdcffaa\\\";s:9:\\\"relations\\\";a:0:{}s:10:\\\"connection\\\";s:5:\\\"mysql\\\";s:15:\\\"collectionClass\\\";N;}s:10:\\\"actionType\\\";s:15:\\\"upvote_received\\\";s:11:\\\"pointsDelta\\\";i:-5;s:11:\\\"referenceId\\\";s:36:\\\"aa0dfcee-8ae7-4a23-b3b6-bf1157eb46f0\\\";s:13:\\\"referenceType\\\";s:7:\\\"comment\\\";}}s:5:\\\"tries\\\";N;s:13:\\\"maxExceptions\\\";N;s:7:\\\"backoff\\\";N;s:10:\\\"retryUntil\\\";N;s:7:\\\"timeout\\\";N;s:13:\\\"failOnTimeout\\\";b:0;s:17:\\\"shouldBeEncrypted\\\";b:0;s:14:\\\"shouldBeUnique\\\";b:0;s:29:\\\"shouldBeUniqueUntilProcessing\\\";b:0;s:8:\\\"uniqueId\\\";N;s:9:\\\"uniqueFor\\\";N;s:3:\\\"job\\\";N;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\",\"commandName\":\"Illuminate\\\\Events\\\\CallQueuedListener\",\"batchId\":null},\"maxTries\":null,\"createdAt\":1781434278,\"failOnTimeout\":false,\"attempts\":3,\"type\":\"event\",\"timeout\":null,\"tags\":[\"App\\\\Models\\\\User:774642ed-4119-48b9-931d-63dfcbdcffaa\"],\"id\":\"fde3a54d-6f79-4e67-ad1c-85fc912936eb\",\"displayName\":\"App\\\\Listeners\\\\AwardPoints\",\"maxExceptions\":null,\"pushedAt\":\"1781434278.6322\",\"uuid\":\"fde3a54d-6f79-4e67-ad1c-85fc912936eb\",\"silenced\":false,\"retryUntil\":null,\"backoff\":null,\"delay\":null,\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\"}','Illuminate\\Queue\\MaxAttemptsExceededException: App\\Listeners\\AwardPoints has been attempted too many times. in /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/MaxAttemptsExceededException.php:24\nStack trace:\n#0 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(883): Illuminate\\Queue\\MaxAttemptsExceededException::forJob(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#1 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(592): Illuminate\\Queue\\Worker->maxAttemptsExceededException(Object(Illuminate\\Queue\\Jobs\\RedisJob))\n#2 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(493): Illuminate\\Queue\\Worker->markJobAsFailedIfAlreadyExceedsMaxAttempts(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), 3)\n#3 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(454): Illuminate\\Queue\\Worker->process(\'redis\', Object(Illuminate\\Queue\\Jobs\\RedisJob), Object(Illuminate\\Queue\\WorkerOptions))\n#4 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Worker.php(212): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\RedisJob), \'redis\', Object(Illuminate\\Queue\\WorkerOptions))\n#5 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(149): Illuminate\\Queue\\Worker->daemon(\'redis\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#6 /var/www/html/vendor/laravel/framework/src/Illuminate/Queue/Console/WorkCommand.php(132): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'redis\', \'default\')\n#7 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#8 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#9 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#10 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#11 /var/www/html/vendor/laravel/framework/src/Illuminate/Container/Container.php(799): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#12 /var/www/html/vendor/laravel/framework/src/Illuminate/Console/Command.php(211): Illuminate\\Container\\Container->call(Array)\n#13 /var/www/html/vendor/symfony/console/Command/Command.php(341): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#14 /var/www/html/vendor/laravel/framework/src/Illuminate/Console/Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#15 /var/www/html/vendor/symfony/console/Application.php(1117): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#16 /var/www/html/vendor/symfony/console/Application.php(356): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#17 /var/www/html/vendor/symfony/console/Application.php(195): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#18 /var/www/html/vendor/laravel/framework/src/Illuminate/Foundation/Console/Kernel.php(198): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#19 /var/www/html/vendor/laravel/framework/src/Illuminate/Foundation/Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#20 /var/www/html/artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#21 {main}','2026-06-14 03:56:25');
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `follows`
--

DROP TABLE IF EXISTS `follows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `follows` (
  `id` char(36) NOT NULL,
  `follower_id` char(36) NOT NULL,
  `following_id` char(36) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `follows_follower_id_following_id_unique` (`follower_id`,`following_id`),
  KEY `follows_follower_id_index` (`follower_id`),
  KEY `follows_following_id_index` (`following_id`),
  CONSTRAINT `follows_follower_id_foreign` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `follows_following_id_foreign` FOREIGN KEY (`following_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follows`
--

LOCK TABLES `follows` WRITE;
/*!40000 ALTER TABLE `follows` DISABLE KEYS */;
INSERT INTO `follows` VALUES
('142805ed-2024-4952-a6cb-0edf787c6b59','774642ed-4119-48b9-931d-63dfcbdcffaa','4c324d24-f559-4567-a9f6-b425c1e481ab','2026-06-13 05:57:19'),
('32fcad59-94af-4755-b546-2aba9d7123ff','774642ed-4119-48b9-931d-63dfcbdcffaa','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','2026-06-14 10:52:04'),
('60a26cc3-4240-4af4-8382-29474f4fe1d1','774642ed-4119-48b9-931d-63dfcbdcffaa','1cec8710-b813-4040-b742-5c60a6b4f739','2026-06-13 06:18:45'),
('7a9b37c2-90d5-48e3-a670-aff32103791b','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','57d57121-800a-49b2-a261-9648d5f64d57','2026-06-12 17:13:51'),
('b13b0cbe-da4a-4ff7-a5d5-8c438fb6d27a','c5b020c2-0a38-426c-9a7c-662d7f35bcb0','774642ed-4119-48b9-931d-63dfcbdcffaa','2026-06-13 05:58:49'),
('b5bfcde1-17b0-4325-9190-b039990856da','57d57121-800a-49b2-a261-9648d5f64d57','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','2026-06-04 09:15:41'),
('ec81269d-8058-43a1-9660-cd2ef1dafd2c','774642ed-4119-48b9-931d-63dfcbdcffaa','33e66497-159c-482b-9dec-dd2cea22548c','2026-06-14 05:22:36');
/*!40000 ALTER TABLE `follows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `likes` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `target_id` char(36) NOT NULL,
  `target_type` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `likes_user_id_target_id_target_type_unique` (`user_id`,`target_id`,`target_type`),
  KEY `likes_target_id_target_type_index` (`target_id`,`target_type`),
  CONSTRAINT `likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` VALUES
('0bf22b58-29f3-4d34-a473-a2bb3a9f31c6','fe811823-f15f-4720-8ca1-4dc8c361fc5d','02c33a66-2d6a-4e1b-8530-646a72b048c4','post','2026-06-14 11:02:29'),
('1888d32c-2a95-4743-a7ca-611805ab2ac4','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','05dd4a0c-4a92-4118-be2f-b0e826b80b98','comment','2026-06-14 11:22:41'),
('345f226f-0f27-4205-b306-552d831b0317','774642ed-4119-48b9-931d-63dfcbdcffaa','9101338f-c2af-47d4-b683-a3a10791397b','comment','2026-06-14 10:51:08'),
('71f8541d-d93b-4f41-b0ab-b1ad9564102d','57d57121-800a-49b2-a261-9648d5f64d57','8c4a0dc2-92e3-4987-bd28-e741a65d73a6','comment','2026-06-04 09:15:32'),
('c181c369-2671-443b-b5d6-c7d5dcf85af2','fe811823-f15f-4720-8ca1-4dc8c361fc5d','86db0afe-897f-4141-8edc-fda291169197','comment','2026-06-13 00:11:47'),
('c4ddd9fa-d284-46e6-b979-9110b3e8bc91','774642ed-4119-48b9-931d-63dfcbdcffaa','aa0dfcee-8ae7-4a23-b3b6-bf1157eb46f0','comment','2026-06-14 10:51:07'),
('d305f390-a581-4b1f-b60b-34b148c27179','210c02c2-19eb-4f48-b5b1-1c8396dab783','ec211521-33e3-496f-890e-2534d53e9eed','post','2026-06-11 08:58:54'),
('f89e7523-5b07-46e2-994b-c8c428e176af','57d57121-800a-49b2-a261-9648d5f64d57','ec211521-33e3-496f-890e-2534d53e9eed','post','2026-06-04 09:15:32');
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES
(1,'0001_01_01_000000_create_users_table',1),
(2,'0001_01_01_000001_create_cache_table',1),
(3,'0001_01_01_000002_create_jobs_table',1),
(4,'2026_06_03_123509_create_personal_access_tokens_table',1),
(5,'2026_06_03_130100_create_roles_table',1),
(6,'2026_06_03_130200_create_categories_table',1),
(7,'2026_06_03_130300_create_tags_table',1),
(8,'2026_06_03_130400_create_posts_table',1),
(9,'2026_06_03_130500_create_post_tags_table',1),
(10,'2026_06_03_130600_create_comments_table',1),
(11,'2026_06_03_130700_create_user_roles_table',1),
(12,'2026_06_03_130800_create_votes_table',1),
(13,'2026_06_03_130900_create_likes_table',1),
(14,'2026_06_03_131000_create_follows_table',1),
(15,'2026_06_03_131100_create_points_log_table',1),
(16,'2026_06_03_131200_create_notifications_table',1),
(17,'2026_06_03_131300_create_reports_table',1),
(18,'2026_06_03_131400_create_bookmarks_table',1),
(19,'2026_06_03_131500_create_post_edit_history_table',1),
(20,'2026_06_03_131600_create_comment_edit_history_table',1),
(21,'2026_06_13_000000_create_shadow_bans_table',2),
(22,'2026_06_13_010000_create_moderation_logs_table',3),
(23,'2026_06_13_020000_add_status_to_comments_table',4),
(24,'2026_06_13_030000_add_comment_id_to_moderation_logs_table',5),
(25,'2026_06_14_060800_create_page_views_table',6);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `moderation_logs`
--

DROP TABLE IF EXISTS `moderation_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `moderation_logs` (
  `id` char(36) NOT NULL,
  `post_id` char(36) DEFAULT NULL,
  `comment_id` char(36) DEFAULT NULL,
  `moderator_id` char(36) NOT NULL,
  `action` varchar(20) NOT NULL,
  `reason` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `moderation_logs_moderator_id_foreign` (`moderator_id`),
  KEY `moderation_logs_post_id_index` (`post_id`),
  KEY `moderation_logs_action_index` (`action`),
  KEY `moderation_logs_comment_id_index` (`comment_id`),
  CONSTRAINT `moderation_logs_comment_id_foreign` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `moderation_logs_moderator_id_foreign` FOREIGN KEY (`moderator_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `moderation_logs_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `moderation_logs`
--

LOCK TABLES `moderation_logs` WRITE;
/*!40000 ALTER TABLE `moderation_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `moderation_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `type` varchar(255) NOT NULL,
  `notifiable_type` varchar(255) NOT NULL,
  `notifiable_id` char(36) NOT NULL,
  `data` text NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page_views`
--

DROP TABLE IF EXISTS `page_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `page_views` (
  `id` char(36) NOT NULL,
  `session_id` varchar(100) NOT NULL,
  `url` varchar(500) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `referer` varchar(500) DEFAULT NULL,
  `visited_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `page_views_visited_at_index` (`visited_at`),
  KEY `page_views_session_id_index` (`session_id`),
  KEY `page_views_user_id_index` (`user_id`),
  CONSTRAINT `page_views_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_views`
--

LOCK TABLES `page_views` WRITE;
/*!40000 ALTER TABLE `page_views` DISABLE KEYS */;
INSERT INTO `page_views` VALUES
('01e3bc89-f8e5-40f5-9d41-cfc93cdc9ea3','131b31c0-4548-4cb6-bd11-43e939a6819c','/notifications','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','104.23.175.135','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:24:25'),
('0369d641-02d9-4098-89c9-9067a68e0f13','8f0eb624-f697-43c4-8aa1-dc14e88e45f5','/profile','c5b020c2-0a38-426c-9a7c-662d7f35bcb0','172.70.93.110','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 04:22:28'),
('0774689d-30f7-4102-90f3-76e06fa7330b','b157eab2-a508-422a-bb22-b7223e4a03c9','/',NULL,'172.70.208.96','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-13 23:18:31'),
('0937ec70-b472-4992-adba-24a068459cd3','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/settings','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','162.158.170.177','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 04:09:34'),
('0ba03618-a79d-40b9-8ee1-10bebb25b0b7','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/',NULL,'172.70.143.200','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 03:52:33'),
('0bdd3d6e-b425-4449-9e95-e00b263389df','b157eab2-a508-422a-bb22-b7223e4a03c9','/','33e66497-159c-482b-9dec-dd2cea22548c','172.71.124.226','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-13 23:26:39'),
('0bea8669-5969-40c4-85c4-9edaad184edb','131b31c0-4548-4cb6-bd11-43e939a6819c','/search','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','172.70.143.200','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:24:10'),
('11c560c2-b6a9-443a-91ab-7a42df70ea6c','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/settings','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','162.158.170.176','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 04:10:31'),
('1746f323-6182-482c-8771-73957c3463a1','8c48749a-faae-40c9-88ca-9d358317e4c5','/','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:52:17'),
('1816810d-a358-4b36-a937-0387eb74ed3b','ab53783d-779f-44d8-bd1f-892ac4e8c269','/',NULL,'162.158.107.21','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:12:06'),
('18dbc00f-3999-48ce-8e6c-3a9166cd978f','1de3ce4d-173d-437c-b203-c1cd856f3f03','/bookmarks','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.70.143.200','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:41:48'),
('1b8c7e7c-0921-46cb-b59b-84834b453b4a','8c48749a-faae-40c9-88ca-9d358317e4c5','/posts/create','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:58:09'),
('1e887acd-4a77-4368-8483-a0d1e326507d','5e93a900-8586-4c43-bd52-c9427cd7f798','/',NULL,'172.68.164.110','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:54:00'),
('1ec22287-043f-4e2b-984b-b4bb38582375','1de3ce4d-173d-437c-b203-c1cd856f3f03','/profile','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.71.124.241','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:41:50'),
('231c2a7c-eb90-4692-aec7-5d61d13c256c','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/search',NULL,'172.70.143.200','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 03:52:33'),
('2350ade7-c159-4176-b81c-ffc6eaebfc4e','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/posts/ec211521-33e3-496f-890e-2534d53e9eed','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:53:21'),
('2392244d-b49c-45c3-8b53-d50ed01c2833','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/search','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:53:07'),
('2421cd02-0045-4137-8736-0b22202593c4','14e10509-c3e9-4613-ba46-de47695e8156','/',NULL,'172.70.143.200','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 03:50:30'),
('24cbdd5a-b71d-4295-84f6-3089d96d5596','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/notifications','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:52:18'),
('24df2b0a-662f-49d3-893d-e5e53501f720','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/posts/02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'172.70.143.200','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 03:52:35'),
('28d34917-e88f-4409-bac7-7a4bf490bfdf','1de3ce4d-173d-437c-b203-c1cd856f3f03','/notifications','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.70.143.200','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:41:46'),
('2bedf50b-74cb-46ec-8ce9-87a558af5ad1','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','162.158.170.176','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 04:14:27'),
('2f6e31e1-f230-4b66-8de2-06ca2fa12b13','8c48749a-faae-40c9-88ca-9d358317e4c5','/posts/eaf84ea9-a074-43d1-b2de-b3571bb902df','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.97','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:58:13'),
('31eb13c2-bf39-407e-b213-7fb138b03675','8c48749a-faae-40c9-88ca-9d358317e4c5','/about','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:52:52'),
('3347ffe6-4208-4fc6-8296-dff95cbc2187','8c48749a-faae-40c9-88ca-9d358317e4c5','/posts/02c33a66-2d6a-4e1b-8530-646a72b048c4','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:49:47'),
('33ae91e4-2a20-4e5d-af93-ecc675afb189','131b31c0-4548-4cb6-bd11-43e939a6819c','/trending','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','104.23.175.135','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:26:08'),
('36a67e48-f6f9-4226-af74-03b1ff41f47d','2fac9f28-ee52-4444-ad69-a81140108a7f','/',NULL,'162.158.189.102','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 03:48:23'),
('36b645d1-60fb-4778-add3-b9aa7b04454b','8c48749a-faae-40c9-88ca-9d358317e4c5','/bookmarks','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:52:44'),
('3c89bc79-15af-41b8-843c-1a6754cc9ce4','915b6623-3215-4463-8968-53640a635377','/posts/02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'162.158.107.21','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:12:01'),
('3e968b44-9079-4b6a-8f05-ec8a68432393','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/bookmarks','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:52:20'),
('3f43aa41-ad04-44db-bd09-3330173fe3d6','14e10509-c3e9-4613-ba46-de47695e8156','/',NULL,'172.70.143.200','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 03:49:55'),
('41fa14d3-a0f7-4e25-8546-80c32d666026','250c9fcc-ac38-47c1-9a22-7d820bcaebda','/',NULL,'172.68.164.111','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:12:24'),
('4469709a-c421-49b0-9a86-3f2da1df72c8','8c48749a-faae-40c9-88ca-9d358317e4c5','/','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:54:20'),
('45d96dd2-9c81-4231-978d-ce5a2afff8ec','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','162.158.170.177','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 04:13:15'),
('46f00028-3b27-476f-93aa-42091c7f9776','8c48749a-faae-40c9-88ca-9d358317e4c5','/','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:52:55'),
('490ce23a-dffa-4b25-9d0f-74e52e48ca05','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/','c5b020c2-0a38-426c-9a7c-662d7f35bcb0','162.158.163.228','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:51:12'),
('4c1dea68-5707-4720-a280-3d9cc27d199a','337e017f-6457-4ef4-97c8-46a44495623e','/posts/02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'162.158.107.21','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:09:02'),
('4ce87985-45c1-4887-848a-a679dff0d3c1','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:53:38'),
('4df321a7-80f5-4d80-b681-1d3ca4d947ef','1de3ce4d-173d-437c-b203-c1cd856f3f03','/terms/user-agreement','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.71.124.241','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:42:55'),
('517e9c03-5082-42db-9498-1c32045c2a8f','131b31c0-4548-4cb6-bd11-43e939a6819c','/help','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','104.23.175.135','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:27:21'),
('52d57a97-8c2f-4884-9538-3e63f6662760','1de3ce4d-173d-437c-b203-c1cd856f3f03','/report-bug','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.71.124.241','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:42:48'),
('547f8dae-168b-4373-a7aa-5ea0985f6eea','131b31c0-4548-4cb6-bd11-43e939a6819c','/','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','172.70.208.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:22:50'),
('573965a0-5024-4f2e-9460-2fba8400ec37','a955878e-2183-4a62-b033-65c3ccbb9a12','/',NULL,'162.158.190.31','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:07:05'),
('5899c70d-0c9b-44a3-98cd-50571397a712','b157eab2-a508-422a-bb22-b7223e4a03c9','/admin/dashboard','33e66497-159c-482b-9dec-dd2cea22548c','172.71.124.240','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-13 23:26:43'),
('5abb6e1b-2ba4-4668-be39-445dd1f8570a','8c48749a-faae-40c9-88ca-9d358317e4c5','/','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.97','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:51:25'),
('609a4ddd-ba35-4cf6-9a5a-e3581fc7ebcb','13228238-d7a7-4113-b14d-84b2ca79c3dd','/',NULL,'162.158.190.31','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:02:34'),
('619a69db-c39d-4c78-905a-f86aedc7e230','131b31c0-4548-4cb6-bd11-43e939a6819c','/help','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','104.23.175.135','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:26:53'),
('620f5545-c872-43cf-8d59-e8ab52d009d1','8f0eb624-f697-43c4-8aa1-dc14e88e45f5','/','c5b020c2-0a38-426c-9a7c-662d7f35bcb0','172.70.93.111','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 04:21:18'),
('671004d3-a6a5-4245-abf0-a38af1840d64','131b31c0-4548-4cb6-bd11-43e939a6819c','/bookmarks','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','172.70.208.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:24:35'),
('6906f8aa-7b6e-444e-820e-0526093ba0c5','250c9fcc-ac38-47c1-9a22-7d820bcaebda','/posts/02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'172.68.164.111','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:12:25'),
('6bc8e516-a1b6-46cf-b27f-86ec6b3051ab','test-sesi-123','/',NULL,'192.168.144.1','curl/7.88.1',NULL,'2026-06-13 23:14:28'),
('6bf36c03-ca98-49ab-852b-7dc59f778c0b','131b31c0-4548-4cb6-bd11-43e939a6819c','/notifications','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','104.23.175.135','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:23:58'),
('6c35991e-93d9-4842-82bd-14a6fff7e7b2','8c48749a-faae-40c9-88ca-9d358317e4c5','/profile','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:52:47'),
('6c7616f3-c7ed-4b2f-8a41-b19348324fc7','915b6623-3215-4463-8968-53640a635377','/',NULL,'172.68.164.111','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:11:49'),
('713ba716-4961-42f4-8d3c-3dc53ffd1426','60e4f7d4-b971-4522-b710-64bbd01a1780','/',NULL,'162.158.107.21','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:13:26'),
('743d8067-afec-4941-85a1-7b7798e6d87d','1de3ce4d-173d-437c-b203-c1cd856f3f03','/terms/aksatax-rule','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.71.124.241','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:42:50'),
('74eb06b2-ab97-4d0b-95b8-fcbc15194f43','3d53bcd7-3418-427a-aefa-c61c01693fb5','/',NULL,'172.71.124.241','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 03:49:02'),
('76c76645-d7a3-40e1-86c2-bece7d6977d7','2259a1f4-24e7-469a-ba66-3f5c01284540','/posts/02c33a66-2d6a-4e1b-8530-646a72b048c4','fe811823-f15f-4720-8ca1-4dc8c361fc5d','162.158.170.177','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:10:29'),
('76febf87-c30a-4081-a1cf-f111d1fce4d6','2259a1f4-24e7-469a-ba66-3f5c01284540','/posts/02c33a66-2d6a-4e1b-8530-646a72b048c4','fe811823-f15f-4720-8ca1-4dc8c361fc5d','162.158.170.176','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:10:04'),
('7b950b01-a073-4615-830b-ed1b069172c7','131b31c0-4548-4cb6-bd11-43e939a6819c','/topics','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','172.70.143.200','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:26:22'),
('7dc9052f-ab0d-49a1-9b82-d54457df825a','ab53783d-779f-44d8-bd1f-892ac4e8c269','/posts/02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'162.158.107.21','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:12:08'),
('801b832a-e763-4a2d-81eb-f6983dd7c2d8','8c48749a-faae-40c9-88ca-9d358317e4c5','/posts/eaf84ea9-a074-43d1-b2de-b3571bb902df','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.97','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:54:16'),
('80a7dec8-bdf7-4b41-98b1-da09084ed8ae','131b31c0-4548-4cb6-bd11-43e939a6819c','/posts/02c33a66-2d6a-4e1b-8530-646a72b048c4','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','172.70.143.200','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:22:04'),
('84cf98cd-a890-45ca-b9b5-97e14b7f9d5d','3d53bcd7-3418-427a-aefa-c61c01693fb5','/posts/02c33a66-2d6a-4e1b-8530-646a72b048c4','fe811823-f15f-4720-8ca1-4dc8c361fc5d','104.23.175.134','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 03:50:34'),
('8514fa2a-c745-442f-9c8f-152b57391235','8c48749a-faae-40c9-88ca-9d358317e4c5','/','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:46:21'),
('86f79e79-4b9f-43ba-bca5-bc3c0bf5405e','b51b232b-42a9-4436-b193-e732a86bc0a1','/',NULL,'172.68.164.111','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:05:06'),
('8a7052e5-033b-48f9-aa23-c45de06064c8','9da67956-266a-4e49-9aba-4ff2dbcf8eda','/',NULL,'162.158.190.31','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:01:28'),
('8b6a517d-8904-4499-9813-d9313f692373','fc71eda5-5543-47c3-8f46-2e54e8b4ebec','/posts/create','774642ed-4119-48b9-931d-63dfcbdcffaa','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 04:20:49'),
('907166cb-1366-43ee-a92f-8da5a7460f83','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/notifications','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:53:09'),
('90eb0e34-e0a6-4fda-8424-a4c205b6298a','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/user/tester','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:53:17'),
('92b83590-5d9a-4702-9cd9-f1d5a76acaa7','337e017f-6457-4ef4-97c8-46a44495623e','/',NULL,'172.68.164.111','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:08:56'),
('953257e1-b6c5-494e-8c0c-b8aab5617452','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/',NULL,'172.70.143.200','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 03:51:17'),
('985c1707-6391-4b84-a8fb-22c4fcbeec05','8c48749a-faae-40c9-88ca-9d358317e4c5','/posts/create','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:43:08'),
('9a3c304e-627f-46fe-a9ef-16e6adcf8e5f','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/posts/create','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','162.158.170.176','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 04:14:34'),
('9b426f48-d769-465c-a378-ab8a0f40e5cf','55bbc584-12b0-4af9-9c7e-8e954371636c','/posts/create','fe811823-f15f-4720-8ca1-4dc8c361fc5d','172.70.143.201','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 03:33:41'),
('9bd70cec-0f70-493f-8db3-0e4c21a0d778','8f0eb624-f697-43c4-8aa1-dc14e88e45f5','/posts/create','c5b020c2-0a38-426c-9a7c-662d7f35bcb0','172.70.93.110','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 04:21:23'),
('9dacaf6d-3087-4f84-8862-8d62670e3934','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/search','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:52:16'),
('9f9fa8a3-3a23-4d71-8d65-2717d37d9be1','1de3ce4d-173d-437c-b203-c1cd856f3f03','/about','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.71.124.241','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:42:33'),
('a12a5151-b4c3-4fd8-8631-a670f105426a','131b31c0-4548-4cb6-bd11-43e939a6819c','/profile','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','172.70.208.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:24:45'),
('a1a03954-b643-4c4e-b4d5-ebe74d0c75fb','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/',NULL,'172.70.143.200','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 03:53:19'),
('a54bda96-8e06-4edf-8c64-d2aa1881198e','8c48749a-faae-40c9-88ca-9d358317e4c5','/user/user','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:52:08'),
('a582b8a6-9ab0-45dd-b822-9e9ea5c70a5b','3aea7148-be01-4c82-9a32-5a7aad0ea6c4','/','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','172.69.176.55','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 04:30:14'),
('a5978440-599a-4402-b888-a31156c4e8f9','1de3ce4d-173d-437c-b203-c1cd856f3f03','/settings','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.71.124.241','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:41:55'),
('a5eaa353-b97b-4c5e-9c73-f39589c196bc','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/admin/dashboard','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:52:44'),
('a66fe2d2-2675-4d59-9d2b-b369dbe3ad40','131b31c0-4548-4cb6-bd11-43e939a6819c','/about','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','104.23.175.135','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:26:39'),
('a6b909b2-d1a5-4991-8b0f-f15e4aa8531c','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/bookmarks','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:53:11'),
('a81375a6-84dc-4816-989a-c9ad7c12c212','8c48749a-faae-40c9-88ca-9d358317e4c5','/help','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:52:53'),
('ac6486de-37ab-49e0-9722-6ff8303b58ec','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:52:13'),
('ac9a6213-01b2-4eb5-9c82-fc8d1e34a1c0','8c48749a-faae-40c9-88ca-9d358317e4c5','/','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:46:47'),
('b0587f1e-aa57-4407-9ced-7a2b64bd6358','fc71eda5-5543-47c3-8f46-2e54e8b4ebec','/posts/create','774642ed-4119-48b9-931d-63dfcbdcffaa','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 04:20:52'),
('b310247c-95da-4059-9154-6fb8f1b8c370','771c9eed-4b4a-4e69-be7c-60f916afe58d','/','c5b020c2-0a38-426c-9a7c-662d7f35bcb0','162.158.163.228','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:51:12'),
('b4cc7abd-92e1-41ec-bd27-5cee390e6270','de68c800-6587-4504-b025-3b6693577fbe','/',NULL,'162.158.170.176','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:08:21'),
('b5b8ccd4-6284-4fc4-9e7d-cb8899609b4e','2259a1f4-24e7-469a-ba66-3f5c01284540','/posts/02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'162.158.170.177','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:09:31'),
('b5ee7af3-a046-4b6e-b2f6-fbf23ec8a594','131b31c0-4548-4cb6-bd11-43e939a6819c','/report-bug','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','104.23.175.135','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:27:17'),
('be4670b8-fc5b-4238-a893-5a7cb148dd28','fc71eda5-5543-47c3-8f46-2e54e8b4ebec','/','774642ed-4119-48b9-931d-63dfcbdcffaa','172.70.208.97','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 04:32:52'),
('bebea300-7dbc-4a89-91b9-490c68a4706a','2259a1f4-24e7-469a-ba66-3f5c01284540','/',NULL,'162.158.107.21','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:09:28'),
('c12f65cb-5f03-40a3-a898-b3c409289421','2f2a56fd-812b-4643-bc07-1369fd80ada4','/',NULL,'172.68.164.111','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:03:46'),
('c5209282-033d-4510-8d8c-1522bd148230','2a057743-1ffc-44a9-8a34-d6f259b93c94','/',NULL,'162.158.170.176','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:10:45'),
('c5599627-590c-4164-ac57-fc8ce87b24e2','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/settings','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','162.158.170.176','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 04:09:56'),
('c9f29ffb-4aa8-43de-b782-65d4eb654371','2a057743-1ffc-44a9-8a34-d6f259b93c94','/posts/02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'162.158.170.177','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:10:47'),
('cc011a8b-537a-4f2d-b758-fa69c3275114','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/','33e66497-159c-482b-9dec-dd2cea22548c','172.70.93.110','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 04:17:54'),
('cd1ccc20-7e10-4830-a6a6-8c2150ed2923','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','162.158.170.176','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 04:09:28'),
('ce2ac0f9-17d4-4a03-93ee-c1a55ce3b8d5','8c48749a-faae-40c9-88ca-9d358317e4c5','/','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:39:39'),
('cf28a3ae-9a87-46a2-bb33-a6cecbc77db4','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:53:06'),
('cf4b6b3c-baa1-46dc-b0fb-e7cacbe7841c','131b31c0-4548-4cb6-bd11-43e939a6819c','/terms/aksatax-rule','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','104.23.175.135','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:27:30'),
('d29f9564-738f-46d9-ba39-e1e016591c9e','fc71eda5-5543-47c3-8f46-2e54e8b4ebec','/','774642ed-4119-48b9-931d-63dfcbdcffaa','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 04:20:46'),
('d2c87a1f-96c0-41a8-b0af-6489274e87f8','f843d3cb-f009-45be-b94c-4f7d0f5ec4bc','/',NULL,'162.158.170.176','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:01:58'),
('d5149997-1403-47fc-9c06-f312b186acdd','1de3ce4d-173d-437c-b203-c1cd856f3f03','/','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.70.143.200','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:42:58'),
('d5d6e119-8605-4815-8346-b00281bb1921','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/admin/dashboard','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:53:01'),
('d64b81d1-99b4-43df-a988-a5e5f21fa876','55bbc584-12b0-4af9-9c7e-8e954371636c','/',NULL,'172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 03:31:07'),
('d7a9b372-f7b5-4ab3-8c62-0957f629bf42','2259a1f4-24e7-469a-ba66-3f5c01284540','/','fe811823-f15f-4720-8ca1-4dc8c361fc5d','162.158.107.21','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:10:25'),
('d9a98af6-2f44-4f0a-82d7-16d9f03632e3','1de3ce4d-173d-437c-b203-c1cd856f3f03','/topics','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.70.208.97','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:42:30'),
('df420997-43bd-4194-92a8-366cdd0170ea','99a30563-3865-4258-ae5f-affdec88aa41','/',NULL,'172.70.143.201','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 03:30:40'),
('df4bcd86-b476-4ce2-a1f8-eb95f75c0fab','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/',NULL,'172.70.93.111','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 04:17:41'),
('dfe5ac92-64dc-4ac9-970c-7b9c0f97bdce','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/profile','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:52:24'),
('e00aabf5-f981-45b7-b52b-ad87f5434cab','1de3ce4d-173d-437c-b203-c1cd856f3f03','/help','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.71.124.241','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:42:36'),
('e2df40b5-e8f6-4682-84da-6e61e76fde88','131b31c0-4548-4cb6-bd11-43e939a6819c','/settings','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','172.70.208.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:24:59'),
('e5bc5c49-fec0-451d-a257-725afd18385e','1de3ce4d-173d-437c-b203-c1cd856f3f03','/search','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.70.143.200','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:41:23'),
('e8952e56-73f9-4ea9-9285-9424af155f3b','61d9693c-9c99-40e5-bffb-ff41d5e1b076','/posts/create','fe811823-f15f-4720-8ca1-4dc8c361fc5d','172.68.164.110','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','http://localhost:3000/','2026-06-14 03:35:04'),
('eaf5ec12-b1a6-41bb-b247-f80faef8364b','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/profile','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','162.158.170.176','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 04:09:54'),
('ebf36058-b889-4b37-a535-bd0d49efa4f6','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/posts/create','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','162.158.170.177','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 04:13:31'),
('ec35af7e-8a34-4c06-8c59-914bc7dd6273','8c48749a-faae-40c9-88ca-9d358317e4c5','/profile','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:46:42'),
('ec50f523-b248-49b9-b4aa-4c0fecffdab5','1de3ce4d-173d-437c-b203-c1cd856f3f03','/trending','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.70.143.200','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:42:26'),
('edd1e714-156b-48dd-8ad2-6abdc6c211ec','1a6c3193-04a4-45c7-bae6-4f333d474a17','/',NULL,'172.70.143.201','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 03:39:45'),
('f105f53a-e62d-4b5d-bd8d-d352ca3f0488','131b31c0-4548-4cb6-bd11-43e939a6819c','/terms/user-agreement','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','104.23.175.135','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:28:00'),
('f17b3fe7-4fe3-45a4-9aa4-12791529b602','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:53:11'),
('f17d944d-43d8-4126-8ffb-86def9c8fb15','8c48749a-faae-40c9-88ca-9d358317e4c5','/search','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.97','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:52:19'),
('f815f002-ef47-4a35-a9a0-df46213bd46d','131b31c0-4548-4cb6-bd11-43e939a6819c','/terms/privacy-policy','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','104.23.175.135','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:27:46'),
('f931fe79-8afb-420c-a1d7-9912d7ee7283','8c48749a-faae-40c9-88ca-9d358317e4c5','/notifications','774642ed-4119-48b9-931d-63dfcbdcffaa','162.158.88.96','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0','https://aksatax.busines.biz.id/','2026-06-14 03:52:36'),
('fad6feed-38e1-4a3c-9a12-d0cfa25b4ed3','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/posts/ec211521-33e3-496f-890e-2534d53e9eed','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:53:16'),
('fb1d0e2b-0ccd-497c-b611-32cd18dc7c2b','8a701184-b5a7-40b2-9ebe-4293e52a9df5','/posts/create','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','162.158.170.177','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','https://aksatax.busines.biz.id/search','2026-06-14 04:13:14'),
('fe35870b-cc21-4a67-a567-2f97304963f9','595ac316-a4a4-4d41-801a-7914a7278635','/',NULL,'172.68.164.111','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:11:21'),
('ff380d1e-482b-46b3-941e-b718e8dfc391','66c33a3a-f6e9-4a1a-86ca-42b5ae23bfa8','/','33e66497-159c-482b-9dec-dd2cea22548c','172.69.176.55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0',NULL,'2026-06-14 03:53:10'),
('ff570382-147c-4a83-860d-6372e357ef9f','1de3ce4d-173d-437c-b203-c1cd856f3f03','/terms/privacy-policy','863214f7-c9a5-49ef-ab5f-6249baa2eea6','172.71.124.241','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Cypress/15.17.0 Chrome/138.0.7204.251 Electron/37.6.0 Safari/537.36',NULL,'2026-06-14 04:42:53');
/*!40000 ALTER TABLE `page_views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` char(36) NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES
(1,'App\\Models\\User','33e66497-159c-482b-9dec-dd2cea22548c','auth-token','09eb5c07299b1080f6a45c41ad07039c79ea10b0ed84d92da2fc948d3bbb93a3','[\"*\"]',NULL,NULL,'2026-06-03 20:40:43','2026-06-03 20:40:43'),
(2,'App\\Models\\User','33e66497-159c-482b-9dec-dd2cea22548c','auth-token','5993374ccc6550d10f4c55907fb1044935700470643c6b62751450b433e4b61f','[\"*\"]',NULL,NULL,'2026-06-03 20:55:24','2026-06-03 20:55:24'),
(3,'App\\Models\\User','33e66497-159c-482b-9dec-dd2cea22548c','auth-token','a3ea1ff6f39cbae1de40ad6eb2d5fab18f35ed1d888887df5db3b3170eebb6c3','[\"*\"]','2026-06-03 20:55:25',NULL,'2026-06-03 20:55:24','2026-06-03 20:55:25'),
(4,'App\\Models\\User','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','auth-token','93a5f4ce6766d2b61defc4b933788041d9c02b0ff70629576900b1a90aef1814','[\"*\"]','2026-06-03 20:56:02',NULL,'2026-06-03 20:56:02','2026-06-03 20:56:02'),
(5,'App\\Models\\User','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','auth-token','fac254993478ae4e625d9c0aec050541ee375df46907037122a0dc2b36668ab3','[\"*\"]','2026-06-03 20:56:23',NULL,'2026-06-03 20:56:23','2026-06-03 20:56:23'),
(6,'App\\Models\\User','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','auth-token','14ef15d2390165635699aa2e960830b19adadd242fc79bd02ddb0e68c3b1b79e','[\"*\"]','2026-06-03 20:56:50',NULL,'2026-06-03 20:56:50','2026-06-03 20:56:50'),
(7,'App\\Models\\User','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','auth-token','959a34ca814c8608a3725c2321f0185f6d880c206fc7eee2ebf5820175835990','[\"*\"]','2026-06-03 20:57:07',NULL,'2026-06-03 20:57:07','2026-06-03 20:57:07'),
(8,'App\\Models\\User','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','auth-token','08ca4bb7d4fd9b698fa4d9b640c40d40eecc6390b0c1e91f658d36e22296d1ea','[\"*\"]','2026-06-03 20:58:04',NULL,'2026-06-03 20:58:04','2026-06-03 20:58:04'),
(9,'App\\Models\\User','33e66497-159c-482b-9dec-dd2cea22548c','auth-token','ed06f90499ae07858c04f1d5aafda6d2db667d3448400e7618afe36a8d31a118','[\"*\"]',NULL,NULL,'2026-06-03 20:58:04','2026-06-03 20:58:04'),
(10,'App\\Models\\User','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','auth-token','967da2da4919d0ec42215cd7082665a2a35dc0fbc1f0a1a819bcf3e07e3f6547','[\"*\"]','2026-06-03 20:58:24',NULL,'2026-06-03 20:58:24','2026-06-03 20:58:24'),
(11,'App\\Models\\User','efa3bcce-4f17-440b-92bc-4dad6457f054','auth-token','1c7344f77f82bd949a8c6f581aa7015e01e9b7c6a929bd093f32fbe93afbe160','[\"*\"]',NULL,NULL,'2026-06-03 21:33:59','2026-06-03 21:33:59'),
(12,'App\\Models\\User','33e66497-159c-482b-9dec-dd2cea22548c','auth-token','1d9316ea55baa008955ca5aadc13a90f7fcb300c3dc01ab86c03d427905cef0e','[\"*\"]',NULL,NULL,'2026-06-03 23:26:12','2026-06-03 23:26:12'),
(13,'App\\Models\\User','33e66497-159c-482b-9dec-dd2cea22548c','auth-token','94f13d1456e618461914d230ba41cf6b32ae6879af179b64b68ac833d977e930','[\"*\"]','2026-06-03 23:48:27',NULL,'2026-06-03 23:48:02','2026-06-03 23:48:27'),
(14,'App\\Models\\User','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','auth-token','325b0cb03ccf02e5bd2d4e3901d18ba1f5f9e991ff78f604fa3a95520f3f1acb','[\"*\"]','2026-06-03 23:48:21',NULL,'2026-06-03 23:48:16','2026-06-03 23:48:21'),
(15,'App\\Models\\User','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','test','6a2eab760cf1f7f0cb7ab1355daa1f711264542e16c977e3091c3ec8ed72196d','[\"*\"]','2026-06-04 02:11:36',NULL,'2026-06-04 02:10:33','2026-06-04 02:11:36'),
(19,'App\\Models\\User','57d57121-800a-49b2-a261-9648d5f64d57','auth-token','a2a82098a5f2544c590da8e232b3d22c51fa0fe411c51d2d05f42dda116fef5f','[\"*\"]',NULL,NULL,'2026-06-04 02:15:21','2026-06-04 02:15:21'),
(20,'App\\Models\\User','57d57121-800a-49b2-a261-9648d5f64d57','auth-token','6eda707753568e4f2c6144d63701e23aedf190758ce6f70451d7424381702fd7','[\"*\"]','2026-06-04 02:15:52',NULL,'2026-06-04 02:15:52','2026-06-04 02:15:52'),
(21,'App\\Models\\User','1cec8710-b813-4040-b742-5c60a6b4f739','auth-token','0d325dc9fedef161ce96cdfd9b0afa74f0ca04a10ba4689fcff8ebc4ee4e22ca','[\"*\"]',NULL,NULL,'2026-06-04 02:31:26','2026-06-04 02:31:26'),
(22,'App\\Models\\User','be77a066-904e-49ef-b4f4-2b8b88d9f8ff','auth-token','cf7f73cf0862bcc0cfd5094b99c3cf3b71c8b0edd3b51e0c408d0dbbde56152a','[\"*\"]',NULL,NULL,'2026-06-04 02:32:06','2026-06-04 02:32:06'),
(23,'App\\Models\\User','be77a066-904e-49ef-b4f4-2b8b88d9f8ff','auth-token','19e9e95cb67ba29acb52a04ebc1d7b4e5f19f0b3138c3c8accbe23b7dc2a9783','[\"*\"]',NULL,NULL,'2026-06-04 02:32:13','2026-06-04 02:32:13'),
(24,'App\\Models\\User','1cec8710-b813-4040-b742-5c60a6b4f739','auth-token','75a724cc1530f1ce289178293a340045603f4c4300b749741e76df130ccb73f2','[\"*\"]',NULL,NULL,'2026-06-04 02:32:54','2026-06-04 02:32:54'),
(25,'App\\Models\\User','1cec8710-b813-4040-b742-5c60a6b4f739','auth-token','0c3ffa38747587869f3215a4817d9edf67564aebed405fb803d0da6a99d04d71','[\"*\"]',NULL,NULL,'2026-06-04 02:51:28','2026-06-04 02:51:28'),
(26,'App\\Models\\User','1cec8710-b813-4040-b742-5c60a6b4f739','auth-token','095a147004619ac332af558b7e8064ee11a60343ead4d199d22c6dfa90559850','[\"*\"]',NULL,NULL,'2026-06-04 18:52:15','2026-06-04 18:52:15'),
(27,'App\\Models\\User','1cec8710-b813-4040-b742-5c60a6b4f739','auth-token','e6858fd946df14f051660c7417f21448bdb53ac9c35b85c72c9c9733bf027651','[\"*\"]',NULL,NULL,'2026-06-05 06:45:01','2026-06-05 06:45:01'),
(28,'App\\Models\\User','1cec8710-b813-4040-b742-5c60a6b4f739','auth-token','6597c168dc50ebfef02f70ae67797b2a63764c6e10b40d1d88d81b3a4d2f2338','[\"*\"]',NULL,NULL,'2026-06-05 08:59:01','2026-06-05 08:59:01'),
(29,'App\\Models\\User','1cec8710-b813-4040-b742-5c60a6b4f739','auth-token','a120ae4be029013dfae7607dcb29bfe765b8f3c20fac365ed8893223527e9b38','[\"*\"]',NULL,NULL,'2026-06-05 09:20:22','2026-06-05 09:20:22'),
(30,'App\\Models\\User','1cec8710-b813-4040-b742-5c60a6b4f739','auth-token','4c3fa52cb5bc348071322b9bcb0be87f76e65b6af3c5fa6a9d2ba8bafc33eb9a','[\"*\"]',NULL,NULL,'2026-06-06 01:59:35','2026-06-06 01:59:35'),
(31,'App\\Models\\User','1cec8710-b813-4040-b742-5c60a6b4f739','auth-token','b0e4564501053e16f0ea63db5a3ee8e0ff2ce43aeaa5b77de892b8eef99b0892','[\"*\"]',NULL,NULL,'2026-06-06 09:06:47','2026-06-06 09:06:47'),
(32,'App\\Models\\User','5be8a241-5de1-489e-8108-3e5506c36642','auth-token','660117bef03353aadae73f9d6c2baeccd97519aa9fd778e2354806c2ce246a1c','[\"*\"]',NULL,NULL,'2026-06-07 04:06:49','2026-06-07 04:06:49'),
(33,'App\\Models\\User','05c6d6c9-0450-4904-9e08-22ec3597c7de','auth-token','a8898ed49399e3d4c74e80eded9a74058dee13597b9bc3f6f6ed4cf2f9376a03','[\"*\"]',NULL,NULL,'2026-06-07 04:09:23','2026-06-07 04:09:23'),
(34,'App\\Models\\User','90ffe614-50e5-41f5-89bc-25f3814be8be','auth-token','b9a0c2905fcdf1b40efba77dce34d2ad1a1cce09a81a49fb2a54946c6ec4f931','[\"*\"]',NULL,NULL,'2026-06-07 04:18:10','2026-06-07 04:18:10'),
(37,'App\\Models\\User','89673d91-139c-4017-9fdf-2dc984d8ee64','auth-token','3f670573e7684579ed509ef0fa3b9dce198ce7058787d69bb8a9d3624d6f0414','[\"*\"]',NULL,NULL,'2026-06-07 04:24:02','2026-06-07 04:24:02'),
(40,'App\\Models\\User','50bec28e-07e2-4972-929e-1738cca5c549','auth-token','c8bc1a2756a15fbac851bc06fd6f94ca3e2ee23965bae9e5028effb1ffb2aa4e','[\"*\"]',NULL,NULL,'2026-06-07 23:17:13','2026-06-07 23:17:13'),
(43,'App\\Models\\User','c5b020c2-0a38-426c-9a7c-662d7f35bcb0','auth-token','cdde120c8159ba4fdcf2cc8ae902c33ae9bf7ee709348fd0e865ea13dc60a0ed','[\"*\"]','2026-06-12 22:56:47',NULL,'2026-06-11 03:45:16','2026-06-12 22:56:47'),
(44,'App\\Models\\User','71499012-4388-4c16-a05c-65af15850986','auth-token','40b9624c8852dd5c47b94ee38c45613dbf73ed22a84648b58e81f95312e26325','[\"*\"]',NULL,NULL,'2026-06-11 05:12:06','2026-06-11 05:12:06'),
(54,'App\\Models\\User','845d3436-2275-46bb-b4d3-7f47dbef9ea0','auth-token','b80e6bed9e8df99e9ff38414aa22d8dfed9117e68a4b0eba151ea4fc432a1dcd','[\"*\"]','2026-06-13 01:21:14',NULL,'2026-06-12 19:40:33','2026-06-13 01:21:14'),
(57,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','05c2eeb1c16c1f5391403ca05c750093e93be0add34d9b1d4d66809c9f87d4e5','[\"*\"]','2026-06-12 22:50:30',NULL,'2026-06-12 22:47:56','2026-06-12 22:50:30'),
(58,'App\\Models\\User','774642ed-4119-48b9-931d-63dfcbdcffaa','auth-token','d708938b3f5c032342ce69acba8dc6b31cc5a9954c08d25799f4599b860cabc7','[\"*\"]',NULL,NULL,'2026-06-12 22:54:40','2026-06-12 22:54:40'),
(59,'App\\Models\\User','774642ed-4119-48b9-931d-63dfcbdcffaa','auth-token','22c0fea1cb9e54e65a58d6fe991591fe121b6e21b093a788bb80c6a9f4b3e4d6','[\"*\"]','2026-06-14 04:53:32',NULL,'2026-06-12 22:54:54','2026-06-14 04:53:32'),
(64,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','867ec68b71c280557bb2c2d90633223ff3f7c2bf1c84f5a4797282ad59b4ee7e','[\"*\"]','2026-06-13 22:53:40',NULL,'2026-06-13 22:53:35','2026-06-13 22:53:40'),
(65,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','1ec0d0705809b1ed8980e7368d76fe4a68efc185440bfbdfd8e429061b4e32dd','[\"*\"]','2026-06-13 22:54:39',NULL,'2026-06-13 22:54:38','2026-06-13 22:54:39'),
(66,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','96bb0bc958a135ca506fa4fd12d3f6942168c4422783067576c4e8b321c5b2ea','[\"*\"]','2026-06-13 22:54:49',NULL,'2026-06-13 22:54:48','2026-06-13 22:54:49'),
(67,'App\\Models\\User','061463bf-9691-4598-810a-20cd9e36145b','auth-token','b365dd681703dddff7ebcfda31d9b5f96cb1766f2789d2c3a535d798bf615aa3','[\"*\"]',NULL,NULL,'2026-06-13 23:00:29','2026-06-13 23:00:29'),
(68,'App\\Models\\User','1cec8710-b813-4040-b742-5c60a6b4f739','test','fe46256a39c8824e50583dd24a54b9af252fca001a0fd8e90970bf74b4b082ba','[\"*\"]','2026-06-13 23:16:13',NULL,'2026-06-13 23:14:36','2026-06-13 23:16:13'),
(70,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','c3156f1a92bfd6e71ef4dabe5eea7542b9b82b75f929857450e5b26963dbbb5a','[\"*\"]','2026-06-13 23:35:14',NULL,'2026-06-13 23:35:12','2026-06-13 23:35:14'),
(71,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','b92ece5f9ed223f75e8374a1168bde8340171d8c3537659a0c0607745893effb','[\"*\"]',NULL,NULL,'2026-06-13 23:35:20','2026-06-13 23:35:20'),
(72,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','afacf4023db90dcd43789c4b2c2e38bbdac3ba480cc127213e870a5456a8533a','[\"*\"]','2026-06-13 23:35:29',NULL,'2026-06-13 23:35:26','2026-06-13 23:35:29'),
(73,'App\\Models\\User','1a4a8359-a3e4-46f5-963f-9ed6ce371789','auth-token','e5e0d0a369fea1452e847d4cc3ab76a66302a46903f4217c9a1647f9d88cb13a','[\"*\"]',NULL,NULL,'2026-06-13 23:37:35','2026-06-13 23:37:35'),
(74,'App\\Models\\User','553ad0fe-7eef-4ed2-9aa8-1748f80246fb','auth-token','d4cf00c7b155277757b0055407ed526060b85cd8c4784d9c465a0770075c70b7','[\"*\"]',NULL,NULL,'2026-06-13 23:39:30','2026-06-13 23:39:30'),
(75,'App\\Models\\User','74bcdd9d-3846-48e0-a46c-1b1d5aa08df1','auth-token','5b7169c536ea15a1bfd6457797dfbd6c23fce5f7f9a163ab060eaef7469a3c6c','[\"*\"]',NULL,NULL,'2026-06-13 23:42:06','2026-06-13 23:42:06'),
(76,'App\\Models\\User','f1514ca9-03cb-42c0-805f-48029de8689b','auth-token','a2860fb6a35b7133dfe3dd21166efc1e7024dacae87bfee8d6fc7defae0cc31f','[\"*\"]',NULL,NULL,'2026-06-13 23:44:46','2026-06-13 23:44:46'),
(77,'App\\Models\\User','9e8c2250-8dde-407e-8e69-cd685456312f','auth-token','1a863d957748886294344ca39f8b5e36b228f072e668b19d5368ec8f1d41b60c','[\"*\"]',NULL,NULL,'2026-06-13 23:51:56','2026-06-13 23:51:56'),
(78,'App\\Models\\User','aed20064-eabf-4f47-b1e7-bcf898c7fbe4','auth-token','d8662b2fea1e68f5ce75c75ed3cef2bf552f95b45d8163bc8dfce93225de8393','[\"*\"]',NULL,NULL,'2026-06-13 23:52:06','2026-06-13 23:52:06'),
(79,'App\\Models\\User','6b99676c-79b4-4782-af28-84db87b9b0d6','auth-token','52f712b349c04630c6ca0e45427ce4276f11769d78d350eabd65c1aea2d12fbb','[\"*\"]',NULL,NULL,'2026-06-13 23:52:44','2026-06-13 23:52:44'),
(80,'App\\Models\\User','323ab8e5-2e2e-4a19-a9a2-605e6f86ff61','auth-token','56609c9f0f8e5fca13a20eae1997ca5e8017a71fbe3c3bcb3490df1c2083451c','[\"*\"]',NULL,NULL,'2026-06-13 23:54:00','2026-06-13 23:54:00'),
(81,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','92d3c25473f2a9eaadd345f03d59d0ac09ca30e8cc78562d02405d0e5b2bf1c0','[\"*\"]','2026-06-14 04:53:32',NULL,'2026-06-13 23:55:39','2026-06-14 04:53:32'),
(82,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','673fc2c631b3c4703fcb164c03b3fb0e39ad4a7a92d1b3deff23bd594fda98dd','[\"*\"]','2026-06-13 23:56:14',NULL,'2026-06-13 23:56:13','2026-06-13 23:56:14'),
(83,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','3045df0bbd4fad2f2f9945720326faa6b2e4755b99c700a34f0b68bd24e276e5','[\"*\"]','2026-06-13 23:57:06',NULL,'2026-06-13 23:57:04','2026-06-13 23:57:06'),
(84,'App\\Models\\User','eaed0e41-0d1a-4611-979b-f6b356db11c9','auth-token','7594d9aac7bfc99502b0ebbd49cd157e12489008fbd12521b466a448a085e904','[\"*\"]',NULL,NULL,'2026-06-14 03:30:02','2026-06-14 03:30:02'),
(85,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','2382c20d37cf557de719655739393a57f0d842f878341bb2a7b6ef184751ec50','[\"*\"]','2026-06-14 03:39:17',NULL,'2026-06-14 03:31:39','2026-06-14 03:39:17'),
(86,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','09137842b8c11da1646b3092d645935ea9b117323ceb87b30c56d353156ecc11','[\"*\"]','2026-06-14 04:00:57',NULL,'2026-06-14 03:49:14','2026-06-14 04:00:57'),
(88,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','2b833ae813aa51d78478393de654b0cd0f6b912a72b457ca743d7c35f5e38bd7','[\"*\"]','2026-06-14 04:02:30',NULL,'2026-06-14 04:02:17','2026-06-14 04:02:30'),
(89,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','04515caa5dec96a823e7fb36f68b5ac91e961fd745497af27aaff6db17a33778','[\"*\"]','2026-06-14 04:07:20',NULL,'2026-06-14 04:07:19','2026-06-14 04:07:20'),
(90,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','9221555b5f1b5de4639ae8b46af1c1743993c7d8e15743d583e77cbfcb47c6a3','[\"*\"]','2026-06-14 04:07:44',NULL,'2026-06-14 04:07:42','2026-06-14 04:07:44'),
(91,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','3a60074b63aa48779092b25705db94d476818b1cefa43bfab8ce14967dd7b5fa','[\"*\"]','2026-06-14 04:08:14',NULL,'2026-06-14 04:08:11','2026-06-14 04:08:14'),
(92,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','0237d57ca5d8017742f337749a0b4bc4c62901b83706a671bdd5feb851b98766','[\"*\"]','2026-06-14 04:08:27',NULL,'2026-06-14 04:08:23','2026-06-14 04:08:27'),
(93,'App\\Models\\User','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','auth-token','99ee7cac7d4eed98468b3c36cd2fbd762d00a931a9ff76852287c0a3c9dda419','[\"*\"]','2026-06-14 04:30:41',NULL,'2026-06-14 04:09:26','2026-06-14 04:30:41'),
(94,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','dba86b56496c117e7388b10518e427774f3aa00fa122f54eeeafe937eec17c18','[\"*\"]','2026-06-14 04:10:38',NULL,'2026-06-14 04:09:42','2026-06-14 04:10:38'),
(95,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','b48981ad1d9053d3621f046cf0966c4b2ef5f19b774b8e222c131820453e3b6d','[\"*\"]','2026-06-14 04:11:27',NULL,'2026-06-14 04:11:24','2026-06-14 04:11:27'),
(96,'App\\Models\\User','fe811823-f15f-4720-8ca1-4dc8c361fc5d','auth-token','9b1f9836db70762d5133982b9d20d5a55f5dd8b5cac3b3b56229b2c7e32738e3','[\"*\"]','2026-06-14 04:12:20',NULL,'2026-06-14 04:12:19','2026-06-14 04:12:20'),
(98,'App\\Models\\User','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','auth-token','ce39e9a0c94433826646831d72eae5e55bdfb1ed47c5111884c661079d1b0eb6','[\"*\"]',NULL,NULL,'2026-06-14 04:19:43','2026-06-14 04:19:43'),
(100,'App\\Models\\User','c5b020c2-0a38-426c-9a7c-662d7f35bcb0','auth-token','c21e590f6d76f18f7817c5e0bfede05e9dcdbdfd4509bdfb391ec8e3a8f10efe','[\"*\"]','2026-06-14 04:55:38',NULL,'2026-06-14 04:21:17','2026-06-14 04:55:38'),
(101,'App\\Models\\User','75e95c8f-1b7d-43a7-8627-9dda3a575e9d','auth-token','2e883e1946c857aea2b688100c157687970d28327de2eec3d3e7377997cfce24','[\"*\"]',NULL,NULL,'2026-06-14 04:31:30','2026-06-14 04:31:30'),
(102,'App\\Models\\User','6bcdcf46-ae53-4692-a8a0-aad91231948b','auth-token','fff867b1f939a165c4d7d7b6e98b7270d03939f9befa524f8ac382de8e5b1ff8','[\"*\"]',NULL,NULL,'2026-06-14 04:33:36','2026-06-14 04:33:36'),
(103,'App\\Models\\User','ae89281f-e8bd-4bcd-b503-98ccd902e9a0','auth-token','9dbf3004f556dd6aa27e0ea49a46c11a531d2261fc83825b4ce23d6419da398b','[\"*\"]',NULL,NULL,'2026-06-14 04:37:14','2026-06-14 04:37:14'),
(104,'App\\Models\\User','7fb93398-3ea0-4ded-9f2d-92f11f67895b','auth-token','0acc097c37e5fc88d7af2aa774fdc18a9fac7bbb4bc56881f83b0c7eb6d5108d','[\"*\"]',NULL,NULL,'2026-06-14 04:38:28','2026-06-14 04:38:28'),
(105,'App\\Models\\User','863214f7-c9a5-49ef-ab5f-6249baa2eea6','auth-token','ace3560f1d4169a0f25cf6e622476ed2905ee03770bf411afc3738ef479c36fc','[\"*\"]',NULL,NULL,'2026-06-14 04:40:49','2026-06-14 04:40:49'),
(107,'App\\Models\\User','37beb3b7-1cc7-4659-93d7-8752ef0cbb68','auth-token','6ade379d10df2e5d5c18a4c99709c7837fc4fe08f2544e7ca9c81d7eed075720','[\"*\"]',NULL,NULL,'2026-06-14 04:50:40','2026-06-14 04:50:40'),
(108,'App\\Models\\User','37beb3b7-1cc7-4659-93d7-8752ef0cbb68','auth-token','df87b6042685ab5b6f5c41ae1a04f1e8951d36c65b880018197028e9d7a303ef','[\"*\"]','2026-06-14 04:50:53',NULL,'2026-06-14 04:50:50','2026-06-14 04:50:53');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `points_log`
--

DROP TABLE IF EXISTS `points_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `points_log` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `points` int(11) NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `reference_id` char(36) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `points_log_user_id_index` (`user_id`),
  KEY `points_log_action_type_index` (`action_type`),
  CONSTRAINT `points_log_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `points_log`
--

LOCK TABLES `points_log` WRITE;
/*!40000 ALTER TABLE `points_log` DISABLE KEYS */;
INSERT INTO `points_log` VALUES
('00774bc6-17d7-4ed7-b355-1f23def8c0ae','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('02534df2-1035-4866-9585-8389628e8b30','774642ed-4119-48b9-931d-63dfcbdcffaa',1,'comment_created','9101338f-c2af-47d4-b683-a3a10791397b','Menambahkan komentar','2026-06-14 10:53:44'),
('04376ff4-c592-45c2-b613-bc5f504b3a47','845d3436-2275-46bb-b4d3-7f47dbef9ea0',10,'upvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('0579b7c3-4921-44d5-b90e-231c29f61d35','33e66497-159c-482b-9dec-dd2cea22548c',10,'upvote_received','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c',NULL,'2026-06-14 05:28:11'),
('075d73fc-1cb8-4384-9acf-f7660609f463','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('07bfda9d-0949-4763-bb1d-481fb1041fb5','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',20,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('07fa1e6c-6687-4d7c-abf6-d82fc666f8d4','845d3436-2275-46bb-b4d3-7f47dbef9ea0',1,'comment_created','6a9f674d-f498-4c1e-8d9b-3d964a2b4451','Menambahkan komentar','2026-06-14 05:28:12'),
('089abf1b-f038-4535-b0d4-3cf07be97850','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 04:30:31'),
('0d200341-67c9-4625-ab00-a538c3b30c0c','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-10,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('0e3c586b-1396-46a2-b659-e89eccf64087','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 10:53:37'),
('0e72b030-77b9-43b7-a7b8-358f0b124c7e','33e66497-159c-482b-9dec-dd2cea22548c',20,'upvote_received','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c',NULL,'2026-06-14 05:28:11'),
('0f1f7e40-349f-4112-9e7e-99f74bdd62a5','57d57121-800a-49b2-a261-9648d5f64d57',-20,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('10c8afb9-187c-4c1b-8e90-59855cd2be8a','774642ed-4119-48b9-931d-63dfcbdcffaa',-5,'upvote_received','9101338f-c2af-47d4-b683-a3a10791397b',NULL,'2026-06-14 10:54:37'),
('1198afaf-ccb0-4c3a-9ba6-bb8f774af72b','774642ed-4119-48b9-931d-63dfcbdcffaa',1,'comment_created','54c258b6-d076-4d48-a78a-aa79b91458b1','Menambahkan komentar','2026-06-14 05:28:11'),
('11efcb24-1611-4fc3-97d9-18b58b7edc9a','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',20,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('12a219c3-6899-4532-b32f-09fb505580e3','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('12ede498-c74e-448a-ad2a-d95e9feebfe7','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('14415f77-2cd7-45db-a21c-2299336a651f','845d3436-2275-46bb-b4d3-7f47dbef9ea0',10,'upvote_received','38329261-3952-4262-a039-31c17d32db07',NULL,'2026-06-14 05:28:11'),
('147c48b6-dfb1-4fe9-8caa-cc8862093e77','33e66497-159c-482b-9dec-dd2cea22548c',-10,'downvote_received','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c',NULL,'2026-06-14 05:28:11'),
('14df63f0-cf4d-44d7-ac47-0ac3ed65ea5f','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('15a6c9ba-a0e8-4b8a-bb19-14ba95667374','774642ed-4119-48b9-931d-63dfcbdcffaa',5,'upvote_received','aa0dfcee-8ae7-4a23-b3b6-bf1157eb46f0',NULL,'2026-06-14 10:53:25'),
('15c04987-9d45-48ef-b6fd-de4fc74300c0','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('1b43d52c-f255-4bbe-8ee4-377684518fc0','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('1cfe7bff-055e-409e-9ea0-7f8a557a912b','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('1da97752-0442-4db0-9f00-dc796a3b846f','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('1dd860d1-dd32-47be-ac21-c2a820376baf','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('1fa2199a-16b9-4968-a716-a01e0685e8d4','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('20549ecb-cf14-4156-b0e6-b6cab1dae167','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('214f6587-3bae-41ed-b1fb-e25318c0395e','33e66497-159c-482b-9dec-dd2cea22548c',-20,'downvote_received','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c',NULL,'2026-06-14 05:28:11'),
('25bb5672-7581-403c-9c1e-b77f2ce44c22','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',5,'upvote_received','c0f3d5d4-113f-4aca-a864-c09a895f3030',NULL,'2026-06-14 05:28:12'),
('2651a510-9328-4f44-8ba7-631a103ab57b','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:11'),
('267ff517-7bf3-4e13-ace8-dd2df3ce94f1','845d3436-2275-46bb-b4d3-7f47dbef9ea0',1,'comment_created','bc34cb10-85a8-4a2b-b2c8-386b2731841e','Menambahkan komentar','2026-06-14 05:28:11'),
('273bee4c-39dd-48f3-9b18-c41eb5ed6868','774642ed-4119-48b9-931d-63dfcbdcffaa',5,'upvote_received','9101338f-c2af-47d4-b683-a3a10791397b',NULL,'2026-06-14 10:54:50'),
('288c9abc-4545-41b6-9cdb-639b2c91432b','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('28b000cc-ec22-4cd0-bc3f-17f0afb233da','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('2c13971f-4b94-4ea8-a4eb-dc1efc6953bc','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-1,'downvote_received','c0f3d5d4-113f-4aca-a864-c09a895f3030',NULL,'2026-06-14 05:28:12'),
('2c6be343-4430-4739-9923-faae034d1056','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('2d876293-fa9b-4fa3-8c0d-304b135f4bc9','57d57121-800a-49b2-a261-9648d5f64d57',-2,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('2dc7373a-d072-4707-a685-30e3819f9bbb','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('2fb5629a-bffb-416e-b9a4-830ce10bd00f','845d3436-2275-46bb-b4d3-7f47dbef9ea0',10,'upvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('301f6af5-ec7c-42d9-8b1a-282804013a70','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('3092a1ae-1915-43db-84fc-9aa0cfd53557','845d3436-2275-46bb-b4d3-7f47dbef9ea0',10,'upvote_received','38329261-3952-4262-a039-31c17d32db07',NULL,'2026-06-14 05:28:11'),
('316f97d3-ce14-427f-8b48-19269e8108cd','774642ed-4119-48b9-931d-63dfcbdcffaa',5,'upvote_received','aa0dfcee-8ae7-4a23-b3b6-bf1157eb46f0',NULL,'2026-06-14 10:54:53'),
('317c88c2-eed3-4c34-b7a2-b2ded268372a','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('31d9e2bc-6c16-425a-974e-0093333a5b0f','774642ed-4119-48b9-931d-63dfcbdcffaa',5,'upvote_received','aa0dfcee-8ae7-4a23-b3b6-bf1157eb46f0',NULL,'2026-06-14 10:53:01'),
('3370bb2d-2ea2-4201-90c4-41fbb652bf5a','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',20,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('36067b61-423b-4c69-a93c-8a85006f8f04','57d57121-800a-49b2-a261-9648d5f64d57',-20,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('366d4720-161c-4a70-b374-ba89eb3d91f7','845d3436-2275-46bb-b4d3-7f47dbef9ea0',1,'comment_created','bc34cb10-85a8-4a2b-b2c8-386b2731841e','Menambahkan komentar','2026-06-14 05:28:11'),
('38e150b0-37e4-4728-b2a9-cdb35a4eda4a','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('391a2942-f596-4e90-9ad1-a6fe4fd96690','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-10,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('3937eb28-a416-4f39-8dc5-08b2a79a8709','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-10,'upvote_received','38329261-3952-4262-a039-31c17d32db07',NULL,'2026-06-14 05:28:11'),
('3b7371ca-31e1-4457-a055-c4334b542a29','774642ed-4119-48b9-931d-63dfcbdcffaa',1,'comment_created','9101338f-c2af-47d4-b683-a3a10791397b','Menambahkan komentar','2026-06-14 10:52:51'),
('3baca748-a803-45d3-9372-b14a12f2a608','33e66497-159c-482b-9dec-dd2cea22548c',-2,'downvote_received','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c',NULL,'2026-06-14 05:28:11'),
('3d93368e-d56c-431f-a82a-3b75d33f0eeb','57d57121-800a-49b2-a261-9648d5f64d57',-20,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:11'),
('3f9530e6-e7c4-49c7-82ed-610601dd8d8b','57d57121-800a-49b2-a261-9648d5f64d57',-2,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:11'),
('403263bf-d99c-4533-a834-f50c84277662','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('40894f33-2923-481a-bd8b-5b42922381e7','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('42b205cb-2352-4ffd-9805-27935fa3bd06','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('44998128-abf6-4614-9cf5-f2357ae369a9','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','c0f3d5d4-113f-4aca-a864-c09a895f3030',NULL,'2026-06-14 05:28:12'),
('46edcd41-0b31-4ade-ba53-eaebc2749c01','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('4708a51a-2120-4db3-aa6c-871115002da0','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('48f78e30-541c-4957-9872-a9b8d544d662','845d3436-2275-46bb-b4d3-7f47dbef9ea0',10,'upvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('4a28a809-9286-4103-aee2-f6f1656d8c64','33e66497-159c-482b-9dec-dd2cea22548c',-10,'upvote_received','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c',NULL,'2026-06-14 05:28:11'),
('4aba374d-1213-4d03-9564-0a5de5b4cbdd','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('4afbcb74-628e-432b-aeab-468436fa039b','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('4bfa4222-13a9-4ceb-92be-c98b6cd03d94','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',20,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('4c46f52c-02ed-42fe-96fe-6298cad41d90','57d57121-800a-49b2-a261-9648d5f64d57',-2,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('4ce69a60-14a1-4032-a41d-0f8c6603f1e4','845d3436-2275-46bb-b4d3-7f47dbef9ea0',10,'upvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('4e1ec388-2987-4010-b529-c663dc66e723','57d57121-800a-49b2-a261-9648d5f64d57',-10,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('4f01331b-9a4d-42be-bb2e-d0d91cb184e8','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 11:22:30'),
('4f84e5a6-727a-43f4-a8c7-de9316421bd3','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',5,'upvote_received','c0f3d5d4-113f-4aca-a864-c09a895f3030',NULL,'2026-06-14 05:28:12'),
('4ff49cdb-e7fb-4b5f-9442-f5dbac4ba812','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:11'),
('508c594d-d5b6-4d43-a6c1-892520797a0f','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-10,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('523bd451-38d2-4fe8-832b-c333cc5af536','774642ed-4119-48b9-931d-63dfcbdcffaa',5,'upvote_received','aa0dfcee-8ae7-4a23-b3b6-bf1157eb46f0',NULL,'2026-06-14 10:54:33'),
('53b979e6-16a7-4eaa-ab59-5486c38f3b27','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('53e5ea94-024f-4cd0-9495-8853ce765bd0','57d57121-800a-49b2-a261-9648d5f64d57',-10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('54a8805a-df17-46ee-ad6a-f1d66175e528','774642ed-4119-48b9-931d-63dfcbdcffaa',1,'comment_created','54c258b6-d076-4d48-a78a-aa79b91458b1','Menambahkan komentar','2026-06-14 05:28:11'),
('55d064f6-f958-4f5d-88d0-5062b34e100f','57d57121-800a-49b2-a261-9648d5f64d57',-10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('5704af12-efd3-4862-8845-ff7f34d228db','57d57121-800a-49b2-a261-9648d5f64d57',-20,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('5a2cbdcc-ed28-4858-9266-b594150b4700','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('5e32ffb6-6917-4f96-8726-f8cfac2faf37','57d57121-800a-49b2-a261-9648d5f64d57',-10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('5ebb01b8-accc-47be-9df5-8eec368288c9','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('5f66c217-3167-43b2-b451-d080d6242e34','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('5fe7be6f-6bde-42c7-a175-e45103f3f4b4','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('6098afef-d0ae-42ad-bf87-fa008c085294','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('6126f026-c9a5-48d3-b6f8-56b0957c6ee5','33e66497-159c-482b-9dec-dd2cea22548c',-10,'downvote_received','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c',NULL,'2026-06-14 05:28:11'),
('6658540d-93d4-4b98-b83e-ca8f3c5ac5e8','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('668ee228-a927-4e95-b3e6-a9dcf6aa34b6','57d57121-800a-49b2-a261-9648d5f64d57',-10,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('6bc6230a-cda4-4ffe-82c1-3b199352200f','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('6c130435-02b7-4a05-b746-680ea0794185','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('6e766165-04ae-4156-840c-59ea4ec07b20','57d57121-800a-49b2-a261-9648d5f64d57',-10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('6e904d19-6404-44cc-91ba-0e0686b88063','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('71217c4b-d252-46b9-a4d3-7352701b635d','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('71618fad-b8a1-44b4-acbe-2a85968796c1','774642ed-4119-48b9-931d-63dfcbdcffaa',1,'comment_created','aa0dfcee-8ae7-4a23-b3b6-bf1157eb46f0','Menambahkan komentar','2026-06-14 10:54:26'),
('71bce9ad-2190-486f-82ec-1d4fde91c99d','57d57121-800a-49b2-a261-9648d5f64d57',-2,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:11'),
('71f154ea-1284-49f3-a82f-c182b322408a','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('73bbaea6-021f-4bdd-93ee-096ee6137902','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:11'),
('74fb6a63-eeff-46e9-8e2c-9daf093e84c4','845d3436-2275-46bb-b4d3-7f47dbef9ea0',10,'upvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('7553704e-7e00-466f-b678-9b87f758480e','57d57121-800a-49b2-a261-9648d5f64d57',20,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('772e1382-40f7-4e8f-89ea-8bccb50ec516','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',20,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('773f9d24-216b-4851-87e8-8c43b77275fe','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 10:55:10'),
('78934081-a042-410f-964c-cd204bb971e9','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('79628738-0cef-415a-b954-4c09f911c5cb','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('7a459ade-da68-4a08-a622-18629484d781','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',20,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('7bfa5e6c-e719-4b42-8bc9-6d228b2a7e97','c5b020c2-0a38-426c-9a7c-662d7f35bcb0',1,'comment_created','6cf01ab9-4230-4cb2-8d3a-a8f066b8ed75','Menambahkan komentar','2026-06-14 05:28:11'),
('7cee8fff-8d4e-44f2-9e39-dbf055f625bc','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','c0f3d5d4-113f-4aca-a864-c09a895f3030',NULL,'2026-06-14 05:28:12'),
('7d077129-4083-4225-858d-326855b37327','57d57121-800a-49b2-a261-9648d5f64d57',-2,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('7d397fe3-0967-4db5-bfbf-b1d94e991735','33e66497-159c-482b-9dec-dd2cea22548c',10,'upvote_received','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c',NULL,'2026-06-14 05:28:11'),
('7f97863e-bcc6-4be3-8f81-e9e76ccb4cb4','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('7ff3fb3d-3207-44c6-83e0-2471fb82d912','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('807b3c0c-9ebe-4a39-9d9b-2722ba296375','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('8085729a-de14-4d47-89be-281a93382d4f','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('81134a91-61c7-406e-b937-2f30094ee332','57d57121-800a-49b2-a261-9648d5f64d57',-10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('81e87bbe-d14d-4877-a1eb-ecfdb69930ba','fb501bb5-6f4a-4d2d-a0ec-36f61c053067',5,'upvote_received','05dd4a0c-4a92-4118-be2f-b0e826b80b98',NULL,'2026-06-14 11:24:26'),
('82a0e264-a8ea-4047-b523-9934f5d98633','fb501bb5-6f4a-4d2d-a0ec-36f61c053067',5,'upvote_received','05dd4a0c-4a92-4118-be2f-b0e826b80b98',NULL,'2026-06-14 11:22:48'),
('83e5c646-7d2d-49a8-9d54-1ca9d7bb0687','33e66497-159c-482b-9dec-dd2cea22548c',20,'upvote_received','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c',NULL,'2026-06-14 05:28:11'),
('85295042-2dae-4512-9f8b-ad25d1e2fc28','fe811823-f15f-4720-8ca1-4dc8c361fc5d',1,'comment_created','57e72981-dac6-4d5f-a55b-b27f2358482c','Menambahkan komentar','2026-06-14 05:28:11'),
('87139284-7924-4044-9195-ea10476be07a','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('8be89ca3-c770-4d9d-9aed-919dcfff71f4','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'report_resolved','6784aa4d-56b5-43db-a504-c547eaced5ae','Laporan diselesaikan: misinformation','2026-06-13 07:16:03'),
('8c9c7dd5-6807-43aa-a777-baf15b5594a6','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-5,'upvote_received','c0f3d5d4-113f-4aca-a864-c09a895f3030',NULL,'2026-06-14 05:28:12'),
('8d995eb2-3847-446b-a046-2afb01a85669','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 11:12:16'),
('8defb824-5b10-4f0f-ab22-a47a4171770f','57d57121-800a-49b2-a261-9648d5f64d57',-10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('8e9a7e7f-00ef-4c67-b412-b75be0bd414e','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('8ec35486-8991-417c-9b8c-1230b8b225bb','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-10,'upvote_received','38329261-3952-4262-a039-31c17d32db07',NULL,'2026-06-14 05:28:11'),
('8f40b2b4-6a17-4407-a0d1-50ade7e0655d','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('8f6f02a3-01c2-41b4-beb2-2daade3ca2c3','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('8ffb1713-e34d-4cfc-9c94-12824477f83c','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'upvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('91108f5f-3f4f-4178-8618-84233d444b62','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('92cc1ee4-b2ff-4547-94f4-badb1697055e','33e66497-159c-482b-9dec-dd2cea22548c',-2,'downvote_received','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c',NULL,'2026-06-14 05:28:11'),
('9376c95c-50c0-47a0-9a20-70b5a3712183','fe811823-f15f-4720-8ca1-4dc8c361fc5d',1,'comment_created','57e72981-dac6-4d5f-a55b-b27f2358482c','Menambahkan komentar','2026-06-14 05:28:11'),
('94204ade-b614-424f-962f-ea0869e1e808','57d57121-800a-49b2-a261-9648d5f64d57',-2,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('95440168-729b-44ca-9b5e-1979309087fa','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('95886fde-9b11-4b93-be0c-254db7cbb8a1','33e66497-159c-482b-9dec-dd2cea22548c',1,'comment_created','34f01297-157d-47a2-be68-425e00b9d9bd','Menambahkan komentar','2026-06-14 10:55:22'),
('96461529-aff5-47f2-bf61-17b332737625','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('9656a178-525a-46ca-b6e5-3278fb8eebf0','845d3436-2275-46bb-b4d3-7f47dbef9ea0',1,'comment_created','4be974bd-730b-4b15-b33a-93070a87f514','Menambahkan komentar','2026-06-14 05:28:11'),
('965e8c47-f2f1-4623-8e65-71cd5edcf5a3','774642ed-4119-48b9-931d-63dfcbdcffaa',-5,'upvote_received','9101338f-c2af-47d4-b683-a3a10791397b',NULL,'2026-06-14 10:53:08'),
('97bea98c-f62c-4982-9433-bcdbdfb04de0','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('9842aea7-d14b-4647-ba64-4c26a9d3d5be','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('9cc961ab-da9b-41b0-8a0b-2dfd076fd792','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'upvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('9f12cfba-b46b-4e63-9d62-dcef4057c277','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('9f3b1577-91f8-438c-b9b6-47ef66482329','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:11'),
('9f689dd0-095a-41d4-b02a-872262d29bc4','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('a03afe85-4039-40e0-ad9a-64381d1e399d','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('a04a5891-2038-4fea-874f-ac1671e0a25b','33e66497-159c-482b-9dec-dd2cea22548c',-20,'downvote_received','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c',NULL,'2026-06-14 05:28:11'),
('a0761b79-225c-49dc-8b42-bb99ddadbf7d','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 11:10:43'),
('a2ecfb5f-92c5-4cc1-b897-7c65b55a9693','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('a2fa1973-d459-465d-9577-d05dfb0b64d9','57d57121-800a-49b2-a261-9648d5f64d57',20,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('a44f1892-b7c8-4944-9f5a-1069fdc28ccc','774642ed-4119-48b9-931d-63dfcbdcffaa',-1,'downvote_received','9101338f-c2af-47d4-b683-a3a10791397b',NULL,'2026-06-14 10:52:58'),
('a6ddb515-44ce-481c-ae0a-399a8d633880','774642ed-4119-48b9-931d-63dfcbdcffaa',1,'comment_created','9101338f-c2af-47d4-b683-a3a10791397b','Menambahkan komentar','2026-06-14 10:52:45'),
('a89be974-ca34-4f7b-b815-e016924c5ddb','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('a9d3c570-70a3-48e7-b588-1e6c72c22581','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('ab495526-4e94-49b3-ba2a-763a1dca53ac','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('abe27569-4218-44ad-8e79-9ffe558b12f2','774642ed-4119-48b9-931d-63dfcbdcffaa',10,'upvote_received','9101338f-c2af-47d4-b683-a3a10791397b',NULL,'2026-06-14 10:53:04'),
('ac3f00a0-51c8-4244-bb5a-075267ad8be6','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('acabd320-546f-484c-b224-60cde36a1f90','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('af37f9f5-f685-4e7e-8b26-5ebff6d44354','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('b1113b4f-4897-4f53-9dd0-982553a50a35','774642ed-4119-48b9-931d-63dfcbdcffaa',1,'comment_created','aa0dfcee-8ae7-4a23-b3b6-bf1157eb46f0','Menambahkan komentar','2026-06-14 10:52:54'),
('b1584063-6888-4b46-89d2-91be9c5837ad','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('b238dcab-0ed5-475f-a71a-b58a75974232','57d57121-800a-49b2-a261-9648d5f64d57',-20,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:11'),
('b2565cb3-7eaa-4430-aaa4-07776b8cdc4b','c5b020c2-0a38-426c-9a7c-662d7f35bcb0',1,'comment_created','d9c37e38-9a34-4350-80e2-721893cf22db','Menambahkan komentar','2026-06-14 05:28:11'),
('b2726ba5-584a-41c8-aa24-3d10e911b8a3','57d57121-800a-49b2-a261-9648d5f64d57',-10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('b3c44db2-f567-49cd-97e0-a9b188c95150','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('b8a20edb-2426-4fce-a147-3d45eebd75c9','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('b9f31ed9-3a9e-4d16-8cee-008accaacf1e','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 11:22:27'),
('bc806a54-a17c-4630-954b-5e97be750858','33e66497-159c-482b-9dec-dd2cea22548c',-10,'upvote_received','4de86fc4-ac0d-4c2a-93f3-4d8e3039583c',NULL,'2026-06-14 05:28:11'),
('bee0dfe5-66eb-4603-a2a9-dd86e6fda50d','c5b020c2-0a38-426c-9a7c-662d7f35bcb0',1,'comment_created','d9c37e38-9a34-4350-80e2-721893cf22db','Menambahkan komentar','2026-06-14 05:28:11'),
('c0b8d211-e85f-4972-a3c0-65ae6edaf294','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('c188d77d-bc43-47a8-9746-b186f614b9da','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('c2c2fc66-5a29-4214-9404-51d3dba407bc','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('c2c3e581-aa3f-4495-91fc-c5f0b82c04f9','33e66497-159c-482b-9dec-dd2cea22548c',1,'comment_created','34f01297-157d-47a2-be68-425e00b9d9bd','Menambahkan komentar','2026-06-14 10:53:41'),
('c480a544-2de5-47e5-b402-84ac603d8790','c5b020c2-0a38-426c-9a7c-662d7f35bcb0',1,'comment_created','6cf01ab9-4230-4cb2-8d3a-a8f066b8ed75','Menambahkan komentar','2026-06-14 05:28:11'),
('c4b532c3-eed3-4e98-9197-fe1edb278a76','fb501bb5-6f4a-4d2d-a0ec-36f61c053067',1,'comment_created','05dd4a0c-4a92-4118-be2f-b0e826b80b98','Menambahkan komentar','2026-06-14 11:22:42'),
('c56fa68b-a872-4f4d-ad46-d53521143577','774642ed-4119-48b9-931d-63dfcbdcffaa',-5,'upvote_received','aa0dfcee-8ae7-4a23-b3b6-bf1157eb46f0',NULL,'2026-06-14 10:53:19'),
('c64013ba-8d6b-49ef-bfb4-3284cbae9a81','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('c6f7cfe5-5f8d-40db-a246-32ed8ab636cd','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-10,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('c746aa34-4d3a-45cb-9ebd-0800f53e2547','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('c76755c7-753f-4b90-9f2f-d83f492b07e9','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 11:25:34'),
('cb185569-b39a-477b-a590-ae99f5ad0d81','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:11'),
('cd9bce4f-2d3f-4524-a3a4-b3112157acdc','57d57121-800a-49b2-a261-9648d5f64d57',-10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('cdb7baa6-4b98-4fd1-be46-097ecf5f5fdc','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('ce349090-90ef-4620-88a7-0e50dbaba266','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('d0668739-6181-4d41-a410-9dafc25474fc','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('d0e76645-f4d0-4adc-b289-5e3ccdd210c8','57d57121-800a-49b2-a261-9648d5f64d57',-20,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:11'),
('d12bbf2a-3f70-4dbf-9b0e-3cdcac740f3a','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('d5143ecb-54fb-49d3-b58f-a10d4ec49043','845d3436-2275-46bb-b4d3-7f47dbef9ea0',10,'upvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('d8034625-471b-4415-bde7-67b46e3f2597','774642ed-4119-48b9-931d-63dfcbdcffaa',5,'upvote_received','9101338f-c2af-47d4-b683-a3a10791397b',NULL,'2026-06-14 10:53:12'),
('d819e108-e9c7-4362-b3ac-67a71278fed8','845d3436-2275-46bb-b4d3-7f47dbef9ea0',10,'upvote_received','38329261-3952-4262-a039-31c17d32db07',NULL,'2026-06-14 05:28:11'),
('d8ce0284-59b8-44e6-bb5f-b0bd3c7089ec','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',20,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('d90e237b-95c3-40eb-8454-700589d23a92','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('d951c6b8-3c78-49e4-9514-5475ea598f47','57d57121-800a-49b2-a261-9648d5f64d57',-20,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:11'),
('db77792e-5f96-4da5-b774-75d315cdb09c','57d57121-800a-49b2-a261-9648d5f64d57',-10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('db8e3571-6c98-4ec4-8203-f34166acbd62','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('dd14d011-da9d-4c50-9405-76fc3ff76e2d','57d57121-800a-49b2-a261-9648d5f64d57',-10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('e0dfbdc5-c985-4ab2-9b3f-a33b44358f2d','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('e240a617-dfdf-48d9-b2df-232bfe7a22be','57d57121-800a-49b2-a261-9648d5f64d57',-10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('e299965c-e87f-49e8-b763-d2151457ed2c','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('e43e1de8-afca-4a11-adf4-ba0ae30035bc','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('e5ef081a-13f4-4cc5-a546-4d2711497983','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('e699f5d2-1eeb-441c-ba11-6adddd9b700e','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('e74b0efe-d220-4005-b200-2590608cde56','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('ebfb760b-522e-4df7-b140-f1dd87c23dc7','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('ec21455f-123b-4a4b-9bf0-74d60cd1d2a7','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 11:24:00'),
('ee4d8a3a-a092-403b-a731-434c4d851cd7','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-5,'upvote_received','c0f3d5d4-113f-4aca-a864-c09a895f3030',NULL,'2026-06-14 05:28:12'),
('ef18eb04-6fab-4c51-a5a5-dbcb3ce8f6a0','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-20,'downvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:12'),
('ef486a4b-f536-46d1-9ee5-3a79d6a498f3','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-1,'downvote_received','c0f3d5d4-113f-4aca-a864-c09a895f3030',NULL,'2026-06-14 05:28:12'),
('f023b9cc-54f1-4f68-b300-174a7c6b1ebd','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('f0a041f0-2b56-4704-afcb-58cfd9749ddf','845d3436-2275-46bb-b4d3-7f47dbef9ea0',1,'comment_created','4be974bd-730b-4b15-b33a-93070a87f514','Menambahkan komentar','2026-06-14 05:28:11'),
('f3127e5b-0c1d-4113-83e9-e28245724c6a','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('f55c5ee6-e848-4db2-a2e1-7429b0efea93','57d57121-800a-49b2-a261-9648d5f64d57',-20,'downvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('f63be11c-d75d-4181-893e-883c3b10d5b6','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-5,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('f679b160-dac8-4d97-93c8-47a831daedbd','57d57121-800a-49b2-a261-9648d5f64d57',-10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('f7397a5f-267b-4a7e-baca-6263166251d5','57d57121-800a-49b2-a261-9648d5f64d57',10,'upvote_received','ec211521-33e3-496f-890e-2534d53e9eed',NULL,'2026-06-14 05:28:12'),
('f7ca9750-4863-46db-adfe-f67a8e2230aa','845d3436-2275-46bb-b4d3-7f47dbef9ea0',1,'comment_created','6a9f674d-f498-4c1e-8d9b-3d964a2b4451','Menambahkan komentar','2026-06-14 05:28:12'),
('f87acd55-e177-4a19-b0d4-7f1f0e2c0189','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',20,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('f921d87f-a062-437e-b04d-4e5b7c89fb7f','845d3436-2275-46bb-b4d3-7f47dbef9ea0',10,'upvote_received','38329261-3952-4262-a039-31c17d32db07',NULL,'2026-06-14 05:28:11'),
('fd73735b-7bad-46a5-8e4c-010f976066c1','845d3436-2275-46bb-b4d3-7f47dbef9ea0',-1,'downvote_received','6a9f674d-f498-4c1e-8d9b-3d964a2b4451',NULL,'2026-06-14 05:28:12'),
('fdf60536-74e6-4436-87cc-c5ba5881b44b','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11'),
('fe6796a1-9f1f-4ea4-be87-d7803e7e8c69','fb501bb5-6f4a-4d2d-a0ec-36f61c053067',1,'comment_created','05dd4a0c-4a92-4118-be2f-b0e826b80b98','Menambahkan komentar','2026-06-14 11:24:15'),
('fff0aefb-9e32-4109-98c2-21a15ecba547','2036e7f5-e6af-457a-aa4b-4ef4b824ed93',-10,'upvote_received','02c33a66-2d6a-4e1b-8530-646a72b048c4',NULL,'2026-06-14 05:28:11');
/*!40000 ALTER TABLE `points_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_edit_history`
--

DROP TABLE IF EXISTS `post_edit_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_edit_history` (
  `id` char(36) NOT NULL,
  `post_id` char(36) NOT NULL,
  `edited_by` char(36) NOT NULL,
  `body_before` text NOT NULL,
  `body_after` text NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `edited_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `post_edit_history_post_id_foreign` (`post_id`),
  KEY `post_edit_history_edited_by_foreign` (`edited_by`),
  CONSTRAINT `post_edit_history_edited_by_foreign` FOREIGN KEY (`edited_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `post_edit_history_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_edit_history`
--

LOCK TABLES `post_edit_history` WRITE;
/*!40000 ALTER TABLE `post_edit_history` DISABLE KEYS */;
INSERT INTO `post_edit_history` VALUES
('5a5f5456-ec2e-494d-b111-97470fb870c1','ec211521-33e3-496f-890e-2534d53e9eed','57d57121-800a-49b2-a261-9648d5f64d57','Laravel adalah framework PHP yang powerful...','Laravel adalah framework PHP terbaik untuk web artisan...','Menambahkan detail','2026-06-04 09:15:41');
/*!40000 ALTER TABLE `post_edit_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_tags`
--

DROP TABLE IF EXISTS `post_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_tags` (
  `post_id` char(36) NOT NULL,
  `tag_id` char(36) NOT NULL,
  PRIMARY KEY (`post_id`,`tag_id`),
  KEY `post_tags_tag_id_foreign` (`tag_id`),
  CONSTRAINT `post_tags_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `post_tags_tag_id_foreign` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_tags`
--

LOCK TABLES `post_tags` WRITE;
/*!40000 ALTER TABLE `post_tags` DISABLE KEYS */;
INSERT INTO `post_tags` VALUES
('02c33a66-2d6a-4e1b-8530-646a72b048c4','0ec6ccfe-a89a-4ed1-9af5-a64954b3d0ca'),
('02c33a66-2d6a-4e1b-8530-646a72b048c4','58bc90dd-51a4-47e1-9dc0-c6996cea3a4a'),
('38329261-3952-4262-a039-31c17d32db07','5cd3c745-362c-44e6-8c6a-3c2bda41d98c'),
('38329261-3952-4262-a039-31c17d32db07','90dd46fc-c79f-45ad-94e7-581f15f82258'),
('4de86fc4-ac0d-4c2a-93f3-4d8e3039583c','d04d61e3-068b-4719-8bfc-1cf31b23735f'),
('50707173-ef95-4888-a5d0-26cf58962eda','7b66ecee-dbd1-433a-a968-f05f976ee75a'),
('50707173-ef95-4888-a5d0-26cf58962eda','defa8a92-c167-4620-a6d3-2d37ac9c90d1'),
('515df151-1076-499a-b66f-b51796f3741d','0cf915ee-f626-47d4-a2d3-26739b0e8568'),
('515df151-1076-499a-b66f-b51796f3741d','11a5a84d-2c68-4a57-848c-0d6063bed92a'),
('6b1ddda9-116f-408f-b441-bd9d2b608538','11a5a84d-2c68-4a57-848c-0d6063bed92a'),
('6b1ddda9-116f-408f-b441-bd9d2b608538','f4b0bff6-e9eb-46ca-9ed2-ff06e8255db7'),
('9ac03af5-e39e-48cc-9887-dd63b18793f2','947a9070-e783-4106-847f-2084931fc558'),
('b812d824-f65e-49ca-8be6-c79c76616465','11a5a84d-2c68-4a57-848c-0d6063bed92a'),
('eaf84ea9-a074-43d1-b2de-b3571bb902df','11a5a84d-2c68-4a57-848c-0d6063bed92a'),
('eaf84ea9-a074-43d1-b2de-b3571bb902df','947a9070-e783-4106-847f-2084931fc558'),
('ec211521-33e3-496f-890e-2534d53e9eed','0cf915ee-f626-47d4-a2d3-26739b0e8568'),
('f5bea9ca-69b4-4e07-9113-190a1a3b25ed','11a5a84d-2c68-4a57-848c-0d6063bed92a'),
('f5bea9ca-69b4-4e07-9113-190a1a3b25ed','532228e4-1b9d-4463-8800-aaf696b5b98f');
/*!40000 ALTER TABLE `post_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `category_id` char(36) NOT NULL,
  `title` varchar(300) NOT NULL,
  `body` text NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'open',
  `view_count` int(11) NOT NULL DEFAULT 0,
  `vote_score` int(11) NOT NULL DEFAULT 0,
  `is_answered` tinyint(1) NOT NULL DEFAULT 0,
  `accepted_answer_id` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `posts_user_id_index` (`user_id`),
  KEY `posts_category_id_index` (`category_id`),
  KEY `posts_status_index` (`status`),
  KEY `posts_created_at_index` (`created_at`),
  CONSTRAINT `posts_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  CONSTRAINT `posts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES
('02c33a66-2d6a-4e1b-8530-646a72b048c4','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','06cac1de-f0c5-4c6f-8bae-1c9ffa360865','Cara optimal menggunakan Eloquent Relationships di Laravel 11','Saya baru belajar Laravel 11 dan bingung cara terbaik menggunakan Eloquent Relationships.\n\nMisalnya, saya punya model `Post` dan `Comment`. Kapan harus pakai `hasMany`, `belongsTo`, atau `morphMany`? Ada best practice untuk performa?\n\nMohon pencerahan dari teman-teman yang sudah berpengalaman.','open',72,11,0,NULL,'2026-06-03 20:40:29','2026-06-14 04:22:38'),
('38329261-3952-4262-a039-31c17d32db07','845d3436-2275-46bb-b4d3-7f47dbef9ea0','165e0346-05af-447d-9b79-fa0f9a9393cd','React useState vs useReducer, kapan pake yang mana?','Saya masih bingung kapan harus menggunakan `useState` dan kapan `useReducer`.\n\nDari yang saya baca:\n- `useState` untuk state sederhana\n- `useReducer` untuk state kompleks dengan banyak action\n\nTapi di praktiknya, state sederhana pun kadang butuh banyak setter. Mohon saran!','open',7,11,0,NULL,'2026-06-03 20:40:29','2026-06-12 23:00:25'),
('4de86fc4-ac0d-4c2a-93f3-4d8e3039583c','33e66497-159c-482b-9dec-dd2cea22548c','523bdbf6-4546-4d40-8494-7b747958699d','Tailwind CSS vs CSS Modules untuk project besar','Tim saya diskusi tentang CSS approach.\n\nTim A: Tailwind lebih cepat development, utility-first\nTim B: CSS Modules lebih terstruktur, maintainable\n\nAda yang punya pengalaman pakai Tailwind di project besar (>50 komponen)?','open',8,20,0,NULL,'2026-06-03 20:40:29','2026-06-12 23:03:58'),
('50707173-ef95-4888-a5d0-26cf58962eda','845d3436-2275-46bb-b4d3-7f47dbef9ea0','5ba758b9-4841-4266-9bfb-907bb9f300b7','Cara migrate dari MySQL ke PostgreSQL','Kami berencana migrate database dari MySQL ke PostgreSQL.\n\nYang perlu dipertimbangkan:\n1. Perbedaan tipe data\n2. Migration tools yang tersedia\n3. Downtime strategy\n4. Testing parity\n\nAda yang punya pengalaman migrasi serupa?','open',0,19,0,NULL,'2026-06-03 20:40:29','2026-06-03 20:40:29'),
('515df151-1076-499a-b66f-b51796f3741d','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','165e0346-05af-447d-9b79-fa0f9a9393cd','Tips debugging memory leak di Node.js','Aplikasi Node.js saya mengalami memory leak setelah berjalan beberapa jam.\n\nSudah coba:\n- Heap snapshot\n- Chrome DevTools\n- `--inspect` flag\n\nTapi masih belum ketemu sumbernya. Ada tools atau teknik lain yang bisa dicoba?','open',6,2,0,NULL,'2026-06-03 20:40:29','2026-06-13 00:40:45'),
('6b1ddda9-116f-408f-b441-bd9d2b608538','33e66497-159c-482b-9dec-dd2cea22548c','78932714-d0f6-42bf-8666-b59cdc7a6143','Perbedaan Docker Compose vs Kubernetes untuk development','Tim saya sedang diskusi tentang container orchestration.\n\nSelama ini pakai Docker Compose untuk local development. Tapi ada yang usul pindah ke Kubernetes.\n\nApa kelebihan dan kekurangan masing-masing untuk development workflow sehari-hari?','open',0,8,0,NULL,'2026-06-03 20:40:29','2026-06-03 20:40:29'),
('9ac03af5-e39e-48cc-9887-dd63b18793f2','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','a3ec6c90-48e3-4948-8b97-5f751a9c0614','Belajar AI/ML dari nol, mulai dari mana?','Saya ingin belajar AI/ML tapi bingung mulai dari mana.\n\nBackground: full-stack developer (PHP/JS).\n\nRencana belajar:\n1. Python basics\n2. NumPy & Pandas\n3. Scikit-learn\n4. TensorFlow/PyTorch\n\nApakah urutan ini sudah benar? Ada sumber belajar yang recommended?','open',2,-3,0,NULL,'2026-06-03 20:40:29','2026-06-12 17:12:15'),
('b812d824-f65e-49ca-8be6-c79c76616465','33e66497-159c-482b-9dec-dd2cea22548c','06cac1de-f0c5-4c6f-8bae-1c9ffa360865','Best practice REST API response structure','Saya sedang membangun REST API dan ingin tahu struktur response JSON yang baik.\n\n1. Haruskah pakai envelope seperti `{ data: ..., message: ... }`?\n2. Kapan pakai HTTP code 200 vs 201?\n3. Apakah perlu menyertakan pagination metadata?\n\nTolong share pengalaman kalian!','open',0,16,0,NULL,'2026-06-03 20:40:29','2026-06-03 20:40:29'),
('eaf84ea9-a074-43d1-b2de-b3571bb902df','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','06cac1de-f0c5-4c6f-8bae-1c9ffa360865','Python type hints untuk production code','Saya mulai pakai Python type hints di project production. Tapi kadang ragu:\n\n- Seberapa strict harusnya?\n- `List[int]` vs `Sequence[int]`?\n- Harus pakai `Optional` atau `| None`?\n- Overhead development time vs benefit?\n\nShare pengalaman kalian dong!','open',5,9,0,NULL,'2026-06-03 20:40:29','2026-06-14 04:20:43'),
('ec211521-33e3-496f-890e-2534d53e9eed','57d57121-800a-49b2-a261-9648d5f64d57','d153fa9b-ca35-4615-952c-31be4560c19c','Apa itu Laravel? (Updated)','Laravel adalah framework PHP terbaik untuk web artisan...','deleted',74,-4,1,'8c4a0dc2-92e3-4987-bd28-e741a65d73a6','2026-06-04 02:15:32','2026-06-14 03:53:33'),
('f5bea9ca-69b4-4e07-9113-190a1a3b25ed','845d3436-2275-46bb-b4d3-7f47dbef9ea0','78932714-d0f6-42bf-8666-b59cdc7a6143','Strategi caching Redis untuk aplikasi high-traffic','Aplikasi kami mulai mengalami traffic tinggi dan perlu caching strategy.\n\nRencana:\n1. Cache query results (Redis)\n2. Full page cache untuk pages statis\n3. Queue untuk background jobs\n\nAda best practice atau gotcha yang harus diwaspadai?','open',1,9,0,NULL,'2026-06-03 20:40:29','2026-06-06 00:30:14');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `id` char(36) NOT NULL,
  `reporter_id` char(36) NOT NULL,
  `target_id` char(36) NOT NULL,
  `target_type` varchar(20) NOT NULL,
  `reason` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `resolved_by` char(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `resolved_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reports_resolved_by_foreign` (`resolved_by`),
  KEY `reports_reporter_id_index` (`reporter_id`),
  KEY `reports_target_id_target_type_index` (`target_id`,`target_type`),
  KEY `reports_status_index` (`status`),
  CONSTRAINT `reports_reporter_id_foreign` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reports_resolved_by_foreign` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
INSERT INTO `reports` VALUES
('6784aa4d-56b5-43db-a504-c547eaced5ae','774642ed-4119-48b9-931d-63dfcbdcffaa','176c4645-4838-48ab-a3d0-26e7332b5896','comment','misinformation',NULL,'resolved','845d3436-2275-46bb-b4d3-7f47dbef9ea0','2026-06-12 23:03:36','2026-06-13 00:16:03');
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` char(36) NOT NULL,
  `name` varchar(50) NOT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES
('0deb90cf-5367-44bc-a64a-a1ca39c3b582','moderator','[\"edit_posts\",\"delete_posts\",\"edit_comments\",\"delete_comments\",\"resolve_reports\",\"ban_users\"]','2026-06-04 03:40:28'),
('7261b281-1fdd-4f06-8522-f4bff64984a4','user','[\"create_posts\",\"edit_own_posts\",\"delete_own_posts\",\"create_comments\",\"edit_own_comments\",\"delete_own_comments\",\"vote\",\"like\",\"bookmark\",\"follow\",\"report\"]','2026-06-04 03:40:28'),
('82fa2f9f-8255-42a8-92f4-332879b0d110','admin','[\"*\"]','2026-06-04 03:40:28');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES
('4o1xt3BmbFB9L8MIrxHkeWqWqEvQGmX3DTNpP7hr',NULL,'192.168.144.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiTnphMU9iY2N4RXJlNlpYanp3U0xSSGliYWloQjRjcGhqcTNwNjFMbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hcGkubWVsdmluLm15LmlkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1780562885),
('Am9lRyrXfpKObfGlqaA3DIEbB1gu6uAaggL1ubfv',NULL,'192.168.144.1','Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Claude-User/1.0; +claude-user@anthropic.com)','YTozOntzOjY6Il90b2tlbiI7czo0MDoidU9pNVFSS3N4cnd3bUNoWk5kUmxOMnkwenkzS1JORVZzZnVYTThmRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hcGkubWVsdmluLm15LmlkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1780554854),
('BOjSVb8y4661NnisUerZrcYLGY3Jsc7Fl0HUlcVP',NULL,'192.168.144.1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiRDVMSmN6SVdmY3pZUFFYWTVpTW9ZYTQwVUw5b3oweDl0M2FuU05EWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hcGkubWVsdmluLm15LmlkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1780558603),
('cwHoJ8ZU0FRorFlgnZuNFxjws3suzJDkl6LcMxvM','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','192.168.144.1','curl/7.88.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoia2UyQ283TjZiU291QWZaQW5xRnhFbnhpUW55RDJCdndUVWdreTBlSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjk6Imh0dHA6Ly9sb2NhbGhvc3Q6OTAwMC9ob3Jpem9uIjtzOjU6InJvdXRlIjtzOjEzOiJob3Jpem9uLmluZGV4Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1780555696),
('epiw71rqXkctbv8Ium4oR6uSoPW8ZEu6i1ZMN1Pw',NULL,'192.168.144.1','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:134.0) Gecko/20100101 Firefox/134.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiR1BpMTNKTEtEUDd4ejFqc0F5eFZMVTZwZndXekVPdGJNc2hqR3VSSCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hcGkubWVsdmluLm15LmlkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1780555572),
('EPuBH0nwzcVrpyfjFQNVnX49AmrUxCMbDfsNXCfD',NULL,'192.168.144.1','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:134.0) Gecko/20100101 Firefox/134.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ3dTS1pJVkZEMUQ3QjJ5c0hSSUQ0Y0Rna0E0TmhzYkZ6SXd1clBXZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hcGkubWVsdmluLm15LmlkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1780555619),
('fycyRHFWK5nZmoxdtldvpQuVm0Dc2M5M5bCkDjbR',NULL,'192.168.144.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiNTZocU5Tc21UVFJ3VU9Ndjhhd2dJazJXWHZpYkcyWkNOdEh0Qm53OCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hcGkubWVsdmluLm15LmlkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1780557846),
('i4MOaJ3LmXcVXnjslaCHjMtaGo74EwNGPXDh2oOQ',NULL,'192.168.144.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoicnFyVzZ2dG9VekNQSWlxd2FLWTNaSTRNSjZFUERhc2RJUnpCT3RwcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hcGkubWVsdmluLm15LmlkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1780559095),
('Qi3DC2ZCGU3lx3QDFbvqKDvhqyUG6YBZdKXhQrh6',NULL,'192.168.144.1','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:134.0) Gecko/20100101 Firefox/134.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiajA4OVFnZnpNQW9RVFB5Ulc2VEVaWEhvZlc2TXYzMGJUM1A1dXN4biI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hcGkubWVsdmluLm15LmlkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1780561911),
('QTCSgt8OzdFpYEtpiUzs3Lw2tKRfFblYrs5uQDKW','33e66497-159c-482b-9dec-dd2cea22548c','192.168.144.1','curl/7.88.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiczY0SmNVblVEc2FESTQzM0VrTk5KelFoZ3ZvU3lwZm5BSk51dkRDRyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjk6Imh0dHA6Ly9sb2NhbGhvc3Q6OTAwMC9ob3Jpem9uIjtzOjU6InJvdXRlIjtzOjEzOiJob3Jpem9uLmluZGV4Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1780555696),
('rPFHCAoUtWQ2PNHM8Gvzku5YGZExKVdWcI8pE9Ch',NULL,'192.168.144.1','Scrapy/2.13.4 (+https://scrapy.org)','YTozOntzOjY6Il90b2tlbiI7czo0MDoidjhacVBuOGV1TmNjWjJvdE9YTFMyaFBGbmltNVpxdUZQTUNUdzJTdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hcGkubWVsdmluLm15LmlkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1780556612),
('Sg4DPO2b8dc55cXhCjLo54UmXUiQNgzG6NHUcr3L',NULL,'192.168.144.1','Mozilla/5.0 (X11; Linux x86_64; rv:150.0) Gecko/20100101 Firefox/150.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiY05TRkk1YUxERzIzTU1RQU9kYTAxaG00Z2VvWUc2Y0s0Z20zMzNZVCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hcGkubWVsdmluLm15LmlkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1780554734),
('sL2BY8FdSDWimCIXQ7ZElKtvNgQpesZgx3oPWNtj',NULL,'192.168.144.1','curl/7.88.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiWlpuSVJIWWxwM1duRzNjcEFxUVBhYTRMNVVUUEFDeVlHMk5lNGV3bCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly9sb2NhbGhvc3Q6OTAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1780555682),
('SuukWJexA4X55ygY3aPhGBssHXXKuRTLYxdX4DfM',NULL,'192.168.144.1','Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:134.0) Gecko/20100101 Firefox/134.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiTjk3b2FnaTk3eXJZSWI5YzI1end5ZG1VOHBLMGVlNTBma05mZGt3dSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hcGkubWVsdmluLm15LmlkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1780555347),
('USrNuJXBDGgAgYrBUCm5k3FjqIQP7nrQfiihN4pp',NULL,'192.168.144.1','curl/7.88.1','YTozOntzOjY6Il90b2tlbiI7czo0MDoiQjBvN1prUjI1R0c1NGp4UUIwRktlVEVWcTRqWlRNNjg4aVB1cXlsQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjk6Imh0dHA6Ly9sb2NhbGhvc3Q6OTAwMC9ob3Jpem9uIjtzOjU6InJvdXRlIjtzOjEzOiJob3Jpem9uLmluZGV4Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==',1780555691),
('ZnZv20IeZNTusj54rhI5B8xIQd83A8XF5SVC59XR',NULL,'192.168.144.1','Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:149.0) Gecko/20100101 Firefox/149.0','YTozOntzOjY6Il90b2tlbiI7czo0MDoiZElpQXZnQ3lRNzQzOFI1dmNSZExoQWN4S2d6ZU04bXFWOE83dHJMSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hcGkubWVsdmluLm15LmlkIjtzOjU6InJvdXRlIjtOO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19',1780561807);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shadow_bans`
--

DROP TABLE IF EXISTS `shadow_bans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shadow_bans` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `reason` text NOT NULL,
  `restriction_type` varchar(10) NOT NULL,
  `restriction_duration` int(11) NOT NULL,
  `expires_at` timestamp NOT NULL,
  `created_by` char(36) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `shadow_bans_created_by_foreign` (`created_by`),
  KEY `shadow_bans_user_id_index` (`user_id`),
  KEY `shadow_bans_expires_at_index` (`expires_at`),
  CONSTRAINT `shadow_bans_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `shadow_bans_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shadow_bans`
--

LOCK TABLES `shadow_bans` WRITE;
/*!40000 ALTER TABLE `shadow_bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `shadow_bans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` char(36) NOT NULL,
  `name` varchar(50) NOT NULL,
  `slug` varchar(60) NOT NULL,
  `color` varchar(7) DEFAULT NULL,
  `usage_count` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `tags_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES
('0cf915ee-f626-47d4-a2d3-26739b0e8568','JavaScript','javascript','#F7DF1E',0,'2026-06-04 03:40:28'),
('0ec6ccfe-a89a-4ed1-9af5-a64954b3d0ca','PHP','php','#777BB3',0,'2026-06-04 03:40:28'),
('11a5a84d-2c68-4a57-848c-0d6063bed92a','REST API','rest-api','#6DB33F',0,'2026-06-04 03:40:28'),
('18fa6e87-8289-4657-828a-dc67f3c5d4b4','Vue.js','vuejs','#4FC08D',0,'2026-06-04 03:40:28'),
('4a59545c-cee8-4ec2-909f-bbeeda5b2cbb','Go','go','#00ADD8',0,'2026-06-04 03:40:28'),
('532228e4-1b9d-4463-8800-aaf696b5b98f','Redis','redis','#DC382D',0,'2026-06-04 03:40:28'),
('58bc90dd-51a4-47e1-9dc0-c6996cea3a4a','Laravel','laravel','#FF2D20',0,'2026-06-04 03:40:28'),
('5cd3c745-362c-44e6-8c6a-3c2bda41d98c','React','react','#61DAFB',0,'2026-06-04 03:40:28'),
('7b66ecee-dbd1-433a-a968-f05f976ee75a','MySQL','mysql','#4479A1',0,'2026-06-04 03:40:28'),
('7e3039cd-2104-4d9e-bed9-8e51337990a2','Java','java','#007396',0,'2026-06-04 03:40:28'),
('90dd46fc-c79f-45ad-94e7-581f15f82258','TypeScript','typescript','#3178C6',0,'2026-06-04 03:40:28'),
('947a9070-e783-4106-847f-2084931fc558','Python','python','#3776AB',0,'2026-06-04 03:40:28'),
('d04d61e3-068b-4719-8bfc-1cf31b23735f','Tailwind CSS','tailwind-css','#06B6D4',0,'2026-06-04 03:40:28'),
('defa8a92-c167-4620-a6d3-2d37ac9c90d1','PostgreSQL','postgresql','#4169E1',0,'2026-06-04 03:40:28'),
('f4b0bff6-e9eb-46ca-9ed2-ff06e8255db7','Docker','docker','#2496ED',0,'2026-06-04 03:40:28');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` char(36) NOT NULL,
  `role_id` char(36) NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `user_roles_role_id_foreign` (`role_id`),
  CONSTRAINT `user_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_roles_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES
('05c6d6c9-0450-4904-9e08-22ec3597c7de','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-07 04:09:23'),
('061463bf-9691-4598-810a-20cd9e36145b','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-13 23:00:29'),
('1a4a8359-a3e4-46f5-963f-9ed6ce371789','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-13 23:37:35'),
('1cec8710-b813-4040-b742-5c60a6b4f739','82fa2f9f-8255-42a8-92f4-332879b0d110','2026-06-04 02:49:32'),
('2036e7f5-e6af-457a-aa4b-4ef4b824ed93','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-03 20:40:29'),
('210c02c2-19eb-4f48-b5b1-1c8396dab783','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-10 19:00:18'),
('323ab8e5-2e2e-4a19-a9a2-605e6f86ff61','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-13 23:54:00'),
('33e66497-159c-482b-9dec-dd2cea22548c','82fa2f9f-8255-42a8-92f4-332879b0d110','2026-06-03 20:40:29'),
('37beb3b7-1cc7-4659-93d7-8752ef0cbb68','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-14 04:50:40'),
('4c324d24-f559-4567-a9f6-b425c1e481ab','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-11 05:13:22'),
('50bec28e-07e2-4972-929e-1738cca5c549','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-07 23:17:13'),
('553ad0fe-7eef-4ed2-9aa8-1748f80246fb','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-13 23:39:30'),
('57d57121-800a-49b2-a261-9648d5f64d57','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-04 02:15:21'),
('5be8a241-5de1-489e-8108-3e5506c36642','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-07 04:06:49'),
('6b99676c-79b4-4782-af28-84db87b9b0d6','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-13 23:52:44'),
('6bcdcf46-ae53-4692-a8a0-aad91231948b','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-14 04:33:36'),
('71499012-4388-4c16-a05c-65af15850986','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-11 05:12:06'),
('74bcdd9d-3846-48e0-a46c-1b1d5aa08df1','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-13 23:42:06'),
('75e95c8f-1b7d-43a7-8627-9dda3a575e9d','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-14 04:31:30'),
('774642ed-4119-48b9-931d-63dfcbdcffaa','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-12 22:54:40'),
('7fb93398-3ea0-4ded-9f2d-92f11f67895b','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-14 04:38:28'),
('845d3436-2275-46bb-b4d3-7f47dbef9ea0','0deb90cf-5367-44bc-a64a-a1ca39c3b582','2026-06-03 20:40:29'),
('863214f7-c9a5-49ef-ab5f-6249baa2eea6','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-14 04:40:49'),
('89673d91-139c-4017-9fdf-2dc984d8ee64','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-07 04:24:02'),
('90ffe614-50e5-41f5-89bc-25f3814be8be','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-07 04:18:10'),
('9e8c2250-8dde-407e-8e69-cd685456312f','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-13 23:51:56'),
('ae89281f-e8bd-4bcd-b503-98ccd902e9a0','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-14 04:37:14'),
('aed20064-eabf-4f47-b1e7-bcf898c7fbe4','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-13 23:52:06'),
('be77a066-904e-49ef-b4f4-2b8b88d9f8ff','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-04 02:32:06'),
('c5b020c2-0a38-426c-9a7c-662d7f35bcb0','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-11 03:45:16'),
('eaed0e41-0d1a-4611-979b-f6b356db11c9','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-14 03:30:01'),
('efa3bcce-4f17-440b-92bc-4dad6457f054','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-03 21:33:59'),
('f1514ca9-03cb-42c0-805f-48029de8689b','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-13 23:44:46'),
('fb501bb5-6f4a-4d2d-a0ec-36f61c053067','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-14 04:19:43'),
('fe811823-f15f-4720-8ca1-4dc8c361fc5d','7261b281-1fdd-4f06-8522-f4bff64984a4','2026-06-12 09:04:12');
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` char(36) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `avatar_url` varchar(500) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `reputation_points` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `is_banned` tinyint(1) NOT NULL DEFAULT 0,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
('05c6d6c9-0450-4904-9e08-22ec3597c7de','topik','topik209@gmail.com','$2y$12$U7/UXzLrUrTpcxNNnkMRpuuKP/6cYkcrhcvI/p22jcU8aQnMXwocS',NULL,NULL,0,1,0,NULL,NULL,'2026-06-07 04:09:23','2026-06-07 04:09:23'),
('061463bf-9691-4598-810a-20cd9e36145b','Bunga Aprilia','bunga2009@gmail.com','$2y$12$WOMzuupdUNJ2YgEwG5EZberWSbdm50UQGcH5fb3uZ0H1.ApbN70l6',NULL,NULL,10,1,0,NULL,NULL,'2026-06-13 23:00:29','2026-06-13 23:00:29'),
('1a4a8359-a3e4-46f5-963f-9ed6ce371789','aprilia','aprilia@gmail.com','$2y$12$7ELsNPN5Jb4a2HZ7vAXHWOpXMh.xEkZA7371NQK3RqVPbyp6BKmO2',NULL,NULL,10,1,0,NULL,NULL,'2026-06-13 23:37:35','2026-06-13 23:37:35'),
('1cec8710-b813-4040-b742-5c60a6b4f739','budi','budi@example.com','$2y$12$cOBNhxXvy1TnyFQU8MFIPu9xIMrmLnaVguv8Onjqx/dApDU.YI9Qy',NULL,NULL,0,1,0,NULL,NULL,'2026-06-04 02:31:26','2026-06-04 02:31:26'),
('2036e7f5-e6af-457a-aa4b-4ef4b824ed93','user','user@forum.test','$2y$12$hGBkrPBB3QLBKjSqfp5Cje0xAwaMHY7senUTMAMvUkH6XAe8ZZS9u',NULL,NULL,-37,1,0,NULL,NULL,'2026-06-03 20:40:29','2026-06-14 04:25:34'),
('210c02c2-19eb-4f48-b5b1-1c8396dab783','king nasir','mel@gmail.com','$2y$12$OZd/7SFCjGRCWe5YuHhWneUJ6ODThXX8rixrijis4bivSg4W4d7Gu',NULL,NULL,0,1,0,NULL,NULL,'2026-06-10 19:00:18','2026-06-10 19:00:18'),
('323ab8e5-2e2e-4a19-a9a2-605e6f86ff61','testuser_gbx1wo','test_gbx1wo@example.com','$2y$12$d1ru4IcvRcdfIUc4Hd1qTO84pam7umHaqgPQSM8UzIidYdayYa1la',NULL,NULL,10,1,0,NULL,NULL,'2026-06-13 23:54:00','2026-06-13 23:54:00'),
('33e66497-159c-482b-9dec-dd2cea22548c','admin','admin@forum.test','$2y$12$Gudm/JZtrcX45gQbJwxl0eWRG1hruAErXThbcN7AQEIiljhknRAne',NULL,NULL,128,2,0,NULL,NULL,'2026-06-03 20:40:29','2026-06-14 03:55:22'),
('37beb3b7-1cc7-4659-93d7-8752ef0cbb68','apayak','apayak@gmail.com','$2y$12$9Es3.4TTsHniaf4NG3DzE.dGfD48UXZ0S4G2m285gkut1fAphiZD.',NULL,NULL,10,1,0,NULL,NULL,'2026-06-14 04:50:40','2026-06-14 04:50:40'),
('4c324d24-f559-4567-a9f6-b425c1e481ab','deleted_4c324d24-f559-4567-a9f6-b425c1e481ab','deleted_4c324d24-f559-4567-a9f6-b425c1e481ab@deleted.com','$2y$12$/M2uR6x4gnyi3PhQdVmou.T0E55ukSu18Hkh6AYDJ5k7jvwyx0qra',NULL,NULL,0,1,1,NULL,NULL,'2026-06-11 05:13:22','2026-06-13 08:05:25'),
('50bec28e-07e2-4972-929e-1738cca5c549','atha123','atha@gmail.com','$2y$12$eq7YVzmsiCzP1rzY9MCHb.WEVKnA1GMfJozHisTNW9KunmknZ3F5.',NULL,NULL,0,1,0,NULL,NULL,'2026-06-07 23:17:12','2026-06-07 23:17:12'),
('553ad0fe-7eef-4ed2-9aa8-1748f80246fb','ariska','ariska@gmail.com','$2y$12$MNrYf9GzkwWDy6O7ypHncOngP.2V7Ku3dJmGrzFD58tAkrSgvW3BW',NULL,NULL,10,1,0,NULL,NULL,'2026-06-13 23:39:30','2026-06-13 23:39:30'),
('57d57121-800a-49b2-a261-9648d5f64d57','tester','tester@test.com','$2y$12$d0k0CQB72LcTENhRCFIFwuwZUUrYgamy5L85MdWbsh0QNpQ.9AAE.',NULL,NULL,-92,1,1,NULL,NULL,'2026-06-04 02:15:21','2026-06-13 22:28:12'),
('5be8a241-5de1-489e-8108-3e5506c36642','piw','piww1223@gmail.com','$2y$12$26DXWZDAX4q4OzL4CvQMWu1w8rdcd7WFZCIB9/OwZ.ZLskbeUVBaS',NULL,NULL,0,1,0,NULL,NULL,'2026-06-07 04:06:49','2026-06-07 04:06:49'),
('6b99676c-79b4-4782-af28-84db87b9b0d6','testuser_hu5tkt','test_hu5tkt@example.com','$2y$12$zp6t4YEpOeJzmlCJQILBvu6xu9OlA0Wy3ItFglN0I2t.HTrxmG4TW',NULL,NULL,10,1,0,NULL,NULL,'2026-06-13 23:52:44','2026-06-13 23:52:44'),
('6bcdcf46-ae53-4692-a8a0-aad91231948b','testuser_bxu21eos','testuser_bxu21eos@example.com','$2y$12$BBcUjEkoG3I9pHzuJmK6XOC19vQqenlb7pj8LsyM/rXBdaczANirm',NULL,NULL,10,1,0,NULL,NULL,'2026-06-14 04:33:36','2026-06-14 04:33:36'),
('71499012-4388-4c16-a05c-65af15850986','atha','athaa@gmail.com','$2y$12$u1hR8lH6CAshhrnI9G3Rpu8/7zpga.PM.Gib4EjNk5HlT25IvpkAi',NULL,NULL,0,1,0,NULL,NULL,'2026-06-11 05:12:06','2026-06-11 05:12:06'),
('74bcdd9d-3846-48e0-a46c-1b1d5aa08df1','dewangga','sadewangga@gmail.com','$2y$12$Kjg8mhxkLCW73wVo1dqke.Hj6N9mT.DvZ65sHHwglMX0qljhfvIUO',NULL,NULL,10,1,0,NULL,NULL,'2026-06-13 23:42:06','2026-06-13 23:42:06'),
('75e95c8f-1b7d-43a7-8627-9dda3a575e9d','testuser_9h3dqcfi','testuser_9h3dqcfi@example.com','$2y$12$hm2dy2nEpUv5hjB2vH8mjewOfXdQT1LwbKpbLFCp64NQmrehbT0YK',NULL,NULL,10,1,0,NULL,NULL,'2026-06-14 04:31:30','2026-06-14 04:31:30'),
('774642ed-4119-48b9-931d-63dfcbdcffaa','just_bung4','bunga3@gmail.com','$2y$12$D6rUO8hFtM2kzCr6PO9OweS2dvWpxVlcBamYwhMOZBSo5/2Ydbchu',NULL,NULL,41,1,0,NULL,NULL,'2026-06-12 22:54:40','2026-06-14 03:54:53'),
('7fb93398-3ea0-4ded-9f2d-92f11f67895b','member1','member1@gmail.com','$2y$12$6ApEMzWVQmiAS13T0y1wF.0b.03L898xGRX.5Ln2jUxpmzQQtnBjG',NULL,NULL,10,1,0,NULL,NULL,'2026-06-14 04:38:28','2026-06-14 04:38:28'),
('845d3436-2275-46bb-b4d3-7f47dbef9ea0','moderator','moderator@forum.test','$2y$12$tKlpuDOqH55BudvvhtKnIuxem1FtmsryPtiUBQAexwg24NMkSRRaa',NULL,NULL,33,1,0,NULL,NULL,'2026-06-03 20:40:29','2026-06-14 03:55:10'),
('863214f7-c9a5-49ef-ab5f-6249baa2eea6','testing','testing@gmail.com','$2y$12$sRfd9XcIeXyn/u2uBfKRSuIlVd/GF6FsbU3ZkbjGbggoYt1EY6rT2',NULL,NULL,10,1,0,NULL,NULL,'2026-06-14 04:40:49','2026-06-14 04:42:21'),
('89673d91-139c-4017-9fdf-2dc984d8ee64','owi1','owi456@gmail.com','$2y$12$X8E.qicl0sRUb5Hr1QRsAe1kF6kOheVOfth4fejWtg0f2dXY6yCkK',NULL,NULL,0,1,0,NULL,NULL,'2026-06-07 04:24:02','2026-06-07 04:24:02'),
('90ffe614-50e5-41f5-89bc-25f3814be8be','owi','owi87@gmail.com','$2y$12$5532/l9iYwwuMZAP7hrqJ.mEWxIvPZMECCTt796QdNALNtTmA3KOi',NULL,NULL,0,1,0,NULL,NULL,'2026-06-07 04:18:10','2026-06-07 04:18:10'),
('9e8c2250-8dde-407e-8e69-cd685456312f','testuser_17p3l','test_17p3l@example.com','$2y$12$JyU9a2hpVauiNpOahi3TL.S8qAZaFFIbtj7oFRcMtsF0qMegixala',NULL,NULL,10,1,0,NULL,NULL,'2026-06-13 23:51:56','2026-06-13 23:51:56'),
('ae89281f-e8bd-4bcd-b503-98ccd902e9a0','member','member@gmail.com','$2y$12$tKJXu/.V.VlLBaKOaiSJyOCXHv6LNzb3kt6kE3caQiEVFmoDZ.iOG',NULL,NULL,10,1,0,NULL,NULL,'2026-06-14 04:37:14','2026-06-14 04:37:14'),
('aed20064-eabf-4f47-b1e7-bcf898c7fbe4','testuser_l11osg','test_l11osg@example.com','$2y$12$hWbbhRd5Lom9hbw4Dz7b/eG2mReBuvMnm5B190j0bNcra9f7devMy',NULL,NULL,10,1,0,NULL,NULL,'2026-06-13 23:52:06','2026-06-13 23:52:06'),
('be77a066-904e-49ef-b4f4-2b8b88d9f8ff','budi123','budi123@example.com','$2y$12$79yGozBWN1.AobH1ruC39.bL9UU2v0zfJ2Vc/kySrhfmOOglGyBYe',NULL,NULL,0,1,0,NULL,NULL,'2026-06-04 02:32:06','2026-06-04 02:32:06'),
('c5b020c2-0a38-426c-9a7c-662d7f35bcb0','baebadoobe','keylalarasati223@gmail.com','$2y$12$a/EZfP3Jas8QDUY63Y7tiegwjBAoC6lY0zmgx1wy2EJyLpBRbK05y',NULL,NULL,4,1,0,NULL,NULL,'2026-06-11 03:45:16','2026-06-13 22:28:11'),
('eaed0e41-0d1a-4611-979b-f6b356db11c9','testuser_va7ecr','test_va7ecr@example.com','$2y$12$sQnTf9Tkdq1007tsWOfTHOvKI28IOjvpOzsaZs/l7fxq3wWcMO6Zq',NULL,NULL,10,1,0,NULL,NULL,'2026-06-14 03:30:01','2026-06-14 03:30:01'),
('efa3bcce-4f17-440b-92bc-4dad6457f054','testuser','test@test.com','$2y$12$3ZxFoTnOqmnLMOes862JJOJg6kg/9TTCVM2t79IID8l95b7pPPO..',NULL,NULL,0,1,0,NULL,NULL,'2026-06-03 21:33:59','2026-06-03 21:33:59'),
('f1514ca9-03cb-42c0-805f-48029de8689b','testuser_juni_2026','testuser@june2026.com','$2y$12$pAPoEUTSiEV.dnj9ISKDVOxrfDD6k3ijjurKc3MQG./BJ0JBd28dK',NULL,NULL,10,1,0,NULL,NULL,'2026-06-13 23:44:46','2026-06-13 23:44:46'),
('fb501bb5-6f4a-4d2d-a0ec-36f61c053067','riskaw','riskaw@gmail.com','$2y$12$xiADIjvIBJ3ltnfK7sT..uVtgMNHqi/dt6OmpwenuIm348P/kkiyy',NULL,NULL,22,1,0,NULL,NULL,'2026-06-14 04:19:43','2026-06-14 04:25:52'),
('fe811823-f15f-4720-8ca1-4dc8c361fc5d','bunga','bunga@gmail.com','$2y$12$H.LxsU711XpPonejNUqMfepwXX6UMSd55KKmh.WwQXF00V98DiRnS',NULL,NULL,2,1,0,NULL,NULL,'2026-06-12 09:04:12','2026-06-13 22:28:11');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `votes`
--

DROP TABLE IF EXISTS `votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `votes` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `target_id` char(36) NOT NULL,
  `target_type` varchar(20) NOT NULL,
  `vote_type` varchar(10) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `votes_user_id_target_id_target_type_unique` (`user_id`,`target_id`,`target_type`),
  KEY `votes_target_id_target_type_index` (`target_id`,`target_type`),
  CONSTRAINT `votes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `votes`
--

LOCK TABLES `votes` WRITE;
/*!40000 ALTER TABLE `votes` DISABLE KEYS */;
INSERT INTO `votes` VALUES
('04581628-b720-4f7d-badc-b382ac696268','774642ed-4119-48b9-931d-63dfcbdcffaa','c0f3d5d4-113f-4aca-a864-c09a895f3030','comment','upvote','2026-06-14 05:23:04'),
('23775fdf-72ab-4be8-8c2b-dda1dcc0a03d','210c02c2-19eb-4f48-b5b1-1c8396dab783','ec211521-33e3-496f-890e-2534d53e9eed','post','downvote','2026-06-11 09:04:01'),
('28a095a9-eb00-48a3-b555-73929618d4cc','774642ed-4119-48b9-931d-63dfcbdcffaa','aa0dfcee-8ae7-4a23-b3b6-bf1157eb46f0','comment','upvote','2026-06-14 10:51:20'),
('2d2986b7-eaaf-4078-8f1a-5d68012442b8','c5b020c2-0a38-426c-9a7c-662d7f35bcb0','ec211521-33e3-496f-890e-2534d53e9eed','post','downvote','2026-06-13 06:17:42'),
('30fef1f0-211e-4dd8-8b2d-ff8450856441','fe811823-f15f-4720-8ca1-4dc8c361fc5d','38329261-3952-4262-a039-31c17d32db07','post','upvote','2026-06-13 05:49:58'),
('47584ea3-946f-410f-b89c-be9ba452e38e','c5b020c2-0a38-426c-9a7c-662d7f35bcb0','02c33a66-2d6a-4e1b-8530-646a72b048c4','post','downvote','2026-06-13 06:17:55'),
('79bc0799-6868-46d8-9a55-449b4338b312','33e66497-159c-482b-9dec-dd2cea22548c','6a9f674d-f498-4c1e-8d9b-3d964a2b4451','comment','downvote','2026-06-14 10:53:26'),
('8a9cac1f-6454-42b4-aa3a-f58ae189cdc1','57d57121-800a-49b2-a261-9648d5f64d57','ec211521-33e3-496f-890e-2534d53e9eed','post','upvote','2026-06-04 09:15:32'),
('90933104-5549-40fd-b496-06fbacf27a26','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','05dd4a0c-4a92-4118-be2f-b0e826b80b98','comment','upvote','2026-06-14 11:22:44'),
('9a86090d-61aa-43fa-9651-e9e26d9450e8','2036e7f5-e6af-457a-aa4b-4ef4b824ed93','ec211521-33e3-496f-890e-2534d53e9eed','post','downvote','2026-06-13 02:33:18'),
('9b2219b1-77e1-49dd-8b41-dace83083f80','fb501bb5-6f4a-4d2d-a0ec-36f61c053067','02c33a66-2d6a-4e1b-8530-646a72b048c4','post','downvote','2026-06-14 11:22:21'),
('a9a71bef-c5e5-492a-989c-f47ab5f6713a','fe811823-f15f-4720-8ca1-4dc8c361fc5d','ec211521-33e3-496f-890e-2534d53e9eed','post','downvote','2026-06-12 19:54:00'),
('ac9b4311-f130-4cc5-b432-df5744f7b050','57d57121-800a-49b2-a261-9648d5f64d57','8c4a0dc2-92e3-4987-bd28-e741a65d73a6','comment','upvote','2026-06-04 09:15:32'),
('bcd219ca-729e-4dd5-a372-a700d3cc3993','845d3436-2275-46bb-b4d3-7f47dbef9ea0','ec211521-33e3-496f-890e-2534d53e9eed','post','downvote','2026-06-13 06:35:11'),
('d1708666-b06f-4157-baf0-29a3a14cde4b','845d3436-2275-46bb-b4d3-7f47dbef9ea0','6a9f674d-f498-4c1e-8d9b-3d964a2b4451','comment','downvote','2026-06-13 07:09:56'),
('d88f9f2e-2d9e-4011-856a-9c591e581251','774642ed-4119-48b9-931d-63dfcbdcffaa','9101338f-c2af-47d4-b683-a3a10791397b','comment','upvote','2026-06-14 10:51:17');
/*!40000 ALTER TABLE `votes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-14 18:55:58

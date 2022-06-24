-- MySQL dump 10.13  Distrib 8.0.29, for Linux (x86_64)
--
-- Host: std-mysql    Database: std_1695_web_exm
-- ------------------------------------------------------
-- Server version	5.7.26-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
INSERT INTO `alembic_version` VALUES ('26a006f1b8e5');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_genre_like`
--

DROP TABLE IF EXISTS `book_genre_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_genre_like` (
  `genre_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  PRIMARY KEY (`genre_id`,`book_id`),
  KEY `fk_book_genre_like_book_id_books` (`book_id`),
  CONSTRAINT `fk_book_genre_like_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`),
  CONSTRAINT `fk_book_genre_like_genre_id_genre` FOREIGN KEY (`genre_id`) REFERENCES `genre` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_genre_like`
--

LOCK TABLES `book_genre_like` WRITE;
/*!40000 ALTER TABLE `book_genre_like` DISABLE KEYS */;
INSERT INTO `book_genre_like` VALUES (1,19),(2,19),(3,19),(2,20),(5,20),(9,20),(1,21),(4,21),(9,21),(3,22),(9,22),(9,23),(1,28),(2,28),(3,28);
/*!40000 ALTER TABLE `book_genre_like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `short_desc` text NOT NULL,
  `year` int(11) NOT NULL,
  `publisher` varchar(100) NOT NULL,
  `author` varchar(100) NOT NULL,
  `volume` int(11) NOT NULL,
  `rating_sum` int(11) NOT NULL,
  `rating_num` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (19,'Гарри Поттер и философский камень','блаблабла',2002,'Махаон','Дж. К. Роулинг',500,0,0),(20,'Дюна','# блаблаблабла',2002,'Neoclassic','Герберт Ф.',700,0,0),(21,'Метро 2033','блаблаблабла',2002,'АСТ','Глуховский Д.А.',384,0,0),(22,'Преступление и наказание','блаблаблабла',1850,'ЭКСМО','Достоевский Ф.М.',592,0,0),(23,'Собачье сердце','*блаблабла*',1900,'АСТ','Булгаков М.А.',288,11,3),(28,'Война и мир','Фигня',1812,'АСТ','Толстой',700,0,0);
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `covers`
--

DROP TABLE IF EXISTS `covers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `covers` (
  `id` varchar(100) NOT NULL,
  `mime_type` varchar(100) NOT NULL,
  `md5_hash` varchar(100) NOT NULL,
  `book_id` int(11) DEFAULT NULL,
  `file_name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_covers_md5_hash` (`md5_hash`),
  KEY `fk_covers_book_id_books` (`book_id`),
  CONSTRAINT `fk_covers_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `covers`
--

LOCK TABLES `covers` WRITE;
/*!40000 ALTER TABLE `covers` DISABLE KEYS */;
INSERT INTO `covers` VALUES ('62de5aa4-74d2-4580-84a2-311bb717d4e0','image/png','0640826460baece3d4f170c0f9dd086f',23,'2022-06-22_164930971.png'),('bc4a444d-a705-475a-8acb-776fc32f607f','image/png','b8c5dee76501f3cfd9d3d82ada4d258e',22,'2022-06-22_164708595.png'),('e8e09e14-dd70-4d60-9145-cbb1376fd0b6','image/png','73e51fd960f3c7ca8bf41865f892abdf',20,'2022-06-22_164252849.png'),('eb8bfece-b41b-451e-96ad-499148671f8f','image/png','02b4fc843d925ae21e0822b12cb48d19',19,'2022-06-22_164124111.png'),('f6e83ec1-78f2-4898-a1e9-16988b3dee2a','image/png','225c32d927f997ea4b4275fdfe069b0f',28,'book_logo.png'),('fdc40c65-c0c8-4eda-99b1-91f639567093','image/png','63e4056535044dd2ad0f6ca6388da8a6',21,'2022-06-22_164427993.png');
/*!40000 ALTER TABLE `covers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES (1,'Фантастика'),(2,'Приключения'),(3,'Детектив'),(4,'Ужасы'),(5,'Фентези'),(6,'Проза'),(9,'Роман');
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `text` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `rating` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_reviews_book_id_books` (`book_id`),
  KEY `fk_reviews_user_id_users` (`user_id`),
  CONSTRAINT `fk_reviews_book_id_books` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`),
  CONSTRAINT `fk_reviews_user_id_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,23,3,'круто','2022-06-22 17:54:20',5),(2,23,1,'норм','2022-06-22 17:57:45',4),(3,23,2,'# не оч','2022-06-22 19:15:46',2);
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin'),(2,'editor'),(3,'user');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_name` varchar(100) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `login` varchar(100) NOT NULL,
  `password_hash` varchar(200) NOT NULL,
  `role_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_users_login` (`login`),
  KEY `fk_users_role_id_roles` (`role_id`),
  CONSTRAINT `fk_users_role_id_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'userov','user',NULL,'user','pbkdf2:sha256:260000$m3l4F3qXMgTSzc00$130c89bd525502c5f15bea126c637b834c7e6a355bf149ea6d10a5155079a742',3,'2022-06-20 19:43:25'),(2,'editorov','editor',NULL,'editor','pbkdf2:sha256:260000$m3l4F3qXMgTSzc00$130c89bd525502c5f15bea126c637b834c7e6a355bf149ea6d10a5155079a742',2,'2022-06-21 16:21:56'),(3,'adminov','admin',NULL,'admin','pbkdf2:sha256:260000$m3l4F3qXMgTSzc00$130c89bd525502c5f15bea126c637b834c7e6a355bf149ea6d10a5155079a742',1,'2022-06-20 19:44:13');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visits`
--

DROP TABLE IF EXISTS `visits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `path` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_visits_user_id_users` (`user_id`),
  CONSTRAINT `fk_visits_user_id_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=657 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visits`
--

LOCK TABLES `visits` WRITE;
/*!40000 ALTER TABLE `visits` DISABLE KEYS */;
INSERT INTO `visits` VALUES (1,3,'/library/19/show','2022-06-24 16:06:06'),(3,3,'/','2022-06-24 16:06:07'),(4,3,'/','2022-06-24 16:07:54'),(5,3,'/library/23/show','2022-06-24 16:07:55'),(6,3,'/','2022-06-24 16:08:14'),(7,3,'/','2022-06-24 16:20:02'),(8,3,'/','2022-06-24 16:21:05'),(9,3,'/','2022-06-24 16:21:46'),(10,3,'/','2022-06-24 16:27:04'),(11,3,'/','2022-06-24 16:58:10'),(12,3,'/','2022-06-24 16:58:14'),(13,3,'/','2022-06-24 16:58:28'),(14,3,'/','2022-06-24 16:58:45'),(15,3,'/library/22/show','2022-06-24 16:58:49'),(16,3,'/','2022-06-24 16:59:13'),(17,3,'/','2022-06-24 17:06:19'),(18,3,'/','2022-06-24 17:07:09'),(19,3,'/','2022-06-24 17:08:00'),(20,3,'/','2022-06-24 17:08:04'),(21,3,'/','2022-06-24 17:08:59'),(22,3,'/','2022-06-24 17:09:14'),(23,3,'/','2022-06-24 17:10:54'),(24,3,'/','2022-06-24 17:12:15'),(25,3,'/','2022-06-24 17:12:23'),(26,3,'/','2022-06-24 17:18:00'),(27,3,'/','2022-06-24 17:18:14'),(28,3,'/','2022-06-24 17:18:14'),(29,3,'/library/22/show','2022-06-24 17:18:42'),(30,3,'/library/22/show','2022-06-24 17:18:43'),(31,3,'/library/22/show','2022-06-24 17:18:44'),(32,3,'/library/23/show','2022-06-24 17:18:46'),(33,3,'/library/22/show','2022-06-24 17:20:43'),(34,3,'/','2022-06-24 17:20:44'),(35,3,'/','2022-06-24 17:21:06'),(36,3,'/','2022-06-24 17:22:03'),(37,3,'/library/19/show','2022-06-24 17:22:31'),(38,3,'/','2022-06-24 17:22:34'),(39,3,'/library/19/show','2022-06-24 17:22:35'),(40,3,'/library/19/show','2022-06-24 17:22:36'),(41,3,'/library/19/show','2022-06-24 17:22:38'),(42,3,'/library/19/show','2022-06-24 17:22:39'),(43,3,'/library/19/show','2022-06-24 17:22:40'),(44,3,'/library/19/show','2022-06-24 17:22:50'),(45,3,'/','2022-06-24 17:22:51'),(46,3,'/','2022-06-24 17:22:51'),(47,3,'/library/21/show','2022-06-24 17:25:32'),(48,3,'/library/20/show','2022-06-24 17:25:33'),(49,3,'/library/22/show','2022-06-24 17:25:34'),(50,3,'/library/23/show','2022-06-24 17:25:35'),(51,3,'/library/21/show','2022-06-24 17:25:36'),(52,3,'/library/20/show','2022-06-24 17:25:37'),(53,3,'/library/19/show','2022-06-24 17:25:38'),(54,3,'/','2022-06-24 17:25:41'),(55,3,'/library/new','2022-06-24 17:25:46'),(56,3,'/library/new','2022-06-24 17:25:46'),(57,3,'/library/create','2022-06-24 17:26:02'),(58,3,'/','2022-06-24 17:26:02'),(59,3,'/','2022-06-24 17:26:03'),(60,3,'/library/27/show','2022-06-24 17:26:05'),(61,3,'/library/27/show','2022-06-24 17:26:06'),(62,3,'/','2022-06-24 17:26:10'),(63,3,'/','2022-06-24 17:26:19'),(64,3,'/','2022-06-24 17:26:21'),(65,3,'/','2022-06-24 17:26:32'),(66,3,'/','2022-06-24 17:26:48'),(67,3,'/','2022-06-24 17:27:37'),(68,3,'/','2022-06-24 17:28:24'),(69,3,'/','2022-06-24 17:28:53'),(70,3,'/','2022-06-24 17:30:27'),(71,3,'/','2022-06-24 17:31:05'),(72,3,'/','2022-06-24 17:46:39'),(73,3,'/','2022-06-24 17:48:49'),(74,3,'/','2022-06-24 18:26:43'),(75,3,'/library/new','2022-06-24 18:26:45'),(76,3,'/library/new','2022-06-24 18:26:45'),(77,3,'/','2022-06-24 18:26:46'),(78,3,'/','2022-06-24 18:26:46'),(79,3,'/library/27/show','2022-06-24 18:26:49'),(80,3,'/','2022-06-24 18:26:58'),(81,3,'/','2022-06-24 18:27:00'),(82,3,'/library/27/delete','2022-06-24 18:27:07'),(83,3,'/','2022-06-24 18:27:07'),(84,3,'/','2022-06-24 18:27:37'),(85,3,'/','2022-06-24 18:27:39'),(86,3,'/','2022-06-24 18:27:40'),(87,3,'/','2022-06-24 18:27:40'),(88,3,'/','2022-06-24 18:27:50'),(89,3,'/favicon.ico','2022-06-24 18:27:50'),(90,3,'/library/27/show','2022-06-24 18:27:52'),(91,3,'/','2022-06-24 18:28:28'),(92,3,'/','2022-06-24 18:28:59'),(93,3,'/','2022-06-24 18:32:38'),(94,3,'/','2022-06-24 18:34:22'),(95,3,'/library/new','2022-06-24 18:34:57'),(96,3,'/library/new','2022-06-24 18:34:58'),(97,3,'/library/create','2022-06-24 18:35:25'),(98,3,'/','2022-06-24 18:35:26'),(99,3,'/','2022-06-24 18:35:31'),(100,3,'/library/28/show','2022-06-24 18:35:45'),(101,3,'/library/28/show','2022-06-24 18:35:47'),(102,3,'/library/28/show','2022-06-24 18:35:48'),(103,3,'/library/28/show','2022-06-24 18:35:49'),(104,3,'/library/28/show','2022-06-24 18:35:50'),(105,3,'/library/28/show','2022-06-24 18:35:51'),(106,3,'/library/28/show','2022-06-24 18:35:52'),(107,3,'/library/28/show','2022-06-24 18:35:59'),(108,3,'/library/28/show','2022-06-24 18:36:00'),(109,3,'/library/28/show','2022-06-24 18:36:01'),(110,3,'/library/28/show','2022-06-24 18:36:02'),(111,3,'/library/28/show','2022-06-24 18:36:03'),(112,3,'/library/28/show','2022-06-24 18:36:04'),(113,3,'/library/28/show','2022-06-24 18:37:07'),(114,3,'/','2022-06-24 18:37:08'),(115,1,'/','2022-06-24 18:43:22'),(116,1,'/library/21/show','2022-06-24 18:43:24'),(117,1,'/','2022-06-24 18:43:32'),(118,1,'/','2022-06-24 18:43:33'),(119,1,'/library/28/show','2022-06-24 18:43:35'),(120,1,'/library/28/show','2022-06-24 18:43:44'),(121,1,'/library/28/show','2022-06-24 18:43:45'),(122,1,'/library/28/show','2022-06-24 18:43:46'),(123,1,'/library/28/show','2022-06-24 18:43:46'),(124,1,'/library/28/show','2022-06-24 18:43:47'),(125,1,'/library/28/show','2022-06-24 18:43:48'),(126,1,'/library/28/show','2022-06-24 18:43:48'),(127,1,'/library/28/show','2022-06-24 18:43:50'),(128,1,'/library/28/show','2022-06-24 18:43:51'),(129,1,'/','2022-06-24 18:44:13'),(130,1,'/','2022-06-24 18:44:20'),(131,1,'/','2022-06-24 18:44:21'),(132,1,'/','2022-06-24 18:46:22'),(133,1,'/','2022-06-24 18:46:31'),(134,1,'/','2022-06-24 18:46:32'),(135,1,'/','2022-06-24 18:57:41'),(136,1,'/','2022-06-24 18:57:42'),(137,1,'/','2022-06-24 18:58:01'),(138,1,'/','2022-06-24 18:58:02'),(139,1,'/','2022-06-24 19:03:08'),(140,1,'/','2022-06-24 19:03:09'),(141,1,'/','2022-06-24 19:03:14'),(142,1,'/','2022-06-24 19:03:15'),(143,1,'/','2022-06-24 19:08:30'),(144,1,'/','2022-06-24 19:08:31'),(145,1,'/','2022-06-24 19:08:32'),(146,1,'/','2022-06-24 19:08:33'),(147,1,'/','2022-06-24 19:09:17'),(148,1,'/auth/logout','2022-06-24 19:10:24'),(149,NULL,'/','2022-06-24 19:10:24'),(150,NULL,'/','2022-06-24 19:10:25'),(151,NULL,'/','2022-06-24 19:27:14'),(152,NULL,'/','2022-06-24 19:27:27'),(153,NULL,'/library/23/show','2022-06-24 19:27:34'),(154,NULL,'/','2022-06-24 19:53:56'),(155,NULL,'/library/23/show','2022-06-24 19:54:01'),(156,NULL,'/','2022-06-24 19:54:58'),(157,NULL,'/','2022-06-24 19:56:01'),(158,NULL,'/','2022-06-24 19:56:27'),(159,NULL,'/','2022-06-24 20:11:08'),(160,NULL,'/','2022-06-24 20:22:13'),(161,NULL,'/library/19/show','2022-06-24 20:22:14'),(162,NULL,'/library/23/show','2022-06-24 20:22:28'),(163,NULL,'/library/23/show','2022-06-24 20:26:49'),(164,NULL,'/library/23/show','2022-06-24 20:29:45'),(165,NULL,'/library/23/show','2022-06-24 20:29:54'),(166,NULL,'/library/23/show','2022-06-24 20:30:05'),(167,NULL,'/','2022-06-24 20:30:16'),(168,NULL,'/library/21/show','2022-06-24 20:30:20'),(169,NULL,'/library/21/show','2022-06-24 20:30:53'),(170,NULL,'/library/21/show','2022-06-24 20:31:13'),(171,NULL,'/library/21/show','2022-06-24 20:31:14'),(172,NULL,'/library/21/show','2022-06-24 20:31:15'),(173,NULL,'/library/21/show','2022-06-24 20:31:17'),(174,NULL,'/library/21/show','2022-06-24 20:31:18'),(175,NULL,'/library/21/show','2022-06-24 20:31:19'),(176,NULL,'/library/21/show','2022-06-24 20:31:20'),(177,NULL,'/','2022-06-24 20:33:45'),(178,NULL,'/library/23/show','2022-06-24 20:33:47'),(179,NULL,'/','2022-06-24 20:35:29'),(180,NULL,'/library/19/show','2022-06-24 20:35:37'),(181,NULL,'/library/19/show','2022-06-24 20:36:05'),(182,NULL,'/library/19/show','2022-06-24 20:36:55'),(183,NULL,'/library/19/show','2022-06-24 20:37:00'),(184,NULL,'/','2022-06-24 20:37:03'),(185,NULL,'/library/22/show','2022-06-24 20:37:05'),(186,NULL,'/','2022-06-24 20:37:08'),(187,NULL,'/library/21/show','2022-06-24 20:37:10'),(188,NULL,'/','2022-06-24 20:41:18'),(189,NULL,'/library/19/show','2022-06-24 20:41:28'),(190,NULL,'/library/19/show','2022-06-24 20:41:40'),(191,NULL,'/library/19/show','2022-06-24 20:41:45'),(192,NULL,'/library/19/show','2022-06-24 20:42:26'),(193,NULL,'/library/19/show','2022-06-24 20:42:29'),(194,NULL,'/','2022-06-24 20:45:39'),(195,NULL,'/library/22/show','2022-06-24 20:45:41'),(196,NULL,'/library/22/show','2022-06-24 20:45:44'),(197,NULL,'/library/22/show','2022-06-24 20:45:50'),(198,NULL,'/','2022-06-24 20:45:56'),(199,NULL,'/','2022-06-24 20:46:10'),(200,NULL,'/library/22/show','2022-06-24 20:46:14'),(201,NULL,'/library/22/show','2022-06-24 20:46:26'),(202,NULL,'/library/22/show','2022-06-24 20:47:53'),(203,NULL,'/library/22/show','2022-06-24 20:47:57'),(204,NULL,'/','2022-06-24 20:48:00'),(205,NULL,'/library/23/show','2022-06-24 20:48:01'),(206,NULL,'/library/23/show','2022-06-24 20:48:04'),(207,NULL,'/','2022-06-24 20:48:08'),(208,NULL,'/','2022-06-24 20:48:12'),(209,NULL,'/favicon.ico','2022-06-24 20:48:15'),(210,NULL,'/library/20/show','2022-06-24 20:48:15'),(211,NULL,'/','2022-06-24 20:48:16'),(212,NULL,'/','2022-06-24 20:48:17'),(213,NULL,'/','2022-06-24 20:48:18'),(214,NULL,'/library/22/show','2022-06-24 20:48:19'),(215,NULL,'/','2022-06-24 20:48:20'),(216,NULL,'/','2022-06-24 20:51:29'),(217,NULL,'/library/22/show','2022-06-24 20:51:33'),(218,NULL,'/','2022-06-24 20:55:54'),(219,NULL,'/','2022-06-24 20:56:09'),(220,NULL,'/library/20/show','2022-06-24 20:56:10'),(221,NULL,'/favicon.ico','2022-06-24 20:56:10'),(222,NULL,'/','2022-06-24 20:56:32'),(223,NULL,'/','2022-06-24 20:56:34'),(224,NULL,'/library/28/show','2022-06-24 20:56:35'),(225,NULL,'/','2022-06-24 20:56:41'),(226,NULL,'/','2022-06-24 20:58:28'),(227,NULL,'/','2022-06-24 20:59:08'),(228,NULL,'/library/20/show','2022-06-24 20:59:09'),(229,NULL,'/','2022-06-24 20:59:16'),(230,NULL,'/AES','2022-06-24 21:00:50'),(231,NULL,'/','2022-06-24 21:00:54'),(232,NULL,'/','2022-06-24 21:03:39'),(233,NULL,'/','2022-06-24 21:03:44'),(234,NULL,'/','2022-06-24 21:03:45'),(235,NULL,'/','2022-06-24 21:03:46'),(236,NULL,'/','2022-06-24 21:04:08'),(237,NULL,'/','2022-06-24 21:04:32'),(238,NULL,'/','2022-06-24 21:04:34'),(239,NULL,'/','2022-06-24 21:04:44'),(240,NULL,'/','2022-06-24 21:04:45'),(241,NULL,'/','2022-06-24 21:04:46'),(242,NULL,'/','2022-06-24 21:04:47'),(243,NULL,'/','2022-06-24 21:04:47'),(244,NULL,'/library/28/show','2022-06-24 21:04:48'),(245,NULL,'/','2022-06-24 21:04:49'),(246,NULL,'/','2022-06-24 21:04:52'),(247,NULL,'/','2022-06-24 21:05:00'),(248,NULL,'/','2022-06-24 21:05:00'),(249,NULL,'/','2022-06-24 21:06:02'),(250,NULL,'/auth/login','2022-06-24 21:06:15'),(251,NULL,'/auth/login','2022-06-24 21:06:21'),(252,2,'/','2022-06-24 21:06:21'),(253,2,'/library/19/show','2022-06-24 21:06:26'),(254,2,'/','2022-06-24 21:06:26'),(255,2,'/library/19/show','2022-06-24 21:06:27'),(256,2,'/library/19/show','2022-06-24 21:06:28'),(257,2,'/library/19/show','2022-06-24 21:06:29'),(258,2,'/','2022-06-24 21:06:31'),(259,2,'/library/19/show','2022-06-24 21:06:33'),(260,2,'/library/19/show','2022-06-24 21:06:34'),(261,2,'/library/19/show','2022-06-24 21:06:35'),(262,2,'/','2022-06-24 21:06:36'),(263,2,'/library/19/show','2022-06-24 21:06:38'),(264,2,'/library/19/show','2022-06-24 21:06:39'),(265,2,'/library/19/show','2022-06-24 21:06:40'),(266,2,'/','2022-06-24 21:06:41'),(267,2,'/','2022-06-24 21:07:08'),(268,2,'/','2022-06-24 21:31:35'),(269,2,'/','2022-06-24 21:31:53'),(270,2,'/','2022-06-24 21:32:05'),(271,2,'/library/21/show','2022-06-24 21:32:08'),(272,2,'/','2022-06-24 21:32:10'),(273,2,'/','2022-06-24 21:32:30'),(274,2,'/library/22/show','2022-06-24 21:32:32'),(275,2,'/library/22/show','2022-06-24 21:32:32'),(276,2,'/','2022-06-24 21:32:33'),(277,2,'/','2022-06-24 21:32:52'),(278,2,'/','2022-06-24 21:33:05'),(279,2,'/','2022-06-24 21:33:28'),(280,2,'/','2022-06-24 21:33:37'),(281,2,'/','2022-06-24 21:33:54'),(282,2,'/','2022-06-24 21:34:26'),(283,2,'/library/23/show','2022-06-24 21:34:30'),(284,2,'/','2022-06-24 21:34:31'),(285,2,'/','2022-06-24 21:39:21'),(286,2,'/library/22/show','2022-06-24 21:45:11'),(287,2,'/','2022-06-24 21:45:12'),(288,2,'/','2022-06-24 21:45:14'),(289,2,'/library/22/show','2022-06-24 21:45:18'),(290,2,'/','2022-06-24 21:45:19'),(291,2,'/auth/logout','2022-06-24 21:45:24'),(292,NULL,'/','2022-06-24 21:45:24'),(293,NULL,'/auth/login','2022-06-24 21:45:25'),(294,NULL,'/auth/login','2022-06-24 21:45:30'),(295,3,'/','2022-06-24 21:45:30'),(296,3,'/library/21/show','2022-06-24 21:45:33'),(297,3,'/','2022-06-24 21:45:34'),(298,3,'/','2022-06-24 21:45:40'),(299,3,'/library/21/show','2022-06-24 21:45:44'),(300,3,'/library/21/show','2022-06-24 21:45:46'),(301,3,'/','2022-06-24 21:45:46'),(302,3,'/','2022-06-24 21:46:23'),(303,3,'/','2022-06-24 21:46:30'),(304,3,'/','2022-06-24 21:46:41'),(305,3,'/library/21/show','2022-06-24 21:46:46'),(306,3,'/','2022-06-24 21:46:47'),(307,3,'/','2022-06-24 21:46:56'),(308,3,'/','2022-06-24 21:46:57'),(309,3,'/','2022-06-24 21:49:28'),(310,3,'/','2022-06-24 21:50:23'),(311,3,'/auth/logout','2022-06-24 21:50:25'),(312,NULL,'/','2022-06-24 21:50:25'),(313,NULL,'/auth/login','2022-06-24 21:50:26'),(314,NULL,'/auth/login','2022-06-24 21:50:31'),(315,1,'/','2022-06-24 21:50:31'),(316,1,'/auth/logout','2022-06-24 21:50:37'),(317,NULL,'/','2022-06-24 21:50:37'),(318,NULL,'/auth/login','2022-06-24 21:50:42'),(319,NULL,'/auth/login','2022-06-24 21:50:50'),(320,3,'/','2022-06-24 21:50:50'),(321,3,'/visits/logs','2022-06-24 21:50:51'),(322,3,'/','2022-06-24 21:50:52'),(323,3,'/auth/logout','2022-06-24 21:53:28'),(324,NULL,'/','2022-06-24 21:53:28'),(325,NULL,'/','2022-06-24 21:53:33'),(326,NULL,'/auth/login','2022-06-24 21:54:04'),(327,NULL,'/auth/login','2022-06-24 21:54:09'),(328,3,'/','2022-06-24 21:54:09'),(329,3,'/','2022-06-24 22:03:42'),(330,3,'/visits/logs','2022-06-24 22:03:59'),(331,3,'/visits/logs','2022-06-24 22:05:31'),(332,3,'/visits/logs','2022-06-24 22:05:41'),(333,3,'/visits/logs','2022-06-24 22:06:25'),(334,3,'/visits/logs','2022-06-24 22:06:48'),(335,3,'/visits/logs','2022-06-24 22:07:22'),(336,3,'/visits/logs','2022-06-24 22:09:00'),(337,3,'/visits/logs','2022-06-24 22:11:07'),(338,3,'/visits/stats/users','2022-06-24 22:11:13'),(339,3,'/visits/stats/pages','2022-06-24 22:11:17'),(340,3,'/visits/stats/users','2022-06-24 22:11:36'),(341,3,'/visits/stats/pages','2022-06-24 22:12:25'),(342,3,'/visits/stats/users','2022-06-24 22:12:26'),(343,3,'/visits/stats/users','2022-06-24 22:13:03'),(344,3,'/visits/stats/users','2022-06-24 22:14:21'),(345,3,'/visits/stats/pages','2022-06-24 22:14:24'),(346,3,'/visits/stats/users','2022-06-24 22:14:24'),(347,3,'/','2022-06-24 22:14:25'),(348,3,'/visits/logs','2022-06-24 22:14:30'),(349,3,'/visits/stats/pages','2022-06-24 22:14:31'),(350,3,'/visits/stats/users','2022-06-24 22:14:31'),(351,3,'/visits/stats/pages','2022-06-24 22:14:37'),(352,3,'/visits/stats/pages','2022-06-24 22:26:16'),(353,3,'/visits/stats/pages','2022-06-24 22:26:58'),(354,3,'/visits/stats/pages','2022-06-24 22:27:18'),(355,3,'/visits/stats/pages','2022-06-24 22:27:31'),(356,3,'/visits/stats/pages','2022-06-24 22:27:48'),(357,3,'/visits/stats/pages','2022-06-24 22:28:27'),(358,3,'/visits/stats/pages','2022-06-24 22:29:10'),(359,3,'/visits/stats/pages','2022-06-24 22:30:07'),(360,3,'/visits/stats/pages','2022-06-24 22:31:20'),(361,3,'/visits/stats/pages','2022-06-24 22:31:46'),(362,3,'/visits/stats/pages','2022-06-24 22:32:01'),(363,3,'/visits/stats/pages','2022-06-24 22:32:17'),(364,3,'/visits/stats/users','2022-06-24 22:32:22'),(365,3,'/visits/stats/pages','2022-06-24 22:32:26'),(366,3,'/visits/stats/users','2022-06-24 22:32:27'),(367,3,'/visits/stats/pages','2022-06-24 22:32:29'),(368,3,'/visits/stats/users','2022-06-24 22:32:30'),(369,3,'/visits/stats/pages','2022-06-24 22:32:58'),(370,3,'/visits/stats/users','2022-06-24 22:32:59'),(371,3,'/visits/stats/users','2022-06-24 22:33:10'),(372,3,'/visits/stats/pages','2022-06-24 22:33:13'),(373,3,'/visits/stats/users','2022-06-24 22:33:15'),(374,3,'/visits/stats/pages','2022-06-24 22:33:16'),(375,3,'/visits/stats/users','2022-06-24 22:33:17'),(376,3,'/visits/stats/pages','2022-06-24 22:33:18'),(377,3,'/visits/stats/users','2022-06-24 22:33:20'),(378,3,'/visits/stats/pages','2022-06-24 22:33:23'),(379,3,'/visits/stats/users','2022-06-24 22:33:24'),(380,3,'/visits/stats/users','2022-06-24 22:34:12'),(381,3,'/visits/stats/users','2022-06-24 22:35:47'),(382,3,'/visits/stats/users','2022-06-24 22:35:56'),(383,3,'/visits/stats/users','2022-06-24 22:36:23'),(384,3,'/visits/stats/pages','2022-06-24 22:37:04'),(385,3,'/visits/stats/users','2022-06-24 22:37:05'),(386,3,'/visits/stats/pages','2022-06-24 22:37:06'),(387,3,'/visits/stats/users','2022-06-24 22:37:07'),(388,3,'/visits/stats/pages','2022-06-24 22:37:08'),(389,3,'/visits/stats/users','2022-06-24 22:37:08'),(390,3,'/visits/stats/pages','2022-06-24 22:37:09'),(391,3,'/visits/stats/users','2022-06-24 22:37:10'),(392,3,'/visits/stats/pages','2022-06-24 22:37:11'),(393,3,'/visits/stats/users','2022-06-24 22:37:12'),(394,3,'/visits/stats/pages','2022-06-24 22:42:23'),(395,3,'/visits/stats/users','2022-06-24 22:42:50'),(396,3,'/visits/stats/users','2022-06-24 22:44:55'),(397,3,'/visits/stats/users','2022-06-24 22:50:49'),(398,3,'/visits/stats/users','2022-06-24 22:52:44'),(399,3,'/visits/stats/users','2022-06-24 22:53:11'),(400,3,'/visits/stats/users','2022-06-24 22:53:18'),(401,3,'/visits/stats/pages','2022-06-24 22:53:20'),(402,3,'/visits/stats/pages','2022-06-24 22:54:32'),(403,3,'/visits/stats/users','2022-06-24 22:54:34'),(404,3,'/visits/stats/users','2022-06-24 22:54:35'),(405,3,'/visits/stats/users','2022-06-24 22:54:37'),(406,3,'/visits/stats/users','2022-06-24 22:54:39'),(407,3,'/visits/stats/users','2022-06-24 22:54:39'),(408,3,'/visits/stats/users','2022-06-24 22:55:12'),(409,3,'/visits/stats/users','2022-06-24 22:55:13'),(410,3,'/visits/stats/users','2022-06-24 22:55:15'),(411,3,'/visits/stats/users','2022-06-24 22:55:16'),(412,3,'/visits/stats/users','2022-06-24 22:55:17'),(413,3,'/visits/stats/users','2022-06-24 22:55:18'),(414,3,'/visits/stats/users','2022-06-24 22:55:19'),(415,3,'/visits/stats/pages','2022-06-24 22:55:23'),(416,3,'/visits/stats/pages','2022-06-24 22:56:35'),(417,3,'/visits/stats/pages','2022-06-24 22:59:25'),(418,3,'/','2022-06-24 22:59:38'),(419,3,'/','2022-06-24 23:00:16'),(420,3,'/','2022-06-24 23:00:17'),(421,3,'/visits/logs','2022-06-24 23:00:18'),(422,3,'/visits/stats/users','2022-06-24 23:00:19'),(423,3,'/visits/stats/pages','2022-06-24 23:00:20'),(424,3,'/visits/stats/pages','2022-06-24 23:00:30'),(425,3,'/visits/stats/users','2022-06-24 23:00:32'),(426,3,'/visits/stats/pages','2022-06-24 23:00:33'),(427,3,'/visits/stats/users','2022-06-24 23:00:34'),(428,3,'/visits/stats/pages','2022-06-24 23:00:37'),(429,3,'/visits/stats/users','2022-06-24 23:00:40'),(430,3,'/visits/stats/users','2022-06-24 23:01:43'),(431,3,'/visits/stats/user','2022-06-24 23:23:54'),(432,3,'/visits/stats/users','2022-06-24 23:23:57'),(433,3,'/visits/stats/pages','2022-06-24 23:24:09'),(434,3,'/visits/stats/users','2022-06-24 23:25:16'),(435,3,'/visits/stats/pages','2022-06-24 23:25:20'),(436,3,'/visits/stats/users','2022-06-24 23:25:25'),(437,3,'/visits/stats/pages','2022-06-24 23:25:26'),(438,3,'/visits/stats/users','2022-06-24 23:25:27'),(439,3,'/visits/stats/pages','2022-06-24 23:25:27'),(440,3,'/visits/stats/users','2022-06-24 23:25:28'),(441,3,'/visits/stats/pages','2022-06-24 23:25:30'),(442,3,'/visits/stats/users','2022-06-24 23:25:30'),(443,3,'/visits/stats/pages','2022-06-24 23:25:32'),(444,3,'/visits/stats/pages','2022-06-24 23:28:49'),(445,3,'/visits/stats/users','2022-06-24 23:28:50'),(446,3,'/visits/stats/users','2022-06-24 23:29:05'),(447,3,'/visits/stats/pages','2022-06-24 23:29:09'),(448,3,'/visits/stats/users','2022-06-24 23:29:10'),(449,3,'/visits/stats/users','2022-06-24 23:35:25'),(450,3,'/visits/stats/users','2022-06-24 23:35:49'),(451,3,'/visits/stats/users','2022-06-24 23:36:09'),(452,3,'/visits/stats/users','2022-06-24 23:36:14'),(453,3,'/visits/stats/users','2022-06-24 23:36:37'),(454,3,'/visits/stats/users','2022-06-24 23:36:38'),(455,3,'/visits/stats/users','2022-06-24 23:44:46'),(456,3,'/visits/stats/users','2022-06-24 23:45:12'),(457,3,'/visits/stats/users','2022-06-24 23:45:23'),(458,3,'/visits/stats/users','2022-06-24 23:46:14'),(459,3,'/visits/stats/users','2022-06-24 23:46:16'),(460,3,'/visits/stats/users','2022-06-24 23:48:45'),(461,3,'/visits/stats/users','2022-06-24 23:50:11'),(462,3,'/visits/stats/users','2022-06-24 23:50:12'),(463,3,'/visits/stats/users','2022-06-24 23:50:13'),(464,3,'/visits/stats/users','2022-06-24 23:50:13'),(465,3,'/visits/stats/users','2022-06-24 23:50:14'),(466,3,'/visits/stats/users','2022-06-24 23:50:14'),(467,3,'/visits/stats/users','2022-06-24 23:50:15'),(468,3,'/visits/stats/users','2022-06-24 23:50:40'),(469,3,'/visits/stats/users','2022-06-24 23:51:15'),(470,3,'/visits/stats/users','2022-06-24 23:51:33'),(471,3,'/visits/stats/users','2022-06-24 23:54:19'),(472,3,'/visits/stats/users','2022-06-24 23:54:35'),(473,3,'/visits/stats/users','2022-06-24 23:54:42'),(474,3,'/visits/stats/users','2022-06-24 23:55:23'),(475,3,'/visits/stats/users','2022-06-24 23:55:50'),(476,3,'/visits/stats/users','2022-06-24 23:56:04'),(477,3,'/visits/stats/users','2022-06-24 23:56:17'),(478,3,'/visits/stats/users','2022-06-24 23:56:30'),(479,3,'/visits/stats/users','2022-06-24 23:56:43'),(480,3,'/visits/stats/users','2022-06-24 23:58:26'),(481,3,'/visits/stats/users','2022-06-24 23:59:31'),(482,3,'/visits/stats/users','2022-06-25 00:03:15'),(483,3,'/visits/stats/users','2022-06-25 00:03:53'),(484,3,'/visits/stats/users','2022-06-25 00:20:48'),(485,3,'/visits/stats/users','2022-06-25 00:30:30'),(486,3,'/visits/stats/users','2022-06-25 00:31:14'),(487,3,'/visits/stats/users','2022-06-25 00:31:28'),(488,3,'/visits/stats/users','2022-06-25 00:31:50'),(489,3,'/visits/stats/users','2022-06-25 00:32:06'),(490,3,'/visits/stats/users','2022-06-25 00:32:17'),(491,3,'/visits/stats/users','2022-06-25 00:32:38'),(492,3,'/visits/stats/users','2022-06-25 00:33:33'),(493,3,'/visits/stats/users','2022-06-25 00:33:41'),(494,3,'/visits/stats/users','2022-06-25 00:40:09'),(495,3,'/visits/stats/users','2022-06-25 00:40:49'),(496,3,'/visits/stats/users','2022-06-25 00:40:56'),(497,3,'/visits/stats/users','2022-06-25 00:41:05'),(498,3,'/visits/stats/users','2022-06-25 00:41:07'),(499,3,'/visits/stats/users','2022-06-25 00:41:13'),(500,3,'/visits/stats/users','2022-06-25 00:41:18'),(501,3,'/visits/stats/users','2022-06-25 00:41:21'),(502,3,'/visits/stats/users','2022-06-25 00:42:16'),(503,3,'/visits/stats/users','2022-06-25 00:42:27'),(504,3,'/visits/stats/users','2022-06-25 00:42:28'),(505,3,'/visits/stats/users','2022-06-25 00:42:30'),(506,3,'/visits/stats/users','2022-06-25 00:43:52'),(507,3,'/visits/stats/users','2022-06-25 00:45:51'),(508,3,'/visits/stats/users','2022-06-25 00:45:53'),(509,3,'/visits/stats/users','2022-06-25 00:46:36'),(510,3,'/visits/stats/users','2022-06-25 00:47:05'),(511,3,'/visits/stats/users','2022-06-25 00:47:14'),(512,3,'/visits/stats/users','2022-06-25 00:47:16'),(513,3,'/visits/stats/users','2022-06-25 00:54:47'),(514,3,'/visits/stats/users','2022-06-25 00:54:52'),(515,3,'/visits/stats/users','2022-06-25 00:54:56'),(516,3,'/visits/stats/users','2022-06-25 00:55:23'),(517,3,'/visits/stats/users','2022-06-25 00:55:26'),(518,3,'/visits/stats/users','2022-06-25 00:57:31'),(519,3,'/visits/stats/users','2022-06-25 00:57:41'),(520,3,'/visits/stats/users','2022-06-25 00:57:41'),(521,3,'/visits/stats/users','2022-06-25 00:57:41'),(522,3,'/visits/stats/users','2022-06-25 00:57:41'),(523,3,'/visits/stats/users','2022-06-25 00:57:42'),(524,3,'/visits/stats/users','2022-06-25 00:57:42'),(525,3,'/visits/stats/users','2022-06-25 00:57:42'),(526,3,'/visits/stats/users','2022-06-25 00:57:42'),(527,3,'/visits/stats/users','2022-06-25 00:58:43'),(528,3,'/visits/stats/users','2022-06-25 00:58:47'),(529,3,'/visits/stats/users','2022-06-25 00:59:14'),(530,3,'/visits/stats/users','2022-06-25 00:59:19'),(531,3,'/visits/stats/users','2022-06-25 00:59:21'),(532,3,'/visits/stats/users','2022-06-25 01:01:21'),(533,3,'/visits/stats/users','2022-06-25 01:01:27'),(534,3,'/visits/stats/users','2022-06-25 01:01:31'),(535,3,'/visits/stats/users','2022-06-25 01:01:35'),(536,3,'/visits/stats/users','2022-06-25 01:01:39'),(537,3,'/visits/stats/users','2022-06-25 01:02:08'),(538,3,'/visits/stats/users','2022-06-25 01:02:10'),(539,3,'/visits/stats/users','2022-06-25 01:02:56'),(540,3,'/visits/stats/users','2022-06-25 01:03:05'),(541,3,'/visits/stats/users','2022-06-25 01:03:22'),(542,3,'/visits/stats/users','2022-06-25 01:04:28'),(543,3,'/visits/stats/users','2022-06-25 01:05:22'),(544,3,'/visits/stats/users','2022-06-25 01:05:25'),(545,3,'/visits/stats/users','2022-06-25 01:05:27'),(546,3,'/visits/stats/users','2022-06-25 01:07:45'),(547,3,'/visits/stats/users','2022-06-25 01:07:48'),(548,3,'/visits/stats/users','2022-06-25 01:07:53'),(549,3,'/visits/stats/users','2022-06-25 01:08:49'),(550,3,'/visits/stats/users','2022-06-25 01:08:52'),(551,3,'/visits/stats/users','2022-06-25 01:08:53'),(552,3,'/visits/stats/users','2022-06-25 01:09:12'),(553,3,'/visits/stats/users','2022-06-25 01:09:16'),(554,3,'/visits/stats/users','2022-06-25 01:09:18'),(555,3,'/visits/stats/users','2022-06-25 01:09:40'),(556,3,'/visits/stats/users','2022-06-25 01:09:44'),(557,3,'/visits/stats/users','2022-06-25 01:09:45'),(558,3,'/visits/stats/users','2022-06-25 01:13:34'),(559,3,'/visits/stats/users','2022-06-25 01:14:52'),(560,3,'/visits/stats/users','2022-06-25 01:14:53'),(561,3,'/visits/stats/users','2022-06-25 01:14:54'),(562,3,'/visits/stats/users','2022-06-25 01:15:00'),(563,3,'/visits/stats/users','2022-06-25 01:15:03'),(564,3,'/visits/stats/users','2022-06-25 01:15:05'),(565,3,'/visits/stats/users','2022-06-25 01:15:07'),(566,3,'/visits/stats/users','2022-06-25 01:15:09'),(567,3,'/visits/stats/users','2022-06-25 01:15:15'),(568,3,'/visits/stats/users','2022-06-25 01:15:27'),(569,3,'/visits/stats/users','2022-06-25 01:15:35'),(570,3,'/visits/stats/users','2022-06-25 01:17:07'),(571,3,'/visits/stats/users','2022-06-25 01:17:10'),(572,3,'/visits/stats/users','2022-06-25 01:17:29'),(573,3,'/visits/stats/users','2022-06-25 01:17:34'),(574,3,'/visits/stats/users','2022-06-25 01:17:48'),(575,3,'/visits/stats/users','2022-06-25 01:18:11'),(576,3,'/visits/stats/users','2022-06-25 01:18:16'),(577,3,'/','2022-06-25 01:19:14'),(578,3,'/visits/logs','2022-06-25 01:19:18'),(579,3,'/visits/stats/users','2022-06-25 01:19:20'),(580,3,'/visits/stats/users','2022-06-25 01:19:28'),(581,3,'/visits/stats/users','2022-06-25 01:19:33'),(582,3,'/visits/stats/pages','2022-06-25 01:19:34'),(583,3,'/visits/stats/users','2022-06-25 01:19:34'),(584,3,'/visits/stats/users','2022-06-25 01:19:44'),(585,3,'/visits/stats/users','2022-06-25 01:20:14'),(586,3,'/visits/stats/users','2022-06-25 01:20:33'),(587,3,'/visits/stats/users','2022-06-25 01:20:36'),(588,3,'/visits/stats/users','2022-06-25 01:21:19'),(589,3,'/visits/stats/users','2022-06-25 01:21:24'),(590,3,'/visits/stats/users','2022-06-25 01:21:32'),(591,3,'/visits/stats/users','2022-06-25 01:22:06'),(592,3,'/visits/stats/users','2022-06-25 01:22:29'),(593,3,'/visits/stats/users','2022-06-25 01:23:37'),(594,3,'/visits/stats/users','2022-06-25 01:23:44'),(595,3,'/visits/stats/users','2022-06-25 01:24:08'),(596,3,'/visits/stats/users','2022-06-25 01:24:12'),(597,3,'/visits/stats/users','2022-06-25 01:24:30'),(598,3,'/visits/stats/users','2022-06-25 01:24:52'),(599,3,'/','2022-06-25 01:25:04'),(600,3,'/visits/logs','2022-06-25 01:25:06'),(601,3,'/visits/stats/users','2022-06-25 01:25:07'),(602,3,'/visits/stats/users','2022-06-25 01:25:14'),(603,3,'/visits/stats/users','2022-06-25 01:25:21'),(604,3,'/visits/stats/users','2022-06-25 01:25:28'),(605,3,'/visits/stats/users','2022-06-25 01:26:42'),(606,3,'/visits/stats/users','2022-06-25 01:26:47'),(607,3,'/visits/stats/users','2022-06-25 01:27:01'),(608,3,'/visits/stats/users','2022-06-25 01:27:07'),(609,3,'/visits/stats/users','2022-06-25 01:27:08'),(610,3,'/visits/stats/users','2022-06-25 01:27:09'),(611,3,'/visits/stats/users','2022-06-25 01:27:15'),(612,3,'/visits/stats/users','2022-06-25 01:27:18'),(613,3,'/visits/stats/users','2022-06-25 01:27:20'),(614,3,'/visits/stats/users','2022-06-25 01:27:21'),(615,3,'/','2022-06-25 01:30:01'),(616,3,'/auth/logout','2022-06-25 01:30:28'),(617,NULL,'/','2022-06-25 01:30:28'),(618,NULL,'/','2022-06-25 01:30:37'),(619,NULL,'/library/19/show','2022-06-25 01:30:45'),(620,NULL,'/','2022-06-25 01:30:50'),(621,NULL,'/library/23/show','2022-06-25 01:30:51'),(622,NULL,'/','2022-06-25 01:31:00'),(623,NULL,'/','2022-06-25 01:31:13'),(624,NULL,'/library/21/show','2022-06-25 01:31:20'),(625,NULL,'/','2022-06-25 01:31:23'),(626,NULL,'/library/22/show','2022-06-25 01:31:24'),(627,NULL,'/','2022-06-25 01:31:38'),(628,NULL,'/auth/login','2022-06-25 01:33:17'),(629,NULL,'/auth/login','2022-06-25 01:33:20'),(630,NULL,'/','2022-06-25 01:33:53'),(631,NULL,'/auth/login','2022-06-25 01:33:54'),(632,NULL,'/auth/login','2022-06-25 01:36:10'),(633,NULL,'/auth/login','2022-06-25 01:36:10'),(634,NULL,'/','2022-06-25 01:36:24'),(635,NULL,'/','2022-06-25 01:36:36'),(636,NULL,'/auth/login','2022-06-25 01:36:38'),(637,NULL,'/auth/login','2022-06-25 01:36:54'),(638,NULL,'/auth/login','2022-06-25 01:37:13'),(639,NULL,'/','2022-06-25 01:37:28'),(640,NULL,'/auth/login','2022-06-25 01:37:29'),(641,NULL,'/auth/login','2022-06-25 01:37:35'),(642,NULL,'/auth/login','2022-06-25 01:37:37'),(643,3,'/','2022-06-25 01:37:37'),(644,3,'/visits/logs','2022-06-25 01:37:39'),(645,3,'/','2022-06-25 01:37:41'),(646,3,'/visits/logs','2022-06-25 01:37:45'),(647,3,'/visits/logs','2022-06-25 01:38:00'),(648,3,'/visits/stats/users','2022-06-25 01:38:02'),(649,3,'/visits/stats/users','2022-06-25 01:38:26'),(650,3,'/visits/stats/users','2022-06-25 01:38:37'),(651,3,'/visits/stats/pages','2022-06-25 01:38:39'),(652,3,'/visits/stats/users','2022-06-25 01:38:40'),(653,3,'/visits/stats/pages','2022-06-25 01:38:42'),(654,3,'/visits/stats/users','2022-06-25 01:38:43'),(655,3,'/','2022-06-25 01:38:54'),(656,NULL,'/','2022-06-25 01:44:38');
/*!40000 ALTER TABLE `visits` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-06-25  1:48:55

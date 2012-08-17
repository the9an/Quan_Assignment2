-- MySQL dump 10.13  Distrib 5.1.61, for redhat-linux-gnu (x86_64)
--
-- Host: localhost    Database: Quan_forum
-- ------------------------------------------------------
-- Server version	5.1.61

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `access`
--

DROP TABLE IF EXISTS `access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `access` (
  `access_id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(8) unsigned NOT NULL,
  `topic_id` int(8) unsigned NOT NULL,
  `permission_id` int(8) unsigned NOT NULL,
  PRIMARY KEY (`access_id`),
  KEY `role_id` (`role_id`),
  KEY `topic_id` (`topic_id`),
  KEY `permission_id` (`permission_id`),
  CONSTRAINT `access_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`),
  CONSTRAINT `access_ibfk_2` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`topic_id`),
  CONSTRAINT `access_ibfk_3` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access`
--

LOCK TABLES `access` WRITE;
/*!40000 ALTER TABLE `access` DISABLE KEYS */;
/*!40000 ALTER TABLE `access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permission` (
  `permission_id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `permission_name` varchar(20) NOT NULL,
  PRIMARY KEY (`permission_id`),
  UNIQUE KEY `permission_name` (`permission_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
/*!40000 ALTER TABLE `permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post`
--

DROP TABLE IF EXISTS `post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `post` (
  `post_id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `post_thread_id` int(8) unsigned NOT NULL,
  `post_body` longtext COLLATE utf8_unicode_ci NOT NULL,
  `post_created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `post_last_modified` timestamp NULL DEFAULT NULL,
  `post_owner` int(8) unsigned NOT NULL,
  `post_image` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`post_id`),
  KEY `post_owner` (`post_owner`),
  KEY `post_thread_id` (`post_thread_id`),
  KEY `fk_post_1_idx` (`post_thread_id`),
  CONSTRAINT `post_ibfk_1` FOREIGN KEY (`post_thread_id`) REFERENCES `thread` (`thread_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `post_ibfk_2` FOREIGN KEY (`post_owner`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post`
--

LOCK TABLES `post` WRITE;
/*!40000 ALTER TABLE `post` DISABLE KEYS */;
INSERT INTO `post` VALUES (36,1,'Thu upload image','2012-08-16 13:45:48',NULL,2,'/upload/283765_392134360854225_468948806_n.jpg'),(39,4,'thu ','2012-08-16 15:36:44',NULL,1,'/upload/283765_392134360854225_468948806_n.jpg'),(40,6,'<p>cai nay o <a href=\"http://google.com.vn\">http://google.com.vn</a> va  google.com.vn</p>','2012-08-17 14:11:00',NULL,2,NULL),(41,6,'<p><a href=\"mailto:thequan1989@gmail.com\">thequan1989@gmail.com</a></p>','2012-08-17 14:12:11',NULL,2,NULL),(42,1,'<p>ngay mua gio</p>','2012-08-17 16:12:32',NULL,1,NULL);
/*!40000 ALTER TABLE `post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role` (
  `role_id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  `role_description` mediumtext,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'admin','can create edit delete all user, topic, thread'),(2,'mod','can create edit delete all topic, thread'),(3,'register','can crete a thread, a post.'),(4,'guest','can create a post');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_user`
--

DROP TABLE IF EXISTS `role_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `role_user` (
  `role_user_id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(8) unsigned NOT NULL,
  `user_id` int(8) unsigned NOT NULL,
  PRIMARY KEY (`role_user_id`),
  KEY `user_id` (`user_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `role_user_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`),
  CONSTRAINT `role_user_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_user`
--

LOCK TABLES `role_user` WRITE;
/*!40000 ALTER TABLE `role_user` DISABLE KEYS */;
INSERT INTO `role_user` VALUES (1,1,1),(2,4,2),(3,3,3),(4,3,4);
/*!40000 ALTER TABLE `role_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thread`
--

DROP TABLE IF EXISTS `thread`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `thread` (
  `thread_id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `topic_id` int(8) unsigned NOT NULL,
  `thread_title` text COLLATE utf8_unicode_ci NOT NULL,
  `thread_created_date` datetime NOT NULL,
  `topic_owner` int(8) unsigned NOT NULL,
  `status` varchar(16) COLLATE utf8_unicode_ci DEFAULT 'active',
  `thread_content` longtext COLLATE utf8_unicode_ci NOT NULL,
  `last_post_time` timestamp NULL DEFAULT NULL,
  `thread_image` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`thread_id`),
  KEY `topic_id` (`topic_id`),
  KEY `topic_owner` (`topic_owner`),
  CONSTRAINT `thread_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`topic_id`),
  CONSTRAINT `thread_ibfk_2` FOREIGN KEY (`topic_owner`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thread`
--

LOCK TABLES `thread` WRITE;
/*!40000 ALTER TABLE `thread` DISABLE KEYS */;
INSERT INTO `thread` VALUES (1,1,'会話 1','2012-08-16 06:45:48',1,'active','会話は話題の伝達を目的とせずに、話すことで共通の価値観を共有したり、共通の時間を分かち合ったりすることに着眼点があるものである。また、話すことでストレスを解消する機能もある。\n\n会話はしばしばキャッチボールに喩えられる。キャッチボールは向かい合った二人ないし複数人数が相互にボールを投げ、投げられたボールを相手が受け取って投げ返す遊びであるが、会話も相互に相手に話題を投げ掛け、その返答を期待するものである。片方が一方的に喋っていたり、お互いに相手の話題に関係なく自分の言いたいことを述べ合っているという「ラジオを2台ないしそれ以上並べて、別々の番組を流している」のと大差ないような場合は、会話の範疇には含まれない。このため会話の場合は「相手が話題を返し易いよう、その内容を選ぶ」という性質を持つ。\n\n近年では電話やインターネットといった通信媒体（→伝送路）の発達にも伴い、電話越しに対話したり、あるいはインターネット上のシステムの働きにより文字を介して行う電子掲示板やチャットなどの様式も見られ、またこれらの発展系であるテレビ電話やボイスチャットも利用され始めている。またこういったシステムは、複数人数で会話する用途にも利用されており、単なる日常の話題から社会問題に関する議論まで、様々な話題での会話が見られる。\n\nこれらは個人に内在する情報を相互に投げ掛けあう性質のものであり、共通認識を育んだり、社会性を育んだりする一方、デマや噂・風説・集団思考（「集団浅慮」とも）のような誤情報の共有といった問題行動の一助ともなりうる行為でもある。\n\nただ問題面を考慮しても会話は多くの場合において好ましいものだと認識されており、また多くの者が好む傾向が見られる。','2012-08-17 16:12:32',NULL),(2,1,'会話 2','2012-08-14 11:16:59',1,'active','dfsfs','2012-08-14 18:16:59',NULL),(4,1,'ngay dep troi','2012-08-16 07:11:03',1,'active','Hom nay la moi ngay dep troi','2012-08-16 15:36:44',NULL),(6,1,'Ngay nang','2012-08-16 16:28:43',3,'active','','2012-08-17 14:12:11','/upload/283765_392134360854225_468948806_n.jpg');
/*!40000 ALTER TABLE `thread` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topic` (
  `topic_id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `topic_name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int(8) unsigned NOT NULL,
  `actived` bit(1) DEFAULT NULL,
  PRIMARY KEY (`topic_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `topic_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic`
--

LOCK TABLES `topic` WRITE;
/*!40000 ALTER TABLE `topic` DISABLE KEYS */;
INSERT INTO `topic` VALUES (1,'かな入門','2012-08-10 15:19:05',1,''),(2,'漢字','2012-08-10 15:19:40',1,''),(3,'聴解ﾀｽｸ25','2012-08-10 15:20:23',1,''),(4,'やさしい作文','2012-08-10 15:20:23',1,'');
/*!40000 ALTER TABLE `topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `user_id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `password` varchar(128) NOT NULL,
  `created_date` datetime NOT NULL,
  `status` char(16) NOT NULL DEFAULT 'active',
  `avatar` varchar(260) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_name` (`user_name`,`user_email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'quan','thequan1989@gmail.com','3d4f2bf07dc1be38b20cd6e46949a1071f9d0e3d','2012-08-09 06:50:05','active',NULL),(2,'guest','guest@guest.co','356a192b7913b04c54574d18c28d46e6395428ab','2012-08-13 04:05:47','active',NULL),(3,'honglinh','honglinh@gmail.com','7c222fb2927d828af22f592134e8932480637c0d','2012-08-16 15:02:37','active',NULL),(4,'thequan','thequan@gmail.com','7c4a8d09ca3762af61e59520943dc26494f8941b','2012-08-17 16:50:21','active',NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-08-17 12:35:46

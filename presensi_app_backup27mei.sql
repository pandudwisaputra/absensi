-- MySQL dump 10.13  Distrib 8.0.33, for Linux (x86_64)
--
-- Host: localhost    Database: presensi_app
-- ------------------------------------------------------
-- Server version	8.0.33-0ubuntu0.22.04.1

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
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id_admin` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `name` varchar(150) NOT NULL,
  `email` varchar(150) NOT NULL,
  `image` varchar(150) NOT NULL,
  `password` varchar(260) NOT NULL,
  `is_active` int NOT NULL,
  `date_created` int NOT NULL,
  `temp` int NOT NULL,
  PRIMARY KEY (`temp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES ('0','SuperAdmin','admin@gmail.com','default.png','$2y$10$hWI2gkMUd9sX06bgXu6QIO7GPIlqUHEeMAd3AC5qqXCIX7N5qv.AS',1,1601653500,1),('U-002','Satria Rahmat Putra','satriarahmatputra27@gmail.com','IMG-20191227-WA0007.jpg','$2y$10$4w9hk01ePGyvZEr54Eja6OGuARwAxMTaXxdOiySzsaesnvo.Sy.Sq',1,1639548735,2),('U-003','feby','feby@gmail.com','DSC_0560.JPG','$2y$10$4w9hk01ePGyvZEr54Eja6OGuARwAxMTaXxdOiySzsaesnvo.Sy.Sq',1,1640092634,3),('1','a','a@gmail.com','mesti disimak.png','12345',4,4,4);
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jabatan`
--

DROP TABLE IF EXISTS `jabatan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jabatan` (
  `id_jabatan` int NOT NULL,
  `salary` varchar(50) DEFAULT NULL,
  `jabatan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `overtime` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_jabatan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jabatan`
--

LOCK TABLES `jabatan` WRITE;
/*!40000 ALTER TABLE `jabatan` DISABLE KEYS */;
INSERT INTO `jabatan` VALUES (0,'900000','Midle Programmer','20000'),(1,'900000','Senior Progammer','10000');
/*!40000 ALTER TABLE `jabatan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `karyawan`
--

DROP TABLE IF EXISTS `karyawan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `karyawan` (
  `id_karyawan` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_jabatan` int NOT NULL,
  `nama_lengkap` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `foto` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `alamat` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `agama` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `no_hp` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `pendidikan` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_karyawan`),
  KEY `karyawan_FK` (`id_jabatan`),
  CONSTRAINT `karyawan_FK` FOREIGN KEY (`id_jabatan`) REFERENCES `jabatan` (`id_jabatan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `karyawan`
--

LOCK TABLES `karyawan` WRITE;
/*!40000 ALTER TABLE `karyawan` DISABLE KEYS */;
INSERT INTO `karyawan` VALUES ('MARS001',1,'PANDU DWI SAPUTRA','kapan 3.jpg','Madiun Kota','Islam','pandudwisaputra0@gmail.com','082995886778','S1 Teknik Informatika'),('MARS002',1,'RENDRA TRI KUSUMA','j.jpg','Madiun','Islam','rendratrykusuma@gmail.com','0818829172918','TEKNIK INFORMATIKA'),('MARS003',1,'RIDHO','p.jpg','Madiun','Islam','ridhorifai960@gmail.com','081223443225','Teknik ');
/*!40000 ALTER TABLE `karyawan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `office`
--

DROP TABLE IF EXISTS `office`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `office` (
  `id` int NOT NULL,
  `nama_kantor` varchar(100) NOT NULL,
  `alamat` varchar(200) NOT NULL,
  `latitude` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `longitude` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `jam_masuk` varchar(100) NOT NULL,
  `jam_pulang` varchar(100) NOT NULL,
  `set_radius_presensi` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `office`
--

LOCK TABLES `office` WRITE;
/*!40000 ALTER TABLE `office` DISABLE KEYS */;
INSERT INTO `office` VALUES (1,'PT MARSTECH GLOBAL','Jln. Margatama Asri IV No.3, Kanigoro, Kec.Kartoharjo, Kota Madiun','-7.636915','111.542653','08.00','17.00','50');
/*!40000 ALTER TABLE `office` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp`
--

DROP TABLE IF EXISTS `otp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `otp` (
  `id_otp` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `no_hp` varchar(100) DEFAULT NULL,
  `otp` varchar(6) DEFAULT NULL,
  `time_otp` varchar(26) NOT NULL,
  PRIMARY KEY (`id_otp`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp`
--

LOCK TABLES `otp` WRITE;
/*!40000 ALTER TABLE `otp` DISABLE KEYS */;
INSERT INTO `otp` VALUES (1,'rendratry1@gmail.com','','8018','2022-12-06 04:48:58'),(2,'rendratry1@gmail.com','','5252','2022-12-14 04:38:33'),(3,'rendratry1@gmail.com','','3356','2023-01-24 02:44:50'),(4,'rendratry1@gmail.com','','6947','�'),(5,'rendratry1@gmail.com','','2676','1674530126198'),(6,'rendratry1@gmail.com','','4484','1674541432111'),(7,'rendratry1@gmail.com','','7898','1674541477196'),(8,'rendratry1@gmail.com','','5990','1674618495066'),(9,'rendratry1@gmail.com','','2160','1675397186061'),(14,'pandudwisaputra0@gmail.com','','1070','1675479568020'),(15,'pandudwisaputra0@gmail.com','','0594','1675479999831'),(16,'pandudwisaputra0@gmail.com','','7162','1675480365914'),(17,'rendratrikusuma@student.uns.ac.id','','2475','1675480870058'),(18,'ridhorifai960@gmail.com','','5923','1675481472909'),(19,'kaudia897@gmail.com','','8631','1675481524717'),(20,'rendratry1@gmail.com','','0281','1675481744614'),(21,'yanto@gmail.com','','4992','1675482968195'),(22,'yanto@gmail.com','','1941','1675483185930'),(23,'pandudwisaputra0@gmail.com','','3752','1675484503265'),(24,'yanto@gmail.com','','3711','1675485680982'),(25,'yanto@gmail.com','','1671','1675485994156'),(26,'yanto@gmail.com','','4318','1675485998305'),(27,'yanto@gmail.com','','4626','1675486075604'),(28,'yanto@gmail.com','','8324','1675486089884'),(29,'yanto@gmail.com','','4646','1675486101877'),(30,'yanto@gmail.com','','2438','1675486226485'),(31,'yanto@gmail.com','','4071','1675486232180'),(32,'yanto@gmail.com','','4387','1675486296991'),(33,'yanto@gmail.com','','2733','1675486343558'),(34,'yanto@gmail.com','','2055','1675486537420'),(35,'yanto@gmail.com','','7169','1675486592946'),(36,'yanto@gmail.com','','6725','1675486610218'),(37,'yanto@gmail.com','','5210','1675486636538'),(38,'yanto@gmail.com','','4699','1675486656967'),(39,'yanto@gmail.com','','9272','1675486670859'),(40,'yanto@gmail.com','','3085','1675486737911'),(41,'yanto@gmail.com','','6116','1675486769648'),(42,'pandudwisaputra0@gmail.com','','1079','1675486814349'),(43,'pandudwisaputra0@gmail.com','','2061','1675486944634'),(44,'pandudwisaputra0@gmail.com','','4377','1675487290820'),(45,'pandudwisaputra0@gmail.com','','2780','1675492473659'),(46,'pandudwisaputra0@gmail.com','','7155','1675492494063'),(47,'pandudwisaputra0@gmail.com','','8000','1675492529351'),(48,'pandudwisaputra0@gmail.com','','0158','1675492967305'),(49,'rendratry1@gmail.com','','5612','1675493837240'),(50,'pandudwisaputra0@gmail.com','','6044','1675493852002'),(51,'pandudwisaputra0@gmail.com','','7689','1675498414944'),(52,'pandudwisaputra0@gmail.com','','5716','1675498666451'),(53,'pandudwisaputra0@gmail.com','','3495','1675498959671'),(54,'pandudwisaputra0@gmail.com','','5046','1675499073691'),(55,'pandudwisaputra0@gmail.com','','6343','1675499840683'),(56,'pandudwisaputra0@gmail.com','','9616','1675499993155'),(57,'pandudwisaputra0@gmail.com','','1921','1675500562383'),(58,'pandudwisaputra0@gmail.com','','6463','1675501107878'),(59,'pandudwisaputra0@gmail.com','','1464','1675501252321'),(60,'pandudwisaputra0@gmail.com','','3315','1675510986493'),(61,'pandudwisaputra0@gmail.com','','5594','1675511380806'),(62,'rendratry1@gmail.com','','5680','1675570880303'),(63,'pandudwisaputra0@gmail.com','','3385','1675571300965'),(64,'rendratrykusuma@gmail.com','','6552','1675753829554'),(65,'ridhorifai88@student.uns.ac.id','','0175','1675753893376'),(66,'pandudwisaputra0@gmail.com','','1024','1675907679774'),(67,'pandudwisaputra0@gmail.com','','9259','1675908028865'),(68,'pandudwisaputra0@gmail.com','','0559','1675908386447'),(69,'pandudwisaputra0@gmail.com','','5475','1675908872248'),(70,'pandudwisaputra0@gmail.com','','6395','1675909702080'),(71,'pandudwisaputra0@gmail.com','','2284','1675909726585'),(72,'pandudwisaputra0@gmail.com','','6540','1675923472585'),(73,'rendratry1@gmail.com','','6474','1675956340598'),(74,'pandudwisaputra0@gmail.com','','7508','1676210041626'),(75,'pandu@gmail.com','','3105','1676368635235'),(76,'pandudwisaputra0@gmail.com','','7787','1676378043736'),(77,'pandudwisaputra0@gmail.com','','3501','1676378167525'),(78,'pandudwisaputra0@gmail.com','','3216','1676378603078'),(79,'pandudwisaputra0@gmail.com','','4026','1676430213948'),(80,'pandudwisaputra0@gmail.com','','3644','1676431167902'),(81,'pandudwisaputra0@gmail.com','','1552','1676431688975'),(82,'pandudwisaputra0@gmail.com','','0662','1676431695616'),(83,'pandudwisaputra0@gmail.com','','8396','1676433673901'),(84,'pandu@gmail.com','','2997','1676436580660'),(85,'pandudwisaputra0@gmail.com','','2799','1676436623987'),(86,'pandudwisaputra0@gmail.com','','2149','1676437080132'),(87,'pandudwisaputra0@gmail.com','','9680','1676515184247'),(88,'pandudwisaputra0@gmail.com','','4011','1676515561661'),(89,'pandudwisaputra0@gmail.com','','0908','1676516023032'),(90,'pandudwisaputra0@gmail.com','','2904','1676542056305'),(91,'rendratrykusuma@gmail.com','','3571','1676627495426'),(92,'rendratrykusuma@gmail.com','','2357','1676627567290'),(93,'rendratrykusuma@gmail.com','','1425','1676627851783'),(94,'rendratrykusuma@gmail.com','','9180','1676628349801'),(95,'rendratrykusuma@gmail.com','','2775','1676628593121'),(96,'ridhorifai960@gmail.com','','1583','1676629339532'),(97,'ridhorifai960@gmail.com','','3721','1676629545186'),(98,'pandudwisaputra0@gmail.com','','8861','1677564611423'),(99,'pandudwisaputra0@gmail.com','','7469','1684848496342'),(100,'pandudwisaputra0@gmail.com','','3330','1684997284289'),(101,'pandudwisaputra0@gmail.com','','6674','1684997734234'),(102,'pandudwisaputra0@gmail.com','','6694','1685078707277'),(103,'pandudwisaputra0@gmail.com','','1104','1685162467368'),(104,'pandudwisaputra0@gmail.com','','0583','1685172288776'),(105,'pandudwisaputra0@gmail.com','','5991','1685172575627'),(106,'pandudwisaputra0@gmail.com','','3610','1685172803256');
/*!40000 ALTER TABLE `otp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `presensi_masuk`
--

DROP TABLE IF EXISTS `presensi_masuk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `presensi_masuk` (
  `id_presensi` int NOT NULL AUTO_INCREMENT,
  `id_user` int NOT NULL,
  `tanggal_presensi` varchar(100) NOT NULL,
  `jam_masuk` varchar(100) NOT NULL,
  `jam_keluar` varchar(100) DEFAULT NULL,
  `tanggal_keluar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `keterangan_masuk` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `keterangan_keluar` varchar(100) DEFAULT NULL,
  `latitude` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `longitude` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `alamat` varchar(200) NOT NULL,
  `status_presensi` varchar(100) DEFAULT NULL,
  `keterangan_tidak_masuk` varchar(255) NOT NULL,
  `link_bukti` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id_presensi`),
  KEY `presensi_masuk_fk` (`id_user`),
  CONSTRAINT `presensi_masuk_fk` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `presensi_masuk`
--

LOCK TABLES `presensi_masuk` WRITE;
/*!40000 ALTER TABLE `presensi_masuk` DISABLE KEYS */;
/*!40000 ALTER TABLE `presensi_masuk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id_user` int NOT NULL AUTO_INCREMENT,
  `id_karyawan` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(200) DEFAULT NULL,
  `ava` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id_user`),
  KEY `user_FK` (`id_karyawan`),
  CONSTRAINT `user_FK` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan` (`id_karyawan`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (12,'MARS001','pandudwisaputra0@gmail.com','$2a$10$u6GFf/89tuZt7VkLXWU6Zugy56UfxizUbPNvtEOd8.ZBrl84ZN1CG','-');
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

-- Dump completed on 2023-05-27  9:19:17

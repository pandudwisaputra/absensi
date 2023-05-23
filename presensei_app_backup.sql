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
  `jabatan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
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
INSERT INTO `karyawan` VALUES ('MARS001',1,'PANDU DWI SAPUTRA','kapan 3.jpg','Madiun Kota','Islam','pandudwisaputra0@gmail.com','082995886778','S1 Teknik Informatika',''),('MARS002',1,'RENDRA TRI KUSUMA','j.jpg','Madiun','Islam','rendratrykusuma@gmail.com','0818829172918','TEKNIK INFORMATIKA',' '),('MARS003',1,'RIDHO','p.jpg','Madiun','Islam','ridhorifai960@gmail.com','081223443225','Teknik ',' ');
/*!40000 ALTER TABLE `karyawan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `office`
--

DROP TABLE IF EXISTS `office`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `office` (
  `nama_kantor` varchar(100) NOT NULL,
  `alamat` varchar(200) NOT NULL,
  `latitude` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `longitude` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `jam_masuk` varchar(100) NOT NULL,
  `jam_pulang` varchar(100) NOT NULL,
  `set_radius_presensi` varchar(100) NOT NULL,
  `id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `office`
--

LOCK TABLES `office` WRITE;
/*!40000 ALTER TABLE `office` DISABLE KEYS */;
INSERT INTO `office` VALUES ('PT MARSTECH GLOBAL','Jln. Margatama Asri IV No.3, Kanigoro, Kec.Kartoharjo, Kota Madiun','-7.636915','111.542653','08:57','10:16','50',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp`
--

LOCK TABLES `otp` WRITE;
/*!40000 ALTER TABLE `otp` DISABLE KEYS */;
INSERT INTO `otp` VALUES (1,'rendratry1@gmail.com','','8018','2022-12-06 04:48:58'),(2,'rendratry1@gmail.com','','5252','2022-12-14 04:38:33'),(3,'rendratry1@gmail.com','','3356','2023-01-24 02:44:50'),(4,'rendratry1@gmail.com','','6947','�'),(5,'rendratry1@gmail.com','','2676','1674530126198'),(6,'rendratry1@gmail.com','','4484','1674541432111'),(7,'rendratry1@gmail.com','','7898','1674541477196'),(8,'rendratry1@gmail.com','','5990','1674618495066'),(9,'rendratry1@gmail.com','','2160','1675397186061'),(14,'pandudwisaputra0@gmail.com','','1070','1675479568020'),(15,'pandudwisaputra0@gmail.com','','0594','1675479999831'),(16,'pandudwisaputra0@gmail.com','','7162','1675480365914'),(17,'rendratrikusuma@student.uns.ac.id','','2475','1675480870058'),(18,'ridhorifai960@gmail.com','','5923','1675481472909'),(19,'kaudia897@gmail.com','','8631','1675481524717'),(20,'rendratry1@gmail.com','','0281','1675481744614'),(21,'yanto@gmail.com','','4992','1675482968195'),(22,'yanto@gmail.com','','1941','1675483185930'),(23,'pandudwisaputra0@gmail.com','','3752','1675484503265'),(24,'yanto@gmail.com','','3711','1675485680982'),(25,'yanto@gmail.com','','1671','1675485994156'),(26,'yanto@gmail.com','','4318','1675485998305'),(27,'yanto@gmail.com','','4626','1675486075604'),(28,'yanto@gmail.com','','8324','1675486089884'),(29,'yanto@gmail.com','','4646','1675486101877'),(30,'yanto@gmail.com','','2438','1675486226485'),(31,'yanto@gmail.com','','4071','1675486232180'),(32,'yanto@gmail.com','','4387','1675486296991'),(33,'yanto@gmail.com','','2733','1675486343558'),(34,'yanto@gmail.com','','2055','1675486537420'),(35,'yanto@gmail.com','','7169','1675486592946'),(36,'yanto@gmail.com','','6725','1675486610218'),(37,'yanto@gmail.com','','5210','1675486636538'),(38,'yanto@gmail.com','','4699','1675486656967'),(39,'yanto@gmail.com','','9272','1675486670859'),(40,'yanto@gmail.com','','3085','1675486737911'),(41,'yanto@gmail.com','','6116','1675486769648'),(42,'pandudwisaputra0@gmail.com','','1079','1675486814349'),(43,'pandudwisaputra0@gmail.com','','2061','1675486944634'),(44,'pandudwisaputra0@gmail.com','','4377','1675487290820'),(45,'pandudwisaputra0@gmail.com','','2780','1675492473659'),(46,'pandudwisaputra0@gmail.com','','7155','1675492494063'),(47,'pandudwisaputra0@gmail.com','','8000','1675492529351'),(48,'pandudwisaputra0@gmail.com','','0158','1675492967305'),(49,'rendratry1@gmail.com','','5612','1675493837240'),(50,'pandudwisaputra0@gmail.com','','6044','1675493852002'),(51,'pandudwisaputra0@gmail.com','','7689','1675498414944'),(52,'pandudwisaputra0@gmail.com','','5716','1675498666451'),(53,'pandudwisaputra0@gmail.com','','3495','1675498959671'),(54,'pandudwisaputra0@gmail.com','','5046','1675499073691'),(55,'pandudwisaputra0@gmail.com','','6343','1675499840683'),(56,'pandudwisaputra0@gmail.com','','9616','1675499993155'),(57,'pandudwisaputra0@gmail.com','','1921','1675500562383'),(58,'pandudwisaputra0@gmail.com','','6463','1675501107878'),(59,'pandudwisaputra0@gmail.com','','1464','1675501252321'),(60,'pandudwisaputra0@gmail.com','','3315','1675510986493'),(61,'pandudwisaputra0@gmail.com','','5594','1675511380806'),(62,'rendratry1@gmail.com','','5680','1675570880303'),(63,'pandudwisaputra0@gmail.com','','3385','1675571300965'),(64,'rendratrykusuma@gmail.com','','6552','1675753829554'),(65,'ridhorifai88@student.uns.ac.id','','0175','1675753893376'),(66,'pandudwisaputra0@gmail.com','','1024','1675907679774'),(67,'pandudwisaputra0@gmail.com','','9259','1675908028865'),(68,'pandudwisaputra0@gmail.com','','0559','1675908386447'),(69,'pandudwisaputra0@gmail.com','','5475','1675908872248'),(70,'pandudwisaputra0@gmail.com','','6395','1675909702080'),(71,'pandudwisaputra0@gmail.com','','2284','1675909726585'),(72,'pandudwisaputra0@gmail.com','','6540','1675923472585'),(73,'rendratry1@gmail.com','','6474','1675956340598'),(74,'pandudwisaputra0@gmail.com','','7508','1676210041626'),(75,'pandu@gmail.com','','3105','1676368635235'),(76,'pandudwisaputra0@gmail.com','','7787','1676378043736'),(77,'pandudwisaputra0@gmail.com','','3501','1676378167525'),(78,'pandudwisaputra0@gmail.com','','3216','1676378603078'),(79,'pandudwisaputra0@gmail.com','','4026','1676430213948'),(80,'pandudwisaputra0@gmail.com','','3644','1676431167902'),(81,'pandudwisaputra0@gmail.com','','1552','1676431688975'),(82,'pandudwisaputra0@gmail.com','','0662','1676431695616'),(83,'pandudwisaputra0@gmail.com','','8396','1676433673901'),(84,'pandu@gmail.com','','2997','1676436580660'),(85,'pandudwisaputra0@gmail.com','','2799','1676436623987'),(86,'pandudwisaputra0@gmail.com','','2149','1676437080132'),(87,'pandudwisaputra0@gmail.com','','9680','1676515184247'),(88,'pandudwisaputra0@gmail.com','','4011','1676515561661'),(89,'pandudwisaputra0@gmail.com','','0908','1676516023032'),(90,'pandudwisaputra0@gmail.com','','2904','1676542056305'),(91,'rendratrykusuma@gmail.com','','3571','1676627495426'),(92,'rendratrykusuma@gmail.com','','2357','1676627567290'),(93,'rendratrykusuma@gmail.com','','1425','1676627851783'),(94,'rendratrykusuma@gmail.com','','9180','1676628349801'),(95,'rendratrykusuma@gmail.com','','2775','1676628593121'),(96,'ridhorifai960@gmail.com','','1583','1676629339532'),(97,'ridhorifai960@gmail.com','','3721','1676629545186'),(98,'pandudwisaputra0@gmail.com','','8861','1677564611423');
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
  `selfie` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `alamat` varchar(200) NOT NULL,
  `status_presensi` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_presensi`),
  KEY `presensi_masuk_fk` (`id_user`),
  CONSTRAINT `presensi_masuk_fk` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`)
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `presensi_masuk`
--

LOCK TABLES `presensi_masuk` WRITE;
/*!40000 ALTER TABLE `presensi_masuk` DISABLE KEYS */;
INSERT INTO `presensi_masuk` VALUES (64,3,'1676623176208','15.39','15.39','1676623192922','telat','pulang lebih awal','-7.6369009','111.5425674','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2Fa1457d12-f734-42fd-8200-d00a595f306d8053074101938070601.jpg?alt=media&token=9a7b58b9-923b-4319-97eb-e2ee2ea1fa2d','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(65,3,'1676623931182','15.52','15.52','1676623949515','telat','pulang lebih awal','-7.6369042','111.5425682','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2Fbbbf217e-92d4-45ab-8603-ad3a6200d0d07043062765791344519.jpg?alt=media&token=73b78dd9-fba1-4740-be2c-3690beb56970','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(66,3,'1676623982135','15.53','15.53','1676623999066','telat','pulang lebih awal','-7.636901','111.5425666','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2Fa06decf3-3d68-478f-81a0-a841dc8d0d856235954469856531521.jpg?alt=media&token=a75560d8-3f57-4b37-97d5-0a2a51a3ee40','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(67,3,'1676624035361','15.53','15.54','1676624073302','telat','pulang lebih awal','-7.6369018','111.5425682','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F0b799253-a389-46ec-9c78-316d0a4fe815657737207868108371.jpg?alt=media&token=ce502a8e-fd28-4163-85df-e31e3c3dae39','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(68,3,'1676624522600','16.2','16.2','1676624573532','telat','pulang lebih awal','-7.6369015','111.5425679','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2Fa4444bd3-d250-4cb8-9dc6-6dd3b0ef22142134329572747984970.jpg?alt=media&token=4bdd477d-5af5-44cc-947f-645bcd621c7a','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(69,3,'1676624747333','16.5','16.7','1676624834792','telat','pulang lebih awal','-7.6368962','111.5425854','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2Fa621d086-29f9-47b4-99d3-c55e53b2558d335263224325288215.jpg?alt=media&token=a9faa5a0-8c8d-4ab8-815e-efac5f1c2d42','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(70,3,'1676624854914','16.7','16.8','1676624932315','telat','pulang lebih awal','-7.6369028','111.5425663','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F246efafd-aa6e-4600-83ff-42b7980a97395843492301026999062.jpg?alt=media&token=6491f1b0-4f10-4129-be6e-c7f6ae2dde3a','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(71,3,'1676624954919','16.9','16.9','1676624990459','telat','pulang lebih awal','-7.6369037','111.5425678','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2Ffe86a8b7-0b44-4fd5-9167-854ed74754154253954163041152094.jpg?alt=media&token=6437381c-ac90-453e-8127-3f1d72ef8040','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(72,3,'1676625011514','16.10','16.11','1676625070326','telat','pulang lebih awal','-7.6369013','111.5425667','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F5107f56f-5993-44e9-94b2-f2ac01fb9c862121057915913374989.jpg?alt=media&token=9e86b636-3845-4544-b111-d6ee1b13fb76','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(73,3,'1676625103702','16.11','16.12','1676625121399','telat','pulang lebih awal','-7.6369009','111.5425674','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F32bb18cf-d882-4c28-a5af-50f494aa10de168235263427354218.jpg?alt=media&token=3cb0d2f7-e298-4da5-920f-9e8c4f26f62d','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(74,3,'1676627693122','16.54','16.55','1676627730538','telat','pulang lebih awal','-7.6369015','111.542605','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F72ae3c23-b160-43af-a826-fd80960daf951962830543565987306.jpg?alt=media&token=9a323b6d-70b5-439e-a073-54493c1f24c3','Kanigoro, Kartoharjo, Madiun City, East Java, Indonesia, 63118','selesai'),(75,3,'1676628030965','17.0','17.1','1676628107425','tepat waktu','pulang lebih awal','-7.637027','111.5424136','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2Fbb62f927-2922-4cbb-9616-84971db66e858833692499191211881.jpg?alt=media&token=3c379763-3040-45b0-9db6-45ec81f60ea5','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(76,5,'1676628087471','17.1','17.2','1676628121206','telat','pulang lebih awal','-7.6369006','111.5425669','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F717da60a-e858-4d33-8c99-ac5e648530554616019875704176476.jpg?alt=media&token=ceb24d86-c7cf-40c7-959c-0388d7964458','Kanigoro, Kartoharjo, Madiun City, East Java, Indonesia, 63118','selesai'),(77,5,'1676628200507','17.3','17.3','1676628213484','telat','pulang lebih awal','-7.6369016','111.5425673','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F90520a4d-5d3b-4384-b397-5c79260102403541888943207538743.jpg?alt=media&token=3243e482-a252-4ce3-bfd2-d1e36f2f6c7e','Kanigoro, Kartoharjo, Madiun City, East Java, Indonesia, 63118','selesai'),(78,3,'1676628237081','17.3','17.4','1676628255081','telat','pulang lebih awal','-7.6369934','111.5425481','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F6aca1034-d5a4-4c67-98fd-4dce4d0c15d93058955162608111403.jpg?alt=media&token=99c5756e-75f6-4edf-bfab-b767eddf7375','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(79,5,'1676628560944','17.9','17.14','1676628874086','telat','pulang lebih awal','-7.6368977','111.5425662','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F6b2a6f8f-71b5-4e22-b8f8-c0861c7114035776080174627072134.jpg?alt=media&token=b07c5e4c-112c-4784-bd95-e4117ed5d80a','Kanigoro, Kartoharjo, Madiun City, East Java, Indonesia, 63118','selesai'),(80,5,'1676628854658','17.14','17.15','1676628909812','telat','pulang lebih awal','-7.6369761','111.5425045','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F66e9e0b5-7b00-4d0c-aa12-801f8631f9091510840415912266568.jpg?alt=media&token=27340b5c-d868-4c33-b841-c02e8bf95a2f','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(81,5,'1676628946839','17.15','17.17','1676629024296','telat','pulang lebih awal','-7.6369025','111.5425567','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2Fdda0b4e2-b06a-4c93-af7c-a1b7521a76ec479032268066050090.jpg?alt=media&token=072137e8-c1e2-4ea7-92e1-7c64173e5b0c','Kanigoro, Kartoharjo, Madiun City, East Java, Indonesia, 63118','selesai'),(82,6,'1676629413708','17.23','17.23','1676629438208','telat','pulang lebih awal','-7.6369027','111.5425674','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F89855e09-15cf-44ac-9d18-14b01f52b00c8258469752084198106.jpg?alt=media&token=de6277df-0468-43d8-a35d-bff1bbee035b','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','selesai'),(83,5,'1676644379367','21.32','-','-','telat','-','-7.636939750145232','111.54259497128515','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F2e4ccdbe-c617-4d46-a142-bbd587940f0d2478552596175398822.jpg?alt=media&token=17b317b4-0341-486a-a942-a813adc3ca31','Kanigoro, Kartoharjo, Madiun City, East Java, Indonesia, 63118','-'),(84,5,'1676645031613','21.43','21.45','1676645106837','telat','pulang tepat waktu','-7.636910036998052','111.54257622502178','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F1081d805-8b0b-48eb-b93f-6c738ee787b6827578804229765891.jpg?alt=media&token=cee80585-76e1-4fda-a7ea-ed7ef2e3af4e','Kanigoro, Kartoharjo, Madiun City, East Java, Indonesia, 63118','selesai'),(85,5,'1676645338038','21.48','21.52','1676645573996','telat','pulang tepat waktu','-7.636904010088323','111.5425600943736','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2Fd89d1b1e-1bcb-4c21-af4d-83b70110dbd63087411862890055761.jpg?alt=media&token=6a5a05a7-9857-4129-b928-95ce5606d9eb','Kanigoro, Kartoharjo, Madiun City, East Java, Indonesia, 63118','selesai'),(86,5,'1676691186508','10.33','-','-','telat','-','-7.6369509332414545','111.54263713158221','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2Fe194c2fc-5f86-4a4b-9937-3ad5ef37d2ad4319220037770066876.jpg?alt=media&token=11db6541-3fc1-4faa-a3f2-f15bf9ff7cfd','Kanigoro, Kartoharjo, Madiun City, East Java, Indonesia, 63118','-'),(87,5,'1676722706006','19.18','19.18','1676722729261','telat','pulang tepat waktu','-7.636946353215679','111.54264200230931','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F6a0286da-491f-4131-880a-0c4cae5da1cf2379556237599057999.jpg?alt=media&token=68d1b318-da46-4ff7-882f-2d2232551417','Kanigoro, Kartoharjo, Madiun City, East Java, Indonesia, 63118','selesai'),(88,5,'1676761092188','5.58','13.24','1677392646491','tepat waktu','pulang lebih awal','-7.63694526711561','111.54263778122525','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2Fe344d8b4-d17f-4871-86c6-37e2f4a8e4ba6234057678115071910.jpg?alt=media&token=529b454e-b196-492b-9a3c-98b510e08eef','Kanigoro, Kartoharjo, Madiun City, East Java, Indonesia, 63118','selesai'),(89,5,'1677392689947','13.24','-','-','telat','-','-7.636940431660751','111.54264772976302','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F76af76d3-0efc-4b16-84e0-96ac1a74c33e8646068992097280949.jpg?alt=media&token=d19b297b-ab2f-4f0e-b776-b901d0adfdf0','Kanigoro, Kartoharjo, Madiun City, East Java, Indonesia, 63118','-'),(90,3,'1677393100909','13.31','-','-','telat','-','-7.636965201812199','111.542613471701','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2Fc66144b0-2faf-4d2f-8917-ea627f2c13907238634581828536903.jpg?alt=media&token=bfc6f0b7-cb9d-4bf4-8cf0-3b84ecd409c5','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','-'),(91,3,'1677393267107','13.34','-','-','telat','-','-7.636960026430999','111.54261949554163','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2Ff2b41234-54f1-4e85-83cf-06d911b5e4704952989985835627317.jpg?alt=media&token=b415974f-30df-4837-a717-fa309711a09b','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','-'),(92,5,'1676448061042','18.11','-','-','tepat waktu','-','-7.636939750145232','111.54259497128515','http://myfin.id','Indonesahh Madiun','-'),(93,3,'1684499670036','19.34','-','-','tepat waktu','-','-7.637000520452765','111.5426259669784','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/selfie%2F82a31aa4-34a6-4a6a-8ac6-ccda765db7e53432956993604573609.jpg?alt=media&token=88651fb6-430f-4607-94e3-74caf1b5bc4c','Kanigoro, Kecamatan Kartoharjo, Kota Madiun, Jawa Timur, Indonesia, 63118','-');
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
  `nama_lengkap` varchar(100) DEFAULT NULL,
  `no_hp` varchar(50) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `ava` varchar(200) DEFAULT NULL,
  `status_login` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id_user`),
  KEY `user_FK` (`id_karyawan`),
  CONSTRAINT `user_FK` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan` (`id_karyawan`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,NULL,'Ridhorifai@gmail.com','Ridho','','$2a$10$8JcOFN1kh7fP7.aWIiUYyOV3QAel1HxJin3WeQzQa7HGbUKvwukDS','myfin.id',0),(3,NULL,'pandudwisaputra0@gmail.com','Pandu ','','$2a$10$g/issngV4a8Ca45Uz3XRd./AGgpo4Dz3wntknTgujJ6rJL8ktRUnu','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/profile_picture%2FIMG_20230217_015806_null.jpg?alt=media&token=b4f9d126-3ccf-424f-bda9-cc8a59ea1c29',0),(4,'MARS001','Ridhorifai@gmail.com','Ridho','','$2a$10$vVPnOb5gsVzG6wvwM7jJz.bvVvbBsFCcFPVTtLBOD.RFnlsATNkQu','-',0),(5,'MARS002','rendratrykusuma@gmail.com','Rendra Tri Kusuma','','$2a$10$QVyhfqUu7aqFQvaiSnkEoOXzv6tNqquZidLzzZoyigA4zFBZem6mq','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/profile_picture%2FIMG-20230211-WA0003.jpeg?alt=media&token=f6672157-eb6d-4be5-8bdc-6e179c34302e',0),(6,'MARS003','ridhorifai960@gmail.com','Ridho ','','$2a$10$dapdvImc9W8TBglGvnyGu.VUUVKuWOrqZKi4Gi5paxGnkp5b8onPe','https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/profile_picture%2FIMG-20230217-WA0002.jpg?alt=media&token=ca44eeba-ad8d-4b4e-b15f-7f0d35a48ec3',0);
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

-- Dump completed on 2023-05-19 13:31:53

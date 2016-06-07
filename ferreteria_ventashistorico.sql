-- MySQL dump 10.13  Distrib 5.7.9, for Win32 (AMD64)
--
-- Host: localhost    Database: ferreteria
-- ------------------------------------------------------
-- Server version	5.7.10-log

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
-- Table structure for table `ventashistorico`
--

DROP TABLE IF EXISTS `ventashistorico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ventashistorico` (
  `ID_VENTA` int(11) NOT NULL,
  `ID_PRODUCTO` varchar(13) DEFAULT NULL,
  `PRODUCTO_VENTA` varchar(255) DEFAULT NULL,
  `CANTIDAD_VENTA` int(10) DEFAULT NULL,
  `TOTAL_VENTA` decimal(19,4) DEFAULT NULL,
  `FECHA_VENTA` date DEFAULT NULL,
  PRIMARY KEY (`ID_VENTA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventashistorico`
--

LOCK TABLES `ventashistorico` WRITE;
/*!40000 ALTER TABLE `ventashistorico` DISABLE KEYS */;
INSERT INTO `ventashistorico` VALUES (1,NULL,'PINTURA DOAL ROJA',7,1050.0000,NULL),(2,NULL,'1',1,1.0000,NULL),(3,NULL,'BLOC',1,5.0000,NULL),(4,NULL,'BLOC',9,5.0000,NULL),(5,NULL,'BLOC',1,5.0000,NULL),(6,NULL,'DESARMADOR TRUPER',1,50.0000,NULL),(7,NULL,'DESARMADOR TRUPER',1,50.0000,NULL),(8,NULL,'DESARMADOR TRUPER',1,50.0000,NULL),(9,'1233333333333','BLOC',3,15.0000,NULL),(10,'1233333333333','BLOC',1,5.0000,NULL),(11,'1234444444444','DESARMADOR TRUPER',4,200.0000,NULL),(12,'1234566666666','ROTOMARTILLO TRUPER M32',1,200.0000,NULL),(13,'1233333333333','BLOC',1,5.0000,NULL),(14,'1233333333333','BLOC',4,20.0000,NULL),(16,'1234444444444','DESARMADOR TRUPER',1,50.0000,NULL),(17,'1234566666666','ROTOMARTILLO TRUPER M32',6,1200.0000,NULL),(18,'1233333333333','BLOC',50,200.0000,NULL),(19,'1233333333333','BLOC',1,5.0000,NULL),(20,'1233333333333','BLOC',3,15.0000,NULL),(21,'1234444444444','DESARMADOR TRUPER',1,50.0000,NULL),(22,'1233333333333','BLOC',1,5.0000,NULL),(23,'1234444444444','DESARMADOR TRUPER',1,50.0000,NULL),(24,'1233333333333','BLOC',3,15.0000,NULL),(25,'1234444444444','DESARMADOR TRUPER',4,200.0000,NULL),(26,'1233333333333','BLOC',3,15.0000,NULL),(27,'1233333333333','BLOC',1,5.0000,NULL),(28,'1234444444444','DESARMADOR TRUPER',1,50.0000,NULL),(29,'1234444444444','DESARMADOR TRUPER',1,50.0000,NULL),(30,'1233333333333','BLOC',1,5.0000,NULL),(31,'1233333333333','BLOC',3,15.0000,NULL),(32,'1233333333333','BLOC',1,5.0000,NULL),(33,'1233333333333','BLOC',1,5.0000,NULL),(34,'1233333333333','BLOC',3,15.0000,NULL),(35,'1233333333333','BLOC',1,5.0000,'2016-01-01'),(36,'1234444444444','DESARMADOR TRUPER',1,50.0000,'2016-01-01');
/*!40000 ALTER TABLE `ventashistorico` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-06-06 22:50:46

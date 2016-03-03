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
-- Dumping routines for database 'ferreteria'
--
/*!50003 DROP FUNCTION IF EXISTS `calculaExistencias` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculaExistencias`(id CHAR(13),cantidad INT) RETURNS int(11)
BEGIN
	DECLARE existenciasactuales INT;
	DECLARE existenciasresta INT;
	SELECT 
		EXISTENCIAS
	FROM
		productos
	WHERE
		ID_PRODUCTO = id INTO existenciasactuales;
	-- --
	SET existenciasresta = existenciasactuales - cantidad;
RETURN existenciasresta;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `conPrecio` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `conPrecio`(IN id CHAR(13), IN cantidad INT, OUT precio DOUBLE)
BEGIN
DECLARE cantmayoreo INT;
SELECT CANTIDAD_MAYOREO FROM productos WHERE ID_PRODUCTO = id INTO cantmayoreo;
IF (cantidad>=cantmayoreo) THEN
SELECT PRECIO_MAYOREO FROM productos WHERE ID_PRODUCTO = id INTO precio;
ELSE
SELECT PRECIO_MENUDEO FROM productos WHERE ID_PRODUCTO = id INTO precio;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `conProducto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `conProducto`(IN id CHAR(13), IN cantidad INT, OUT mensaje VARCHAR(70), OUT retorno INT, OUT nombre VARCHAR(50))
venta: BEGIN
DECLARE existenciasresta INT;
DECLARE reorden INT;
DECLARE minimo INT;
-- --
SELECT NOMBRE_PRODUCTO FROM productos
WHERE ID_PRODUCTO = id INTO nombre;
-- --
IF (nombre IS NOT NULL) THEN
-- --
SET existenciasresta = calculaExistencias(id,cantidad);
--
IF (existenciasresta>=0) THEN
	SELECT MINIMO_PRODUCTO FROM productos WHERE ID_PRODUCTO = id INTO minimo;
	SELECT REORDENAR FROM productos WHERE ID_PRODUCTO = id INTO reorden;
    IF (existenciasresta<minimo) THEN
		SET mensaje = 'El producto está en su punto mínimo';
	ELSEIF (existenciasresta<reorden) THEN
		SET mensaje = 'El producto está en su punto de reorden';
	END IF;
    SET retorno = 1;
-- --
ELSE 
	SET mensaje = 'Las existencias no son suficientes para realizar la venta';
    SET retorno = 0;
    LEAVE venta;
END IF;
-- --
ELSE 
SET mensaje = 'El producto no existe';
SET retorno = 0;
LEAVE venta;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `pasarahistorico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `pasarahistorico`()
BEGIN
	INSERT INTO ventashistorico
	(`ID_VENTA`,
	`ID_PRODUCTO`,
	`PRODUCTO_VENTA`,
	`CANTIDAD_VENTA`,
	`TOTAL_VENTA`,
	`FECHA_VENTA`)
	SELECT
	ID_VENTA,
	ID_PRODUCTO,
	PRODUCTO_VENTA,
	CANTIDAD_VENTA,
	TOTAL_VENTA,
	FECHA_VENTA
	FROM ventas;
	DELETE FROM ventas;
    UPDATE parametros SET FECHA_SISTEMA = DATE_ADD(FECHA_SISTEMA,INTERVAL 1 DAY) WHERE FECHA_SISTEMA IS NOT NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `venta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `venta`(IN nombre VARCHAR(50),IN id CHAR(13), IN cantidad INT, IN precio DOUBLE)
BEGIN
DECLARE existenciasresta INT;
DECLARE fecha DATETIME;
SET existenciasresta = calculaExistencias(id,cantidad);
SELECT FECHA_SISTEMA FROM parametros WHERE FECHA_SISTEMA IS NOT NULL INTO fecha;
INSERT INTO VENTAS (PRODUCTO_VENTA,ID_PRODUCTO, CANTIDAD_VENTA, TOTAL_VENTA, FECHA_VENTA)
	VALUES (nombre, id,cantidad, precio, fecha);
	-- --
	UPDATE productos 
	SET 
    EXISTENCIAS = existenciasresta
	WHERE
    ID_PRODUCTO = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-03-02 23:27:43

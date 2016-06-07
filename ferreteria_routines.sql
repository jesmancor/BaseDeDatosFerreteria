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
CREATE DEFINER=`root`@`localhost` PROCEDURE `conProducto`(IN id CHAR(13), IN cantidad INT, OUT mensaje VARCHAR(70), OUT retorno INT, OUT nombre VARCHAR(50), IN descripcion VARCHAR(200),IN tipoCon CHAR(1))
venta: BEGIN
DECLARE existenciasresta INT;
DECLARE reorden INT;
DECLARE minimo INT;
-- --
DECLARE tipoConVenta CHAR(1); 
DECLARE tipoConMod CHAR(1);
DECLARE tipoConPorDescri CHAR(1);
SET tipoConVenta = '1';
SET tipoConMod = '2';
SET tipoConPorDescri = '3';
-- --
SELECT NOMBRE_PRODUCTO FROM productos
WHERE ID_PRODUCTO = id INTO nombre;
-- --
IF (nombre IS NOT NULL) THEN
-- --
IF (tipoCon = tipoConVenta) THEN
SET existenciasresta = calculaExistencias(id,cantidad);
--
IF (existenciasresta>=0) THEN
	SELECT MINIMO_PRODUCTO FROM productos WHERE ID_PRODUCTO = id INTO minimo;
	SELECT REORDENAR FROM productos WHERE ID_PRODUCTO = id INTO reorden;
    IF (existenciasresta<minimo) THEN
		SET mensaje = 'El producto está en su punto mínimo';
	ELSEIF (existenciasresta<reorden) THEN
		SET mensaje = 'El producto está en su punto de reorden';
	ELSE
		SET mensaje = 'nulo';
	END IF;
    SET retorno = 1;
-- --
ELSE 
	SET mensaje = 'Las existencias no son suficientes para realizar la venta';
    SET retorno = 0;
    LEAVE venta;
END IF;
-- --
ELSEIF (tipoCon=tipoConMod) THEN
	SELECT 
    NOMBRE_PRODUCTO,
    DESCRIPCION_PRODUCTO,
    TIPO_PRODUCTO,
    PRECIO_MENUDEO,
    PRECIO_MAYOREO,
    DESCUENTO,
    EXISTENCIAS,
    MAXIMO_PRODUCTO,
    MINIMO_PRODUCTO,
    REORDENAR
    FROM productos
    WHERE ID_PRODUCTO = id;
END IF;
ELSE 
SET mensaje = 'El producto no existe';
SET retorno = 0;
IF (tipoCon=tipoConPorDescri) THEN
	SET descripcion = CONCAT('%', descripcion,'%');
	SELECT * FROM productos WHERE DESCRIPCION_PRODUCTO LIKE	descripcion OR NOMBRE_PRODUCTO LIKE descripcion;
    END IF;
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
/*!50003 DROP PROCEDURE IF EXISTS `productoAlta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `productoAlta`(
in id char(13),
in nombre varchar(50),
in tipo varchar(50),
in descripcion varchar(200),
in pMenudeo double,
in pMayoreo double,
in descuento int
)
BEGIN
INSERT INTO `ferreteria`.`productos`
(`ID_PRODUCTO`,
`NOMBRE_PRODUCTO`,
`TIPO_PRODUCTO`,
`DESCRIPCION_PRODUCTO`,
`PRECIO_MENUDEO`,
`PRECIO_MAYOREO`,
`DESCUENTO`)
VALUES
(id,
nombre,
tipo,
descripcion,
pMenudeo,
pMayoreo,
descuento);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `productoBaja` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `productoBaja`(in id char(13))
BEGIN
delete from productos where ID_PRODUCTO = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `productoMod` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `productoMod`(
in id char(13),
in nombre varchar(50),
in tipo varchar(50),
in descripcion varchar(200),
in pMenudeo double,
in pMayoreo double,
in descuento int,
in nuevaExistencia int,
in maximo int,
in minimo int,
in reorden int,
in proveedor char(3),
in cantidad int,
in tipoMod char(1),
out mensaje varchar(100)
)
modi:begin
if(tipoMod='1') then
	update productos set
	NOMBRE_PRODUCTO = nombre,
	TIPO_PRODUCTO = tipo,
	DESCRIPCION_PRODUCTO = descripcion,
	PRECIO_MENUDEO = pMenudeo,
	PRECIO_MAYOREO = pMayoreo,
	DESCUENTO = descuento
	where ID_PRODUCTO = id;
    
elseif(tipoMod='2') then

	if(reorden>=maximo) then
		set mensaje = 'El punto de reorden no puede ser mayor al máximo';
		rollback;
        leave modi;
    end if;
    
    if(reorden<=minimo) then
		set mensaje = 'El punto de reorden no puede ser menor al mínimo';
		rollback;
        leave modi;
    end if;
    
    if(minimo>=maximo) then
		set mensaje = 'El punto de mínimo no puede ser mayor al máximo';
		rollback;
        leave modi;
    end if;
    
    if not exists(select NOMBRE_PROVEEDOR
    from proveedores where ID_PROVEEDOR = proveedor) then
		set mensaje = 'Debe asignar un proveedor para realizar la compra';
		rollback;
        leave modi;
    end if;
    
	insert into compras values
    (null, proveedor, cantidad, 0, 0);
	
	update productos set
    EXISTENCIAS = nuevaExistencia,
    MAXIMO_PRODUCTO = maximo,
    MINIMO_PRODUCTO = minimo
    where ID_PRODUCTO = id;
end if;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proveedorAlta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proveedorAlta`(in id char(10), in nombre varchar(255), out mensaje varchar(255))
alta:BEGIN
	if(nombre='') then
		set mensaje = 'Debe ingresar el nombre del proveedor';
		rollback;
        leave alta;
    end if;

	insert into proveedores (ID_PROVEEDOR, NOMBRE_PROVEEDOR) values (id, nombre);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proveedorBaja` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proveedorBaja`(in id char(3))
BEGIN
	delete from proveedores where ID_PROVEEDOR = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proveedorCon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proveedorCon`(in id char(3), in nombre varchar(255), in tipoCon char(1))
BEGIN
if tipoCon = '1' then
	select NOMBRE_PROVEEDOR from proveedores where ID_PROVEEDOR = id;
elseif tipoCOn = '2' then
	set nombre = CONCAT('%', nombre,'%');
	select ID_PROVEEDOR, NOMBRE_PROVEEDOR from proveedores where NOMBRE_PROVEEDOR like nombre;
end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proveedorMod` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proveedorMod`(in id char(3),in nombre varchar(255), out mensaje varchar(255))
modif:BEGIN
	if(nombre='') then
		set mensaje = 'Debe ingresar el nombre del proveedor';
		rollback;
        leave modif;
    end if;
	update proveedores set NOMBRE_PROVEEDOR = nombre where ID_PROVEEDOR = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `provprodAlt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `provprodAlt`(in producto char(13), in precio double, in proveedor char(3))
BEGIN
	insert into relprovprod values
    (producto, precio, proveedor);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `provprodCon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `provprodCon`(in id char(3))
BEGIN
	select ID_PRODUCTO, PRECIO_PRODUCTO, ID_PROVEEDOR
    from relprovprod where
	ID_PROVEEDOR = id;
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

-- Dump completed on 2016-06-06 22:50:49

CREATE DATABASE `pgs` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE TABLE `controller` (
  `ControllerId` int(11) NOT NULL AUTO_INCREMENT,
  `Number` int(11) NOT NULL,
  `IPAddress` varchar(50) NOT NULL,
  `LevelId` int(11) NOT NULL,
  PRIMARY KEY (`ControllerId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `controllerinfo` (
  `EventId` char(32) NOT NULL,
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Status` varchar(50) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=36145 DEFAULT CHARSET=utf8;

CREATE TABLE `controllerstatus` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `ControllerId` int(11) NOT NULL,
  `Active` tinyint(1) NOT NULL,
  `UpdateDate` datetime NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `detector` (
  `DetectorId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Number` int(11) NOT NULL,
  `LevelId` int(11) NOT NULL,
  PRIMARY KEY (`DetectorId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `detectordirection` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `EventId` char(32) NOT NULL,
  `Number` int(11) NOT NULL,
  `Direction` varchar(50) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=1075 DEFAULT CHARSET=utf8;

CREATE TABLE `display` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `IPAddress` varchar(50) NOT NULL,
  `Port` int(11) NOT NULL,
  `Type` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

CREATE TABLE `displaycomponent` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `DisplayId` int(11) NOT NULL,
  `ComponentId` int(11) NOT NULL,
  `Type` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;

CREATE TABLE `displaytype` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Type` varchar(50) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `event` (
  `Id` char(32) NOT NULL,
  `Description` longtext,
  `ControllerId` int(11) NOT NULL,
  `EventDate` datetime NOT NULL,
  `EventType` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `eventtype` (
  `EventType` int(11) NOT NULL,
  `Description` varchar(50) NOT NULL,
  PRIMARY KEY (`EventType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `level` (
  `LevelId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Number` int(11) NOT NULL,
  `Spaces` int(11) NOT NULL,
  `TotalZones` int(11) NOT NULL,
  `ParkingId` int(11) NOT NULL,
  PRIMARY KEY (`LevelId`),
  KEY `Parking_FK_idx` (`ParkingId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `levelinfo` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `EventId` char(32) NOT NULL,
  `Count` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=1061 DEFAULT CHARSET=utf8;

CREATE TABLE `maincontroller` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IPAddress` varchar(50) NOT NULL,
  `Port` varchar(50) NOT NULL,
  `Active` tinyint(1) NOT NULL DEFAULT '0',
  `FileName` varchar(50) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `occupancy` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Active` tinyint(1) NOT NULL,
  `ResetTime` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `parking` (
  `ParkingId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `TotalSpaces` int(11) NOT NULL,
  `TotalLevels` int(11) NOT NULL,
  PRIMARY KEY (`ParkingId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `role` (
  `RoleId` int(11) NOT NULL AUTO_INCREMENT,
  `Role` varchar(50) NOT NULL,
  PRIMARY KEY (`RoleId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `server` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `IPAddress` varchar(50) NOT NULL,
  `Port` varchar(50) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `user` (
  `UserId` int(11) NOT NULL AUTO_INCREMENT,
  `UserName` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL,
  `RoleId` int(11) NOT NULL,
  PRIMARY KEY (`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `zone` (
  `ZoneId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Number` int(11) NOT NULL,
  `LevelId` int(11) NOT NULL,
  `Spaces` int(11) NOT NULL,
  `TotalEntry` int(11) NOT NULL,
  `TotalExit` int(11) NOT NULL,
  PRIMARY KEY (`ZoneId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `zoneinfo` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `EventId` char(32) NOT NULL,
  `Number` int(11) NOT NULL,
  `Count` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=1175 DEFAULT CHARSET=utf8;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_controllerdetails`(IN controllernumber INT, IN ipaddress VARCHAR(50), IN levelid INT)
BEGIN
INSERT INTO `pgs`.`controller`
(`Number`,
`IPAddress`,
`LevelId`)
VALUES
(controllernumber,
ipaddress,
levelid);
SELECT LAST_INSERT_ID();
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_controllerinfo`(IN eventid CHAR(32), IN activestatus varchar(50))
BEGIN
INSERT INTO `pgs`.`controllerinfo`
(`EventId`,
`Status`)
VALUES
(eventid, activestatus);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_controllerstatus`(IN controllerid INT, IN active TINYINT(1), IN updatedate DATETIME)
BEGIN
INSERT INTO `pgs`.`controllerstatus`
(`ControllerId`,
`Active`,
`UpdateDate`)
VALUES
(controllerid,
active,
updatedate);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_detectordetails`(IN detectorname VARCHAR(50), IN detectornumber INT, IN levelid INT)
BEGIN
INSERT INTO `pgs`.`detector`
(`Name`,
`Number`,
`LevelId`)
VALUES
(detectorname,
detectornumber,
levelid);
SELECT LAST_INSERT_ID();
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_detectordirection`(in eventid char(32), in detectornumber int, in direction varchar(50))
BEGIN
INSERT INTO `pgs`.`detectordirection`
(`EventId`,
`Number`,
`Direction`)
VALUES
(eventid,
detectornumber,
direction);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_display`(IN displayname VARCHAR(50), IN ipaddress VARCHAR(50), IN displayport INT, IN displaytype INT)
BEGIN
INSERT INTO `pgs`.`display`
(`Name`,
`IPAddress`,
`Port`,
`Type`)
VALUES
(displayname,
ipaddress,
displayport,
displaytype);
SELECT LAST_INSERT_ID();
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_displaycomponent`(IN displayid INT, IN componentid INT, IN displaytype INT)
BEGIN
INSERT INTO `pgs`.`displaycomponent`
(`DisplayId`,
`ComponentId`,
`Type`)
VALUES
(displayid,
componentid,
displaytype);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_eventdetails`(IN eventid CHAR(32), IN description LONGTEXT, IN controllerid INT, IN eventdate DATETIME, in eventtype int)
BEGIN
INSERT INTO `pgs`.`event`
(`Id`,
`Description`,
`ControllerId`,
`EventDate`,
`EventType`)
VALUES
(eventid,
description,
controllerid,
eventdate,
eventtype);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_leveldetails`(IN levelname VARCHAR(50), IN levelnumber INT, IN spaces INT, IN totalzones INT, IN parkingId INT)
BEGIN
INSERT INTO `pgs`.`level`
(`Name`,
`Number`,
`Spaces`,
`TotalZones`,
`ParkingId`)
VALUES
(levelname,
levelnumber,
spaces,
totalzones,
parkingId);
SELECT LAST_INSERT_ID();
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_levelinfo`(IN eventid CHAR(32), IN count int)
BEGIN
INSERT INTO `pgs`.`levelinfo`
(`EventId`,
`Count`)
VALUES
(eventid,
count);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_maincontrollerdetails`(IN ipaddress VARCHAR(50), IN portaddress VARCHAR(50), IN active TINYINT(1), IN filename VARCHAR(50))
BEGIN
INSERT INTO `pgs`.`maincontroller`
(`IPAddress`,
`Port`,
`Active`,
`FileName`)
VALUES
(ipaddress,
portaddress,
active,
filename);
SELECT LAST_INSERT_ID();
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_occupancy`(IN active TINYINT(1), IN resettime INT)
BEGIN
Truncate table `pgs`.`occupancy`;
INSERT INTO `pgs`.`occupancy`
(`Active`,
`ResetTime`)
VALUES
(active,
resettime);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_parkingdetails`(IN parkingname VARCHAR(50), IN totalspaces INT, IN totallevels INT)
BEGIN
INSERT INTO `pgs`.`parking`
(`Name`,
`TotalSpaces`,
`TotalLevels`)
VALUES
(parkingname,
totalspaces,
totallevels);
SELECT LAST_INSERT_ID();
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_serverdetails`(IN ipaddress VARCHAR(50), IN portaddress VARCHAR(50))
BEGIN
INSERT INTO `pgs`.`server`
(`IPAddress`,
`Port`)
VALUES
(ipaddress,
portaddress);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_user`(IN username VARCHAR(50), IN userpassword VARCHAR(50), IN roleid INT)
BEGIN
INSERT INTO `pgs`.`user`
(`UserName`,
`Password`,
`RoleId`)
VALUES
(username,
userpassword,
roleid);
SELECT LAST_INSERT_ID();
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_zonedetails`(IN zonename VARCHAR(50), IN zonenumber INT, IN levelid INT, IN spaces INT, IN totalentry INT, IN totalexit INT)
BEGIN
INSERT INTO `pgs`.`zone`
(`Name`,
`Number`,
`LevelId`,
`Spaces`,
`TotalEntry`,
`TotalExit`)
VALUES
(zonename,
zonenumber,
levelid,
spaces,
totalentry,
totalexit);
SELECT LAST_INSERT_ID();
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_zoneinfo`(in eventid char(32), in zonenumber int, in count int)
BEGIN
INSERT INTO `pgs`.`zoneinfo`
(`EventId`,
`Number`,
`Count`)
VALUES
(eventid, 
zonenumber,
count);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `reset_configuration`()
BEGIN
truncate `pgs`.`controller`;
truncate `pgs`.`detector`;
truncate `pgs`.`level`;
truncate `pgs`.`maincontroller`;
truncate `pgs`.`parking`;
truncate `pgs`.`server`;
truncate `pgs`.`zone`;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user`(IN userid INT, IN username VARCHAR(50), IN userpassword VARCHAR(50), IN roleid INT)
BEGIN
UPDATE `pgs`.`user`
SET
UserName = username,
Password = userpassword,
RoleId = roleid
WHERE UserId = userid;
END$$
DELIMITER ;

CREATE SCHEMA cap09 CHARACTER SET utf8mb4;

USE cap09;

CREATE TABLE `cap09`.`dataset` (
	`location` text,
	`city` text,
	`country` text,
	`pollutant` text,
	`value` text,
	`timestamp` text,
	`unit` text,
	`source_name` text,
	`latitude` text,
	`longitude` text,
	`averaged_over_in_hours` text
) CHARACTER SET utf8mb4 ;

SET GLOBAL local_infile = true;

LOAD DATA LOCAL INFILE 'E:/OneDrive/Desktop/dataset.csv' 
INTO TABLE `cap09`.`dataset` 
CHARACTER SET utf8mb4 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES;

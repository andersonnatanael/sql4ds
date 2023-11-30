CREATE TABLE `tb_bikes_2` (
  `duration` int DEFAULT NULL,
  `start_date` text,
  `end_date` text,
  `start_station_number` int DEFAULT NULL,
  `start_station` text,
  `end_station_number` int DEFAULT NULL,
  `end_station` text,
  `bike_number` text,
  `member_type` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOAD DATA LOCAL INFILE "E:\\OneDrive\\Desktop\\sql_para_data_science\\cap_06\\pratica\\2012-capitalbikeshare-tripdata\\2012Q2-capitalbikeshare-tripdata.csv" 
INTO TABLE `cap06`.`tb_bikes_2` 
CHARACTER SET UTF8MB4 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES;

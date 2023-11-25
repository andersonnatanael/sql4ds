CREATE SCHEMA cap05exerc CHARACTER SET utf8mb4;

USE cap05exerc;

# DROP SCHEMA cap05exerc;

CREATE TABLE `cap05exerc`.`channels` (
    `channel_id` INT NULL,
    `channel_name` VARCHAR(50) NULL,
    `channel_tipe` VARCHAR(50) NULL
);

CREATE TABLE `cap05exerc`.`deliveries` (
    `delivery_id` INT NULL,
    `delivery_order_id` INT NULL,
    `driver_id` INT NULL,
    `delivery_distance_meters` INT NULL,
    `delivery_status` VARCHAR(50) NULL
);

CREATE TABLE `cap05exerc`.`drivers` (
    `driver_id` INT NULL,
    `driver_modal` VARCHAR(50) NULL,
    `driver_type` VARCHAR(50) NULL
);

CREATE TABLE `cap05exerc`.`hubs` (
	`hub_id` INT NULL,
    `hub_name` VARCHAR(50),
    `hub_city` VARCHAR(50),
    `hub_state` VARCHAR(2),
    `hub_latitude` FLOAT NULL,
    `hub_longitude` FLOAT NULL
);

CREATE TABLE `cap05exerc`.`orders` (
    `order_id` INT DEFAULT NULL,
    `store_id` INT DEFAULT NULL,
    `channel_id` INT DEFAULT NULL,
    `payment_order_id` INT DEFAULT NULL,
    `delivery_order_id` INT DEFAULT NULL,
    `order_status` TEXT,
    `order_amount` DOUBLE DEFAULT NULL,
    `order_delivery_fee` INT DEFAULT NULL,
    `order_delivery_cost` TEXT,
    `order_created_hour` INT DEFAULT NULL,
    `order_created_minute` INT DEFAULT NULL,
    `order_created_day` INT DEFAULT NULL,
    `order_created_month` INT DEFAULT NULL,
    `order_created_year` INT DEFAULT NULL,
    `order_moment_created` TEXT,
    `order_moment_accepted` TEXT,
    `order_moment_ready` TEXT,
    `order_moment_collected` TEXT,
    `order_moment_in_expedition` TEXT,
    `order_moment_delivering` TEXT,
    `order_moment_delivered` TEXT,
    `order_moment_finished` TEXT,
    `order_metric_collected_time` TEXT,
    `order_metric_paused_time` TEXT,
    `order_metric_production_time` TEXT,
    `order_metric_walking_time` TEXT,
    `order_metric_expediton_speed_time` TEXT,
    `order_metric_transit_time` TEXT,
    `order_metric_cycle_time` TEXT
)
;

CREATE TABLE `cap05exerc`.`payments` (
	`payment_id` INT NULL,
    `payment_order_id` INT NULL,
    `payment_amount` FLOAT NULL,
    `payment_fee` FLOAT NULL,
    `payment_method` TEXT,
    `payment_status` TEXT
);

CREATE TABLE `cap05exerc`.`stores` (
	`store_id` INT NULL,
    `hub_id` INT NULL,
    `store_name` TEXT,
    `store_segment` TEXT,
    `store_plan_price` FLOAT NULL,
    `store_latitude` FLOAT NULL,
    `store_longitude` FLOAT NULL
);

# Fiz o carregamento dos dados via linha de comando, a baixo deixarei os códigos para registro da atividade

LOAD DATA LOCAL INFILE "E:\\OneDrive\\Desktop\\sql_para_data_science\\cap_05\\pratica\\exercicio_cenario_analise_dados_4\\channels.csv" INTO TABLE `cap05exerc`.`channels` CHARACTER SET UTF8MB4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "E:\\OneDrive\\Desktop\\sql_para_data_science\\cap_05\\pratica\\exercicio_cenario_analise_dados_4\\deliveries.csv" INTO TABLE `cap05exerc`.`deliveries` CHARACTER SET UTF8MB4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "E:\\OneDrive\\Desktop\\sql_para_data_science\\cap_05\\pratica\\exercicio_cenario_analise_dados_4\\drivers.csv" INTO TABLE `cap05exerc`.`drivers` CHARACTER SET UTF8MB4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "E:\\OneDrive\\Desktop\\sql_para_data_science\\cap_05\\pratica\\exercicio_cenario_analise_dados_4\\hubs.csv" INTO TABLE `cap05exerc`.`hubs` CHARACTER SET UTF8MB4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "E:\\OneDrive\\Desktop\\sql_para_data_science\\cap_05\\pratica\\exercicio_cenario_analise_dados_4\\orders.csv" INTO TABLE `cap05exerc`.`orders` CHARACTER SET UTF8MB4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "E:\\OneDrive\\Desktop\\sql_para_data_science\\cap_05\\pratica\\exercicio_cenario_analise_dados_4\\payments.csv" INTO TABLE `cap05exerc`.`payments` CHARACTER SET UTF8MB4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "E:\\OneDrive\\Desktop\\sql_para_data_science\\cap_05\\pratica\\exercicio_cenario_analise_dados_4\\stores.csv" INTO TABLE `cap05exerc`.`stores` CHARACTER SET UTF8MB4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
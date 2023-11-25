CREATE SCHEMA cap04exerc DEFAULT CHARACTER SET UTF8MB4;

USE cap04exerc;

SELECT @@character_set_database, @@collation_database;

SHOW VARIABLES LIKE 'COLLATION%';

SELECT
	table_schema,
    table_name,
    table_collation
FROM information_schema.tables
WHERE table_schema= 'cap04exerc';

# DROP SCHEMA cap04exerc;

CREATE TABLE `cap04exerc`.`athletes` (
	`name` VARCHAR(200) NULL,
    `noc` VARCHAR(200) NULL,
    `discipline` VARCHAR(200) NULL
);

# DROP TABLE cap04exerc.athletes;

CREATE TABLE `cap04exerc`.`coaches` (
	`name` VARCHAR(200) NULL,
    `noc` VARCHAR(200) NULL,
    `discipline` VARCHAR(200) NULL,
    `event` VARCHAR(200) NULL
);

CREATE TABLE `cap04exerc`.`entries_gender` (
	`discipline` VARCHAR(200) NULL,
    `female` INT NULL,
    `male` INT NULL,
    `total` INT NULL
);

CREATE TABLE `cap04exerc`.`medals` (
	`rank` INT NULL,
    `noc` VARCHAR(200) NULL,
    `gold` INT NULL,
    `silver` INT NULL,
    `bronze` INT NULL,
    `total` INT NULL,
    `rank_total` INT NULL
);

CREATE TABLE `cap04exerc`.`teams` (
	`name` VARCHAR(200) NULL,
    `discipline` VARCHAR(200) NULL,
    `noc` VARCHAR(200) NULL,
    `event` VARCHAR(200) NULL
);

# Alterar o character set (se necessário)
## De uma tabela
ALTER TABLE `nome_schema`.`nome_tabela` CHARACTER SET latin2 COLLATE latin1_general_ci;
## De todo um schema ou database
ALTER DATABASE nome_schema CHARACTER SET latin2 COLLATE latin1_general_ci;


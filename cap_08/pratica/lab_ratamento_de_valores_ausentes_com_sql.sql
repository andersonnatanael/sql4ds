# CREATE SCHEMA cap08 CHARACTER SET UTF8MB4;

# USE cap08;

CREATE TABLE cap08.TB_INCIDENTES (
  `PdId` bigint DEFAULT NULL,
  `IncidntNum` text,
  `Incident Code` text,
  `Category` text,
  `Descript` text,
  `DayOfWeek` text,
  `Date` text,
  `Time` text,
  `PdDistrict` text,
  `Resolution` text,
  `Address` text,
  `X` double DEFAULT NULL,
  `Y` double DEFAULT NULL,
  `location` text,
  `SF Find Neighborhoods 2 2` text,
  `Current Police Districts 2 2` text,
  `Current Supervisor Districts 2 2` text,
  `Analysis Neighborhoods 2 2` text,
  `DELETE - Fire Prevention Districts 2 2` text,
  `DELETE - Police Districts 2 2` text,
  `DELETE - Supervisor Districts 2 2` text,
  `DELETE - Zip Codes 2 2` text,
  `DELETE - Neighborhoods 2 2` text,
  `DELETE - 2017 Fix It Zones 2 2` text,
  `Civic Center Harm Reduction Project Boundary 2 2` text,
  `Fix It Zones as of 2017-11-06  2 2` text,
  `DELETE - HSOC Zones 2 2` text,
  `Fix It Zones as of 2018-02-07 2 2` text,
  `CBD, BID and GBD Boundaries as of 2017 2 2` text,
  `Areas of Vulnerability, 2016 2 2` text,
  `Central Market/Tenderloin Boundary 2 2` text,
  `Central Market/Tenderloin Boundary Polygon - Updated 2 2` text,
  `HSOC Zones as of 2018-06-05 2 2` text,
  `OWED Public Spaces 2 2` text,
  `Neighborhoods 2` text
);

# Lab: Tratamento de valores ausentes com SQL - Parte 1/3

SELECT * FROM cap08.tb_incidentes;

SELECT DISTINCT Resolution FROM cap08.tb_incidentes;

SELECT Resolution, COUNT(*) AS Total
FROM cap08.tb_incidentes
GROUP BY Resolution
ORDER BY Total DESC;

SELECT COUNT(*) FROM cap08.tb_incidentes;

SELECT COUNT(*)
FROM cap08.tb_incidentes
WHERE Resolution IS NULL;

# Lab: Tratamento de valores ausentes com SQL - Parte 2/3

SELECT COUNT(*)
FROM cap08.tb_incidentes
WHERE Resolution = ' ';

SELECT COUNT(*)
FROM cap08.tb_incidentes
WHERE Resolution = '';

## Null é o tipo unknown no banco de dados e empty (vazio) é o nulo em uma coluna do tipo string.
## O empty também é chamado de blank.

## A principal diferença entre nulo e vazio é que o nulo é usado para se referir a nada, enquanto o vazio é usado para
## se referir a uma string única com comprimento zero.

## Com NULLIF eu converto a string definida para Nulo e assim posso comparar com nulol;
SELECT COUNT(*)
FROM cap08.tb_incidentes
WHERE NULLIF(Resolution, '') IS NULL;

## A função TRIM retira os espaços ao lado direito e esquerdo de uma string
## e ao final comparei com empty (vazio) = ''
SELECT COUNT(*)
FROM cap08.tb_incidentes
WHERE TRIM(COALESCE(Resolution, '')) = '';

## Com LTRIM eu retiro espaços vazios a esquerda e com RTRIM a direita da string
SELECT COUNT(*)
FROM cap08.tb_incidentes
WHERE LENGTH(LTRIM(RTRIM(Resolution))) = 0;

## Com ISNULL desta forma eu faço uma binarização onde se Resolution for empty eu retorno 0 e 1 onde não for
SELECT ISNULL(NULLIF(Resolution, ''))
FROM cap08.tb_incidentes;

# Lab: Tratamento de valores ausentes com SQL - Parte 2/3

SELECT
	CASE
		WHEN Resolution = '' THEN 'OTHER'
        ELSE Resolution
	END AS Resolution
FROM cap08.tb_incidentes;

## Fazendo a alteração acima, diretamente dentro da tabela:

SET SQL_SAFE_UPDATES = 0;

UPDATE cap08.tb_incidentes
SET Resolution = 'OTHER'
WHERE Resolution = '';

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM cap08.tb_incidentes;
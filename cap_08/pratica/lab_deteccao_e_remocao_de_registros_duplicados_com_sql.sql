# Lab - Detecção e Remoção de Registros Duplicados com SQL - Parte 1/3

# Cria a tabela
CREATE TABLE cap08.tb_incidentes_dup (
  `meu_idx_id` int PRIMARY KEY AUTO_INCREMENT,
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

USE cap08;

SELECT * FROM cap08.tb_incidentes_dup;

SELECT PdId, Category
FROM cap08.tb_incidentes_dup
GROUP BY PdId, Category;

SELECT PdId, Category, COUNT(*)
FROM cap08.tb_incidentes_dup
GROUP BY PdId, Category;

SELECT *
FROM cap08.tb_incidentes_dup
WHERE PdId = 11082415274000;

SELECT PdId, Category, COUNT(*) AS numero
FROM cap08.tb_incidentes_dup
GROUP BY PdId, Category
HAVING numero > 1;

SELECT COUNT(dado.numero)
FROM (
	SELECT PdId, Category, COUNT(*) AS numero
	FROM cap08.tb_incidentes_dup
	GROUP BY PdId, Category
	HAVING numero > 1
     ) AS dado;

## Identificando os registros duplicados (e retornando cada linha em duplicidade)

SELECT *
FROM cap08.tb_incidentes_dup
WHERE PdId IN (SELECT PdId FROM cap08.tb_incidentes_dup GROUP BY PdId HAVING COUNT(*) > 1)
ORDER BY PdId;

# Lab - Detecção e Remoção de Registros Duplicados com SQL - Parte 2/3

## Identificando os registros duplicados (e retornando uma linha para duplicidade) com função window

SELECT *
FROM (
	SELECT
		primeiro_resultado.*,
		ROW_NUMBER() OVER (PARTITION BY PdId ORDER BY PdId) AS numero
	FROM cap08.tb_incidentes_dup AS primeiro_resultado
    ) AS segundo_resultado
WHERE numero > 1;

SELECT COUNT(*)
FROM (
	SELECT
		primeiro_resultado.*,
		ROW_NUMBER() OVER (PARTITION BY PdId ORDER BY PdId) AS numero
	FROM cap08.tb_incidentes_dup AS primeiro_resultado
    ) AS segundo_resultado
WHERE segundo_resultado.numero > 1;

## Utilizando Common Table Expression "CTE" para retirar os dados duplicados

WITH cte_table
AS
(
SELECT PdId, Category, ROW_NUMBER() OVER (PARTITION BY PdId, Category ORDER BY PdId) AS contagem
FROM cap08.tb_incidentes_dup
)
SELECT * FROM cte_table WHERE contagem > 1;

SET SQL_SAFE_UPDATES = 0;

WITH cte_table AS (
SELECT PdId, Category, ROW_NUMBER() OVER (PARTITION BY PdId, Category ORDER BY PdId) AS contagem
FROM cap08.tb_incidentes_dup
)
DELETE FROM cap08.tb_incidentes_dup
USING cap08.tb_incidentes_dup INNER JOIN cte_table
ON cap08.tb_incidentes_dup.PdId = cte_table.PdId
WHERE cte_table.contagem > 1;

SET SQL_SAFE_UPDATES = 1;

## Outra forma sem utilizar o CTE

SET SQL_SAFE_UPDATES = 0;
DELETE FROM cap08.tb_incidentes_dup
WHERE
	PdId IN (
		SELECT
			PdId
		FROM (
			SELECT
				PdId,
                ROW_NUMBER() OVER (PARTITION BY PdId ORDER BY PdId) AS row_num
			FROM cap08.tb_incidentes_dup) AS alias
		WHERE row_num > 1
);

## Solucionando com a ajudar do bing

## Preciso tentar de novo no futuro!!!

## Usando o exemplo dado na aula seguinte, consegui fazer o que eu queria fazer, mas pra isso recriei a tablela do 0 
## e adicionei uma coluna de Primary Key, quero tentar novamente de novo, adicionando a coluna de PK a uma tabela
## já existente ao invez de ter q recria-la.

SET SQL_SAFE_UPDATES = 0;

USE cap08;
DELETE n1
FROM tb_incidentes_dup AS n1 INNER JOIN tb_incidentes_dup AS n2
WHERE n1.meu_idx_id > n2.meu_idx_id
AND n1.PdId = n2.PdId;

SET SQL_SAFE_UPDATES = 1;

# Lab - Detecção e Remoção de Registros Duplicados com SQL - Parte 3/3

SELECT *
FROM cap08.tb_incidentes_dup
WHERE PdId = 11082415274000;

CREATE TABLE cap08.tb_alunos (
	id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL
);

## Insere os dados
INSERT INTO cap08.TB_ALUNOS (nome, sobrenome, email) 
VALUES ('Carine ','Schmitt','carine.schmitt@verizon.net'),
       ('Jean','King','jean.king@me.com'),
       ('Peter','Ferguson','peter.ferguson@google.com'),
       ('Janine ','Labrune','janine.labrune@aol.com'),
       ('Jonas ','Bergulfsen','jonas.bergulfsen@mac.com'),
       ('Janine ','Labrune','janine.labrune@aol.com'),
       ('Susan','Nelson','susan.nelson@comcast.net'),
       ('Zbyszek ','Piestrzeniewicz','zbyszek.piestrzeniewicz@att.net'),
       ('Roland','Keitel','roland.keitel@yahoo.com'),
       ('Julie','Murphy','julie.murphy@yahoo.com'),
       ('Kwai','Lee','kwai.lee@google.com'),
       ('Jean','King','jean.king@me.com'),
       ('Susan','Nelson','susan.nelson@comcast.net'),
       ('Roland','Keitel','roland.keitel@yahoo.com');
       
SELECT * FROM cap08.tb_alunos;

SELECT email, COUNT(email) AS contagem
FROM cap08.tb_alunos
GROUP BY email
HAVING contagem > 1;

SELECT * FROM cap08.tb_alunos WHERE email = 'jean.king@me.com';

SET SQL_SAFE_UPDATES = 0;

USE cap08;
DELETE n1
FROM tb_alunos AS n1 INNER JOIN tb_alunos AS n2
WHERE n1.id > n2.id
AND n1.email = n2.email;

SET SQL_SAFE_UPDATES = 1;
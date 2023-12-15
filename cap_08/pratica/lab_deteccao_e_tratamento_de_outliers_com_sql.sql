# Lab - Detecção e Tratamento de Outliers com SQL - Parte 1/2

CREATE TABLE cap08.tb_criancas(nome varchar(20), idade int, peso float);

USE cap08;

INSERT INTO cap08.TB_CRIANCAS 
VALUES ('Bob', 3, 15), ('Maria', 42, 98), ('Julia', 3, 16), ('Maximiliano', 2, 12), ('Roberto', 1, 11), ('Jamil', 2, 14), ('Alberto', 3, 17);

SELECT * FROM cap08.tb_criancas;

## STDDEV retorna standard deviation, ou o desvio padrão
## Idade
SELECT AVG(idade) AS media_idade, STDDEV(idade) AS desvio_padrao_idade
FROM cap08.tb_criancas;

SELECT AVG(idade) AS media_idade, STDDEV(idade) AS desvio_padrao_idade
FROM cap08.tb_criancas
WHERE idade < 5;

# Peso
SELECT AVG(peso) AS media_peso, STDDEV(peso) AS desvio_padrao_peso
FROM cap08.tb_criancas;

SELECT AVG(peso) AS media_peso, STDDEV(peso) AS desvio_padrao_peso
FROM cap08.tb_criancas
WHERE idade < 5;

SELECT * FROM cap08.tb_criancas ORDER BY idade;

SELECT * FROM cap08.tb_criancas ORDER BY peso;

# Lab - Detecção e Tratamento de Outliers com SQL - Parte 2/2

SET @rowindex := -1;

SELECT
	AVG(idade) AS media
FROM (
		SELECT @rowindex:=@rowindex + 1 AS rowindex, cap08.tb_criancas.idade AS idade
        FROM cap08.tb_criancas
        ORDER BY cap08.tb_criancas.idade
	 ) AS d
WHERE d.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));

SET @rowindex:= -1;

SELECT
	AVG(peso) AS media
FROM (
		SELECT @rowindex:=@rowindex + 1 AS rowindex, cap08.tb_criancas.peso AS peso
        FROM cap08.tb_criancas
        ORDER BY cap08.tb_criancas.peso
	 ) AS d
WHERE d.rowindex IN (FLOOR(@rowindex / 2), CEIL(@rowindex / 2));

## Após encontrar os valores vou fazer a alteração do outlier diretamente na fonte

SET SQL_SAFE_UPDATES = 0;

UPDATE cap08.tb_criancas
SET idade = 3
WHERE idade = 42;

UPDATE cap08.tb_criancas
SET peso = 15
WHERE peso = 98;

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM cap08.tb_criancas;

SELECT AVG(peso) AS media_peso, STDDEV(peso) AS desvio_padrao_peso
FROM cap08.tb_criancas;

SELECT AVG(idade) AS media_idade, STDDEV(idade) AS desvio_padrao_idade
FROM cap08.tb_criancas;












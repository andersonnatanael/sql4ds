# Aula: Criando o Modelo de Dados

# Aula: Carregando os Dados

# Aula: Exploração Inicial dos Dados

SELECT COUNT(*) FROM cap07.covid_mortes;
SELECT COUNT(*) FROM cap07.covid_vacinacao;

## Ordenando por nome de coluna ou número da coluna

SELECT * FROM cap07.covid_mortes ORDER BY location, date;
SELECT * FROM cap07.covid_mortes ORDER BY 3 DESC, 4;

# Aula: SAFE UPDATE de Colunas

## Comando para desabilitar o SQL_SAFE_UPDATE, o padrão é 1

SET SQL_SAFE_UPDATES = 0;

UPDATE cap07.covid_mortes
SET date = str_to_date(date, '%d/%m/%y');

UPDATE cap07.covid_vacinacao
SET date = str_to_date(date, '%d/%m/%y');

SET SQL_SAFE_UPDATES = 1;

# Aula: Executando a Análise Exploratória - Análise Univariada com SQL

## Retornando algumas colunas relevantes para nosso estudo

SELECT
	date,
    location,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM cap07.covid_mortes
ORDER BY 2, 1;

## Qual a média de mortos por país?
## Análise Univariada

SELECT
	location,
    ROUND(AVG(total_deaths), 2) AS media_mortos
FROM cap07.covid_mortes
GROUP BY location
ORDER BY media_mortos DESC;

# Aula: Executando a Análise Exploratória - Análise Univariada com SQL

## A análise a seguir tbm é univariada

SELECT
	location,
	ROUND(AVG(total_deaths), 2) AS media_mortos,
    ROUND(AVG(new_cases), 2) AS novos_casos
FROM cap07.covid_mortes
GROUP BY location
ORDER BY media_mortos DESC;

## Qual a proporção de mortes em relação ao total de casos no Brasil?
## Análise Multiariada

SELECT
	date,
    location,
    total_cases,
    total_deaths,
    FLOOR((total_deaths / total_cases) * 100) AS percentual_mortes
FROM cap07.covid_mortes
WHERE location = 'Brazil' OR location = 'Canada'
ORDER BY 2, 1;






SELECT COLUMN_NAME, CHARACTER_SET_NAME, COLLATION_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'cap07'
AND TABLE_NAME = 'covid_mortes';


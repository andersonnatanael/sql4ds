# Aula: Executando a Análise Exploratória - Agregação e Análise - Parte 1/2

## Qual a proporção média entre o total de casos e a população de cada localidade?

SELECT
	location,
    MAX(total_cases) AS total_cases,
    AVG((total_cases) / population) * 100 AS proporcao_casos,
    population
FROM cap07.covid_mortes
GROUP BY location
ORDER BY proporcao_casos DESC;

## Considerando o maior valor de total de casos, quais os países com maior taxa de infecção em relação a população?

SELECT
	location,
    MAX(total_cases) AS total_cases,
    MAX(total_cases / population) * 100 AS percentual_populacao,
    population
FROM cap07.covid_mortes
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY percentual_populacao DESC;

# Aula: Executando a Análise Exploratória - Agregação e Análise - Parte 2/2

## Quais os países com maior número de mortes?

SELECT
	location,
    MAX(total_deaths) AS total_mortes
FROM cap07.covid_mortes
GROUP BY location
ORDER BY total_mortes DESC;
## Dessa forma retorna o valor errado pois a coluna esta configurada com text e nao como int

SELECT
	location,
    MAX(total_deaths * 1) AS total_mortes
FROM cap07.covid_mortes
GROUP BY location
ORDER BY total_mortes DESC;
## Com essa gambiarra, funciona!

## A forma correta de se resolver seria utilizando o CAST para converter para UNSIGNED, ja que ele nao converte para INT
## http://dev.mysql.com/doc/refman/8.0/en/cast-functions.html#function_cast
SELECT
	location,
    MAX(CAST(total_deaths AS UNSIGNED)) AS total_mortes
FROM cap07.covid_mortes
GROUP BY location
ORDER BY total_mortes DESC;

# Aula: Executando a Análise Exploratória - Aplicando o Tipo UNSIGNED

## Quais os continentes com o maior número de mortes?

SELECT
	continent,
    MAX(CAST(total_deaths AS UNSIGNED)) AS total_mortes
FROM cap07.covid_mortes
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_mortes DESC;

## Qual o percentual de mortes por dia?
 
SELECT
	date,
    SUM(new_cases) AS total_cases,
    SUM(CAST(new_deaths AS UNSIGNED)) AS total_deaths,
    COALESCE(ROUND(SUM(CAST(new_deaths AS UNSIGNED)) / SUM(new_cases), 2) * 100, 'NA') AS percent_mortes
FROM cap07.covid_mortes
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;

SELECT * FROM cap07.covid_mortes;

SELECT
	iso_code,
    continent,
    location,
    date,
    MAX(CAST(population AS UNSIGNED)) AS population_max,
    MAX(CAST(total_cases AS UNSIGNED)) AS total_cases_max,
    MAX(CAST(new_cases AS UNSIGNED)) AS new_cases_max
FROM cap07.covid_mortes
GROUP BY location
ORDER BY 7 DESC;

# Aula: Executando a Análise Exploratória - Calculando a Média Móvel (Rolling Statistics) - Parte 1/2

## Qual o número de novos vacinados e a média móvel de novos vacinados ao longo do tempo por localidade?
## Considere apenas os dados da América do Sul.

CREATE OR REPLACE VIEW cap07.media_movel_vacinados AS
SELECT
	M.continent,
    M.location,
    M.date,
    V.new_vaccinations,
    AVG(CAST(V.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY M.location ORDER BY M.date) AS media_movel_vacinados
FROM cap07.covid_mortes AS M
JOIN cap07.covid_vacinacao AS V
ON M.location = V.location
AND M.date = V.date
WHERE M.continent = 'South America'
ORDER BY 2, 3;

# Aula: Executando a Análise Exploratória - Calculando a Média Móvel (Rolling Statistics) - Parte 2/2

SELECT * FROM cap07.covid_mortes;
SELECT * FROM cap07.covid_vacinacao;

## Qual o número de novos vacinados e o total de novos vacinados ao longo do tempo por continente?
## Considere apenas os dados da América do Sul

SELECT
	M.continent,
    M.location,
    M.date,
    COALESCE(CAST(V.new_vaccinations AS UNSIGNED), 0) AS new_vacctinations,
    SUM(CAST(V.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY M.location ORDER BY M.date) AS total_vacinados
FROM cap07.covid_mortes AS M INNER JOIN cap07.covid_vacinacao AS V
ON M.location = V.location
AND M.date = V.date
WHERE M.continent = 'South America'
ORDER BY 1, 2, 3;

## Qual o número de novos vacinados e o total de novos vacinados ao longo do tempo por continente?
## Considere apenas os dados da América do Sul
## Considere a data no formato January/2020

SELECT
	M.continent,
    M.location,
    DATE_FORMAT(M.date, '%M/%Y') AS mes,
    COALESCE(CAST(V.new_vaccinations AS UNSIGNED), 0) AS new_vacctinations,
    SUM(CAST(V.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY M.location ORDER BY DATE_FORMAT(M.date, '%M/%Y')) AS total_vacinados
FROM cap07.covid_mortes AS M INNER JOIN cap07.covid_vacinacao AS V
ON M.location = V.location
AND M.date = V.date
WHERE M.continent = 'South America'
ORDER BY 1, 2;

CREATE OR REPLACE VIEW cap07.novos_vacinados AS
SELECT
	M.continent,
    M.location,
    DATE_FORMAT(M.date, '%M/%Y') AS mes,
    SUM(COALESCE(CAST(V.new_vaccinations AS UNSIGNED), 0)) AS new_vaccinations,
    SUM(SUM(COALESCE(CAST(V.new_vaccinations AS UNSIGNED), 0))) OVER (PARTITION BY M.location ORDER BY M.date) AS total_vacinados
FROM cap07.covid_mortes AS M INNER JOIN cap07.covid_vacinacao AS V
ON M.location = V.location
AND M.date = V.date
WHERE M.continent = 'South America'
GROUP BY M.continent, M.location, DATE_FORMAT(M.date, '%M/%Y')
ORDER BY 1, 2, M.date;

# Aula: Executando a Análise Exploratória - Usando Common Table Expressions (CTE) - Parte 1/2

## Qual o percentual da população com pelo menos 1 dose de vacina ao longo do tempo?
## Considere apenas os dados do Brasil

WITH PopvsVac (continent, location, date, population, new_vaccinations, TotalMovelVacinacao) AS
(
SELECT
	M.continent,
	M.location,
    M.date,
    M.population,
    V.new_vaccinations,
    SUM(CAST(V.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY M.location ORDER BY M.date) AS TotalMovelVacinacao
FROM cap07.covid_mortes AS M
INNER JOIN cap07.covid_vacinacao AS V
ON M.location = V.location
AND M.date = V.date
WHERE M.location = 'Brazil'
)
SELECT *, (TotalMovelVacinacao / population) * 100 AS Percentual_1_Dose FROM PopvsVac;

# Aula: Executando a Análise Exploratória - Usando Common Table Expressions (CTE) - Parte 1/2

## Durante o mês de Maio/2021 o percentual de vacinados com pelo menos uma dose aumentou ou diminuiu no Brasil?

WITH PopvsVac (continent, location, date, population, new_vaccinations, TotalMovelVacinacao) AS
(
SELECT
	M.continent,
	M.location,
    M.date,
    M.population,
    V.new_vaccinations,
    SUM(CAST(V.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY M.location ORDER BY M.date) AS TotalMovelVacinacao
FROM cap07.covid_mortes AS M
INNER JOIN cap07.covid_vacinacao AS V
ON M.location = V.location
AND M.date = V.date
WHERE M.location = 'Brazil'
AND M.date >= '2021-05-01'
AND M.date < '2021-06-01'
)
SELECT *, (TotalMovelVacinacao / population) * 100 AS Percentual_1_Dose FROM PopvsVac;

# Aula: Executando a Análise Exploratória - Entregando o Resultado da Análise

## Criando uma VIEW para armazenar a consulta e entregar o resultado

CREATE OR REPLACE VIEW cap07.PercentualPopVac AS
WITH PopvsVac (continent, location, date, population, new_vaccinations, TotalMovelVacinacao) AS
(
SELECT
	M.continent,
	M.location,
    M.date,
    M.population,
    V.new_vaccinations,
    SUM(CAST(V.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY M.location ORDER BY M.date) AS TotalMovelVacinacao
FROM cap07.covid_mortes AS M
INNER JOIN cap07.covid_vacinacao AS V
ON M.location = V.location
AND M.date = V.date
WHERE M.location = 'Brazil'
)
SELECT *, (TotalMovelVacinacao / population) * 100 AS Percentual_1_Dose FROM PopvsVac;

## Ao criar a VIEW, é possível acessar seus dados como se fosse uma tabela no sgbd
## Por exemplo:

## Total de vacinados com pelo menos 1 dose ao longo do tempo
SELECT * FROM cap07.percentualpopvac;

## Total de vacinados com pelo menos uma dose em June/2021
SELECT *
FROM cap07.percentualpopvac
WHERE DATE_FORMAT(date, '%M/%Y') = 'June/2021';

## Dias com percentual de vacinados com pelo menos 1 dose maior que 30
SELECT *
FROM cap07.percentualpopvac
WHERE Percentual_1_Dose > 30;

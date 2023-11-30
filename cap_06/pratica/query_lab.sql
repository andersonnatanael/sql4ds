# Laboratório - Aggregate Window Function - Parte 1/2

SELECT * FROM cap06.tb_bikes;

## Duração total do aluguel das bikes (em horas):

SELECT SUM(duration / 60 / 60) AS duracao_total_horas
FROM cap06.tb_bikes;

SELECT COUNT(*) FROM cap06.tb_bikes;
SELECT COUNT(DISTINCT(bike_number)) FROM cap06.tb_bikes;
SELECT AVG(duration / 60) FROM cap06.tb_bikes;

SELECT COUNT(*) * 4.9
FROM cap06.tb_bikes
WHERE duration < 10800;
# 1764563.5

SELECT SUM(duration / 60 * 0.05 * 4.9) 
FROM cap06.tb_bikes
WHERE duration < 10800;
# 1288198.5

SELECT COUNT(*) * 8 * 4.9
FROM cap06.tb_bikes
WHERE duration > 10800;
# 47118.4

## Duração total do aluguel das bikes (em horas), ao longo do tempo (soma acumulada):

SELECT duration,
	   ROUND(SUM(duration / 60 / 60) OVER (ORDER BY start_date), 2) AS duracao_total_acumulada
FROM cap06.tb_bikes;

# Laboratório - Aggregate Window Function - Parte 2/2

## Duração total do aluguel das bikes (em horas), ao longo do tempo, por estação de início do aluguel da bike,
## quando a data de início for inferior a '2012-01-08'

SELECT start_station,
	   duration,
	   ROUND(SUM(duration / 60 / 60) OVER (PARTITION BY start_station ORDER BY start_date), 2) AS duracao_total_acumulada
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08';

# Laboratório - Calculando Estatísticas com Window Functions - Parte 1/3

## Qual a média de tempo (em horas) de aluguel de bike da estação de início 31017?

SELECT start_station_number, 
       ROUND(AVG(duration / 60 / 60), 2) AS duracao_media
FROM cap06.tb_bikes
WHERE start_station_number = 31017
GROUP BY start_station_number;

## Qual a média de tempo (em horas) de aluguel da estação de início 31017, ao longo do tempo (média móvel)?

SELECT start_date,
       ROUND(AVG(duration / 60 / 60) OVER (ORDER BY start_date), 2) AS media
FROM cap06.tb_bikes
WHERE start_station_number = 31017;

## Retornar:
## Estação de inicio, data de inicio e duração de cada aluguel de bike em segundos
## Duração total de aluguel das bikes ao longo do tempo por estação de inicio
## Duração média do alugel das bikes ao longo do tempo por estação de início
## Número de aluguéis de bikes por estação ao longo do tempo
## Somente os resistros quando a data de início foir inferior a '2012-01-08'

SELECT * FROM cap06.tb_bikes;

SELECT start_station,
       start_date,
       ROUND(duration / 60, 2) AS duration,
       ROUND(SUM(duration / 60) OVER (PARTITION BY start_station ORDER BY start_date), 2) AS sum_duration,
       ROUND(AVG(duration / 60) OVER (PARTITION BY start_station ORDER BY start_date), 2) AS avg_duration,
       COUNT(*) OVER (PARTITION BY start_station ORDER BY start_date) AS num_shares
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08';
# ORDER BY duration DESC;

# Laboratório - Calculando Estatísticas com Window Functions - Parte 2/3
# Laboratório - Calculando Estatísticas com Window Functions - Parte 3/3

## Retornar:
## Estação de início, data de início de cada aluguel de bike e duração de cada aluguel em segundos
## Número de aluguéis de bikes (independente de estação) ao longo do tempo
## Somente os registros quando a data de início for inferior a '2012-01-08'

## Solução que fiz
SELECT * FROM cap06.tb_bikes;
SELECT start_station,
       start_date,
       duration,
       COUNT(*) OVER (ORDER BY start_date) AS num_share
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08';

## Outra forma que o professor ensinou
SELECT * FROM cap06.tb_bikes;
SELECT start_station,
       start_date,
       duration,
       ROW_NUMBER() OVER (ORDER BY start_date) AS num_share
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08';

# ROW_NUMBER() conta o número de linhas. simples assim...

# E se quisermos o resultado anterior, mas com a contagem por estação?alter

SELECT * FROM cap06.tb_bikes;
SELECT start_station,
       start_date,
       duration,
       ROW_NUMBER() OVER (PARTITION BY start_station ORDER BY start_date) AS num_share
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08';

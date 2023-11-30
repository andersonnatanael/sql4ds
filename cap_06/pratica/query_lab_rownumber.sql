# Lavoratório - ROW NUMBER, DENSE RANK e RANK - Part 1/2
# Lavoratório - ROW NUMBER, DENSE RANK e RANK - Part 2/2

## Estação, data de início, duração em segundos do aluguel e número de aluguéis por estação ao longo do tempo:

SELECT start_station,
       start_date,
       duration,
       ROW_NUMBER() OVER (PARTITION BY start_station ORDER BY start_date) AS num_shares
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08';

## Estação, data de início, duração em segundos do aluguel e número de aluguéis por estação ao longo do tempo:
## para a estação de id 31000, com a coluna de start_date convertida para o formato date

## Estação, data de início, duração em segundos do aluguel e número de aluguéis por estação ao longo do tempo:
## para a estação de id 31000

## ROW_NUMBER()
SELECT start_station,
       CAST(start_date AS DATE) AS start_date,
       duration,
       ROW_NUMBER() OVER (PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS num_shares
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08'
AND start_station_number = 31000;

## DENSE_RANK()
SELECT start_station,
       CAST(start_date AS DATE) AS start_date,
       duration,
       DENSE_RANK() OVER (PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS num_shares
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08'
AND start_station_number = 31000;

## RANK()
SELECT start_station,
       CAST(start_date AS DATE) AS start_date,
       duration,
       RANK() OVER (PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS num_shares
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08'
AND start_station_number = 31000;

## ROW_NUMBER(), DENSE_RANK() e RANK()
SELECT start_station,
       CAST(start_date AS DATE) AS start_date,
       duration,
       ROW_NUMBER() OVER (PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS 'ROW_NUMBER()',
       DENSE_RANK() OVER (PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS 'DENSE_RANK()',
       RANK() OVER (PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS 'RANK()'
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08'
AND start_station_number = 31000;
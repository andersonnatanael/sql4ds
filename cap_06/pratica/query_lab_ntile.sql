# A função NTILE() é uma das WINDOW FUNCTIONS que distribui linhas em uma partição ordenada em um número predefinido
# de grupos aproximadamente iguais. A função atribui a cada grupo um número a partir de 1:

SELECT start_station,
       duration,
       ROW_NUMBER() OVER(PARTITION BY start_station ORDER BY duration) AS 'ROW_NUMBER',
       NTILE(2) OVER(PARTITION BY start_station ORDER BY duration) AS 'NTILE(2)',
       NTILE(4) OVER(PARTITION BY start_station ORDER BY duration) AS 'NTILE(4)',
       NTILE(5) OVER(PARTITION BY start_station ORDER BY duration) AS 'NTILE(5)'
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08'
AND start_station_number = 31000;

SELECT start_station,
       CAST(start_date AS DATE) AS start_date,
       duration,
       ROW_NUMBER() OVER(PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS 'ROW_NUMBER',
       NTILE(2) OVER(PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS 'NTILE(2)',
       NTILE(6) OVER(PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS 'NTILE(6)',
       NTILE(13) OVER(PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS 'NTILE(13)'
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08';
AND start_station_number = 31000;
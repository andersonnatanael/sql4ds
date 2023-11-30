#LAG e LEAD
SELECT start_station,
	   start_date,
       CAST(start_date AS DATE) AS start_date,
	   CAST(start_date AS TIME) AS start_time,
       LAG(duration, 1) OVER (PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS registro_lag,
       duration,
       LEAD(duration, 1) OVER (PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS registro_lead
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08'
AND start_station_number = 31000;

# Qual a diferença da duração do aluguel de bikes ao longo do tempo, de um registro para outro?

SELECT start_station,
       CAST(start_date AS DATE) AS start_date,
       duration,
       duration - LAG(duration, 1) OVER (PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS diferenca
FROM cap06.tb_bikes
WHERE start_date < '2012-01-08'
AND start_station_number = 31000;

# Retirando o valor nulo com sub query
SELECT *
	FROM (
		SELECT start_station,
		       CAST(start_date AS DATE) AS start_date,
			   duration,
		       duration - LAG(duration, 1) OVER (PARTITION BY start_station ORDER BY CAST(start_date AS DATE)) AS diferenca
		FROM cap06.tb_bikes
		WHERE start_date < '2012-01-08'
		AND start_station_number = 31000
        ) AS resultado
WHERE resultado.diferenca IS NOT NULL;








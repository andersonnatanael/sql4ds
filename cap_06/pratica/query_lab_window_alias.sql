SELECT start_station,
       CAST(start_date AS DATE) AS start_date,
       duration,
       ROW_NUMBER() OVER(PARTITION BY start_station ORDER BY duration) AS 'ROW_NUMBER',
       NTILE(2) OVER(PARTITION BY start_station ORDER BY duration) AS 'NTILE(2)',
       NTILE(6) OVER(PARTITION BY start_station ORDER BY duration) AS 'NTILE(6)',
       NTILE(13) OVER(PARTITION BY start_station ORDER BY duration) AS 'NTILE(13)'
  FROM cap06.tb_bikes
 WHERE start_date < '2012-01-08';

SELECT start_station,
       CAST(start_date AS DATE) AS start_date,
       duration,
       ROW_NUMBER() OVER(PARTITION BY start_station ORDER BY duration) AS 'ROW_NUMBER',
       NTILE(2) OVER(PARTITION BY start_station ORDER BY duration) AS 'NTILE(2)',
       NTILE(6) OVER(PARTITION BY start_station ORDER BY duration) AS 'NTILE(6)',
       NTILE(13) OVER(PARTITION BY start_station ORDER BY duration) AS 'NTILE(13)'
  FROM cap06.tb_bikes
 WHERE start_date < '2012-01-08'
WINDOW ntile_window AS (PARTITION BY start_station ORDER BY CAST(start_date AS DATE))
 ORDER BY start_date;
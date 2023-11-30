# Extraindo itens específicos da data:
SELECT
	start_date,
	DATE(start_date),
	TIMESTAMP(start_date),
	YEAR(start_date),
	MONTH(start_date),
	DAY(start_date)
FROM cap06.tb_bikes
WHERE start_station_number = 31000;

# Extraindo o mês da data:
SELECT
	EXTRACT(MONTH FROM start_date) AS mes,
	MONTH(start_date),
	duration
FROM cap06.tb_bikes
WHERE start_station_number = 31000;

# Adicionando 10 dias à data de início

SELECT start_date, DATE_ADD(start_date, INTERVAL 10 DAY) AS start_date, duration
FROM cap06.tb_bikes
WHERE start_station_number = 31000;

# tbm é possível subtrair os dias
SELECT start_date, DATE_ADD(start_date, INTERVAL -10 DAY) AS start_date, duration
FROM cap06.tb_bikes
WHERE start_station_number = 31000;

# Retornando dados de 10 dias anteriores à data de início doaluguel da bike
SELECT start_date, duration
FROM cap06.tb_bikes
WHERE DATE_SUB('2012-03-31', INTERVAL 10 DAY) <= start_date
AND start_station_number;

SELECT DISTINCT(CAST(start_date AS DATE))
FROM cap06.tb_bikes
WHERE DATE_SUB('2012-03-31', INTERVAL 10 DAY) <= start_date
AND start_station_number;

# Diferença entre data de inicio e data de fim
SELECT * 
FROM cap06.tb_bikes;

SELECT
	CAST(start_date AS DATE) AS start_date,
    CAST(end_date AS DATE) AS end_date,
    DATEDIFF(CAST(start_date AS DATE), CAST(end_date AS DATE)) AS diff
FROM cap06.tb_bikes
WHERE start_station_number = 31000;

# Diferença entre hora de inicio e hora de fim
SELECT
	DATE_FORMAT(start_date, '%H') AS start_date,
    DATE_FORMAT(end_date, '%H') AS end_date,
    (DATE_FORMAT(end_date, '%H') - DATE_FORMAT(start_date, '%H')) AS diff
FROM cap06.tb_bikes
WHERE start_station_number = 31000;
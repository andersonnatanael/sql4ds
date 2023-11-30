SELECT DISTINCT(member_type) FROM cap06.tb_bikes_2;
SELECT COUNT(member_type) FROM cap06.tb_bikes_2 WHERE member_type = 'unknown';
SELECT * FROM cap06.tb_bikes_2 WHERE member_type = 'unknown';

# 1- Qual a média de tempo (em segundos) de duração do aluguel de bike por tipo de membro? 

SELECT
	member_type,
    ROUND(AVG(duration), 2) AS media
FROM cap06.tb_bikes_2
GROUP BY member_type
ORDER BY media DESC;

# 2- Qual a média de tempo (em segundos) de duração do aluguel de bike por tipo de membro e 
# por estação fim (onde as bikes são entregues após o aluguel)?

SELECT
	member_type,
    end_station,
    ROUND(AVG(duration), 2) AS media
FROM cap06.tb_bikes_2
GROUP BY member_type, end_station;

# 3- Qual a média de tempo (em segundos) de duração do aluguel de bike por tipo de membro e 
# por estação fim (onde as bikes são entregues após o aluguel) ao longo do tempo?

# Minha solução

SELECT
	start_date,
	member_type,
    end_station,
    ROUND(AVG(duration) OVER (PARTITION BY member_type ORDER BY end_date), 2) AS media
FROM cap06.tb_bikes_2
WINDOW avg_duration AS (PARTITION BY end_station ORDER BY end_date) 
ORDER BY end_station, member_type, start_date;

# Solução do professor

SELECT
	start_date,
	member_type,
    end_station,
    ROUND(AVG(duration) OVER (PARTITION BY member_type ORDER BY end_date), 2) AS media
FROM cap06.tb_bikes_2;

# 4- Qual hora do dia (independente do mês) a bike de número W01182 teve o maior número de 
# aluguéis considerando a data de início? 

SELECT DISTINCT(HOUR(start_date)) AS hours FROM cap06.tb_bikes_2;

SELECT
	HOUR(start_date) AS hours,
    COUNT(HOUR(start_date)) AS shares
FROM cap06.tb_bikes_2
WHERE bike_number = 'W01182'
GROUP BY hours
ORDER BY shares DESC;

# 5- Qual o número de aluguéis da bike de número W01182 ao longo do tempo considerando a 
# data de início?

#SELECT
#	HOUR(start_date) AS hours,
#    COUNT(HOUR(start_date)) AS total
#FROM cap06.tb_bikes_2
#WHERE bike_number = W01182;

SELECT
	CAST(start_date AS DATE) AS start_date,
    ROW_NUMBER() OVER (PARTITION BY CAST(start_date AS DATE) ORDER BY CAST(start_date AS DATE)) AS contagem_diaria,
    ROW_NUMBER() OVER (ORDER BY CAST(start_date AS DATE)) AS contagem_geral
FROM cap06.tb_bikes_2
WHERE bike_number = 'W01182';

# 6- Retornar: 
# Estação fim, data fim de cada aluguel de bike e duração de cada aluguel em segundos 
# Número de aluguéis de bikes (independente da estação) ao longo do tempo  
# Somente os registros quando a data fim foi no mês de Abril 

SELECT
	end_station,
    end_date,
    duration,
	ROW_NUMBER() OVER (ORDER BY end_date) AS num_shares
FROM cap06.tb_bikes_2
WHERE MONTH(end_date) = 04;

# 7- Retornar: 
# Estação fim, data fim e duração em segundos do aluguel  
# A data fim deve ser retornada no formato: 01/January/2012 00:00:00 
# Queremos a ordem (classificação ou ranking) dos dias de aluguel ao longo do tempo 
# Retornar os dados para os aluguéis entre 7 e 11 da manhã 

SELECT
	end_station,
    DATE_FORMAT(end_date, '%d/%M/%Y %H:%i:%s') AS end_date,
    duration,
    DENSE_RANK() OVER (PARTITION BY end_station ORDER BY DATE(end_date)) AS num_days    
FROM cap06.tb_bikes
WHERE HOUR(end_date) >= 07 AND HOUR(end_date) <= 11;

SELECT
	end_station,
    DATE_FORMAT(end_date, '%d/%M/%Y %H:%i:%s') AS end_date,
    duration,
    DENSE_RANK() OVER (PARTITION BY end_station ORDER BY DATE(end_date)) AS num_days,
    RANK() OVER (PARTITION BY end_station ORDER BY DATE(end_date)) AS rank_shares
FROM cap06.tb_bikes
WHERE EXTRACT(HOUR FROM end_date) BETWEEN 07 AND 11;

# 8- Qual a diferença da duração do aluguel de bikes ao longo do tempo, de um registro para
# outro, considerando data de início do aluguel e estação de início? 
# A data de início deve ser retornada no formato: Sat/Jan/12 00:00:00 (Sat = Dia da semana 
# abreviado e Jan igual mês abreviado). Retornar os dados para os aluguéis entre 01 e 03 da manhã

SELECT * 
	FROM ( SELECT
		       DATE_FORMAT(start_date, '%a/%b%y %H:%i:%s') AS start_date,
               start_station,
               duration,
               LAG(duration, 1) OVER (PARTITION BY start_station ORDER BY start_date) AS prox_duration,
               duration - LAG(duration, 1) OVER (PARTITION BY start_station ORDER BY start_date) AS diferenca
		   FROM cap06.tb_bikes_2
           WHERE EXTRACT(HOUR FROM start_date) BETWEEN 01 AND 03) AS resultado
WHERE resultado.diferenca IS NOT NULL;

SELECT
DATE_FORMAT(start_date, '%a/%b%y %H:%i:%s') AS start_date,
start_station,
duration,
LAG(duration, 1) OVER (PARTITION BY start_station ORDER BY start_date) AS prox_duration,
duration - LAG(duration, 1) OVER (PARTITION BY start_station ORDER BY start_date) AS diferenca
FROM cap06.tb_bikes_2
WHERE EXTRACT(HOUR FROM start_date) BETWEEN 01 AND 03;

# ao particionar por start_station como fiz na query anterior foram gerados nulos para cada station, resolvi isso retirando o particionamento

SELECT
DATE_FORMAT(start_date, '%a/%b%y %H:%i:%s') AS start_date,
start_station,
duration,
LAG(duration, 1) OVER (ORDER BY start_date) AS prox_duration,
duration - LAG(duration, 1) OVER (ORDER BY start_date) AS diferenca
FROM cap06.tb_bikes_2;

SELECT * FROM cap06.tb_bikes_2;

# 9- Retornar: 
# Estação fim, data fim e duração em segundos do aluguel  
# A data fim deve ser retornada no formato: 01/January/2012 00:00:00 
# Queremos os registros divididos em 4 grupos ao longo do tempo por partição 
# Retornar os dados para os aluguéis entre 8 e 10 da manhã

SELECT
	end_station,
    DATE_FORMAT(end_date, '%d/%M/%Y %H:%i:%s')
    duration,
    NTILE(4) OVER (PARTITION BY end_station ORDER BY start_date) AS agrupamento
FROM cap06.tb_bikes_2
WHERE HOUR(end_date) >= 8 AND HOUR(end_date) <= 10;

# Qual critério usado pela função NTILE para dividir os grupos?
# O NTILE criou 4 grupos separando pelo critério que eu especifiquei, que no caso foi a coluna end_date, 4 grupos agrupados por datas próximas.alter

# 10- Quais estações tiveram mais de 35 horas de duração total do aluguel de bike ao longo do 
# tempo considerando a data fim e estação fim? 
# Retorne os dados entre os dias '2012-04-01' e '2012-04-02' 
# Dica: Use função window e subquery

# Minha solução incompleta

SELECT * 
	FROM (
		SELECT
			end_station,
			CAST(end_date AS DATE) AS end_date,
			ROUND(SUM(duration / 60 / 60) OVER (PARTITION BY end_station ORDER BY CAST(end_date AS DATE)), 2) AS duration
		FROM cap06.tb_bikes_2
        WHERE end_date BETWEEN '2012-04-01' AND '2012-04-02'
        ) AS teste
WHERE teste.duration >= 35;

# Solução do professor

SELECT
	end_station,
    CAST(end_date AS DATE) AS end_date,
    SUM(duration / 60 / 60) OVER (PARTITION BY end_station ORDER BY CAST(end_date AS DATE)) AS tempo_total_horas
FROM cap06.tb_bikes_2
WHERE end_date BETWEEN '2012-04-01' AND '2012-04-02';

# Próximo passo

SELECT *
FROM (
		SELECT
			end_station,
			CAST(end_date AS DATE) AS end_date,
			SUM(duration / 60 / 60) OVER (PARTITION BY end_station ORDER BY CAST(end_date AS DATE)) AS tempo_total_horas
		FROM cap06.tb_bikes_2
		WHERE end_date BETWEEN '2012-04-01' AND '2012-04-02'
	 ) AS resultado
WHERE resultado.tempo_total_horas >= 35
ORDER BY resultado.end_station;
    
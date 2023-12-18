SELECT * FROM cap09.dataset WHERE pollutant = 'o3' ORDER BY CAST(value AS DOUBLE) DESC;

# 1 – Qual a diferença nos níveis de poluição entre as minimas e máximas dos paises?

WITH meu_cte AS
(
SELECT
	country AS Pais,
    pollutant AS Poluente,
    CAST(value AS DOUBLE) AS Valor
FROM cap09.dataset
WHERE CAST(value AS DOUBLE) > 0
)
SELECT
	Pais,
    Poluente,
    MIN(Valor) AS menor_poluicao,
    MAX(Valor) AS maior_poluicao,
    COALESCE(ROUND(MAX(Valor) / MIN(Valor), 2), 0.00) AS 'diferenca_%'
FROM meu_cte
GROUP BY Pais, Poluente
ORDER BY 5 DESC;

SELECT
	country AS Pais,
    pollutant AS Poluente,
    MIN(ROUND(CAST(value AS DOUBLE), 2)) AS menor_poluicao,
    MAX(ROUND(CAST(value AS DOUBLE), 2)) AS maior_poluicao,
    COALESCE(ROUND(MAX(CAST(value AS DOUBLE)) / MIN(CAST(value AS DOUBLE)), 2), 0.00) AS diferenca
FROM cap09.dataset
WHERE CAST(value AS DOUBLE) > 0
GROUP BY country, pollutant
HAVING diferenca >= 100
ORDER BY 5 DESC;

# 2 – Quais os poluentes foram considerados na pesquisa?

SELECT DISTINCT pollutant FROM cap09.dataset;

# 3 – Qual foi a média de poluição ao longo do tempo provocada pelo poluente ground-level ozone (o3)?

SELECT
	city AS Cidade,
	country AS Pais,
    pollutant AS Poluente,
    DATE_FORMAT(timestamp, '%Y-%m-%d - %T') AS 'Data',
	ROUND(AVG(CAST(value AS UNSIGNED)) OVER (PARTITION BY country, city, pollutant ORDER BY DATE_FORMAT(timestamp, '%Y-%m-%e - %T')), 2) AS m_p_l_tempo
FROM cap09.dataset;

SELECT
	country AS Pais,
    DATE_FORMAT(timestamp, '%Y-%m-%d - %T') AS 'Data',
	ROUND(AVG(CAST(value AS UNSIGNED)) OVER (PARTITION BY country ORDER BY DATE_FORMAT(timestamp, '%Y-%m-%e - %T')), 2) AS m_p_l_tempo
FROM cap09.dataset
WHERE pollutant = 'o3'
ORDER BY country, Data;

# 4 – Qual foi a média de poluição causada pelo poluente ground-level ozone (o3) por país medida em µg/m³ (microgramas por metro cúbico)?

SELECT
	country AS Pais,
    ROUND(AVG(CAST(value AS UNSIGNED)), 2) AS poluicao_media
FROM cap09.dataset
WHERE pollutant = 'o3'
AND unit = 'µg/m³'
GROUP BY country
ORDER BY poluicao_media;

# 5 – Considerando o resultado anterior, qual país teve maior índice de poluição geral por o3, Itália (IT) ou Espanha (ES)? E por quê?

SELECT
	country AS Pais,
    ROUND(AVG(CAST(value AS UNSIGNED)), 2) AS poluicao_media
FROM cap09.dataset
WHERE pollutant = 'o3'
AND country = 'IT' OR country = 'ES'
GROUP BY country
ORDER BY poluicao_media DESC;

SELECT
	country AS Pais,
    ROUND(AVG(CAST(value AS UNSIGNED)), 2) AS poluicao_media,
    STDDEV(CAST(value AS UNSIGNED)) AS desvio_padrao,
    MIN(CAST(value AS UNSIGNED)) poluicao_min,
    MAX(CAST(value AS UNSIGNED)) poluicao_max
FROM cap09.dataset
WHERE pollutant = 'o3'
AND unit = 'µg/m³'
AND country = 'IT' OR country = 'ES'
GROUP BY country
ORDER BY poluicao_media;

# O Coeficiente de Variação (CV) é uma medida estatística da dispersão dos dados em uma série de dados em torno da média. 
# O Coeficiente de Variação representa a razão entre o desvio padrão e a média e é uma estatística útil para comparar o grau 
# de variação de uma série de dados para outra, mesmo que as médias sejam drasticamente diferentes umas das outras.

# Quanto maior o Coeficiente de Variação , maior o nível de dispersão em torno da média, logo, maior variabilidade.

# O Coeficiente de Variação é calculado da seguinte forma: CV = (Desvio Padrão / Média) * 100

WITH pollution_cte AS
(
SELECT
	country AS Pais,
    ROUND(AVG(CAST(value AS UNSIGNED)), 2) AS poluicao_media,
    ROUND(STDDEV(CAST(value AS UNSIGNED)), 2) AS desvio_padrao,
    MIN(CAST(value AS UNSIGNED)) poluicao_min,
    MAX(CAST(value AS UNSIGNED)) poluicao_max
FROM cap09.dataset
WHERE pollutant = 'o3'
AND unit = 'µg/m³'
AND country IN ('IT', 'ES')
#AND country = 'IT' OR country = 'ES'
GROUP BY country
ORDER BY poluicao_media
)
SELECT
	*,
    ROUND((desvio_padrao / poluicao_media) * 100, 2) AS coeficiente_variacao
FROM pollution_cte;

# Conclusão: 
# Embora o CV da Espanha seja muito maior, a média da Itália é muito alta, com os pontos de dados mais próximos da média.
# Os 2 países tem um alto índice de poluição geral por o3
# A Itália apresenta maior índice de poluição geral, pois a média é alta e os pontos de dados estão mais próximos da média.

# 6 – Quais localidades e países tiveram média de poluição em 2020 superior a 100 µg/m³ para o poluente fine particulate matter (pm25)?

SELECT
	COALESCE(location, 'Total') AS localidade,
	COALESCE(country, 'Total') AS pais,
    ROUND(AVG(value)) AS poluicao_media
FROM cap09.dataset
WHERE pollutant = 'pm25'
AND YEAR(timestamp) = 2020
GROUP BY location, country WITH ROLLUP
HAVING poluicao_media > 100;


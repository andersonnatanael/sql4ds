# Script 07 - A

# Cria a tabela
CREATE TABLE cap08.TB_PIPELINE_VENDAS (
  `Account` text,
  `Opportunity_ID` text,
  `Sales_Agent` text,
  `Deal_Stage` text,
  `Product` text,
  `Created_Date` text,
  `Close_Date` text,
  `Close_Value` text DEFAULT NULL
);

# Carregue o dataset3.csv na tabela anterior a partir do MySQL Workbench

# Cria a tabela
CREATE TABLE cap08.TB_VENDEDORES (
  `Sales_Agent` text,
  `Manager` text,
  `Regional_Office` text,
  `Status` text
);

SELECT * FROM cap08.tb_pipeline_vendas;

SELECT * FROM cap08.tb_vendedores;

# Carregue o dataset4.csv na tabela anterior a partir do MySQL Workbench

# Responda os itens abaixo com Linguagem SQL

# 1- Total de vendas

SELECT COUNT(*)
FROM cap08.tb_pipeline_vendas;

# 2- Valor total vendido

SELECT SUM(CAST(Close_Value AS UNSIGNED)) AS total_vendido
FROM cap08.tb_pipeline_vendas
WHERE Deal_Stage = 'Won';

# 3- Número de vendas concluídas com sucesso

SELECT COUNT(*) AS numero_vendas_sucesso
FROM cap08.tb_pipeline_vendas
WHERE Deal_Stage = 'Won';

# 4- Média do valor das vendas concluídas com sucesso

SELECT ROUND(AVG(CAST(Close_Value AS UNSIGNED)), 2) AS media_vendas
FROM cap08.tb_pipeline_vendas
WHERE Deal_Stage = 'Won';

# 5- Valos máximo vendido

SELECT MAX(CAST(Close_Value AS UNSIGNED)) AS maximo_valor
FROM cap08.tb_pipeline_vendas
WHERE Deal_Stage = 'Won';

# 6- Valor mínimo vendido entre as vendas concluídas com sucesso

SELECT MIN(CAST(Close_Value AS UNSIGNED)) AS minimo_valor
FROM cap08.tb_pipeline_vendas
WHERE Deal_Stage = 'Won';

# 7- Valor médio das vendas concluídas com sucesso por agente de vendas
### Não era preciso fazer o INNER JOIN pois a coluna Sales_Agent estava nas duas tabelas...alter
SELECT
	Sales_Agent,
    ROUND(AVG(CAST(Close_Value AS UNSIGNED)), 2) media_vendas
FROM cap08.tb_pipeline_vendas
WHERE B.Deal_Stage = 'Won'
GROUP BY Sales_Agent
ORDER BY media_vendas DESC;

# 8- Valor médio das vendas concluídas com sucesso por gerente do agente de vendas

SELECT
	A.Manager,
    ROUND(AVG(CAST(B.Close_Value AS UNSIGNED)), 2) media_vendas
FROM cap08.tb_vendedores AS A INNER JOIN cap08.tb_pipeline_vendas AS B
ON A.Sales_Agent = B.Sales_Agent
AND B.Deal_Stage = 'Won'
GROUP BY A.Manager
ORDER BY media_vendas DESC;

# 9- Total do valor de fechamento da venda por agente de venda e por conta das vendas concluídas com sucesso

SELECT
	COALESCE(A.Sales_Agent, 'Total agentes') AS Agente,
    COALESCE(B.Account, 'Total sedes') AS Account,
    ROUND(SUM(CAST(B.Close_Value AS UNSIGNED)), 2) AS total_vendas
FROM cap08.tb_vendedores AS A INNER JOIN cap08.tb_pipeline_vendas AS B
ON A.Sales_Agent = B.Sales_Agent
WHERE B.Deal_Stage = 'Won'
GROUP BY A.Sales_Agent, B.Account WITH ROLLUP
ORDER BY 1, 2;

# 10- Número de vendas por agente de venda para as vendas concluídas com sucesso e valor de venda superior a 1000

SELECT
    Sales_Agent,
    COUNT(Deal_Stage) AS total_vendas
FROM cap08.tb_pipeline_vendas
WHERE Close_Value > 1000
GROUP BY Sales_Agent
ORDER BY total_vendas DESC;

# 11- Número de vendas e a média do valor de venda por agente de vendas

SELECT
    Sales_Agent,
    COUNT(Deal_Stage) AS total_vendas,
    ROUND(AVG(CAST(Close_Value AS UNSIGNED)), 2) AS media_vendas
FROM cap08.tb_pipeline_vendas
GROUP BY Sales_Agent
ORDER BY total_vendas DESC;

# 12- Quais agentes de vendas tiveram mais de 30 vendas?

SELECT
	Sales_Agent,
    COUNT(Close_Value) AS total_vendas
FROM cap08.tb_pipeline_vendas
GROUP BY Sales_Agent
HAVING total_vendas > 30
ORDER BY total_vendas DESC;

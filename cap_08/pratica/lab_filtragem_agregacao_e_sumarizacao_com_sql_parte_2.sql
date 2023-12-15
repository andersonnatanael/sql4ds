# Lab - Filtragem, Agregação e Sumarização com SQL - Parte 5/10

CREATE TABLE cap08.TB_CLIENTES_LOC (
  nome_cliente text,
  faturamento double DEFAULT NULL,
  numero_funcionarios int DEFAULT NULL
);

# Carregue o dataset5.csv na tabela anterior a partir do MySQL Workbench

CREATE TABLE cap08.TB_CLIENTES_INT (
  nome_cliente text,
  faturamento double DEFAULT NULL,
  numero_funcionarios int DEFAULT NULL,
  localidade_sede text
);

# Carregue o dataset6.csv na tabela anterior a partir do MySQL Workbench

SELECT * FROM cap08.TB_CLIENTES_LOC;
SELECT * FROM cap08.TB_CLIENTES_INT;

## Retornar todos os clientes e suas localidades, Clientes locais est'ao nos EUA.

SELECT
	A.nome_cliente,
    A.localidade_sede AS localidade_clientes
FROM cap08.tb_clientes_int AS A
UNION
SELECT
	B.nome_cliente,
    'USA' AS localidade_clientes
FROM cap08.tb_clientes_loc AS B
ORDER BY nome_cliente;

# Lab - Filtragem, Agregação e Sumarização com SQL - Parte 6/10

## O cliente ~Ganjaflex~aparece nas duas tabelas de clientes?

SELECT
	COALESCE(A.nome_cliente, 'Sem cliente') AS nome_cliente,
    faturamento,
    localidade_sede
FROM cap08.tb_clientes_int AS A
WHERE A.nome_cliente = 'Ganjaflex'
UNION
SELECT
	COALESCE(B.nome_cliente, 'Sem cliente') AS nome_cliente,
    faturamento,
    'USA' AS localidade_sede
FROM cap08.tb_clientes_loc AS B
WHERE B.nome_cliente = 'Ganjaflex';

## Quais os clientes internacionais que aparecem na tabela de clientes locais?

SELECT nome_cliente
FROM cap08.tb_clientes_int
WHERE TRIM(nome_cliente) IN(SELECT nome_cliente FROM cap08.tb_clientes_loc);

## Qual a média de faturamento por localidade?
## Os clientes locais estão nos EUA e o resultado deve ser ordenado pela média de faturamento.

SELECT
	A.localidade_sede AS localidade,
    ROUND(AVG(A.faturamento), 2) AS media_faturamento
FROM cap08.tb_clientes_int AS A
GROUP BY A.localidade_sede
UNION
SELECT
	'USA' AS localidade,
    ROUND(AVG(B.faturamento), 2) AS media_faturamento
FROM cap08.tb_clientes_loc AS B
GROUP BY localidade
ORDER BY media_faturamento DESC;

# Lab - Filtragem, Agregação e Sumarização com SQL - Parte 7/10

## Use as tabelas tb_pipeline_vendas e tb_vendedores
## Retorne o total do valor de vendas de todos os agentes de vendas e os sub-totais por escritório regional
## Retorne o resultado somente das vendas concluídas com sucesso

SELECT * FROM cap08.tb_pipeline_vendas LIMIT 10;
SELECT * FROM cap08.tb_vendedores LIMIT 10;

SELECT
	COALESCE(B.Regional_Office, 'Total') AS escritorio_regional,
	COALESCE(B.Sales_Agent, 'Total') AS agente_vendas,
    ROUND(SUM(CAST(A.Close_Value AS UNSIGNED)), 2) AS total
FROM cap08.tb_pipeline_vendas AS A INNER JOIN cap08.tb_vendedores AS B
ON A.Sales_Agent = B.Sales_Agent
WHERE Deal_Stage = 'Won'
GROUP BY Regional_Office, B.Sales_Agent WITH ROLLUP;

## Retorne o gerente, o escritório regional, o cliente, o número de vendas e os sub-totais do número de vendas
## Faça isso apenas para as vendas concluídas com sucesso

SELECT
	COALESCE(B.Regional_Office, 'Total') AS Regional_Office,
	COALESCE(B.Manager, 'Total') AS Manager,
	COALESCE(A.Account, 'Total') AS Account,
    COUNT(A.Created_Date) AS Numero_Vendas,
    SUM(CAST(A.Close_Value AS UNSIGNED)) AS Total
FROM cap08.tb_pipeline_vendas AS A INNER JOIN cap08.tb_vendedores AS B
ON A.Sales_Agent = B.Sales_Agent
WHERE A.Deal_Stage = 'Won'
GROUP BY B.Regional_Office, B.Manager, A.Account WITH ROLLUP;

## Nível Ninja das Galáxias :)
## Retorne o gerente, o escritório regional, o cliente, o número de vendas e os sub-totais do número de vendas
## Faça isso apenas para vendas concluidas com sucesso
## Use CTE

WITH meu_cte AS (
	SELECT
		COALESCE(B.Regional_Office, 'Total') AS Regional_Office,
		COALESCE(B.Manager, 'Total') AS Manager,
		COALESCE(A.Account, 'Total') AS Account,
        COUNT(A.Created_Date) AS Numero_Vendas,
		SUM(CAST(A.Close_Value AS UNSIGNED)) AS Total
	FROM cap08.tb_pipeline_vendas AS A INNER JOIN cap08.tb_vendedores AS B
	ON A.Sales_Agent = B.Sales_Agent
    WHERE A.Deal_Stage = 'Won'
	GROUP BY B.Regional_Office, B.Manager, A.Account WITH ROLLUP
)
SELECT Regional_Office, Manager, Account, Numero_Vendas, Total
FROM meu_cte
WHERE Regional_Office = 'Central';

## CTE feito pelo professor

WITH temp_table AS (
SELECT
	B.Regional_Office,
	B.Manager,
	A.Account,
    A.Created_Date,
	A.Close_Value
FROM cap08.tb_pipeline_vendas AS A INNER JOIN cap08.tb_vendedores AS B
WHERE A.Deal_Stage = 'Won'
)
SELECT
	COALESCE(Regional_Office, 'Total') AS Regional_Office,
	COALESCE(Manager, 'Total') AS Manager,
    COALESCE(Account, 'Total') AS 'Account',
    COUNT(*) AS Numero_Vendas,
    SUM(CAST(Close_Value AS UNSIGNED)) AS Total_vendas
FROM temp_table
GROUP BY Regional_Office, Manager, Account WITH ROLLUP;

# Lab - Filtragem, Agregação e Sumarização com SQL - Parte 9/10

CREATE TABLE cap08.TB_PEDIDOS_PRODUTOS (
  sales_agent text,
  account text,
  product text,
  order_value int DEFAULT NULL,
  create_date text
);

SELECT * FROM cap08.tb_pedidos_produtos ORDER BY account;

SELECT *
FROM cap08.tb_pedidos_produtos
WHERE account = 'Acme Corporation'
ORDER BY CAST(create_date AS DATE);

SELECT
	account,
    CAST(create_date AS DATE) AS data_pedido,
    ROUND(AVG(order_value), 2) AS media_valor_pedido
FROM cap08.tb_pedidos_produtos
WHERE account = 'Acme Corporation'
GROUP BY account, data_pedido
ORDER BY data_pedido;

SELECT
	account,
    CAST(create_date AS DATE) AS data_pedido,
    ROUND(AVG(order_value) OVER (), 2) AS media_valor_pedido
FROM cap08.tb_pedidos_produtos
WHERE account = 'Acme Corporation'
ORDER BY data_pedido;

SELECT
	account,
    CAST(create_date AS DATE) AS data_pedido,
    ROUND(AVG(order_value) OVER (PARTITION BY account ORDER BY CAST(create_date AS DATE)), 2) AS media_valor_pedido
FROM cap08.tb_pedidos_produtos
WHERE account = 'Acme Corporation'
ORDER BY data_pedido;

SELECT
	account,
    CAST(create_date AS DATE) AS data_pedido,
    FIRST_VALUE(order_value) OVER (PARTITION BY account ORDER BY CAST(create_date AS DATE)) AS media_valor_pedido
FROM cap08.tb_pedidos_produtos
WHERE account = 'Acme Corporation'
ORDER BY data_pedido;

# Lab - Filtragem, Agregação e Sumarização com SQL - Parte 10/10

SELECT
	account,
    CAST(create_date AS DATE) AS data_pedido,
    LAG(order_value, 1, -1) OVER (PARTITION BY account ORDER BY CAST(create_date AS DATE)) AS 'LAG',
    order_value,
    LEAD(order_value, 1, -1) OVER (PARTITION BY account ORDER BY CAST(create_date AS DATE)) AS 'LEAD'
FROM cap08.tb_pedidos_produtos
WHERE account = 'Acme Corporation'
ORDER BY data_pedido;

## Nível Ninja das Galáxias :)
## Calcule a diferença entre o valor pedido do dia e do dia anterior.

WITH minha_cte AS
(
SELECT
	account,
    CAST(create_date AS DATE) AS data_pedido,
    LAG(order_value, 1, 0) OVER (PARTITION BY account ORDER BY CAST(create_date AS DATE)) AS dia_anterior,
    order_value
FROM cap08.tb_pedidos_produtos
ORDER BY data_pedido
)
SELECT 
	account,
	data_pedido,
    order_value AS pedido_dia,
    dia_anterior AS pedido_anterior,
    order_value - dia_anterior AS diferenca
FROM minha_cte
WHERE account = 'Acme Corporation';

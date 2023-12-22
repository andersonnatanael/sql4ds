# Plano de Execução de Consultas (Visual Explain) - Parte 1/3

SELECT * FROM cap11.tb_clientes;

# Plano de Execução de Consultas (Visual Explain) - Parte 2/3

# https://dev.mysql.com/doc/workbench/en/wb-performance-explain.html

## Um componente que você deve observar é o “custo da consulta”. 

## O custo da consulta refere-se ao quão caro o MySQL considera essa consulta específica em termos do custo 
## geral da execução da consulta e é baseado em muitos fatores diferentes.

## As consultas simples geralmente têm um custo de consulta inferior a 1.000. 
## Consultas com um custo entre 1.000 e 100.000 são consideradas consultas de custo médio e geralmente são 
## rápidas se você estiver executando apenas centenas dessas consultas por segundo (não dezenas de milhares).

## Consultas com um custo superior a 100.000 são consultas caras. Muitas vezes, essas consultas ainda 
## serão executadas rapidamente quando você for um único usuário no sistema, mas você deve pensar cuidadosamente 
## sobre a frequência com que usa essas consultas (especialmente à medida que o número de usuários aumenta).

SELECT * FROM cap11.tb_clientes WHERE id = 1;

SELECT * FROM cap11.TB_CLIENTES WHERE nome = 'Bob Silva';

FLUSH STATUS;

SELECT * FROM cap11.tb_clientes WHERE id = 1;

SHOW SESSION STATUS LIKE 'Handler%';

# Plano de Execução de Consultas (Visual Explain) - Parte 3/3

SELECT * FROM cap11.TB_CLIENTES WHERE nome = 'Bob Silva' OR nome = 'Zinedine Zidane';

SELECT cap11.TB_CLIENTES.nome, cap11.TB_PEDIDOS.data_pedido, cap11.TB_PEDIDOS.valor
FROM cap11.TB_CLIENTES
JOIN cap11.TB_PEDIDOS ON (cap11.TB_CLIENTES.id = cap11.TB_PEDIDOS.id_cliente)
WHERE cap11.TB_CLIENTES.nome = 'Zico Miranda';

SELECT id as ID FROM cap11.TB_CLIENTES  
UNION ALL  
SELECT id_cliente as ID FROM cap11.TB_PEDIDOS;

SELECT id AS ID FROM cap11.TB_CLIENTES  
UNION ALL  
SELECT id_cliente AS ID FROM cap11.TB_PEDIDOS
ORDER BY ID;

SELECT
	IF(GROUPING(ano), 'Total de Todos os Anos', ano) AS ano,
	IF(GROUPING(pais), 'Total de Todos os Países', pais) AS pais,
	IF(GROUPING(produto), 'Total de Todos os Produtos', produto) AS produto,
	SUM(faturamento) faturamento 
FROM cap05.TB_VENDAS
GROUP BY ano, pais, produto WITH ROLLUP;

SELECT estado_cliente, nome_vendedor, CEILING(AVG(valor_pedido)) AS media
FROM cap05.TB_PEDIDOS P INNER JOIN cap05.TB_CLIENTES C INNER JOIN cap05.TB_VENDEDOR V
ON P.id_cliente = C.id_cliente
AND P.id_vendedor = V.id_vendedor
GROUP BY estado_cliente, nome_vendedor
HAVING media > 800
ORDER BY nome_vendedor;

SELECT COALESCE(B.regional_office, "Total") AS "Escritório Regional",
       COALESCE(A.sales_agent, "Total") AS "Agente de Vendas",
       SUM(A.close_value) AS Total
FROM cap08.TB_PIPELINE_VENDAS AS A, cap08.TB_VENDEDORES AS B
WHERE A.sales_agent = B.sales_agent
AND A.deal_stage = "Won"
GROUP BY B.regional_office, A.sales_agent WITH ROLLUP;

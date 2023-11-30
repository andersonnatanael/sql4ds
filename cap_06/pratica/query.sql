SELECT * FROM cap06.tb_vendas;

# Total de vendas:

SELECT SUM(valor_venda) AS total_vendas
FROM cap06.tb_vendas;

# Total de vendas por ano fiscal

SELECT
	IF(GROUPING(ano_fiscal),
		'Total de vendas',
        ano_fiscal) AS ano_fiscal,
	SUM(valor_venda) AS valor_venda
FROM cap06.tb_vendas
GROUP BY ano_fiscal WITH ROLLUP;
    
# Total de vendas por funcionário

SELECT nome_funcionario, SUM(valor_venda) AS total_vendas
FROM cap06.tb_vendas
GROUP BY nome_funcionario
ORDER BY total_vendas;

# Total de vendas por funcionário e por ano

SELECT ano_fiscal, nome_funcionario, SUM(valor_venda) AS total_vendas
FROM cap06.tb_vendas
GROUP BY ano_fiscal, nome_funcionario 
ORDER BY ano_fiscal;

## A query anterior não mudou absolutamente nada nos dados, apenas da pra mudar e manipular a ordem em qeu eles aparecem, nome funcionario ou ano fiscal

# Total de vendas por funcionário, por ano
SELECT
	ano_fiscal,
    nome_funcionario,
    valor_venda,
    SUM(valor_venda) OVER (PARTITION BY ano_fiscal) total_vendas_ano
FROM cap06.tb_vendas
ORDER BY ano_fiscal;

# Total de vendas por ano, por funcionário e total de vendas do funcionário

SELECT
	ano_fiscal,
    nome_funcionario,
    valor_venda,
    SUM(valor_venda) OVER (PARTITION BY nome_funcionario) total_vendas_ano
FROM cap06.tb_vendas
ORDER BY ano_fiscal;

# Total de vendas por ano, por funcionário e total de vendas geral

SELECT
	ano_fiscal,
    nome_funcionario,
    valor_venda,
    SUM(valor_venda) OVER () total_vendas_ano
FROM cap06.tb_vendas
ORDER BY valor_venda DESC;

# Número de vendas por ano, por funcionário e número total de vendas em todos os anos

SELECT
	ano_fiscal,
    nome_funcionario,
    COUNT(*) num_vendas_ano,
    COUNT(*) OVER() num_vendas_geral
FROM cap06.tb_vendas
GROUP BY ano_fiscal, nome_funcionario
ORDER BY ano_fiscal;

## DESAFIO: Reescrever a query anterior usando subquery

SELECT
	ano_fiscal,
    nome_funcionario,
    COUNT(*) AS num_vendas_ano,
    (SELECT COUNT(*) FROM cap06.tb_vendas) AS num_vendas_geral
FROM cap06.tb_vendas
GROUP BY ano_fiscal, nome_funcionario
ORDER BY ano_fiscal;

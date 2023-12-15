# Aula: Cláusula GROUP BY
## Listar os clientes da tabela de clientes

SELECT nome_cliente
FROM cap05.tb_clientes;

## Contagem de clientes por cidade

SELECT COUNT(id_cliente) AS contagem, cidade_cliente
FROM cap05.tb_clientes
GROUP BY cidade_cliente
ORDER BY COUNT(contagem) DESC;

# Aula: Funções de Agregação - Parte 1/5

## Listar os pedidos

SELECT *
FROM cap05.tb_pedidos;

## Média do valor dos pedidos

SELECT AVG(valor_pedido) AS media FROM cap05.tb_pedidos;

## Média do valor dos pediso por cidade

SELECT ROUND(AVG(valor_pedido),2) AS media, cidade_cliente
FROM cap05.tb_pedidos AS P, cap05.tb_clientes AS C
WHERE P.id_cliente = C.id_cliente
GROUP BY C.cidade_cliente
ORDER BY media DESC;

SELECT ROUND(AVG(valor_pedido), 2) AS media, cidade_cliente
FROM cap05.tb_pedidos AS P INNER JOIN cap05.tb_clientes AS C
ON P.id_cliente = C.id_cliente
GROUP BY cidade_cliente
ORDER BY media DESC;

# Insere um novo registro na tabela de clientes
# INSERT INTO `cap05`.`TB_CLIENTES` (`id_cliente`, `nome_cliente`, `endereco_cliente`, `cidade_cliente`, `estado_cliente`)
# VALUES (11, "Michael Jordan", "Rua 21", "Palmas", "TO");

SELECT 
CASE WHEN valor_pedido IS NULL THEN 0 ELSE ROUND(AVG(valor_pedido), 2) END AS media,
cidade_cliente
FROM cap05.tb_pedidos AS P RIGHT JOIN cap05.tb_clientes AS C
ON P.id_cliente = C.id_cliente
GROUP BY cidade_cliente
ORDER BY media DESC;

# Aula: Funções de Agregação - Parte 2/5

## Lista os pedidos

SELECT * FROM cap05.tb_pedidos;

## Soma de todos os pedidos

SELECT SUM(valor_pedido) AS total
FROM cap05.tb_pedidos;

## Soma (total) do valor dos pedidos por cidade

SELECT SUM(valor_pedido) AS total, cidade_cliente
FROM cap05.tb_pedidos AS P INNER JOIN cap05.tb_clientes AS C
ON P.id_cliente = C.id_cliente
GROUP BY cidade_cliente;

# Insere mais 2 clientes
# INSERT INTO `cap05`.`TB_CLIENTES` (`id_cliente`, `nome_cliente`, `endereco_cliente`, `cidade_cliente`, `estado_cliente`)
# VALUES (12, "Bill Gates", "Rua 14", "Santos", "SP");

# INSERT INTO `cap05`.`TB_CLIENTES` (`id_cliente`, `nome_cliente`, `endereco_cliente`, `cidade_cliente`, `estado_cliente`)
# VALUES (13, "Jeff Bezos", "Rua 29", "Osasco", "SP");

# Insere mais 3 pedidos
# INSERT INTO `cap05`.`TB_PEDIDOS` (`id_pedido`, `id_cliente`, `id_vendedor`, `data_pedido`, `id_entrega`, `valor_pedido`)
# VALUES (1016, 11, 5, now(), 27, 234.09);

# INSERT INTO `cap05`.`TB_PEDIDOS` (`id_pedido`, `id_cliente`, `id_vendedor`, `data_pedido`, `id_entrega`, `valor_pedido`)
# VALUES (1017, 12, 4, now(), 22, 678.30);

# INSERT INTO `cap05`.`TB_PEDIDOS` (`id_pedido`, `id_cliente`, `id_vendedor`, `data_pedido`, `id_entrega`, `valor_pedido`)
# VALUES (1018, 13, 4, now(), 22, 978.30);

SELECT SUM(valor_pedido) AS total, cidade_cliente, estado_cliente
FROM cap05.tb_pedidos AS P INNER JOIN cap05.tb_clientes AS C
ON P.id_cliente = C.id_cliente
GROUP BY cidade_cliente, estado_cliente
ORDER BY estado_cliente;

# Insere mais 2 clientes
# INSERT INTO `cap05`.`TB_CLIENTES` (`id_cliente`, `nome_cliente`, `endereco_cliente`, `cidade_cliente`, `estado_cliente`)
# VALUES (14, "Melinda Gates", "Rua 14", "Barueri", "SP");

# INSERT INTO `cap05`.`TB_CLIENTES` (`id_cliente`, `nome_cliente`, `endereco_cliente`, `cidade_cliente`, `estado_cliente`)
# VALUES (15, "Barack Obama", "Rua 29", "Barueri", "SP");

SELECT
CASE
	WHEN FLOOR(SUM(valor_pedido)) IS NULL THEN 0
    ELSE FLOOR(SUM(valor_pedido))
END AS total,
cidade_cliente,
estado_cliente
FROM cap05.tb_pedidos AS P RIGHT JOIN cap05.tb_clientes AS C
ON P.id_cliente = C.id_cliente
GROUP BY cidade_cliente, estado_cliente
ORDER BY SUM(valor_pedido) DESC;

# A função FLOOR faz o arredondamento para o número inteiro.

# Aula: Funções de Agregação - Parte 3/5

## Supondo que a comissão de cada vendedor de ja de 10%, quanto cada vendedor ganhou de comissão nas vendas no estado do Ceará?
## Retorne 0 se nÃo houver ganho de comissão.

SELECT * FROM cap05.tb_clientes;
SELECT * FROM cap05.tb_pedidos;

SELECT
CASE
	WHEN SUM(valor_pedido * 0.1) IS NULL THEN 0
    ELSE ROUND(SUM(valor_pedido * 0.1), 2)
END AS comissao,
nome_vendedor,
CASE
	WHEN estado_cliente IS NULL THEN 'Sem pedido no CE'
    ELSE estado_cliente
END AS estado_cliente
FROM cap05.tb_pedidos AS P INNER JOIN cap05.tb_clientes AS C RIGHT JOIN cap05.tb_vendedor AS V
ON P.id_cliente = C.id_cliente
AND P.id_vendedor = V.id_vendedor
AND estado_cliente = 'CE'
GROUP BY nome_vendedor, estado_cliente
ORDER BY comissao DESC;

# Aula: Funções de Agregação - Parte 4/5

SELECT * FROM cap05.tb_pedidos;

SELECT MAX(valor_pedido) AS maximo
FROM cap05.tb_pedidos;

SELECT MIN(valor_pedido) AS maximo
FROM cap05.tb_pedidos;

SELECT COUNT(*) FROM cap05.tb_pedidos;

## Número de clientes que fizeram pedidos:

SELECT COUNT(DISTINCT(id_cliente)) FROM cap05.tb_pedidos;

## Número de clientes únicos do CE que fizeram pedidos com o nome de cada cliente
SELECT nome_cliente, cidade_cliente, COUNT(DISTINCT C.id_cliente) AS clientes_unicos, COUNT(id_pedido) AS num_pedidos
FROM cap05.tb_pedidos AS P INNER JOIN cap05.tb_clientes AS C
ON P.id_cliente = C.id_cliente
AND estado_cliente = 'CE'
GROUP BY nome_cliente, cidade_cliente;

# Aula: Funções de Agregação - Parte 5/5

## Algum vendedor participou de vendas cujo valor pedido tenha sido superior a 600 no estado de são paulo?

SELECT nome_cliente, valor_pedido, cidade_cliente, estado_cliente
FROM cap05.tb_pedidos AS P INNER JOIN cap05.tb_clientes AS C INNER JOIN cap05.tb_vendedor AS V
ON P.id_cliente = C.id_cliente
AND P.id_vendedor = V.id_vendedor
AND estado_cliente = 'SP'
AND valor_pedido > 600;

# Aula: Filtros com HAVING - Parte 1/2

## Algum vendedor participou de vendas em que a média do valor_pedido por estado do cliente foi superior a 800?

SELECT estado_cliente, CEILING(AVG(valor_pedido)) AS media
FROM cap05.tb_pedidos AS P INNER JOIN cap05.tb_clientes AS C
ON P.id_cliente = C.id_cliente
GROUP BY estado_cliente;

SELECT estado_cliente, nome_vendedor, CEILING(AVG(valor_pedido)) AS media
FROM cap05.tb_pedidos AS P INNER JOIN cap05.tb_clientes AS C INNER JOIN cap05.tb_vendedor AS V
ON P.id_cliente = C.id_cliente
AND P.id_vendedor = V.id_vendedor
GROUP BY estado_cliente, nome_vendedor
HAVING media > 800
ORDER BY media DESC;

# Aula: Filtros com HAVING - Parte 2/2

## Qual estado teve mais de 5 pedidos?

SELECT COUNT(id_pedido) AS num_pedidos, estado_cliente
FROM cap05.tb_pedidos AS P INNER JOIN cap05.tb_clientes AS C
ON P.id_cliente = C.id_cliente
GROUP BY estado_cliente
HAVING num_pedidos >= 5;

# Aula: Trabalhando com Grouping Sets, CUBE e ROLLUP - Parte 1/3

## Faturamento total por ano:
## Agrupado por ano e pais

SELECT ano, pais, SUM(faturamento) AS faturamento_anual
FROM cap05.tb_vendas
GROUP BY ano, pais WITH ROLLUP
ORDER BY ano, pais;

## Agrupado por produto e ano

SELECT ano, produto, SUM(faturamento) AS faturamento_anual
FROM cap05.tb_vendas
GROUP BY ano, produto WITH ROLLUP
ORDER BY GROUPING(produto) DESC;

# Aula: Trabalhando com Grouping Sets, CUBE e ROLLUP - Parte 2/3

## Por que não podemos usar o CASE na query acima?
## Por que o valor nulo não se originou do banco de dados mas sim de consultas e agregações feitas atravez dos dados em si.

# Aula: Trabalhando com Grouping Sets, CUBE e ROLLUP - Parte 3/3

SELECT 
    IF(GROUPING(ano),
        'Total de todos os anos',
        ano) AS ano,
    IF(GROUPING(pais),
        'Total de todos os paises',
        pais) AS pais,
    IF(GROUPING(produto),
        'Total de todos os produtos',
        produto) AS produto,
    SUM(faturamento) AS faturamento
FROM
    cap05.tb_vendas
GROUP BY ano , pais , produto WITH ROLLUP; 

## CUBE 
## ROLLUP E CUBE tem o mesmo prop[osito, gerar grouping sets (conjutos de grupos de dados).
## ROLLUP faz isso atrav[es da hierarquia dos dados.
## CUBE gera totas as combinações possíveis.
## CUBE não é suportado no MySQL.
## Material de referência:
## http://www.sqltutorial.org/sql-cube/


SELECT * FROM cap05.tb_vendas;
SELECT * FROM cap05.tb_clientes;
SELECT * FROM cap05.tb_pedidos;
SELECT * FROM cap05.tb_vendedor;














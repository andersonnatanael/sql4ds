# Trabalhando com Views - Parte 1/2

SELECT *
FROM cap10.tb_venda
WHERE valor_venda > 500;

CREATE VIEW cap10.vw_vendas_maior_500 AS
SELECT *
FROM cap10.tb_venda
WHERE valor_venda > 500;

SELECT * FROM cap10.vw_vendas_maior_500 ORDER BY valor_venda DESC;

# Trabalhando com Views - Parte 2/2

CREATE OR REPLACE VIEW cap10.vw_vendas_maior_500 AS
SELECT nm_cliente, nm_cidade_cliente, nm_localidade, nm_marca_produto, nr_dia, nr_mes, valor_venda
FROM cap10.tb_venda AS A 
INNER JOIN cap10.tb_cliente AS B 
INNER JOIN cap10.tb_produto AS C 
INNER JOIN cap10.tb_tempo AS D 
INNER JOIN cap10.tb_localidade AS E
ON A.sk_cliente = B.sk_cliente
AND A.sk_produto = C.sk_produto
AND A.sk_data = D.sk_data
AND A.sk_localidade = E.sk_localidade
AND valor_venda > 500;

SELECT * FROM cap10.vw_vendas_maior_500
ORDER BY valor_venda DESC;

     #####===== Próximo tópico =====#####

# Trabalhando com Materialized Views - Parte 1/3

## CREATE MATERIALIZED VIEW `new_view` AS
## No momento o MySQL não suporta Marerialized Views

# Trabalhando com Materialized Views - Parte 2/3

## Criação de Materialized View (workaround no MySQL)

CREATE TABLE cap10.tb_vendas (
	id INT PRIMARY KEY AUTO_INCREMENT,
    id_vendedor INT,
    data_venda DATE,
    valor_venda int
);

INSERT INTO cap10.TB_VENDAS (id_vendedor, data_venda, valor_venda) 
VALUES (1001, "2022-01-05", 180), 
       (1002, "2022-01-05", 760), 
       (1003, "2021-01-05", 950), 
       (1004, "2022-01-05", 3200), 
       (1005, "2022-01-05", 2780);

SELECT * FROM cap10.tb_vendas;

SELECT id_vendedor, data_venda, SUM(valor_venda * 0.10) AS comissao
FROM cap10.tb_vendas
WHERE data_venda < CURRENT_DATE
GROUP BY id_vendedor, data_venda
ORDER BY id_vendedor;

CREATE TABLE cap10.vw_mt_comissao (
SELECT id_vendedor, data_venda, SUM(valor_venda * 0.10) AS comissao
FROM cap10.tb_vendas
WHERE data_venda < CURRENT_DATE()
GROUP BY id_vendedor, data_venda);

## Inserindo novos registros na tabela de novas vendas feitas no dia...

INSERT INTO cap10.TB_VENDAS (id_vendedor, data_venda, valor_venda) 
VALUES (1004, "2022-01-05", 450), 
       (1002, "2022-01-05", 520), 
       (1007, "2021-01-05", 640), 
       (1005, "2022-01-05", 1200), 
       (1008, "2022-01-05", 1700);

SELECT * FROM cap10.tb_vendas;

# Trabalhando com Materialized Views - Parte 3/3

DELIMITER //
CREATE PROCEDURE cap10.sp_vw_mt_comissao(OUT dev INT)
BEGIN
	TRUNCATE TABLE cap10.vw_mt_comissao;
    INSERT INTO cap10.vw_mt_comissao
		SELECT id_vendedor, data_venda, SUM(valor_venda * 0.10) AS comissao
		FROM cap10.tb_vendas
		WHERE data_venda 
		GROUP BY id_vendedor, data_venda;
END
//

## Estes comandos são facilmente executados pelo terminal.

CALL cap10.sp_vw_mt_comissao(@dev);

SELECT * FROM cap10.vw_mt_comissao;
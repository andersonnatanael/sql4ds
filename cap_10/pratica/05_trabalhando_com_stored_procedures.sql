# Trabalhando com Stored Procedures - Parte 1/3

## Criação de um Stored Procedure

DELIMITER //
CREATE PROCEDURE cap10.sp_nome_exemplo()
BEGIN

#... aqui vai a query

END
//

## Acima esta o modelo padrão de como se cria um store procedure

DELIMITER //
CREATE PROCEDURE cap10.sp_extrai_clientes1()
BEGIN
	SELECT nm_cliente, nm_cidade_cliente, ROUND(AVG(valor_venda), 2) AS media_valor_venda
    FROM cap10.tb_cliente AS A, cap10.tb_venda AS B
    WHERE B.sk_cliente = A.sk_cliente
    GROUP BY nm_cliente, nm_cidade_cliente;
END
//

CALL cap10.sp_extrai_clientes1();

# Trabalhando com Stored Procedures - Parte 2/3

DELIMITER //
CREATE PROCEDURE cap10.sp_extrai_clientes2(IN media INT)
BEGIN
	SELECT nm_cliente, nm_cidade_cliente, ROUND(AVG(valor_venda), 2) AS media_valor_venda
    FROM cap10.tb_cliente AS A, cap10.tb_venda AS B
    WHERE A.sk_cliente = B.sk_cliente
    GROUP BY nm_cliente, nm_cidade_cliente
    HAVING media_valor_venda > media;
END
//

CALL cap10.sp_extrai_clientes2(500);

DELIMITER //
CREATE PROCEDURE cap10.sp_extrai_clientes3(OUT Contagem_Clientes INT)
BEGIN
	SELECT COUNT(*)
    INTO Contagem_Clientes
    FROM cap10.tb_cliente AS A, cap10.tb_venda AS B
    WHERE B.sk_cliente = A.sk_cliente
    AND valor_venda > 500;
END
//

CALL cap10.sp_extrai_clientes3(@nome_variavel);
SELECT @nome_variavel AS clientes;

# Trabalhando com Stored Procedures - Parte 3/3

SELECT
	B.nk_id_cliente AS id_cliente,
    B.nm_cliente AS nome_cliente,
    C.nm_regiao_localidade AS regiao_venda,
    D.nm_marca_produto AS marca_produto,
    ROUND(AVG(A.valor_venda), 2) AS media_valor_venda
FROM cap10.tb_venda AS A INNER JOIN cap10.tb_cliente AS B INNER JOIN cap10.tb_localidade AS C INNER JOIN cap10.tb_produto AS D
ON A.sk_cliente = B.sk_cliente
AND A.sk_localidade = C.sk_localidade
AND A.sk_produto = D.sk_produto
WHERE D.nm_marca_produto IN ('LG', 'Apple', 'Canon', 'Sansung', 'Sony')
AND C.nm_regiao_localidade LIKE 'S%' OR 'N%'
GROUP BY B.nk_id_cliente, B.nm_cliente, C.nm_regiao_localidade, D.nm_marca_produto
HAVING media_valor_venda > 500
AND nk_id_cliente = 'A10984EDCF10092';

SELECT
    ROUND(AVG(A.valor_venda), 2) AS media_valor_venda
FROM cap10.tb_venda AS A INNER JOIN cap10.tb_cliente AS B INNER JOIN cap10.tb_localidade AS C INNER JOIN cap10.tb_produto AS D
ON A.sk_cliente = B.sk_cliente
AND A.sk_localidade = C.sk_localidade
AND A.sk_produto = D.sk_produto
WHERE D.nm_marca_produto IN ('LG', 'Apple', 'Canon', 'Sansung', 'Sony')
AND C.nm_regiao_localidade LIKE 'S%' OR 'N%'
GROUP BY B.nk_id_cliente, B.nm_cliente, C.nm_regiao_localidade, D.nm_marca_produto
HAVING media_valor_venda > 500
AND nk_id_cliente = 'A10984EDCF10092';

DROP PROCEDURE cap10.sp_extrai_cliente4;

DELIMITER //
CREATE PROCEDURE cap10.sp_extrai_cliente4(IN cliente VARCHAR(20), OUT desconto VARCHAR(30))
BEGIN
	
    DECLARE MediaValorVenda INT DEFAULT 0;
    
	SELECT
		ROUND(AVG(A.valor_venda), 2) AS media_valor_venda
		INTO MediaValorVenda
	FROM cap10.tb_venda AS A INNER JOIN cap10.tb_cliente AS B INNER JOIN cap10.tb_localidade AS C INNER JOIN cap10.tb_produto AS D
	ON A.sk_cliente = B.sk_cliente
	AND A.sk_localidade = C.sk_localidade	
	AND A.sk_produto = D.sk_produto
	WHERE D.nm_marca_produto IN ('LG', 'Apple', 'Canon', 'Sansung', 'Sony')
	AND C.nm_regiao_localidade LIKE 'S%' OR 'N%'
	GROUP BY B.nk_id_cliente, B.nm_cliente, C.nm_regiao_localidade, D.nm_marca_produto
	HAVING media_valor_venda > 500
	AND nk_id_cliente = cliente;
	
    IF MediaValorVenda < 500 THEN
		SET desconto = 'Sem Plano de Desconto';
    ELSEIF MediaValorVenda >= 500 AND MediaValorVenda <= 600 THEN
		SET desconto = 'Plano Básico de Desconto';
	ELSEIF MediaValorVenda >= 600 AND MediaValorVenda <= 800 THEN
		SET desconto = 'Plano Premium de Desconto';
	ELSE
		SET desconto = 'Plano Ouro de Desconto';
	END IF;
END
//

CALL cap10.sp_extrai_cliente4("A10984EDCF10092", @plano);
SELECT @plano AS Cliente;

CALL cap10.sp_extrai_cliente4("D10984EDCF10095", @plano);
SELECT @plano AS Cliente;

CALL cap10.sp_extrai_cliente4("G10984EDCF10098", @plano);
SELECT @plano AS Cliente;

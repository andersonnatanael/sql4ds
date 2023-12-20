# Trabalhando com Functions - Parte 1/3

## As funções são normalmente usadas para cálculas, enquanto os procedimentos armazenados são normalmente
## usados para executar a lógica de negócios.

DELIMITER //
CREATE PROCEDURE proc_name ([parametros])
BEGIN

corpo_da_procedure

END
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION func_name ([parametros])
RETURNS data_type
BEGIN

corpo_da_funcao

END;
//

## Uma função determinística sempre retorna o mesmo resultado com os mesmos parâmetros de entrada no mesmo estado
## do banco de dados. Por exemplo: POW(), SUBSTR(), UCASE().
## Uma função não determinística não retorna necessariamente sempre o mesmo resultado com os mesmos parâmetros
## de entrada no mesmo estado do banco de dados.

DELIMITER //

CREATE FUNCTION func_name ( numero INT )
RETURNS INT
DETERMINISTIC
BEGIN


END
//

# Trabalhando com Functions - Parte 2/3

SELECT * FROM cap10.tb_cliente;

ALTER TABLE cap10.tb_cliente
ADD COLUMN limite_credito INT NULL AFTER desc_cep;

UPDATE cap10.TB_CLIENTE
SET limite_credito = 1000
WHERE sk_cliente = 1;

UPDATE cap10.TB_CLIENTE
SET limite_credito = 0
WHERE sk_cliente = 3;

UPDATE cap10.TB_CLIENTE
SET limite_credito = 2500
WHERE sk_cliente = 4;

UPDATE cap10.TB_CLIENTE
SET limite_credito = 15000
WHERE sk_cliente = 6;

UPDATE cap10.TB_CLIENTE
SET limite_credito = 60000
WHERE sk_cliente = 7;

DELIMITER //

CREATE FUNCTION cap10.fn_nivel_cliente(credito DECIMAL(10,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	DECLARE nivel_cliente VARCHAR(20);
    
    IF credito > 50000 THEN
		SET nivel_cliente = 'Platinum';
	ELSEIF ( credito <= 50000 AND credito > 10000 ) THEN
		SET nivel_cliente = 'Gold';
	ELSEIF credito <= 10000 THEN
		SET nivel_cliente = 'Silver';
	END IF;
    
    RETURN (nivel_cliente);
END
//

SELECT nm_cliente, limite_credito FROM cap10.tb_cliente ORDER BY nm_cliente;

SELECT
	nm_cliente,
    cap10.fn_nivel_cliente(limite_credito) AS status_cliente
FROM cap10.tb_cliente
ORDER BY nm_cliente;

## As Functions criadas tbm são chamadas de User Functions, Funções de Usuário
## Já a função COALESCE() por exemplo, faz parte das Funções Built In do SQL

SELECT
	nm_cliente,
    COALESCE(cap10.fn_nivel_cliente(limite_credito), 'Não definido') AS status_cliente
FROM cap10.tb_cliente
ORDER BY nm_cliente;

# Trabalhando com Functions - Parte 3/3

CREATE VIEW cap10.vw_nivel_cliente AS
SELECT
	nm_cliente,
    COALESCE(cap10.fn_nivel_cliente(limite_credito), 'Não definido') AS status_cliente
FROM cap10.tb_cliente
ORDER BY nm_cliente;

SELECT * FROM cap10.vw_nivel_cliente;

DELIMITER //

CREATE PROCEDURE cap10.sp_get_nivel_cliente(
	IN id_cliente INT,
    OUT nivel_cliente VARCHAR(20)
)
BEGIN
	DECLARE credito DEC(10, 2) DEFAULT 0;
    
    -- Extrai o limite de crédito do cliente
    SELECT limite_credito
    INTO credito
    FROM cap10.tb_cliente
    WHERE sk_cliente = id_cliente;
    
    -- Executa a função
    SET nivel_cliente = cap10.fn_nivel_cliente(credito);
END
//

CALL cap10.sp_get_nivel_cliente(7, @nivel_cliente);
SELECT @nivel_cliente;

CALL cap10.sp_get_nivel_cliente(4, @nivel_cliente);
SELECT @nivel_cliente;

CREATE VIEW cap10.vw_cliente AS
SELECT *
FROM cap10.tb_cliente
WHERE limite_credito IS NOT NULL
ORDER BY nm_cliente;

SELECT * FROM cap10.vw_cliente;

DELIMITER //
CREATE PROCEDURE cap10.sp_get_nivel_cliente2(
	IN id_cliente INT,
    OUT nivel_cliente VARCHAR(20)
)
BEGIN
	
    DECLARE credito DEC(10, 2) DEFAULT 0;
    
    -- Extrai o limite de crédito do cliente
    SELECT limite_credito
    INTO credito
    FROM cap10.vw_cliente
    WHERE sk_cliente = id_cliente;
    
    -- Executa a função
    
    SET nivel_cliente = cap10.fn_nivel_cliente(credito);
END
//

CALL cap10.sp_get_nivel_cliente2(7, @nivel_cliente);
SELECT @nivel_cliente;

CALL cap10.sp_get_nivel_cliente2(4, @nivel_cliente);
SELECT @nivel_cliente;















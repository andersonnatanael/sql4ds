# Trabalhando com Triggers - Parte 1/3

# Trabalhando com Triggers - Parte 2/3

DROP TRIGGER IF EXISTS cap10.upd_check;

## O IF EXISTS pode ser usado tbm para Views, Stored Procedures e Functions.
## Ele faz com que não seja emitido erro, caso o objeto não exita.

DELIMITER //
CREATE TRIGGER cap10.upd_check BEFORE UPDATE ON cap10.tb_cliente
FOR EACH ROW
BEGIN
	IF NEW.limite_credito < 0 THEN
		SET NEW.limite_credito = 0;
	ELSEIF NEW.limite_credito > 100000 THEN
		SET NEW.limite_credito = 100000;
	END IF;
END
//

SELECT * FROM cap10.tb_cliente;

UPDATE cap10.tb_cliente
SET limite_credito = -10
WHERE sk_cliente = 8;

UPDATE cap10.tb_cliente
SET limite_credito = 120000
WHERE sk_cliente = 9;

ALTER TABLE cap10.tb_cliente
ADD COLUMN data_cadastro DATETIME NULL AFTER limite_credito,
ADD COLUMN cadastrado_por VARCHAR(50) NULL AFTER data_cadastro,
ADD COLUMN atualizado_por VARCHAR(50) NULL AFTER cadastrado_por;

DELIMITER //
CREATE TRIGGER cap10.insert_check BEFORE INSERT ON cap10.tb_cliente
FOR EACH ROW
BEGIN
	DECLARE vUser VARCHAR(50);
    
    -- Usuário que realizou o INSERT
    SELECT USER() INTO vUser;
    
    -- Obtém a data do sistema e registra na coluna data_cadastro
    SET NEW.data_cadastro = SYSDATE();
    
    -- Registra na tabela o usuário que fez o INSERT
    SET NEW.cadastrado_por = vUser;
END
//

INSERT INTO cap10.TB_CLIENTE (NK_ID_CLIENTE, NM_CLIENTE, NM_CIDADE_CLIENTE, BY_ACEITA_CAMPANHA, DESC_CEP) 
VALUES ('S10984EDCF10101', 'Diana Ross', 'Rio de Janeiro', '1', '72132901');

INSERT INTO cap10.TB_CLIENTE (NK_ID_CLIENTE, NM_CLIENTE, NM_CIDADE_CLIENTE, BY_ACEITA_CAMPANHA, DESC_CEP) 
VALUES ('T10984EDCF10101', 'Tom Petty', 'Natal', '1', '72132902');

# Trabalhando com Triggers - Parte 3/3

CREATE TABLE cap10.tb_auditoria (
sk_cliente INTEGER,
nk_id_cliente VARCHAR(20),
deleted_date DATE,
deleted_by VARCHAR(45));

DROP TRIGGER IF EXISTS cap10.delete_check;

DELIMITER //
CREATE TRIGGER cap10.delete_check AFTER DELETE ON cap10.tb_cliente
FOR EACH ROW
BEGIN

	DECLARE vUser VARCHAR(45);
    
    SELECT USER() INTO vUser;
    
    INSERT INTO cap10.tb_auditoria(sk_cliente, nk_id_cliente, deleted_date, deleted_by)
    VALUE (OLD.sk_cliente, OLD.nk_id_cliente, SYSDATE(), vUser);
    
END
//

DELETE FROM cap10.tb_cliente WHERE sk_cliente = 13;

SELECT * FROM cap10.tb_cliente;
SELECT * FROM cap10.tb_auditoria;

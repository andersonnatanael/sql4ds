# Explicando a Execução de uma Query - Parte 1/5

CREATE SCHEMA cap11 CHARACTER SET utf8mb4;

CREATE TABLE cap11.TB_CLIENTES (
id INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(50) NOT NULL,
telefone VARCHAR(50) NOT NULL,
email VARCHAR(50) NOT NULL);

CREATE TABLE cap11.TB_PEDIDOS (
id VARCHAR(20) PRIMARY KEY,
data_pedido date,
id_cliente INT NOT NULL,
endereco VARCHAR(50) NOT NULL,
valor INT,
FOREIGN KEY (id_cliente) REFERENCES cap11.TB_CLIENTES(id));

INSERT INTO cap11.TB_CLIENTES values
(NULL,'Bob Silva', '5521876541' , 'bob@teste.com'),
(NULL,'Maria Madalena', '5534789762','maria@teste.com'),
(NULL,'Zico Miranda','5531098713' , 'zico@teste.com'),
(NULL,'Ronaldo Teixeira','5512987689' , 'ronaldo@teste.com'),
(NULL,'Zinedine Zidane','5521213282' , 'zidane@teste.com');

SELECT * FROM cap11.tb_clientes;

INSERT INTO cap11.TB_PEDIDOS value
('2340991', '2022-01-02', 1, 'Natal', 1000),
('3981234', '2022-02-12', 3, 'Fortaleza', 1500),
('7832148', '2022-02-05', 1, 'Recife', 800),
('1298765', '2022-03-01', 2, 'Porto Alegre', 900),
('4398654', '2022-03-17', 3, 'Londrina', 400),
('4398655', '2022-03-18', 4, 'Rio de Janeiro', 1400),
('4398656', '2022-03-19', 5, 'Rio de Janeiro', 1800);

SELECT * FROM cap11.tb_pedidos;

# A Query a seguir esta eficiente ou não?

SELECT * FROM cap11.tb_clientes;

# Explicando a Execução de uma Query - Parte 2/5

SELECT * FROM cap11.tb_clientes;

## https://dev.mysql.com/doc/refman/8.0/en/explain-output.html

EXPLAIN SELECT * FROM cap11.tb_clientes;

# DESCRIBE SELECT * FROM cap11.tb_clientes; # Caiu em desuso

EXPLAIN SELECT * FROM cap11.tb_clientes WHERE id = 1;

# Explicando a Execução de uma Query - Parte 3/5

SHOW WARNINGS;

EXPLAIN SELECT * FROM cap11.tb_clientes WHERE nome = 'Bob Silva';

CREATE INDEX nome_cliente_index ON cap11.tb_clientes(nome);

DROP INDEX nome_cliente_index ON cap11.tb_clientes;

# Explicando a Execução de uma Query - Parte 4/5

CREATE INDEX nome_cliente_index ON cap11.tb_clientes(nome);

EXPLAIN SELECT * FROM cap11.tb_clientes WHERE nome = 'Bob Silva';

EXPLAIN SELECT * FROM cap11.tb_clientes WHERE nome = 'Bob Silva' OR 'Zinedine Zidane';

SELECT cap11.tb_clientes.nome, cap11.tb_pedidos.data_pedido, cap11.tb_pedidos.valor
FROM cap11.tb_clientes INNER JOIN cap11.tb_pedidos
ON cap11.tb_clientes.id = cap11.tb_pedidos.id_cliente
WHERE cap11.tb_clientes.nome = 'Zico Miranda';

EXPLAIN SELECT cap11.tb_clientes.nome, cap11.tb_pedidos.data_pedido, cap11.tb_pedidos.valor
FROM cap11.tb_clientes INNER JOIN cap11.tb_pedidos
ON cap11.tb_clientes.id = cap11.tb_pedidos.id_cliente
WHERE cap11.tb_clientes.nome = 'Zico Miranda';

# O UNION tem um performance ruim, sempre que possível, evite ele o quanto possível.

SELECT id AS ID FROM cap11.tb_clientes
UNION ALL
SELECT id_cliente AS ID FROM cap11.tb_pedidos;

EXPLAIN SELECT id AS ID FROM cap11.tb_clientes
UNION ALL
SELECT id_cliente AS ID FROM cap11.tb_pedidos;

# Explicando a Execução de uma Query - Parte 5/5

EXPLAIN SELECT id AS ID FROM cap11.tb_clientes
UNION ALL
SELECT id_cliente AS ID FROM cap11.tb_pedidos
ORDER BY ID;

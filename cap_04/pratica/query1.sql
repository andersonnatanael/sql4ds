# Aula: INNER JOIN - Parte 1/2
# Retornar id do pedido e nome do cliente
# Inner Join

SELECT * FROM cap04.tb_clientes;
SELECT * FROM cap04.tb_pedidos;

SELECT P.id_pedido, C.nome_cliente
FROM cap04.tb_pedidos AS P
INNER JOIN cap04.tb_clientes AS C 
		ON P.id_cliente = C.id_cliente;
        
# Inner Join só trás os dados que tem relação em ambas as tabelas.

# ---- FIM ----
# Aula: INNER JOIN - Parte 2/2

SELECT P.id_pedido, C.nome_cliente
FROM cap04.tb_pedidos AS P, cap04.tb_clientes AS C
WHERE P.id_cliente = C.id_cliente;

# Retornar id do pedido, nome do cliente e nome do vendedor
# Inner Join com 3 tabelas

SELECT * FROM cap04.tb_clientes; 
SELECT * FROM cap04.tb_pedidos;
SELECT * FROM cap04.tb_vendedor;

SELECT P.id_pedido, C.nome_cliente, V.nome_vendedor
FROM cap04.tb_pedidos AS P
INNER JOIN cap04.tb_clientes AS C
		ON P.id_cliente = C.id_cliente
INNER JOIN cap04.tb_vendedor AS V
		ON P.id_vendedor = V.id_vendedor;
        
# ---- FIM ----
# Aula: INNER JOIN e junção de múltiplas tabelas

SELECT P.id_pedido, C.nome_cliente, V.nome_vendedor
FROM cap04.tb_pedidos AS P, cap04.tb_clientes AS C, cap04.tb_vendedor AS V
WHERE P.id_cliente = C.id_cliente
  AND P.id_vendedor = V.id_vendedor;

# ---- FIM ----
# Aula: INNER JOIN e outras cláusulas SQL

## Inner Join - Padrão ANSI
SELECT P.id_pedido, C.nome_cliente
FROM cap04.tb_pedidos AS P
INNER JOIN cap04.tb_clientes AS C
		ON P.id_cliente = C.id_cliente;
        
## Inner Join quando o nome da coluna é igual em ambas as tabelas
SELECT P.id_pedido, C.nome_cliente
FROM cap04.tb_pedidos AS P
INNER JOIN cap04.tb_clientes AS C
USING (id_cliente);

## Inner Join com WHERE e ORDER BY:
SELECT P.id_pedido, C.nome_cliente
FROM cap04.tb_pedidos AS P
INNER JOIN cap04.tb_clientes AS C
USING (id_cliente)
WHERE C.nome_cliente LIKE 'Bo%'
ORDER BY P.id_pedido DESC;

# ---- FIM ----
# Aula: LEFT JOIN

## Retornar todos os cliente, com ou sem pedido associado (usando Left Join)
# Left Join - indica que queremos todos os dados da tabela da esquerda mesmo sem correspondente na tabela da direita

SELECT C.nome_cliente, P.id_pedido
FROM cap04.tb_clientes AS C
LEFT JOIN cap04.tb_pedidos AS P
USING (id_cliente);

# LEFT OUTER JOIN e LEFT JOIN são a mesma coisa!!!
# A ordem das tabelas no LEFT JOIN faz diferença no resultado final da Query.

SELECT C.nome_cliente, P.id_pedido
FROM cap04.tb_pedidos AS p
LEFT JOIN cap04.tb_clientes AS C
USING (id_cliente);

# ---- FIM ----
# Aula: RIGHT JOIN
# Right Join, indica que queremos todos os dados da tabela da direita, mesmo sem relação com a tabela da esquerda.

SELECT C.nome_cliente, P.id_pedido
FROM cap04.tb_pedidos AS p
RIGHT JOIN cap04.tb_clientes AS C
USING (id_cliente);

# ---- FIM ----
# Aula: Solução Exercíco de Checkpoint
## Retornar a data do pedido, o nome do cliente, todos os vendedores, com ou sem pedidos associado, e ordenar o resultado pelo nome do cliente.

SELECT 
CASE 
	WHEN P.data_pedido IS NULL THEN 'Sem pedido' 
    ELSE P.data_pedido 
END AS data_pedido,
CASE 
	WHEN C.nome_cliente IS NULL THEN 'Sem pedido' 
    ElSE C.nome_cliente 
END AS nome_cliente,
V.nome_vendedor
FROM cap04.tb_pedidos AS P
INNER JOIN cap04.tb_clientes AS C
USING (id_cliente)
RIGHT JOIN cap04.tb_vendedor AS V
USING (id_vendedor)
ORDER BY C.nome_cliente;

# ---- FIM ----
# Aula: rovocando Erro de Integridade Referencial
# Aula: FULL OUTER JOIN

SELECT * FROM cap04.tb_pedidos;

SELECT C.nome_cliente, id_pedido
FROM cap04.tb_clientes AS C
LEFT JOIN cap04.tb_pedidos AS P
USING (id_cliente)
UNION
SELECT C.nome_cliente, id_pedido
FROM cap04.tb_clientes AS C
RIGHT JOIN cap04.tb_pedidos AS P
USING (id_cliente);

# ---- FIM ----
# Aula: SELF JOIN
## Retornar clientes que sejam da mesma cidade

SELECT * FROM cap04.tb_clientes;

SELECT A.nome_cliente, A.cidade_cliente
FROM cap04.tb_clientes AS A, cap04.tb_clientes AS B
WHERE A.id_cliente <> B.id_cliente
  AND A.cidade_cliente = B.cidade_cliente;

# ---- FIM ----
# Aula: CROSS JOIN

SELECT C.nome_cliente, P.id_pedido
FROM cap04.tb_clientes AS C
CROSS JOIN cap04.tb_pedidos AS P;

# ---- FIM ----
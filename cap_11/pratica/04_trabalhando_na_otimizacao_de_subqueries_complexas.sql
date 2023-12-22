# DROP SCHEMA cap05;

# Query 2
# Retorna os nomes dos clientes, cidades dos clientes, valor do pedido e vendedores que fizeram o atendimento, de clientes 
# do estado de SP cujo valor do pedido foi maior que a média de pedidos realizados às 12 hs.

SELECT
	B.nome_cliente,
    B.cidade_cliente,
    A.valor_pedido,
    C.nome_vendedor
FROM cap05.tb_pedidos AS A
INNER JOIN cap05.tb_clientes AS B
INNER JOIN cap05.tb_vendedor AS C
ON A.id_cliente = B.id_cliente
AND A.id_vendedor = C.id_vendedor
WHERE A.valor_pedido > (SELECT AVG(valor_pedido) FROM cap05.tb_pedidos WHERE HOUR(data_pedido) = 16)
AND estado_cliente = 'SP'
ORDER BY nome_cliente;

ALTER TABLE `cap05`.`tb_pedidos`
CHANGE COLUMN `id_pedido` `id_pedido` INT NOT NULL,
ADD PRIMARY KEY (`id_pedido`);

ALTER TABLE `cap05`.`tb_clientes`
CHANGE COLUMN `id_cliente` `id_cliente` INT NOT NULL,
ADD PRIMARY KEY (`id_cliente`);

ALTER TABLE `cap05`.`tb_vendedor`
CHANGE COLUMN `id_vendedor` `id_vendedor` INT NOT NULL,
ADD PRIMARY KEY (`id_vendedor`);

ALTER TABLE `cap05`.`tb_pedidos`
ADD CONSTRAINT `fk_id_cliente`
	FOREIGN KEY (`id_cliente`)
    REFERENCES `cap05`.`tb_clientes`(`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE `cap05`.`tb_pedidos`
ADD CONSTRAINT `fk_id_vendedor`
	FOREIGN KEY (`id_vendedor`)
    REFERENCES `cap05`.`tb_vendedor`(`id_vendedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;



# Trabalhando na Otimização de Queries Complexas - Parte 1/8

## Query 1
## Retorna os nomes dos clientes, cidades dos clientes, valor do pedido e vendedores que fizeram o atendimento, de clientes 
## do estado de SP cujo valor do pedido foi maior que 150

SELECT
	C.nome_cliente,
    C.cidade_cliente,
    P.valor_pedido,
    V.nome_vendedor
FROM cap05.tb_pedidos AS P
INNER JOIN cap05.tb_clientes AS C
INNER JOIN cap05.tb_vendedor AS V
ON P.id_cliente = C.id_cliente
AND P.id_vendedor = V.id_vendedor
WHERE P.valor_pedido > 150
AND estado_cliente = 'SP'
ORDER BY nome_cliente;

## Custo total de 6.24

## CREATE INDEX id_cliente_index ON cap05.tb_clientes(id_cliente);

## Custo total de 5.42

## CREATE INDEX id_pedido_index ON cap05.tb_pedidos(id_pedido);

## DROP INDEX id_pedido_index ON cap05.tb_pedidos;

## Custo total de 5.42 - o custo foi mantido pois mesmo com este indice, a query precisa passar por todos os itens desta tabela

## CREATE INDEX id_vendedor_index ON cap05.tb_vendedor(id_vendedor);
## DROP INDEX id_vendedor_index ON cap05.tb_vendedor;
## Custo total de 5.54 - o custo subiu `-`

# Trabalhando na Otimização de Queries Complexas - Parte 2/8

## Eu havia criado o index, mas a solução do professor era criar a chave primária,
## que no final teve o mesmo desempenho, e ainda garante a integridade referêncial dos dados
## Então fiz o drop do index e criei a PK

## Custo total de 5.42

# Trabalhando na Otimização de Queries Complexas - Parte 3/8

ALTER TABLE `cap05`.`tb_vendedor`
CHANGE COLUMN `id_vendedor` `id_vendedor` INT NOT NULL,
ADD PRIMARY KEY (`id_vendedor`);

## Custo total de 6.75

ALTER TABLE cap05.tb_pedidos
CHANGE COLUMN id_pedido id_pedido INT NOT NULL,
ADD PRIMARY KEY (id_pedido);

## Após criar a chave primaria para as 3 tabelas e mantendo a integridade referencial dos dados das tabelas
## o custo total da execução da query foi de 7.50
## mesmo o custo subindo um pouco devido a criação das PKs, elas são importantes e devem ser mantidas.

# Trabalhando na Otimização de Queries Complexas - Parte 4/8

ALTER TABLE `cap05`.`tb_pedidos`
ADD INDEX `ix_id_cliente` (`id_cliente` ASC) VISIBLE;
DROP INDEX `ix_id_cliente` ON `cap05`.`tb_pedidos`;

ALTER TABLE `cap05`.`tb_pedidos`
ADD INDEX `ix_composto` (`id_cliente` ASC, `id_vendedor` ASC) VISIBLE;
DROP INDEX `ix_composto` ON `cap05`.`tb_pedidos`;

# Trabalhando na Otimização de Queries Complexas - Parte 5/8

## Ambas as formas abaixo servem para criar indice

ALTER TABLE `cap05`.`tb_pedidos`
ADD INDEX `ix_id_cliente` (`id_cliente` ASC) VISIBLE;

CREATE INDEX ix_id_cliente ON cap05.tb_pedidos(id_cliente);

## Com os 2 índices criados na aula anterior eu consigo obter a mesma performance.
## Então é melhor utilizar o índice simples e não o composto, para reduzir o espaço utilizado em disco.

SELECT
	C.nome_cliente,
    C.cidade_cliente,
    P.valor_pedido,
    V.nome_vendedor
FROM cap05.tb_pedidos AS P
INNER JOIN cap05.tb_clientes AS C
INNER JOIN cap05.tb_vendedor AS V
ON P.id_cliente = C.id_cliente
AND P.id_vendedor = V.id_vendedor
WHERE P.valor_pedido > 150
AND estado_cliente = 'SP'
ORDER BY nome_cliente;

## A query foi bem otimizada, mas ainda tem um full table scan, que está ocorrendo no WHERE ao filtrar pelo estado_cliente
## Talvez criand um índice para essa coluna melhore a performance...

ALTER TABLE `cap05`.`tb_clientes`
ADD INDEX `ix_estado` (`estado_cliente` ASC) VISIBLE;

ALTER TABLE `cap05`.`tb_pedidos`
ADD INDEX `ix_valor` (`valor_pedido` ASC) VISIBLE;

DROP INDEX ix_estado ON cap05.tb_clientes;

## O índice ix_estado não ajudou a melhorar a performance da minha query, na vdd ele fez que 2 full table scan fosse realizados ao invez de apenas 1
## Tentei resolver o problema de inumeras formas diferentes, mas sem muito sucesso, então resolvi apenas retiar o índice
## Imagino que o problema esteja ocorrendo no meu pc talvez por causa do hardwere...

ALTER TABLE `cap05`.`tb_pedidos`
DROP INDEX `ix_valor`;

# Trabalhando na Otimização de Queries Complexas - Parte 6/8

ALTER TABLE `cap05`.`tb_clientes`
ADD INDEX `ix_nome_cliente` (`nome_cliente` ASC) VISIBLE;
DROP INDEX ix_nome_cliente ON cap05.tb_clientes;

SELECT
	C.nome_cliente,
    C.cidade_cliente,
    P.valor_pedido,
    V.nome_vendedor
FROM cap05.tb_pedidos AS P
INNER JOIN cap05.tb_clientes AS C
INNER JOIN cap05.tb_vendedor AS V
ON P.id_cliente = C.id_cliente
AND P.id_vendedor = V.id_vendedor
WHERE P.valor_pedido > 150
AND estado_cliente = 'SP'
ORDER BY nome_cliente;

# Trabalhando na Otimização de Queries Complexas - Parte 7/8

## Criando Foreign Keys

ALTER TABLE `cap05`.`tb_pedidos`
ADD CONSTRAINT `fk_id_vendedor`
	FOREIGN KEY (`id_vendedor`)
    REFERENCES `cap05`.`tb_vendedor`(`id_vendedor`)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE `cap05`.`tb_pedidos`
ADD CONSTRAINT `fk_id_cliente`
	FOREIGN KEY (`id_cliente`)
    REFERENCES `cap05`.`tb_clientes`(`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

# Trabalhando na Otimização de Queries Complexas - Parte 8/8

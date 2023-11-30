CREATE SCHEMA cap06;

USE cap06;

CREATE TABLE cap06.tb_vendas (
	nome_funcionario VARCHAR(50) NOT NULL,
    ano_fiscal INT NOT NULL,
    valor_venda DECIMAL(14, 2) NOT NULL,
    PRIMARY KEY(nome_funcionario, ano_fiscal)
);

INSERT INTO cap06.tb_vendas(nome_funcionario, ano_fiscal, valor_venda)
VALUES('Romario',2020,2000),
      ('Romario',2021,2500),
      ('Romario',2022,3000),
      ('Zico',2020,1500),
      ('Zico',2021,1000),
      ('Zico',2022,2000),
	  ('Pele',2020,2000),
      ('Pele',2021,1500),
      ('Pele',2022,2500);

# Lab - Mapeamento com SQL - Parte 1/2

CREATE TABLE cap08.TB_ANIMAIS (
  id INT NOT NULL,
  nome VARCHAR(45) NULL,
  PRIMARY KEY (`id`));

INSERT INTO cap08.TB_ANIMAIS (id, nome)
VALUES (1, 'Zebra'), (2, 'Elefante'), (3, 'Girafa'), (4, 'Tigre');

CREATE TABLE cap08.TB_ZOOS (
  id INT NOT NULL,
  nome VARCHAR(45) NULL,
  PRIMARY KEY (`id`));

INSERT INTO cap08.TB_ZOOS (id, nome)
VALUES (1000, 'Zoo do Rio de Janeiro'), (1001, 'Zoo de Recife'), (1002, 'Zoo de Palmas');

CREATE TABLE cap08.TB_MAP_ANIMAL_ZOO (
  id_animal INT NOT NULL,
  id_zoo INT NOT NULL,
  PRIMARY KEY (`id_animal`, `id_zoo`));

INSERT INTO cap08.TB_MAP_ANIMAL_ZOO (id_animal, id_zoo)
VALUES (1, 1001), (1, 1002), (2, 1001), (3, 1000), (4, 1001);

SELECT * FROM cap08.tb_map_animal_zoo;

## Retornar animal e zoo onde os animais estão

SELECT
	A.nome AS Animal,
    Z.nome AS Zoo
FROM cap08.tb_animais AS A INNER JOIN cap08.tb_map_animal_zoo AS M INNER JOIN cap08.tb_zoos AS Z
ON A.id = M.id_animal 
AND M.id_zoo = Z.id
ORDER BY Animal;

## Segunda forma sugerida pelo professor

SELECT A.nome AS Animal, B.nome AS Zoo
FROM cap08.tb_animais AS A, cap08.tb_map_animal_zoo AS AtoB, cap08.tb_zoos AS B
WHERE AtoB.id_animal = A.id AND B.id = AtoB.id_zoo
UNION
SELECT C.nome AS Animal, B.nome AS Zoo
FROM cap08.tb_animais AS C, cap08.tb_map_animal_zoo AS CtoB, cap08.tb_zoos AS B
WHERE CtoB.id_animal = C.id AND B.id = CtoB.id_zoo
ORDER BY Animal;

## Inserindo mais 1 animal
INSERT INTO cap08.TB_ANIMAIS (id, nome)
VALUES (5, 'Macaco');

SELECT
	A.nome AS Animal,
    COALESCE(Z.nome, 'Sem Zoo') AS Zoo
FROM cap08.tb_animais AS A LEFT JOIN (cap08.tb_map_animal_zoo AS M INNER JOIN cap08.tb_zoos AS Z)
ON A.id = M.id_animal 
AND M.id_zoo = Z.id
ORDER BY Animal;

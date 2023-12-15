# Lab - Enriquecimento e Imputação com SQL = Parte 1/2

SELECT * FROM cap08.tb_incidentes LIMIT 10;

## Na tabela cap08.tb_incidentes, coluna IncidntNum, considere os 4 primeiros dígitos como o código local do incidente
## e os 4 últimos díditos como o código nacional do incidente

SELECT
	IncidntNum,
    SUBSTR(IncidntNum, 1, 4) AS local_code,
    SUBSTR(IncidntNum, -4, 4) AS nacional_code
FROM cap08.tb_incidentes;

SELECT
	IncidntNum,
    SUBSTRING(IncidntNum, 1, 4) AS local_code,
    SUBSTRING(IncidntNum, -4, 4) AS nacional_code
FROM cap08.tb_incidentes;

# Lab - Enriquecimento e Imputação com SQL = Parte 2/2

## Na tabela cap08.tb_incidentes, coluna address, retorne tudo que estiver até o
## primeiro espço (possivelmente o número do endereço)

SELECT
	Address,
    POSITION(' ' IN Address) AS posicao_espaco
FROM cap08.tb_incidentes;

SELECT
	Address,
    SUBSTRING(Address, 1, POSITION(' ' IN Address)) AS desc_final
FROM cap08.tb_incidentes;

## Imputação com Replace

SELECT * FROM cap08.tb_map_animal_zoo;

SELECT
	id_animal,
    REPLACE(id_zoo, 1001, 1007) AS id_zoo
FROM cap08.tb_map_animal_zoo;

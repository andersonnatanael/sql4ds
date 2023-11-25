# Aula: Preparando e Carregando os Dados

SELECT * FROM cap03.tb_dados;

# ----- FIM -----
# Aula: Instrução CASE
# Aula: Binarização com SQL - Exemplo 1

SELECT COUNT(*) FROM cap03.tb_dados;

# >>> Binarização da variável classe (0/1)?

SELECT DISTINCT classe FROM cap03.tb_dados;

SELECT
CASE
	WHEN classe = 'no-recurrence-events' THEN 0
    WHEN classe = 'recurrence-events' THEN 1
END AS classe
FROM cap03.tb_dados;

# Exercício: Binarização da variável irradiando (0/1):

SELECT DISTINCT irradiando FROM cap03.tb_dados;

SELECT
CASE
	WHEN irradiando = 'no' THEN 0
    WHEN irradiando = 'yes' THEN 1
END AS irradiando
FROM cap03.tb_dados;

# ----- FIM -----
# Aula: Binariza;'ao com SQL - Exemplo 2

# Exercício: Binarização da variável node_caps (0/1):
# Aula: Verificando e Tratando Valores Ausentes

SELECT DISTINCT node_caps FROM cap03.tb_dados;

SELECT
CASE
	WHEN node_caps = 'no' THEN 0
    WHEN node_caps = 'yes' THEN 1
    ELSE 2
END AS node_caps
FROM cap03.tb_dados;
# Os valores ausentes encontrados na coluna agora são identificados pelo número 2.

# ----- FIM -----
# Aula: Categorização com SQL - Exemplo 1
# Exercício: Categorização da variável seio (E/D):

SELECT DISTINCT seio FROM cap03.tb_dados;

SELECT
CASE
	WHEN seio = 'left' THEN 'E'
    WHEN seio = 'right' THEN 'D'
END AS seio
FROM cap03.tb_dados;

# Categorização da variável tamanho_tumor (6 Categorias):

SELECT DISTINCT tamanho_tumor FROM cap03.tb_dados;

SELECT
CASE
	WHEN tamanho_tumor = '0-4' OR tamanho_tumor = '5-9' THEN '0-9'
	WHEN tamanho_tumor = '10-14' OR tamanho_tumor = '15-19' THEN '10-19'
	WHEN tamanho_tumor = '20-24' OR tamanho_tumor = '25-29' THEN '20-29'
	WHEN tamanho_tumor = '30-34' OR tamanho_tumor = '35-39' THEN '30-39'
	WHEN tamanho_tumor = '40-44' OR tamanho_tumor = '45-49' THEN '40-49'
	WHEN tamanho_tumor = '50-54' THEN '50-54'
END AS tamanho_tumor
FROM cap03.tb_dados;

# ---- FIM ----
# Aula: Label Encoding com SQL - Exemplo 1

# Label Encoding da variável quadrante (1,2,3,4,5)

SELECT DISTINCT quadrante FROM cap03.tb_dados;

SELECT
CASE
	WHEN quadrante = 'left_up' THEN 1
	WHEN quadrante = 'right_up' THEN 2
	WHEN quadrante = 'central' THEN 3
	WHEN quadrante = 'left_low' THEN 4
	WHEN quadrante = 'right_low' THEN 5
	WHEN quadrante = '?' THEN 0
END AS quadrante
FROM cap03.tb_dados;

# Os valores ausentes foram definidos como 0

# ---- FIM ----
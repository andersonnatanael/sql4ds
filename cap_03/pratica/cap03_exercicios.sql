# Exercício Cenário de Análise de Dados 2

# Trabalhando com o dataset versão final após as transformações feitas durante as aulasneste capítulo, crie instruções SQL que resolvam às questões abaixo:

# 1- Aplique label encoding à variável menopausa.

SELECT DISTINCT menopausa FROM cap03.tb_dados2;

SELECT
CASE
	WHEN menopausa = 'premeno' THEN 1
    WHEN menopausa = 'ge40' THEN 2
    WHEN menopausa = 'lt40' THEN 3
END AS menopausa
FROM cap03.tb_dados2;

# 2- [DESAFIO] Crie uma nova coluna chamada posicao_tumor concatenando as colunas inv_nodes e quadrante.

SELECT CONCAT (inv_nodes, ' - ', quadrante) as posicao_tumor
FROM cap03.tb_dados2;

# 3- [DESAFIO] Aplique One-Hot-Encoding à coluna deg_malig.

SELECT DISTINCT deg_malig FROM cap03.tb_dados2;

SELECT
CASE
	WHEN deg_malig = 1 THEN 1
    ELSE 0
END AS deg_malig_1,
CASE
	WHEN deg_malig = 2 THEN 1
    ELSE 0
END AS deg_malig_2,
CASE
	WHEN deg_malig = 3 THEN 1
    ELSE 0
END AS deg_malig_3
FROM cap03.tb_dados2;

# 4- Crie um novo dataset com todas as variáveis após as transformações anteriores.

SELECT * FROM cap03.tb_dados2;

CREATE TABLE cap03.tb_dados3
AS
SELECT
classe,
idade,
CASE
	WHEN menopausa = 'premeno' THEN 1
    WHEN menopausa = 'ge40' THEN 2
    WHEN menopausa = 'lt40' THEN 3
END AS menopausa,
tamanho_tumor,
CONCAT (inv_nodes, '-', quadrante) as posicao_tumor,
node_caps,
CASE WHEN deg_malig = 1 THEN 1 ELSE 0 END AS deg_malig1,
CASE WHEN deg_malig = 2 THEN 1 ELSE 0 END AS deg_malig2,
CASE WHEN deg_malig = 3 THEN 1 ELSE 0 END AS deg_malig3,
seio,
irradiando
FROM cap03.tb_dados2;
tb_dados2



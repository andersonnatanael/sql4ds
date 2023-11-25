# Aula: Carregando os Dados Fornecidos pele Anvisa

SELECT * FROM cap02.tb_navios;

# ---- FIM ----
# Aula: Anatomia de uma Query SQL
# Aula: Instrução SELECT

SELECT nome_navio FROM cap02.tb_navios;
SELECT nome_navio, mes_ano FROM cap02.tb_navios;

# ---- FIM ----
# Aula: Cláusula WHERE

SELECT nome_navio, classificacao_risco, temporada FROM cap02.tb_navios
WHERE classificacao_risco = 'D';

# ---- FIM ----
# Aula: Cláusula ORDER BY

SELECT nome_navio, classificacao_risco, temporada
FROM cap02.tb_navios
WHERE classificacao_risco = 'D'
ORDER BY nome_navio;

# ---- FIM ----
# Aula: Operadores Lógicos AND e OR

SELECT nome_navio, classificacao_risco, pontuacao_risco, temporada
FROM cap02.tb_navios
WHERE classificacao_risco = 'D'	AND pontuacao_risco > 1000
ORDER BY nome_navio;

# ---- FIM ----
# Aula: Mais operadores lógicos

SELECT nome_navio, classificacao_risco, indice_conformidade, temporada
FROM cap02.tb_navios
WHERE classificacao_risco IN ('A', 'B') AND indice_conformidade > 90
ORDER BY nome_navio;

# ---- FIM ----
# Aula: Limitando o número de linhas

SELECT nome_navio, classificacao_risco, indice_conformidade, temporada
FROM cap02.tb_navios
WHERE classificacao_risco IN ('A', 'B') AND indice_conformidade > 90
ORDER BY indice_conformidade
LIMIT 10;
# LIMIT não deve ser utilizado como filtro, ele apenas serve para limitar o número de linhas vizualizadas

# ---- FIM ----
# Aula: Filtro Condicional e Filtro com Múltiplas Condições

# Em Abril de 2018 alguma embarcação teve índice de conformidade de 100% e pontuação de risco igual a 0?
SELECT nome_navio, mes_ano, indice_conformidade, pontuacao_risco
FROM cap02.tb_navios
WHERE mes_ano = '04/2018' AND indice_conformidade = 100 AND pontuacao_risco = 0
ORDER BY nome_navio;

# ---- FIM ----
# Aula: Filtro Usando Subquery

SELECT nome_navio, mes_ano,Indice_conformidade, pontuacao_risco, temporada
FROM cap02.tb_navios
WHERE indice_conformidade IN (SELECT indice_conformidade
								FROM cap02.tb_navios
							   WHERE indice_conformidade > 90)
                                 AND pontuacao_risco = 0
                                 AND mes_ano = '04/2018'
ORDER BY indice_conformidade;



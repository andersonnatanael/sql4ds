# Trabalhando com o mesmo dataset usado neste cap[itulo, crie instru;'oes SQL que respondam às perguntas abaixo:

# 1- Quais embarcações possuem pontuação de risco igual a 310?

SELECT nome_navio, pontuacao_risco
FROM cap02.tb_navios
WHERE pontuacao_risco = 310
ORDER BY nome_navio;

# 2= Quais embarcações têm classificação de risco A e índice de conformidade maior ou igual a 95%?

SELECT nome_navio, classificacao_risco, indice_conformidade
FROM cap02.tb_navios
WHERE classificacao_risco = 'A'
  AND  indice_conformidade >= 95
ORDER BY nome_navio;

# 3- Quais embarcações têm classificação de risco C ou D e índice de conformidade menor ou igual a 95%?

SELECT nome_navio, classificacao_risco, indice_conformidade
FROM cap02.tb_navios
WHERE (classificacao_risco = 'C' OR classificacao_risco = 'D')
  AND indice_conformidade <= 95
ORDER BY indice_conformidade;

SELECT nome_navio, classificacao_risco, indice_conformidade
FROM cap02.tb_navios
WHERE classificacao_risco IN ('C', 'D') 
  AND indice_conformidade <= 95
ORDER BY indice_conformidade;

# 4- Quais embarcações têm classificação de risco A ou pontuação de risco igual a 0?

SELECT nome_navio, classificacao_risco, pontuacao_risco
FROM cap02.tb_navios
WHERE classificacao_risco = 'A' 
  AND pontuacao_risco = 0
ORDER BY nome_navio;

# 5- [DESAFIO] Quais embarcações foram inspecionadas em Dezembro de 2016?

SELECT nome_navio, mes_ano, temporada
FROM cap02.tb_navios
WHERE mes_ano = '12/2016'
ORDER BY nome_navio;

SELECT nome_navio, mes_ano, temporada
FROM cap02.tb_navios
WHERE temporada LIKE '%Dezembro 2016'
ORDER BY nome_navio;

SELECT nome_navio, mes_ano, temporada
FROM cap02.tb_navios
WHERE mes_ano = '12/2016' 
  AND temporada LIKE '%Dezembro 2016'
ORDER BY nome_navio;
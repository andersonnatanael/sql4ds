SELECT * FROM cap05exerc.hubs ORDER BY hub_id;

# 1. Qual o número de hubs por cidade?

SELECT COUNT(DISTINCT (hub_city)) FROM cap05exerc.hubs;

SELECT  hub_city, COUNT(DISTINCT hub_name) AS total_unidades
FROM cap05exerc.hubs
GROUP BY hub_city
ORDER BY hub_city DESC;

# 2. Qual o número de pedidos (orders) por status:

SELECT DISTINCT(order_status) FROM cap05exerc.orders;

SELECT order_status, COUNT(order_id) AS total_pedidos
FROM cap05exerc.orders
GROUP BY order_status;

# 3. Qual o número de lojas (store) por cidade dos hubs?

SELECT hub_city, hub_state, COUNT(store_id) AS num_lojas
FROM cap05exerc.hubs AS H INNER JOIN cap05exerc.stores AS S
ON H.hub_id = S.hub_id
GROUP BY hub_city, hub_state
#HAVING num_lojas
ORDER BY num_lojas DESC;

## O HAVING só é necessário, quando eu quero aplicar um filtro a uma função de agregação, no caso anterior ele não era necessário pois nenhum filtro havia sido aplicado 

SELECT hub_city, hub_state, COUNT(store_id) AS num_lojas
FROM cap05exerc.hubs AS H INNER JOIN cap05exerc.stores AS S
ON H.hub_id = S.hub_id
GROUP BY hub_city, hub_state
ORDER BY num_lojas DESC;

# 4. Qual o maior e o menor valor de pagamento (payment_amount) registrado?

SELECT * FROM cap05exerc.payments ORDER BY payment_amount DESC;

SELECT MAX(payment_amount) AS max_pagamento, MIN(payment_amount) AS min_pagamento 
FROM cap05exerc.payments;

# 5. Qual tipo de driver (driver_type) fez o maior número de entregas?

SELECT driver_type, COUNT(delivery_id) AS num_entregas
FROM cap05exerc.drivers AS DR INNER JOIN cap05exerc.deliveries AS DE
ON DR.driver_id = DE.driver_id
GROUP BY driver_type
ORDER BY num_entregas DESC;

# 6. Qual a distância média das entregas por tipo de driver (driver_modal)?

SELECT driver_modal, ROUND(AVG(delivery_distance_meters), 2) AS distancia_media
FROM cap05exerc.drivers AS DR INNER JOIN cap05exerc.deliveries AS DE
ON DR.driver_id = DE.driver_id
GROUP BY driver_modal
ORDER BY distancia_media DESC;

# 7. Qual a média de valor de pedido (order_amount) por loja, em ordem decrescente?

SELECT store_name, ROUND(AVG(order_amount), 2) AS media_pedidos
FROM cap05exerc.orders AS O INNER JOIN cap05exerc.stores AS S
ON O.store_id = S.store_id
GROUP BY store_name
ORDER BY media_pedidos DESC;

# 8. Existem pediso que não estão associados a lojas? Se caso positivo, quantos?

SELECT COUNT(order_id) AS total
FROM cap05exerc.orders AS O
WHERE NOT EXISTS ( SELECT order_id
					 FROM cap05exerc.orders AS A INNER JOIN cap05exerc.stores AS B 
                       ON A.store_id = B.store_id);

## Não existem pedidos orfãons.
## Query do professor

SELECT COALESCE(store_name, 'Sem Loja'), COUNT(order_id) AS contagem
FROM cap05exerc.orders AS O LEFT JOIN cap05exerc.stores AS S
ON S.store_id = O.store_id
GROUP BY store_name
ORDER BY store_name;

# 9. Qual o valor total de pedidos (order_amount) no channel 'FOOD PLACE'?

SELECT * FROM cap05exerc.orders;

SELECT channel_name, ROUND(SUM(order_amount), 2) AS total_pedidos
FROM cap05exerc.channels AS C INNER JOIN cap05exerc.orders AS O
ON C.channel_id = O.channel_id
AND channel_name = 'FOOD PLACE'
GROUP BY channel_name;

# 10. Quantos pagamentos foram cancelados (chargeback)?

SELECT COUNT(payment_status) AS pagamentos_cancelados
FROM cap05exerc.payments
WHERE payment_status = 'CHARGEBACK';

# 11. Qual foi o valor médio dos pagamentos cancelados (chargeback)?

SELECT * FROM cap05exerc.payments;

SELECT payment_status, ROUND(AVG(payment_amount), 2) AS media_pedidos
FROM cap05exerc.payments
WHERE payment_status = 'CHARGEBACK';

# 12. Qual a média do valor de pagamento por método de pagamento (payment_method) em ordem decrescente?

USE cap05exerc;

SELECT * FROM cap05exerc.payments;
SELECT DISTINCT(payment_method) FROM cap05exerc.payments;

SELECT payment_method, ROUND(AVG(payment_amount), 2) AS pagamento_medio
FROM cap05exerc.payments
GROUP BY payment_method
ORDER BY pagamento_medio DESC;

# 13. Quais métodos de pagamento tiveram valor médio superios a 100?

SELECT payment_method, ROUND(AVG(payment_amount), 2) AS pagamento_medio
FROM cap05exerc.payments
GROUP BY payment_method
HAVING pagamento_medio > 100
ORDER BY pagamento_medio DESC;

# 14. Qual a média de valor de pedido (order_amount) por estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal (channel_type)?

SELECT hub_state, store_segment, channel_type, ROUND(AVG(order_amount)) AS media_pedidos
FROM cap05exerc.hubs AS H INNER JOIN cap05exerc.stores AS S INNER JOIN cap05exerc.orders AS O INNER JOIN cap05exerc.channels AS C
ON H.hub_id = S.hub_id AND S.store_id = O.store_id AND O.channel_id = C.channel_id
GROUP BY hub_state, store_segment, channel_type
ORDER BY hub_state DESC;

# 15. Qual estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal (channel_type) teve média de valor de pedido (order_amount) maior que 450?

SELECT hub_state, store_segment, channel_type, ROUND(AVG(order_amount)) AS media_pedidos
FROM cap05exerc.hubs AS H INNER JOIN cap05exerc.stores AS S INNER JOIN cap05exerc.orders AS O INNER JOIN cap05exerc.channels AS C
ON H.hub_id = S.hub_id AND S.store_id = O.store_id AND O.channel_id = C.channel_id
GROUP BY hub_state, store_segment, channel_type
HAVING media_pedidos > 450
ORDER BY hub_state DESC;

# 16. Qual o valor total de pedido (order_amount) por estado do hub (hub_state), segmento da loja (store_segment) e tipo de canal (channel_type)? Demonstre os totais intermediários e formate o resultado.

SELECT 
	IF(GROUPING(hub_state),
		'Total por hub_state',
        hub_state) AS hub_state,
    IF(GROUPING(store_segment), 
		'Total por store_segment', 
        store_segment) AS store_segments,
	IF(GROUPING(channel_type),
		'Total por channel_type',
        channel_type)AS channel_type,
    ROUND(SUM(order_amount)) AS total_pedidos
FROM cap05exerc.hubs AS H INNER JOIN cap05exerc.stores AS S INNER JOIN cap05exerc.channels AS C INNER JOIN cap05exerc.orders AS O
ON H.hub_id = S.hub_id AND S.store_id = O.store_id AND C.channel_id = O.channel_id
GROUP BY hub_state, store_segment, channel_type WITH ROLLUP;

# 17. Quando o pedido era do Hub do Rio de Janeiro (hub_state), segmento de loja 'FOOD', tipo de canal Marketplace e foi cancelado, qual foi a média de valor do pedido (order_amount)?

SELECT hub_state, store_segment, channel_type, ROUND(AVG(order_amount), 2) AS media
FROM cap05exerc.hubs AS H INNER JOIN cap05exerc.stores AS S INNER JOIN cap05exerc.channels AS C INNER JOIN cap05exerc.orders AS O
ON H.hub_id = S.hub_id 
AND S.store_id = O.store_id 
AND C.channel_id = O.channel_id 
AND H.hub_state = 'RJ'
AND S.store_segment = 'FOOD'
AND C.channel_type = 'MARKETPLACE'
AND O.order_status = 'CANCELED'
GROUP BY hub_state, store_segment, channel_type;

# 18. Quando o pedido era do segmento de loja 'GOOD', tipo de canal Marketplace e foi cancelado, algum hub_state teve total de valor do pedido superior a 100.000?

SELECT hub_state, ROUND(SUM(order_amount), 2) AS media
FROM cap05exerc.hubs AS H INNER JOIN cap05exerc.stores AS S INNER JOIN cap05exerc.orders AS O INNER JOIN cap05exerc.channels AS C
ON H.hub_id = S.hub_id 
AND S.store_id = O.store_id 
AND S.store_segment = 'GOOD'
AND C.channel_type = 'MARKETPLACE'
AND O.order_status = 'CANCELED'
GROUP BY hub_state
HAVING media > 100000;

# 19. Em que data houve a maior média de valor do pedido (order_amount)? Dica: Pesquise e use a função SUBSTRING().

SELECT SUBSTRING(order_moment_created, 1, 9) AS data_pedido, ROUND(AVG(order_amount)) AS media_pedido
FROM cap05exerc.orders AS O
GROUP BY data_pedido
ORDER BY media_pedido;

# 20. Em quais datas o valor do pedido foi igual a zero (ou seja, n'ao houve venda)? Dica: use a função SUBSTRING().

SELECT SUBSTRING(order_moment_created, 1, 9) AS data_pedido, MIN(order_amount) AS pedido_minimo
FROM cap05exerc.orders AS O
GROUP BY data_pedido
HAVING pedido_minimo = 0
ORDER BY data_pedido ASC;
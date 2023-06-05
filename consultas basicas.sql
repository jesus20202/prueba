use BD_HELADERIA
--a.Liste el código, descripción y stock de los helados en orden descendente por precio.
SELECT cod_helado, des_helado, num_stock_actual,num_precio
FROM tb_helado
ORDER BY num_precio DESC;

--b.Liste los apellidos, nombres y dirección de los clientes que viven en los distritos de 150128, 150142, 150110, 150112.
SELECT des_apepaterno, des_apematerno, des_nombres, des_domicilio,cod_ubigeo
FROM tb_cliente
WHERE cod_ubigeo IN ('150128', '150142', '150110', '150112');

--c.Liste la descripción, precio y stock de los helados con precio entre 10 y 15 o stock < 100.
SELECT des_composicion, num_precio, num_stock_actual
FROM tb_helado
WHERE (num_precio BETWEEN 10 AND 15) OR (num_stock_actual < 100);

--d.Liste los apellidos, nombres y dirección de los clientes con teléfono de la serie 75.SELECT des_apepaterno, des_apematerno, des_nombres, des_domicilio, des_telefono
FROM tb_cliente
WHERE des_telefono LIKE '75%';

--e.Liste el máximo y mínimo valor de la fecha del pedido en donde el estado del pedido sea 2.SELECT MAX(fec_pedido), MIN(fec_pedido)
FROM tb_pedido
WHERE ind_estado = 2;
--f.Liste la cantidad de pedidos despachados (ind_estado = 2).SELECT*
FROM tb_pedido
WHERE ind_estado = 2;
--g.Liste los apellidos y nombres de los repartidores que no han realizado ningún reparto.SELECT r.des_appaterno, r.des_apmaterno, r.des_nombres
FROM tb_repartidor r
LEFT JOIN tb_pedido p ON r.cod_repartidor = p.cod_repartidor
WHERE p.cod_repartidor IS NULL;
--h. Liste los datos de los clientes y el nombre de su distrito.
SELECT tb_cliente.*, tb_ubigeo.des_ubigeo AS nombre_distrito
FROM tb_cliente
JOIN tb_ubigeo ON tb_cliente.cod_ubigeo = tb_ubigeo.cod_ubigeo

--i.Liste los números de pedidos y el monto total del pedido.
SELECT dp.cod_helado, SUM(dp.num_cantidad * dp.num_precio_venta) AS monto_total
FROM tb_pedido p
JOIN tb_detalle_pedido dp ON p.cod_pedido = dp.cod_pedido
GROUP BY dp.cod_helado

--j.Liste el código del pedido, la descripción del cliente, la fecha del pedido y la descripción del horario para todos los pedidos despachados (ind_estado = 2).
SELECT p.cod_pedido, c.des_nombres,c.des_apematerno,c.des_apepaterno, p.fec_pedido, h.des_horario
FROM tb_pedido p
JOIN tb_cliente c ON p.cod_cliente = c.cod_cliente
JOIN tb_horario h ON p.cod_horario = h.cod_horario
WHERE p.ind_estado = 2



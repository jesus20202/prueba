USE BD_HELADERIA
select * from tb_detalle_pedido
where cod_pedido = 'PE002'

-- cantidad de registros y el total de pedido con codigo PE002
SELECT cod_pedido, COUNT (cod_pedido) as CantRegistros,
SUM(num_cantidad) as 'unidades'
from tb_detalle_pedido
where cod_pedido = 'PE002'
GROUP BY cod_pedido 

--Cree una vista vw_pedido donde se incluya el número de pedido, fecha del
--pedido, apellidos y nombres del cliente, el estado del pedido en forma LITERAL
--(1: PENDIENTE, 2: DESPACHADO, 3: ATENDIDO), los apellidos y nombres del
--repartidor, el horario del despacho, así como el monto total del pedido.

select * from tb_helado
select * from tb_pedido
select * from tb_detalle_pedido

select cod_pedido, fec_pedido, CONVERT(varchar, fec_pedido, 112)
from tb_pedido
where CONVERT(varchar, fec_pedido, 112) LIKE('201504%')

select count(distinct cod_pedido) from tb_pedido
where CONVERT(varchar, fec_pedido, 112) >= '20150401'
AND CONVERT(varchar, fec_pedido, 112) < '20150501'

select count (distinct cod_pedido) from tb_pedido
where CONVERT(varchar, fec_pedido, 112) LIKE ('201504%')

--Cree una vista vw_pedido_detalle que incluya el número de pedido, el código y
--la descripción del helado, así como la cantidad pedida, el monto total del pedido
--y el subtotal (cantidad * precio)

select count(distinct p.cod_pedido) as pedidos,
SUM (d.num_cantidad * d.num_precio_venta) as total 
from tb_detalle_pedido d
INNER JOIN tb_detalle_pedido d
on (p.cod_pedido = d.cod_pedido)
where CONVERT (varchar, fec_pedido, 112) >= '20150102'
AND CONVERT(varchar , fec_pedido, 112) < '20150401'

----------------------------------------------------------------------------------------------------------------------------------------

--3. procedimeintos almacenados

--a.  Elabore un procedimiento almacenado que permita visualizar los números de
--pedido, la fecha del pedido, los apellidos y nombres del repartidor y el horario del
--despacho de los pedidos generados por un determinado cliente.



--b.Elabore un procedimiento almacenado que devuelva el número de pedido, fecha de pedido y apellidos y nombres de los clientes que han adquirido un
--determinado producto.
CREATE PROCEDURE SP_adquirirproducto
    @CodigoProducto INT
AS
BEGIN
    SELECT O.cod_pedido, O.fec_pedido, C.des_apepaterno + ', ' + C.des_nombres AS CustomerName
    FROM tb_pedido O
    INNER JOIN tb_detalle_pedido OD ON O.cod_pedido = OD.cod_pedido
    INNER JOIN tb_helado P ON OD.cod_helado = P.cod_helado
    INNER JOIN tb_cliente C ON O.cod_cliente = C.cod_cliente
    WHERE P.cod_helado = @CodigoProducto
END


EXEC SP_adquirirproducto @CodigoProducto = 'H03';


--c. Elabore un procedimiento almacenado que devuelva la cantidad y el importe de los pedidos en un periodo de tiempo.
CREATE PROCEDURE sp_cantidadimporte
	@inicio varchar(8),
	@fin varchar(8)
AS
SELECT COUNT (distinct p.cod_pedido) as pedidos
SUM (d.num_cantidad * d.num_precio_venta) as total
FROM tb_pedido p
INNER JOIN tb_detalle_pedido d
ON (p.cod_pedido = d.cod_pedido)
where CONVERT (varchar, fec_pedido, 112) >= @inicio
AND CONVERT(varchar , fec_pedido, 112) < @fin

EXEC sp_cantidadimporte '20150401' , '20150501'

--d. elabore un procedimeinto almacenado que  devuelva el numero de pedido

CREATE PROCEDURE sp_pedidos
	@codigo varchar(3)
AS
SELECT p.cod_pedido, p.fec_pedido, c.cod_cliente, c.des_apepaterno, c.des_apematerno, c.des_nombres
FROM tb_detalle_pedido d, tb_pedido p, tb_cliente c
WHERE d.cod_helado = @codigo AND 
	  d.cod_pedido = p.cod_pedido AND
	  p.cod_cliente = c.cod_cliente

EXEC sp_pedidos 'H05'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--4. funciones
--a.Cree una función de nombre fn_desc_cliente que retorne los apellidos y nombres (concatenado) de un determinado cliente
CREATE FUNCTION dbo.fn_desc_cliente (@codigo as char(4))
RETURNS varchar(100)
AS
BEGIN
	DECLARE @cadena as varchar (100)
	  SELECT @cadena = des_nombres + ', '+ des_apepaterno + ', ' + des_apematerno
	  FROM tb_cliente
	  WHERE cod_cliente = @codigo

	  RETURN @cadena
END;

--EJECUTAR FUNCION
SELECT cod_cliente, des_nombres, des_apepaterno, des_apematerno, 
dbo.fn_desc_cliente(cod_cliente) as NombreCompleto
FROM tb_cliente


CREATE PROCEDURE sp_pedidos_func
@codigo  varchar(3)
AS
SELECT h.cod_helado, h.des_helado, p.pedido, p.fec_pedido, c.cod_cliente,
dbo.fn_desc_cliente(c.cod_cliente) as Cliente
FROM tb_detalle_pedido d, tb_pedido p, tb_cliente c
WHERE d.cod_helado = @codigo AND
	  d.cod_helado = h.cod_helado AND 
	  d.cod_pedido = p.cod_pedido AND
	  p.cod_cliente = c.cod_cliente


exec sp_pedidos_func 'H10'


---b. Cree una función de nombre fn_monto_pedido que retorne el monto total de un
determinado pedido
CREATE FUNCTION dbo.fn_monto_pedido (@codigo as char(5))
RETURNS decimal(10,2)
AS
BEGIN
	DECLARE @monto as decimal (10,2)

	  SELECT @monto = SUM(d.num_cantidad * d.num_precio_venta)
	  FROM tb_pedido as p
	  INNER JOIN tb_detalle_pedido as d
	  ON (p.cod_pedido = d.cod_pedido)
	  WHERE cod_cliente = @codigo

	  RETURN @monto
END;

--EJECUTAR FUNCION
--FORMA 1
SELECT cod_pedido, DBO.fn_monto_pedido(cod_pedido) as total
FROM tb_pedido

--FORMA2
DECLARE @xmonto as decimal(10,2)
SET @xmonto = dbo.fn_monto_pedido('PE005')
print @xmonto
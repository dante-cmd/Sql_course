USE `ey-program`;

select * 
from coa_31122020 ;

select *
from tb_01012020_31122020;

select Mes, COUNT(Monto) as total
from je_01012020_31122020
group by Mes
ORDER BY total desc;

select Usuario, COUNT(DISTINCT(CuentaContable)) as total
from je_01012020_31122020
group by Usuario
ORDER BY total desc;

-- Create Binary
alter table je_01012020_31122020 add column bin int;

SET SQL_SAFE_UPDATES = 0;
update je_01012020_31122020
set bin  = (case when Monto>0 then 0 else 1 end);



select * 
from je_01012020_31122020;

-- with positive as (
	-- select *
    -- from je_01012020_31122020
    -- WHERE bin = 0
-- )
select Usuario, bin, AVG(Monto) as total
from je_01012020_31122020
group by bin, Usuario
order by total desc;
-- select (case when Monto>0 then 0 else 1 end) as bin
-- from je_01012020_31122020;

CREATE DATABASE EY;
USE EY;
SHOW TABLES FROM EY;
SELECT count(DISTINCT(CuentaContable)) FROM coa_31122020;
SELECT count(*) FROM coa_31122020;
SELECT * FROM coa_31122020;
SELECT * FROM je_01012020_31122020;

SELECT * FROM tb_01012020_31122020;
SHOW COLUMNS FROM listado_transacciones_31122020;


SELECT * FROM coa_31122020
WHERE CuentaContable = 0067600800;



select  * -- DISTINCT(`Codigo de Transaccion`) -- DISTINCT(`Tipo de Transaccion`) -- `Codigo de Cliente`
from listado_transacciones_31122020 ; -- join je_01012020_31122020 on (listado_transacciones_31122020.`Libro Mayor`  = je_01012020_31122020.CuentaContable);



select *
from maestro_clientes_31122020;



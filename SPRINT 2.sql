	
-- >>>>>>>>>>>>>>>>>>>> S P R I N T  2 <<<<<<<<<<<<<<<<<<<<<<

-- ======================= NIVEL 1 =======================
-- Ejercicio 1
-- Muestra todas las transacciones realizadas por empresas de Alemania.
SELECT company_id, company_name, country, amount, date(timestamp) as date
FROM transaction
INNER JOIN company ON transaction.company_id = company.id
WHERE company.country = 'Germany'
ORDER BY date desc;
    
-- NOTA: si cambiamos el orden de 'from' y 'inner join' obtenemos el mismo resultado
SELECT company_id, company_name, country, amount, date(timestamp) as date
from company
INNER JOIN transaction ON company.id = transaction.company_id
where company.country = 'Germany'
order by date desc;


-- Ejercicio 2
-- Marketing está preparando algunos informes de cierres de gestión,
-- te piden que les pases un listado de las empresas que han realizado transacciones
-- por una suma superior a la media de todas las transacciones.
SELECT company_name, SUM(amount) as cantidad_total
from transaction
INNER JOIN company ON transaction.company_id = company.id
group by company_id, company_name
HAVING cantidad_total > (SELECT AVG(amount) FROM transaction)
order by cantidad_total desc;


-- Ejercicio 3
-- El departamento de contabilidad perdió la información de las transacciones realizadas por una empresa,
-- pero no recuerdan su nombre, sólo recuerdan que su nombre iniciaba con la letra c.
-- ¿Cómo puedes ayudarles? Coméntelo acompañándolo de la información de las transacciones.
select
	company_name,
	sum(amount) as cantidal_total,
	count(amount) as cantidad_transacciones
from company
inner join transaction on company.id = transaction.company_id
where company_name like 'c%'
group by company_id, company_name
order by cantidal_total DESC;

-- NOTA: ademas obtenemos el mismo resultado si cambiamos el orden de 'from' y 'join' 
select
	company_name,
	sum(amount) as cantidal_total,
	count(amount) as cantidad_transacciones
from transaction                                           -- cambio de la tabla
inner join company on transaction.company_id = company.id  -- cambio de orden de join
where company_name like 'c%'
group by company_id, company_name
order by cantidal_total DESC;



-- Ejercicio 4
-- Eliminaron del sistema a las empresas que no tienen transacciones registradas,
-- entrega el listado de estas empresas.
select
	company_id, company_name
from company
left join transaction on company.id = transaction.company_id
where transaction.company_id is null;


-- ======================= NIVEL 2 =======================
-- Ejercicio 1
-- En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer
-- competencia a la compañía Non institute. Para ello, te piden la lista de todas las transacciones realizadas
-- por empresas que están ubicadas en el mismo país que esta compañía.
SELECT
	company_id, company_name, amount, country, DATE(timestamp) AS date
FROM transaction
INNER JOIN company ON transaction.company_id = company.id
WHERE company.country = (
	select country
    FROM company
    WHERE company_name = 'Non institute')
ORDER BY date DESC;

-- Comprobamos la existencia de la empresa 'Non institute' y vemos por lo tanto que si existe registros de esa empresa
SELECT 
    id, company_name
FROM company
WHERE company_name = 'Non institute';


-- Ejercicio 2
-- El departamento de contabilidad necesita que encuentres a la empresa que ha realizado la transacción de mayor suma en la base de datos.
SELECT
	company_name, max(amount) as cantidad_maxima
FROM transaction 
INNER JOIN company on transaction.company_id = company.id
GROUP BY company_id, company_name
ORDER BY cantidad_maxima desc
LIMIT 1;


-- ======================= NIVEL 3 ======================= 
-- Ejercicio 1
-- Se están estableciendo los objetivos de la empresa para el siguiente trimestre,
-- por lo que necesitan una sólida base para evaluar el rendimiento y medir el éxito en los diferentes mercados.
-- Para ello, necesitan el listado de los países cuya media de transacciones sea superior a la media general.
SELECT
	country, avg(amount) as media_superior
FROM transaction 
INNER JOIN company on transaction.company_id = company.id
GROUP BY country
HAVING media_superior > (select avg(amount) from transaction)
ORDER BY media_superior desc;
-- resultado:
-- United States	309.179412
-- Ireland	        277.308387
-- United Kingdom	270.731700
-- Canada	        269.647869
-- Sweden	        260.615063

-- NOTA: ademas obtenemos el mismo resultado si cambiamos el orden de 'from' y 'join' 
SELECT
	country, avg(amount) as media_superior
FROM  company
INNER JOIN transaction on company.id = transaction.company_id
GROUP BY country
HAVING media_superior > (select avg(amount) from transaction)
order by media_superior desc;


-- Ejercicio 2
/*Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera,
por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas,
pero el departamento de recursos humanos es exigente y quiere un listado de las empresas donde 
especifiques si tienen más de 4 o menos transacciones. */
SELECT company_name, count(amount) as cantidad_transacciones
	FROM transaction
INNER JOIN company on transaction.company_id = company.id
GROUP BY company_name
HAVING count(amount) > 4 or count(amount) < 4
ORDER BY cantidad_transacciones DESC;




 

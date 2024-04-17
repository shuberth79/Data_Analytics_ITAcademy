	
-- >>>>>>>>>>>>>>>>>>>> S P R I N T  2 <<<<<<<<<<<<<<<<<<<<<<

-- ======================= NIVEL 1 =======================
-- Ejercicio 1_____________________________________________________________________
-- Muestra todas las transacciones realizadas por empresas de Alemania.
SELECT *         
FROM transaction 
WHERE company_id IN (
	SELECT id 
	FROM company 
	WHERE country = "Germany");  

-- Ejercicio 2_____________________________________________________________________
/*Marketing está preparando algunos informes de cierres de gestión,
te piden que les pases un listado de las empresas que han realizado transacciones
por una suma superior a la media de todas las transacciones.

1º Buscamos la media general 
2º Buscamos las compañías que superen esta media
3º Buscamos la información de las compañías para hacer la lista solicitada */
		SELECT *
		FROM company
		WHERE id IN (
			SELECT company_id
			FROM transaction
			WHERE amount > (
                SELECT avg(amount)
				FROM transaction)
			)
		;

-- Ejercicio 3_____________________________________________________________________
-- El departamento de contabilidad perdió la información de las transacciones realizadas por una empresa,
-- pero no recuerdan su nombre, sólo recuerdan que su nombre iniciaba con la letra c.
-- ¿Cómo puedes ayudarles? Coméntelo acompañándolo de la información de las transacciones.
SELECT *,(
    SELECT company_name
    FROM company
    WHERE company_id = id) as nombre_compañias
FROM transaction
WHERE company_id IN (
	SELECT id
	FROM company
	WHERE company_name LIKE 'c%')
; 

-- aqui este codigo lo unico que hacemos es ubicar el nombre de la compañia al inicio 
SELECT (
	SELECT company_name
    FROM company
    WHERE company_id = id) AS nombre_compañias,
transaction.*
FROM transaction
WHERE company_id IN (
	SELECT id
	FROM company
	WHERE company_name LIKE 'c%')
;  

-- Ejercicio 4_____________________________________________________________________
/*Eliminaron del sistema a las empresas que no tienen transacciones registradas,
entrega el listado de estas empresas*/
SELECT id, company_name        -- buscamos registros que no esten en tabla transaction
FROM company
WHERE NOT EXISTS
	(SELECT company_id FROM transaction);      


-- ======================= NIVEL 2 =======================
/* Ejercicio 1_____________________________________________________________________
En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer
competencia a la compañía Non institute. Para ello, te piden la lista de todas las transacciones realizadas
por empresas que están ubicadas en el mismo país que esta compañía.*/
SELECT (
	SELECT company_name
	FROM company
	WHERE company.id = transaction.company_id) as nombre_compañia,
transaction.*
FROM transaction 
WHERE company_id IN (  
	SELECT id
	FROM company
	WHERE country = (   -- filtramos por el pais segun la compañia de interés
		SELECT country
		FROM company
		WHERE company_name = 'Non institute')
	)
; 

/*Ejercicio 2_____________________________________________________________________
El departamento de contabilidad necesita que encuentres a la empresa que ha realizado 
la transacción de mayor suma en la base de datos.*/
SELECT *
FROM company
WHERE company.id = (
	SELECT company_id
    FROM transaction
    ORDER BY amount DESC
    LIMIT 1);


-- ======================= NIVEL 3 ======================= 

/*Ejercicio 1_____________________________________________________________________
Se están estableciendo los objetivos de la empresa para el siguiente trimestre,
por lo que necesitan una sólida base para evaluar el rendimiento y medir el éxito en los diferentes mercados.
Para ello, necesitan el listado de los países cuya media de transacciones sea superior a la media general.*/
SELECT country, round(AVG(amount), 2) AS media_superior  
FROM company, transaction
WHERE company.id = transaction.company_id
GROUP BY country
HAVING AVG(amount) > (
    SELECT AVG(amount)
	FROM transaction)
;
  
/*Ejercicio 2_____________________________________________________________________
Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa
que se requiera, por lo que te piden la información sobre la cantidad de transacciones que
realizan las empresas, pero el departamento de recursos humanos es exigente y quiere un listado
de las empresas donde especifiques si tienen más de 4 o menos transacciones. */
SELECT company_name, count(transaction.amount) as cantidad_transacciones,
	CASE
		WHEN count(transaction.amount) >= 4 THEN 'mayor a 4 transacciones'
		ELSE 'menor a 4'
	END AS valoracion_transacciones
FROM company, transaction
where company.id = transaction.company_id
group by company_name
order by cantidad_transacciones desc;



 

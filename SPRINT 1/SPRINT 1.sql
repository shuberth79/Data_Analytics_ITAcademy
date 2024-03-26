	
-- S P R I N T  1
-- ======================= NIVEL 1 ======================= 
-- Ejercicio 2
-- Realiza la siguiente consulta: Debes obtener el nombre, email y país de cada compañía,
-- ordena los datos en función del nombre de las compañías.
SELECT company_name, email, country
FROM transactions.company
ORDER BY company_name;
    
    
-- Ejercicio 3.
-- Desde la sección de marketing te solicitan que les pases un listado de los países que están realizando compras
SELECT DISTINCT company.country
FROM transactions.company
JOIN transactions.transaction ON transaction.company_id = company.id;

SELECT DISTINCT company.country, SUM(amount) AS total_venta
FROM transactions.company
JOIN transactions.transaction ON transaction.company_id = company.id
GROUP BY company.country
order by total_venta desc;


-- Ejercicio 4
-- Desde marketing también quieren saber desde cuántos países se realizan las compras
SELECT COUNT(DISTINCT company.country) AS total_countries
FROM transactions.company
INNER JOIN transactions.transaction ON transaction.company_id = company.id
WHERE transaction.declined = 0;
  
  
-- Ejercicio 5
-- Tu jefe identifica un error con la compañía que tiene vaya 'b-2354'.
-- Por tanto, te solicita que le indiques el país y nombre de compañía de este ve.
SELECT c.country, c.company_name
FROM transactions.company c
WHERE c.id = 'b-2354';
    
    
-- Ejercicio 6
-- Además, ¿tu jefe te solicita que indiques cuál es la compañía con mayor gasto medio?
SELECT company_name, AVG(transaction.amount) AS average_spend    -- AVG para sacar promedio y AS para asignar nombre a la nueva columna 
FROM transactions.company
INNER JOIN transactions.transaction ON transaction.company_id = company.id
GROUP BY company.id
ORDER BY average_spend DESC
LIMIT 1;


-- ======================= NIVEL 2 ======================= 
-- Ejercicio 1
-- Tu jefe está redactando un informe de cierre del año y te solicita que le envíes información relevante para el documento.
-- Para ello te solicita verificar si en la base de datos existen compañías con identificadores (id) duplicados.
SELECT company.id, COUNT(*) AS num_companies  -- COUNT() para el conteo de las id y luego la asignación
FROM transactions.company
GROUP BY company.id
HAVING COUNT(*) > 1;   -- filtro para indicar las compañias que se repiten mas de 1 vez
-- CONCLUSION: aparentemente no hay duplicados en la base de datos


-- Ejercicio 2
-- ¿En qué día se realizaron las cinco ventas más costosas? Muestra la fecha de la transacción y la sumatoria de la cantidad de dinero.
SELECT DATE(timestamp) as fecha, SUM(amount) AS total_venta
FROM transactions.transaction
GROUP BY fecha
ORDER BY total_venta DESC   -- ordenado por el total de venta en descenso
LIMIT 5;                    -- solo los 5 valores mas altos


-- Ejercicio 3
-- ¿En qué día se realizaron las cinco ventas de menor valor? Muestra la fecha de la transacción y la sumatoria de la cantidad de dinero.
SELECT DATE(timestamp) as fecha, SUM(amount) AS total_venta
FROM transactions.transaction
GROUP BY fecha
ORDER BY total_venta ASC   -- ordenado por el total de venta en descenso
LIMIT 5;  


-- Ejercicio 4
-- ¿Cuál es la media de gasto por país? Presenta los resultados ordenados de mayor a menor medio.
SELECT country, AVG(transaction.amount) AS average_amount
FROM transaction
INNER JOIN company ON transaction.company_id = company.id
GROUP BY company.country
ORDER BY average_amount DESC;


-- ======================= NIVEL 3 ======================= 
-- Ejercicio 1
-- Presenta el nombre, teléfono y país de las compañías, junto con la cantidad total gastada,
-- de aquellas que realizaron transacciones con un gasto comprendido entre 100 y 200 euros.
-- ordena los resultados de mayor a menor cantidad gastada.
SELECT company_name, phone, country, t.amount AS cantidad_total
FROM transaction t
INNER JOIN company c ON t.company_id = c.id
WHERE t.amount BETWEEN 100 AND 200
ORDER BY cantidad_total DESC;




-- Ejercicio 2
-- Indica el nombre de las compañías que realizaron compras el 16 de marzo de 2022,
-- 28 de febrero de 2022 y 13 de febrero de 2022.
SELECT DISTINCT company.company_name, transaction.timestamp
FROM transaction
INNER JOIN company ON transaction.company_id = company.id
WHERE date (timestamp) IN ('2022-03-16%', '2022-02-28%', '2022-02-13%')
GROUP BY company_name, transaction.timestamp;




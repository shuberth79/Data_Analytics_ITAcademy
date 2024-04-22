	
-- S P R I N T  1
-- ======================= NIVEL 1 ======================= 

/*Ejercicio 2_____________________________________________________________________
Realiza la siguiente consulta: Debes obtener el nombre, email y país de cada compañía,
ordena los datos en función del nombre de las compañías*/

-- se usa la base de datos "transactions"
USE transactions;    
         
SELECT company_name, email, country
FROM company
ORDER BY company_name ASC;
    
-- Ejercicio 3_____________________________________________________________________
-- Desde la sección de marketing te solicitan que les pases un listado de los países que están realizando compras
SELECT DISTINCT company.country   
FROM transactions.company
ORDER BY company.country ASC;

-- otro camino usando JOIN con amount
SELECT DISTINCT company.country, SUM(amount) AS total_venta  -- aplicamos JOIN para poder agregar total_venta
FROM transactions.company
JOIN transactions.transaction ON transaction.company_id = company.id
GROUP BY company.country
order by total_venta desc;


-- Ejercicio 4_____________________________________________________________________
-- Desde marketing también quieren saber desde cuántos países se realizan las compras
SELECT COUNT(DISTINCT company.country) AS total_countries    
FROM transactions.company;

-- otro camino usando JOIN
SELECT COUNT(DISTINCT company.country) AS total_countries
FROM transactions.company
INNER JOIN transactions.transaction ON transaction.company_id = company.id
WHERE transaction.declined = 0;

-- Ejercicio 5_____________________________________________________________________
-- Tu jefe identifica un error con la compañía que tiene vaya 'b-2354'.
-- Por tanto, te solicita que le indiques el país y nombre de compañía de este ve.
SELECT country, company_name  
FROM transactions.company c
WHERE c.id = 'b-2354';
    
    
-- Ejercicio 6_____________________________________________________________________
-- Además, ¿tu jefe te solicita que indiques cuál es la compañía con mayor gasto medio?
SELECT company_id, company_name, round(AVG(t.amount),2) AS gasto_promedio  
FROM transaction t
JOIN company c ON t.company_id=c.id
WHERE declined=0               -- se incrementó este filtro para confirmar
GROUP BY company_id
ORDER BY gasto_promedio DESC
LIMIT 1;

-- ======================= NIVEL 2 ======================= 

-- Ejercicio 1_____________________________________________________________________
-- Tu jefe está redactando un informe de cierre del año y te solicita que le envíes información relevante para el documento.
-- Para ello te solicita verificar si en la base de datos existen compañías con identificadores (id) duplicados.
USE transactions;  
SELECT COUNT(id) - COUNT(DISTINCT id) AS 'cantidad compañias duplicadas' 
FROM transactions.company;

-- experimentando con otra forma
SELECT company.id, COUNT(*) AS num_companies  -- COUNT() para el conteo de las id y luego la asignación
FROM transactions.company
GROUP BY company.id
HAVING COUNT(*) > 1;   -- filtro para indicar las compañias que se repiten mas de 1 vez
-- CONCLUSION: aparentemente no hay duplicados en la base de datos

-- Ejercicio 2_____________________________________________________________________
-- ¿En qué día se realizaron las cinco ventas más costosas? Muestra la fecha de la transacción y la sumatoria de la cantidad de dinero.
SELECT DATE(timestamp) as fecha, SUM(amount) AS total_venta
FROM transactions.transaction
WHERE declined=0               
GROUP BY fecha
ORDER BY total_venta DESC   
LIMIT 5;                    


-- Ejercicio 3_____________________________________________________________________
-- ¿En qué día se realizaron las cinco ventas de menor valor? Muestra la fecha de la transacción y la sumatoria de la cantidad de dinero.
SELECT DATE(timestamp) as fecha, SUM(amount) AS total_venta
FROM transactions.transaction
GROUP BY fecha
ORDER BY total_venta ASC   -- ordenado por el total de venta en descenso
LIMIT 5;  

-- otra forma
SELECT DATE(timestamp) as fecha, SUM(amount) AS total_venta
FROM transactions.transaction
WHERE declined=0                
GROUP BY fecha
ORDER BY total_venta ASC   
LIMIT 5;  

-- Ejercicio 4_____________________________________________________________________
-- ¿Cuál es la media de gasto por país? Presenta los resultados ordenados de mayor a menor medio.
SELECT country, AVG(transaction.amount) AS average_amount
FROM transaction
INNER JOIN company ON transaction.company_id = company.id
GROUP BY company.country
ORDER BY average_amount DESC;

-- otra forma
SELECT country, AVG(transaction.amount) AS average_amount
FROM transaction
INNER JOIN company ON transaction.company_id = company.id
WHERE declined=0                
GROUP BY company.country
ORDER BY average_amount DESC;


-- ======================= NIVEL 3 ======================= 

-- Ejercicio 1_____________________________________________________________________
-- Presenta el nombre, teléfono y país de las compañías, junto con la cantidad total gastada,
-- de aquellas que realizaron transacciones con un gasto comprendido entre 100 y 200 euros.
-- ordena los resultados de mayor a menor cantidad gastada.
SELECT company_name, phone, country, t.amount AS cantidad_total
FROM transaction t
INNER JOIN company c ON t.company_id = c.id
WHERE t.amount BETWEEN 100 AND 200
ORDER BY cantidad_total DESC;

SELECT company_name, phone, country, t.amount AS cantidad_total
FROM transaction t
INNER JOIN company c ON t.company_id = c.id
WHERE declined=0 AND t.amount BETWEEN 100 AND 200   
ORDER BY cantidad_total DESC;


-- Ejercicio 2_____________________________________________________________________
-- Indica el nombre de las compañías que realizaron compras el 16 de marzo de 2022,
-- 28 de febrero de 2022 y 13 de febrero de 2022.
SELECT DISTINCT company.company_name, DATE(transaction.timestamp) as fecha_compra
FROM transaction
INNER JOIN company ON transaction.company_id = company.id
WHERE DATE(timestamp) IN ('2022-03-16%', '2022-02-28%', '2022-02-13%')
GROUP BY company_name, transaction.timestamp;




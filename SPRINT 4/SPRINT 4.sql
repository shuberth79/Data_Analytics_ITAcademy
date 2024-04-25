	
-- >>>>>>>>>>>>>>>>>>>> S P R I N T  4 <<<<<<<<<<<<<<<<<<<<<<

-- ======================= NIVEL 1 =======================

/*Partiendo de algunos archivos CSV diseñarás y crearás tu base de datos.
Descarga los archivos CSV, estudiales y diseña una base de datos con un esquema 
de estrella que contenga, al menos 4 tablas de las que puedas realizar las 
siguientes consultas:*/

CREATE DATABASE db_SPRINT4;

CREATE TABLE company (
	id VARCHAR(20) PRIMARY KEY,
	company_name VARCHAR(255),
	phone VARCHAR(15),
	email VARCHAR(150),
	country VARCHAR(150),
	website VARCHAR(150));

-- -----------------------------------------------------

create table credit_card (
	id VARCHAR(20) PRIMARY KEY,
	user_id VARCHAR(20),
	iban VARCHAR(255),
	pan VARCHAR(45),
	pin CHAR(4),
	cvv CHAR(3),
	track1 VARCHAR(255),
	track2 VARCHAR(255),
	expiring_date varchar(255));

-- -----------------------------------------------------

CREATE TABLE products (
	id INT PRIMARY KEY,
	product_name VARCHAR(100),
	price VARCHAR(10),
	colour VARCHAR(100),
	weight VARCHAR(100),
	warehouse_id VARCHAR(100));
-- -----------------------------------------------------

CREATE TABLE users (
	id INT PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR (150),
	postal_code VARCHAR(100),
	address VARCHAR(255));
-- -----------------------------------------------------

CREATE TABLE transactions (
	id VARCHAR(255) PRIMARY KEY,
	card_id VARCHAR(20),
	bussiness_id VARCHAR(150),
	timestamp varchar(150), 
	amount DECIMAL(10,2),
	declined TINYINT(1) DEFAULT 0,
	product_ids VARCHAR(20),
	user_id INT,
	lat VARCHAR(50),
	longitude VARCHAR(50));

/*cargamos e introducimos la data desde los archivo csv facilitados en el ejercicio
de tal modo que copamos las tablas de data a procesar. En algunos casos los archivos 
facilitados venían con ciertas limitaciones que impedian la normal importación, estos
detalles loadexplicaremos a posterior*/

LOAD DATA LOCAL INFILE      
'D:\SH ESPAÑA\CURSOS - CAPACITACIÓN\IT ACADEMY\DATA ANALYTICS\SPRINT 4\DESCARGADOS\transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY  ","
ENCLOSED BY "'"
LINES TERMINATED BY ";"
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE      
'D:\SH ESPAÑA\CURSOS - CAPACITACIÓN\IT ACADEMY\DATA ANALYTICS\SPRINT 4\DESCARGADOS\companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY  ","
ENCLOSED BY "'"
LINES TERMINATED BY ";"
IGNORE 1 ROWS;

/*
Para la usual importación de los datos de usuarios provenientes de los archivos 'csv' denominados 
'users_ca', 'users_uk', 'users_usa', se estableció una unificación de data a una sola tabla 'users'
desde ahi importaremos el contenido de los 3 archivos. 
*/
LOAD DATA LOCAL INFILE      
'D:\SH ESPAÑA\CURSOS - CAPACITACIÓN\IT ACADEMY\DATA ANALYTICS\SPRINT 4\DESCARGADOS\users_ca.csv'
INTO TABLE users
FIELDS TERMINATED BY  ","
ENCLOSED BY "'"
LINES TERMINATED BY ";"
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE      
'D:\SH ESPAÑA\CURSOS - CAPACITACIÓN\IT ACADEMY\DATA ANALYTICS\SPRINT 4\DESCARGADOS\users_uk.csv'
INTO TABLE users
FIELDS TERMINATED BY  ","
ENCLOSED BY "'"
LINES TERMINATED BY ";"
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE      
'D:\SH ESPAÑA\CURSOS - CAPACITACIÓN\IT ACADEMY\DATA ANALYTICS\SPRINT 4\DESCARGADOS\users_usa.csv'
INTO TABLE users
FIELDS TERMINATED BY  ","
ENCLOSED BY "'"
LINES TERMINATED BY ";"
IGNORE 1 ROWS;

/*
En el caso específico de esta importacion en la tabla 'products', se lo importó de forma habitual
conforme venía los datos desde los archivos, se pudo operar sin problema todos los ejercicios, 
de todas formas detallamos la modificacion presentada en cada valor del campo/columna 'price' con 
el signo '$' en la tabla 'products' puede que ha futuro esto complique el fluido trabajo en el filtrado
o consulta. Se procede a extraerlo, osea limpiar la data para que se mas legible y podamos
tipificarlos en la tabla, de VARCHAR(10) a DECIMAL(5,2)
*/
LOAD DATA LOCAL INFILE      
'D:\SH ESPAÑA\CURSOS - CAPACITACIÓN\IT ACADEMY\DATA ANALYTICS\SPRINT 4\DESCARGADOS\products.csv'
INTO TABLE products
FIELDS TERMINATED BY  ","
ENCLOSED BY "'"
LINES TERMINATED BY ";"
IGNORE 1 ROWS
(id, product_name, colour, @price, weight, warehouse_id)
SET price = REPLACE(@price, '$','');  -- Se configura la columna 'price' para extraer el signo '$'
/*
De igual forma, como un camino alternativo, en el proceso de importacion a la tabla 'credit_card', procedemos a modificar a 
conveniencia las fechas registradas 
*/
LOAD DATA LOCAL INFILE      
'D:\SH ESPAÑA\CURSOS - CAPACITACIÓN\IT ACADEMY\DATA ANALYTICS\SPRINT 4\DESCARGADOS\credit_cards.csv'
INTO TABLE credit_card
FIELDS TERMINATED BY  ","
ENCLOSED BY "'"
LINES TERMINATED BY ";"
IGNORE 1 ROWS
(id, user_id, iban, pan, pin, cvv, track1, track2, @expiring_date)
SET expiring_date = STR_TO_DATE(@expiring_date,'%m,%d,%y'); 

/*conforme la elaboración de todas las tablas necesarias, se planifica as relaciones
entre ellas, se establece la indexación con sus respectivos foreign key y evitarnos
posibles inconvenientes */

CREATE INDEX idx_company
	ON transaction(business_id);
    
CREATE INDEX idx_credit_card
	ON transaction(card_id);
    
CREATE INDEX idx_users
	ON transaction(user_id);
    
CREATE INDEX idx_products
	 ON transaction(product_ids);

ALTER TABLE company
	ADD FOREIGN KEY (id) REFERENCES transactions(business_id);
    
ALTER TABLE credit_card
	ADD FOREIGN KEY (id) REFERENCES transactions(card_id);
    
ALTER TABLE users
	ADD FOREIGN KEY (id) REFERENCES transactions(user_id);

/*- EJERCICIO 1_____________________________________________________________________
Realiza una subconsulta que muestre a todos los usuarios con más de 30 transacciones
utilizando al menos 2 tablas..*/
SELECT u.*,                          -- Consulta definitiva como respuesta de la tarea
		(SELECT count(t.id)
        FROM transactions t
        WHERE u.id = t.user_id) AS cantidad_transacciones
FROM users u
GROUP BY id
HAVING cantidad_transacciones > 30;


/*Como una buena practica en la profundizacion en el dominio del manejo del lenguaje,
desgloso algunas opciones con JOIN*/ 

-- Opcion consulta sencilla con JOIN
SELECT u.id,
	u.name as nombre,
    u.surname AS apellido,
    count(t.id) as total_transaccions
FROM users AS u
INNER JOIN transactions AS t ON u.id = t.user_id
GROUP BY u.id, u.name, u.surname
HAVING COUNT(t.id) > 30
ORDER BY total_transaccions DESC;

-- -----------------------------------------------------
 
-- Opcion consulta sencilla con JOIN concatenando los nombres
SELECT t.user_id,
	concat(NAME, ' ',SURNAME) AS "nombres completos",
    count(t.id) AS total_transaccions   
FROM users AS u
INNER JOIN transactions AS t ON u.id = t.user_id
GROUP BY u.id, u.name, u.surname
HAVING  count(t.id) >30
ORDER BY total_transaccions DESC;

-- -----------------------------------------------------

-- Opcion con subconsulta dentro de INNER JOIN concatenando los nombres
SELECT t.user_id,
	concat(NAME, ' ',SURNAME) AS "nombres completos",
    total_transactions
FROM users AS u
INNER JOIN (
	SELECT user_id, COUNT(*) AS total_transactions
	FROM transactions
	GROUP BY user_id
	HAVING COUNT(*) > 30
    	) AS t ON u.id = t.user_id
ORDER BY total_transactions DESC;

-- -----------------------------------------------------

-- Opcion con subconsulta dentro de INNER JOIN, concatenando los nombres y el monto total con 2 decimales
SELECT t.user_id,
	concat(u.NAME, ' ',u.SURNAME) AS "nombres completos",
    total_transacciones,
    monto_total 
FROM users AS u
INNER JOIN (
	SELECT user_id, count(*) AS total_transacciones,
		FORMAT (SUM(t.amount), 'f2') AS monto_total
	FROM transactions AS t
	GROUP BY user_id
	HAVING count(*) >30
	) AS t ON u.id = t.user_id
ORDER BY total_transacciones DESC;
 
/*- EJERCICIO 2_____________________________________________________________________
/*Muestra el promedio de la suma de transacciones por IBAN de las tarjetas de crédito
en la compañía Donec Ltd. utilizando al menos 2 tablas.*/

SELECT co.company_name,
	cc.iban,
	ROUND(AVG(t.amount),2) AS promedio_suma_transacciones  
FROM companies co
INNER JOIN transactions t ON co.company_id = t.business_id
INNER JOIN credit_cards cc ON t.card_id = cc.id
WHERE co.company_name = 'Donec Ltd'
GROUP BY cc.iban;


-- ======================= NIVEL 2 =======================

/*Crea una nueva tabla que refleje el estado de las tarjetas de 
crédito basado en si las últimas tres transacciones fueron declinadas 
y genera la siguiente consulta:*/

-- se crea una nueva tabla
CREATE TABLE card_status (
	card_id VARCHAR(15),
    status VARCHAR(50));

-- Se ingresa los datos de tablas establecidas condicionandolo con filtros según el pedido

INSERT INTO card_status (card_id, status)
WITH transacciones_tarjeta AS (
	SELECT card_id, 
		timestamp, 
		declined, 
		ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS row_transaction
FROM transactions)
SELECT card_id as numero_tarjeta,
	CASE 
		WHEN SUM(declined) <= 2 THEN 'tarjeta activa'
		ELSE 'tarjeta desactivada'
	END AS estado_tarjeta
FROM transacciones_tarjeta
WHERE row_transaction <= 3 
GROUP BY numero_tarjeta;

SELECT card_id as numero_tarjeta,
	status AS estado_tarjeta
FROM card_status;  -- verificando resultados

/* Ejercicio 1_____________________________________________________________________
/*¿Cuántas tarjetas están activas?*/

SELECT COUNT(*) AS 'tarjetas activas'
FROM card_status
WHERE status ='tarjeta activa';


-- ======================= NIVEL 3 =======================

/*Ejercicio 1_____________________________________________________________________
/*Necesitamos conocer el número de veces que se ha vendido cada producto.*/

/*Despues de crear tabla intermedia 'transactions_products_1' con sus respectivas vinculaciones
foraneas e indexaciones, hacemos la importacion de datos*/

CREATE TABLE transactions_products_1 (
  id VARCHAR (255),
  product_ids INT);

LOAD DATA LOCAL INFILE      -- cargamos e introducimos la data desde el archivo csv
'D:\SH ESPAÑA\CURSOS - CAPACITACIÓN\IT ACADEMY\DATA ANALYTICS\SPRINT 4\DESCARGADOS\transactions_products.csv'
INTO TABLE transactions_products8
FIELDS TERMINATED BY  ","
ENCLOSED BY "'"
LINES TERMINATED BY ";"
IGNORE 1 ROWS;

SELECT * 
FROM transactions_products;       -- visualizamos la nueva tabla

SHOW CREATE TABLE transactions_products; -- verificamos codigo

/* consulta usando COUNT para el conteo por product_ids*/
SELECT DISTINCT product_name,
	count(product_ids) AS cantidad_ventas -- conteo por product_ids
FROM products p
INNER JOIN transactions_products tp ON p.id = tp.product_ids
GROUP BY product_name
ORDER BY cantidad_ventas DESC;

/* consulta usando COUNT para el conteo por id*/
SELECT DISTINCT product_name,
	count(tp.id) AS cantidad_ventas -- conteo por id
FROM products p
INNER JOIN transactions_products tp ON p.id = tp.product_ids
GROUP BY product_name
ORDER BY cantidad_ventas DESC;
/*NOTA: surge ciertas dudas que bajo el nombre de 1 producto se encuentre varias versiones de
producto según otras caracteristicas*/

/* En esta consulta intentamos cubrir la sospecha de que existan bajo un mismo nombre varios tipos de producto
ya sea por tamaño color, por alguna razon lo evidencia en warehouse, de este forma asegurandonos usamos
DISTINCT y lo agrupamos por id*/
SELECT DISTINCT p.id,
	count(product_ids) as conteo_ventas
FROM transactions_products as tp
INNER JOIN products as p ON tP.product_ids = p.id
GROUP BY p.id
ORDER BY p.id ASC;

/*Ahora solo agregamos el nombre para conocer a pesar que se repita, pero se diferencia por el id segun su tipología*/
SELECT DISTINCT p.id,
	p.product_name,
	count(tp.id) AS cantidad_ventas
FROM products p
INNER JOIN transactions_products tp ON p.id = tp.product_ids
GROUP BY id
ORDER BY id ASC;


-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<







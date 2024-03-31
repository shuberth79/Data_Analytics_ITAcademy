	
-- >>>>>>>>>>>>>>>>>>>> S P R I N T  4 <<<<<<<<<<<<<<<<<<<<<<

-- ======================= NIVEL 1 =======================

-- Partiendo de algunos archivos CSV diseñarás y crearás tu base de datos.
create database db_SPRINT4;

create table companies (
company_id varchar(20) PRIMARY KEY not null,
company_name varchar(255) null,
phone int(15) null,
email varchar(150) null,
country varchar(150) null,
website varchar(150) null
);
-- -----------------------------------------------------

create table credit_card (
id VARCHAR(20) PRIMARY KEY not null,
user_id INT,
iban VARCHAR(255) null,
pan VARCHAR(45) null,
pin CHAR(4) null,
cvv CHAR(3) null,
track1 varchar(255),
track2 varchar(255),
expiring_date varchar(255) null
);
alter table credit_cards
ADD FOREIGN KEY (user_id) references users(id);
-- -----------------------------------------------------

create table products (
id int auto_increment PRIMARY KEY not null,
product_name varchar(100) not null,
price varchar(10) null,
colour varchar(100) null,
weight double null,
warehouse_id varchar(100) not null
);
-- -----------------------------------------------------

create table users (
id int auto_increment PRIMARY KEY not null,
name varchar(100),
surname varchar(100) null,
phone varchar(150),
email varchar(150),
birth_date varchar(100),
country varchar(150),
city varchar (150),
postal_code varchar(100),
address varchar(255)
);
-- -----------------------------------------------------

CREATE TABLE transactions (
id varchar(255) PRIMARY KEY NOT NULL,
card_id varchar(20) NULL,
bussiness_id varchar(150) NULL,
timestamp varchar(150) NOT NULL, 
amount DECIMAL(10,2) NOT NULL,
declined TINYINT(1) NOT NULL DEFAULT 0,
product_ids varchar(20) NOT NULL,
user_id INT NOT NULL,
lat varchar(50) NULL,
longitude varchar(50) NULL);

alter table transactions
ADD FOREIGN KEY (card_id) references credit_card(id),
ADD FOREIGN KEY (bussiness_id) references companies(company_id),
ADD FOREIGN KEY (product_ids) references products(id),
ADD FOREIGN KEY (user_id) references users(id);

/*- EJERCICIO 1_____________________________________________________________________
Realiza una subconsulta que muestre a todos los usuarios con más de 30 transacciones
utilizando al menos 2 tablas..*/

/*Como una buena practica en la profundizacion en el dominio del manejo de deatos,
desgloso algunas opciones*/ 

-- Opcion consulta sencilla solo con la tabla transactions
SELECT user_id, COUNT(*) AS total_transactions    
FROM transactions
GROUP BY user_id
HAVING COUNT(*) > 30
ORDER BY total_transactions asc;
-- -----------------------------------------------------

-- Opcion consulta sencilla solo con la tabla transactions y montos totales de 2 decimales 'round'
SELECT user_id, COUNT(*) AS total_transactions, ROUND(SUM(amount), 2) as monto_total    
FROM transactions
GROUP BY user_id
HAVING COUNT(*) > 30 AND sum(amount)
ORDER BY total_transactions asc;
-- -----------------------------------------------------

-- Opcion consulta sencilla con Union (2 tablas)
SELECT u.name as nombre, u.surname as apellido, count(t.id) as total_transaccions
FROM users AS u
INNER JOIN transactions AS t ON u.id = t.user_id
GROUP BY u.id, u.name, u.surname
HAVING COUNT(t.id) > 30;
-- -----------------------------------------------------
 
-- Opcion consulta sencilla con Union (2 tablas) concatenando los nombres
select concat(NAME, ' ',SURNAME) AS "nombres completos", count(t.id) as total_transaccions   
from users as u
inner join transactions as t ON u.id = t.user_id
group by u.id, u.name, u.surname
having  count(t.id) >30;
-- -----------------------------------------------------

-- Opcion con subconsulta dentro de INNER JOIN
SELECT u.name, u.surname, total_transactions
FROM users AS u
INNER JOIN (
  SELECT user_id, COUNT(*) AS total_transactions
  FROM transactions
  GROUP BY user_id
  HAVING COUNT(*) > 30
) AS t ON u.id = t.user_id;
-- -----------------------------------------------------

-- Opcion con subconsulta con INNER JOIN y con alias 'nombres completos'
select concat(NAME, ' ', SURNAME) AS "nombres completos", total_transacciones
from users as u
inner join (
select user_id, count(*) as total_transacciones
from transactions 
group by user_id
having count(*) >30
) t ON u.id = t.user_id;
-- -----------------------------------------------------

-- Opcion con subconsulta con INNER JOIN, con alias 'nombres completos' y el monto total de giro en 2 decimales 'format'
select concat(u.NAME, ' ',u.SURNAME) AS "nombres completos", total_transacciones, monto_total 
from users as u
inner join (
select user_id, count(*) as total_transacciones, format(SUM(t.amount), 'f2') as monto_total
from transactions as t
group by user_id
having count(*) >30
) as t ON u.id = t.user_id;
 
/*- EJERCICIO 2_____________________________________________________________________
/*Muestra el promedio de la suma de transacciones por IBAN de las tarjetas de crédito
en la compañía Donec Ltd. utilizando al menos 2 tablas.*/

SELECT co.company_name, AVG(t.amount) AS promedio_suma_transacciones, cc.iban  -- funciona
FROM companies co
inner join transactions t on co.company_id = t.business_id
inner join credit_cards cc on t.card_id = cc.id
WHERE co.company_name = 'Donec Ltd'
GROUP BY co.company_name, cc.iban;


-- ======================= NIVEL 2 =======================

/*Crea una nueva tabla que refleje el estado de las tarjetas de 
crédito basado en si las últimas tres transacciones fueron declinadas 
y genera la siguiente consulta:*/

-- se crea una nueva tabla
CREATE TABLE card_status (
  id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
  card_id VARCHAR(20) NOT NULL,
  status VARCHAR(10) NOT NULL DEFAULT 'active',
  KEY idx_id2 (id),
  CONSTRAINT fk_card_reference FOREIGN KEY (card_id) REFERENCES credit_cards (id)  -- Renamed constraint name
);

INSERT INTO card_status (card_id, status)
SELECT
  t.card_id,
  CASE
    WHEN COUNT(t2.id) >= 3 THEN 'declined'
    ELSE 'active'
  END AS status
FROM transactions t
INNER JOIN transactions t2 ON t.card_id = t2.card_id
WHERE t.timestamp >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
GROUP BY t.card_id;

SELECT cs.id, cc.pan, cs.status
FROM card_status cs
INNER JOIN credit_cards cc ON cs.card_id = cc.id;

/* Ejercicio 1_____________________________________________________________________
/*¿Cuántas tarjetas están activas?*/
select *
from credit_cards
where expiring_date > DATE_FORMAT(CURRENT_DATE,'%m/%d/%Y');

SELECT *
FROM credit_cards
WHERE expiring_date > DATE_FORMAT(CURRENT_DATE, '%m/%d/%4');

SELECT *
FROM credit_cards
WHERE expiring_date > (CURRENT_DATE, '%m/%d/%Y');


-- ======================= NIVEL 3 =======================

/*Ejercicio 1_____________________________________________________________________
/*Necesitamos conocer el número de veces que se ha vendido cada producto.*/

/*Despues de crear tabla intermedia 'transactions_products_1' con sus respectivas vinculaciones
foraneas e indexaciones, hacemos la importacion de datos 
procedemos a INDEXAR*/

CREATE TABLE transactions_products_2 (
  id varchar(255) DEFAULT NULL,
  product_ids int DEFAULT NULL,
  KEY idx_id1 (id),
  KEY idx_id2 (product_ids),
  CONSTRAINT product_ids FOREIGN KEY (product_ids) REFERENCES products (id),
  CONSTRAINT id FOREIGN KEY (id) REFERENCES transactions (id)
);
select * from transactions_products;       -- visualizamos la nueva tabla
SHOW CREATE TABLE transactions_products_1; -- verificamos codigo

/* consulta usando la tabla products y la tabla intermedia transactions_products*/
select DISTINCT product_name, count(product_ids) as cantidad_ventas
from products p
inner join transactions_products tp on p.id = tp.product_ids
group by product_name
order by cantidad_ventas desc;

/* consulta usando la tabla products y la tabla intermedia transactions_products*/
select DISTINCT product_name, count(tp.id) as cantidad_ventas
from products p
inner join transactions_products tp on p.id = tp.product_ids
group by product_name
order by cantidad_ventas desc;
/*NOTA: surge ciertas dudas que bajo el nombre de 1 producto se encuentre varias versiones de
producto según otras caracteristicas*/

/* En esta consulta intentamos cubrir la sospecha de que existan bajo un mismo nombre varios tipos de producto
ya sea por tamaño color, por alguna razon lo evidencia en warehouse, de este forma asegurandonos usamos
DISTINCT y lo agrupamos por id*/
select distinct p.id, count(product_ids) as conteo_ventas
from transactions_products as tp
inner join products as p ON tP.product_ids = p.id
group by p.id
order by p.id asc;

/*Ahora solo agregamos el nombre para conocer a pesar que se repita, pero se diferencia por el id segun su tipología*/
select distinct p.id, p.product_name, count(tp.id) as cantidad_ventas
from products p
inner join transactions_products tp on p.id = tp.product_ids
group by id
order by id asc;


-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<







	
-- >>>>>>>>>>>>>>>>>>>> S P R I N T  3 <<<<<<<<<<<<<<<<<<<<<<

-- ======================= NIVEL 1 =======================

-- se usa la base de datos "transactions"

/*- EJERCICIO 1_____________________________________________________________________
Tu tarea es diseñar y crear una tabla llamada "credit_card" que almacene detalles 
cruciales sobre las tarjetas de crédito. La nueva tabla debe ser capaz de identificar 
de forma única cada tarjeta y establecer una relación adecuada con las otras dos tablas
 ("transaction" y "company"). Después de crear la tabla será necesario que ingreses la 
 información del documento denominado "datos_introducir_credit". Recuerda mostrar el 
 diagrama y realizar una breve descripción del mismo.*/
 
/*Análisis de relaciones:
La tabla "credit_card" tiene una relación de uno a muchos con la tabla "transaction".
Una tarjeta puede tener múltiples transacciones, pero una transacción solo puede estar asociada a una tarjeta.
La tabla "credit_card" tiene una relación de uno a muchos con la tabla "compañero".
Una tarjeta puede estar asociada a un solo compañero, pero un compañero puede tener múltiples tarjetas.*/

CREATE TABLE credit_card (
	id VARCHAR(255) PRIMARY KEY,
	iban VARCHAR(45),
	pan VARCHAR(45),
	pin CHAR(4),
	cvv VARCHAR(3),
	expiring_date VARCHAR(45)
);

CREATE INDEX credit_card_id_idx
	ON transaction(credit_card_id);
ALTER TABLE credit_card
	ADD FOREIGN KEY (id) REFERENCES transaction (credit_card_id);
    
/* Por temas de compatibilidad de tipo de dedato en la tabla, modificamos expiring_date a varchar
para lograr con el objetivo de importar sin problemas*/

CREATE TABLE transaction (
	id VARCHAR(255) PRIMARY KEY,
	credit_card_id VARCHAR(255),
	company_id VARCHAR(255),
	user_id INT,
	lat DECIMAL(10,6),
	longitud DECIMAL(10,6),
	amount DECIMAL(10,2) NOT NULL,
	declined TINYINT(1) NOT NULL DEFAULT 0
);
    
ALTER TABLE transaction
	ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card (id),
    ADD FOREIGN KEY (user_id) REFERENCES user (id);


/*- Ejercicio 2_____________________________________________________________________
El departamento de Recursos Humanos ha identificado un error en el número de cuenta del usuario
con ID CcU-2938. La información que debe mostrarse para este registro 
es: R323456312213576817699999. Recuerda mostrar que el cambio se realizó.*/
-- Hacemos una consulta para visualizar el IBAN
SELECT *
FROM credit_card
WHERE id= "CcU-2938";

-- Modificamos el registro solicitado
UPDATE credit_card
SET iban = 'R323456312213576817699999'
WHERE id = 'CcU-2938';


/*- Ejercicio 3_____________________________________________________________________
En la tabla "transaction" ingresa un nuevo usuario con la siguiente información:
	- Id: 108B1D1D-5B23-A76C-55EF-C568E49A99DD
	- credit_card_id: CcU-9999
	- company_id:	b-9999
	- user_id: 9999
	- lat: 829.999
	- longitud: -117.999
	- amount:	111.11
	- declined: 0
*/
INSERT INTO credit_card (id) value ("CcU-9999");

SELECT*
FROM credit_card 
WHERE id= "CcU-9999";

DELETE FROM credit_card
	WHERE id= "CcU-9999";

INSERT INTO company (id) value ('b-9999');

SELECT * 
FROM company 
WHERE id= 'b-9999';

DELETE FROM company
	WHERE id= 'b-9999';

INSERT INTO user (id) value ('9999');
SELECT * 
FROM user
WHERE id= '9999';

INSERT INTO transaction (id,credit_card_id,company_id,user_id,lat,longitude,amount,declined) 
value ('108B1D1D-5B23-A76C-55EF-C568E49A99DD','CcU-9999','b-9999','9999','829.999','-117.999','111.11','0');

/*ADVERTENCIA:
Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails
(`transactions`.`transaction`, CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`id`))*/

SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO credit_card(id)
VALUES ('CcU-9999'); 

SELECT *
FROM transaction
WHERE credit_card_id = 'CcU-9999';


/*- Ejercicio 4_____________________________________________________________________
Desde recursos humanos te solicitan eliminar la columna "pan" de la tabla credit_card.
Recuerda mostrar el cambio realizado.*/

ALTER TABLE credit_card
DROP COLUMN pan;

SELECT * 
FROM credit_card;

-- ======================= NIVEL 2 =======================

/* Ejercicio 1_____________________________________________________________________
Elimina de la tabla transacción el registro con ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de datos.*/
DELETE FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

SELECT *
FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';


/*Ejercicio 2_____________________________________________________________________
La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias
efectivas. Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus
transacciones. Será necesaria que crees una vista llamada VistaMarketing que contenga la siguiente
información: Nombre de la compañía. Teléfono de contacto. País de residencia. Media de compra realizado
por cada compañía. 
Presenta la vista creada, ordenando los datos de mayor a menor promedio de compra.*/
CREATE VIEW VistaMarketing AS
SELECT company_name,
    phone,
    country,
    promedioCompra pt
FROM company c
JOIN (
	SELECT company_id,
		AVG(amount) AS promedioCompra
	FROM transaction t
	GROUP BY company_id) AS promedio_transaction ON c.id = promedio_transaction.company_id;
    
    
SELECT*
FROM VistaMarketing
ORDER BY PromedioCompra DESC;
-- ---------------------------------------

CREATE VIEW VistaMarketing AS
SELECT company_name AS nombre_compañia,
    phone AS telefono,
    country AS pais_sede,
    ROUND(AVG(amount),2) AS promedioCompra
FROM company c
JOIN transaction t ON c.id = t.company_id
GROUP BY company_id;

SELECT *                   
FROM VistaMarketing
ORDER BY PromedioCompra DESC;

/*Ejercicio 3_____________________________________________________________________
Filtra la vista VistaMarketing para mostrar sólo las compañías que tienen su país de residencia en "Germany"*/
SELECT *                    -- hacemos la impresión de prueba
FROM VistaMarketing
WHERE pais_sede = 'Germany';

SELECT nombre_compañia, pais_sede   -- limpiamos la tabla conforme el pedido, impresión final
FROM VistaMarketing
WHERE pais_sede = 'Germany';


-- ======================= NIVEL 3 =======================

/*Ejercicio 1_____________________________________________________________________
La próxima semana tendrás una nueva reunión con los gerentes de marketing.
Un compañero de tu equipo realizó modificaciones en la base de datos, pero no recuerda cómo las realizó.
Te pide que le ayudes a dejar los comandos ejecutados para obtener el siguiente diagrama:*/

/*Recordatorio
En esta actividad, es necesario que describas el "paso a paso" de las tareas realizadas.
Es importante realizar descripciones sencillas, simples y fáciles de comprender.
Para realizar esta actividad deberás trabajar con los archivos denominados
 "estructura_datos_user" y "datos_introducir_user"*/

-- LISTA DE PASOS PARA LOGRAR EL ESQUEMA INDICADO
-- Creamos la tabla user con sus foreign key y ejecutamos un index con la tabla transaction
-- para agilitar el proceso de datos a posterior
-- A posterior se importan los datos del archivo 'datos_introducir_user'
CREATE INDEX idx_user_id ON transaction(user_id);
 
CREATE TABLE IF NOT EXISTS user (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255),
        FOREIGN KEY(id) REFERENCES transaction(user_id)        
    );
    
-- En la tabla Credit_card se crea una nueva columna fecha_actual con un tipo de dato DATE
ALTER TABLE credit_card
ADD fecha_actual DATE;

-- En la tabla Company se elimina el campo website.
ALTER TABLE company
DROP COLUMN website;

-- En la tabla user, se cambia el campo o columna email a personal_email.
ALTER TABLE user
RENAME COLUMN email TO personal_email;

-- En la tabla credit_card cambiamos el tipo de datos de los campos:
-- id a VARCHAR(20)
-- iban VARCHAR(45)
-- pin VARCHAR(4)
-- cvv INT
-- expire_date VARCHAR(10)
-- Creamos el foreign key para cambiar la relación con la tabla transaction

ALTER TABLE credit_card
CHANGE COLUMN id id VARCHAR(20) not null,
CHANGE COLUMN iban iban VARCHAR(45) null default null,
CHANGE COLUMN pin pin VARCHAR(4) null default null,
CHANGE COLUMN cvv cvv int null default null,
CHANGE COLUMN expiring_date expiring_date VARCHAR(10) null default null;

ALTER TABLE transactions.credit_card
ADD CONSTRAINT card_transaction
FOREIGN KEY (id) REFERENCES transactions.transaction (credit_card_id)
ON DELETE RESTRICT -- evita eliminar una tarjeta de crédito en futuras operaciones
ON UPDATE CASCADE; -- actualiza el ID de la tarjeta de crédito entre la tabla transaction y la tabla credit_card

/*Ejercicio 2_____________________________________________________________________
La empresa también te solicita crear una vista llamada "InformeTecnico" que contenga
la siguiente información:
- ID de la transacción
- Nombre del usuario/a
Apellido del usuario/a
IBAN de la tarjeta de crédito usada.
Nombre de la compañía de la transacción realizada.
Asegúrate de incluir información relevante de ambas tablas y utiliza alias para cambiar de nombre columnas según sea necesario.
Muestra los resultados de la vista, ordena los resultados de forma descendente en función de la variable ID de transacción.*/

CREATE VIEW InformeTecnico AS
SELECT transaction.id AS ID_Transaccion,
		CONCAT(user.name, " ", surname) AS 'Nombres completos',
		credit_card.iban AS 'Numero Tarjeta',
		transaction.amount AS 'Monto transaccion',
		transaction.timestamp AS Fecha,
		transaction.declined AS Estado,
		company.company_name AS 'Nombre Compañia',
		company.country AS 'Pais sede Compañia'
FROM transaction
LEFT JOIN user ON transaction.user_id = user.id
RIGHT JOIN credit_card ON transaction.credit_card_id = credit_card.id
LEFT JOIN company ON transaction.company_id = company.id;


SELECT *
FROM InformeTecnico
ORDER BY ID_Transaccion DESC;

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


	
-- >>>>>>>>>>>>>>>>>>>> S P R I N T  3 <<<<<<<<<<<<<<<<<<<<<<

-- ======================= NIVEL 1 =======================
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

create table credit_card (
id VARCHAR(255) PRIMARY KEY,
iban VARCHAR(45) null,
pan VARCHAR(45) null,
pin CHAR(4) null,
cvv varchar(3) null,
expiring_date varchar(45) null
);

CREATE TABLE transaction (
id VARCHAR(255) PRIMARY KEY,
credit_card_id VARCHAR(255) NULL,
company_id VARCHAR(255) NULL,
user_id INT NULL,
lat DECIMAL(10,6) NULL,
longitud DECIMAL(10,6) NULL,
amount DECIMAL(10,2) NOT NULL,
declined TINYINT(1) NOT NULL DEFAULT 0,
FOREIGN KEY (credit_card_id) REFERENCES credit_card (id) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (user_id) REFERENCES user (id)ON DELETE RESTRICT ON UPDATE CASCADE);

/*- Ejercicio 2_____________________________________________________________________
El departamento de Recursos Humanos ha identificado un error en el número de cuenta del usuario
con ID CcU-2938. La información que debe mostrarse para este registro 
es: R323456312213576817699999. Recuerda mostrar que el cambio se realizó.*/
-- Hacemos una consulta para visualizar el IBAN
SELECT * FROM credit_card
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
INSERT into credit_card (id) value ("CcU-9999");
select * from credit_card where id= "CcU-9999";
DELETE FROM credit_card WHERE id= "CcU-9999";

INSERT into company (id) value ('b-9999');
select * from company where id= 'b-9999';
DELETE FROM company WHERE id= 'b-9999';

INSERT into user (id) value ('9999');
select * from user where id= '9999';

INSERT into transaction (id,credit_card_id,company_id,user_id,lat,longitud,amount,declined) 
value ('108B1D1D-5B23-A76C-55EF-C568E49A99DD','CcU-9999','b-9999','9999','829.999','-117.999','111.11','0');
select * from transaction;


/*- Ejercicio 4_____________________________________________________________________
Desde recursos humanos te solicitan eliminar la columna "pan" de la tabla credit_card.
Recuerda mostrar el cambio realizado.*/

alter table credit_card
drop column pan;
select * from credit_card;

-- ======================= NIVEL 2 =======================

/* Ejercicio 1_____________________________________________________________________
Elimina de la tabla transacción el registro con ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de datos.*/
DELETE FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

select * from transaction
where id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';


/*Ejercicio 2_____________________________________________________________________
La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias
efectivas. Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus
transacciones. Será necesaria que crees una vista llamada VistaMarketing que contenga la siguiente
información: Nombre de la compañía. Teléfono de contacto. País de residencia. Media de compra realizado
por cada compañía. 
Presenta la vista creada, ordenando los datos de mayor a menor promedio de compra.*/
CREATE VIEW VistaMarketing_1 AS
SELECT company_name, phone, country, promedioCompra pt
FROM company c
JOIN (select company_id, avg(amount) as promedioCompra
from transaction  t
group by company_id) as promedio_transaction ON c.id = promedio_transaction.company_id
ORDER BY PromedioCompra DESC;


/*Ejercicio 3_____________________________________________________________________
Filtra la vista VistaMarketing para mostrar sólo las compañías que tienen su país de residencia en "Germany"*/
SELECT *
FROM vistamarketing_1
WHERE country = 'Germany';

SELECT company_name, country
FROM vistamarketing_1
WHERE country = 'Germany';


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
alter table credit_card
add fecha_actual date;

-- En la tabla Company se elimina el campo website.
alter table company
drop column website;

-- En la tabla user, se cambia el campo o columna email a personal_email.
alter table user
rename column email to personal_email;

-- En la tabla credit_card cambiamos el tipo de datos de los campos:
-- id a VARCHAR(20)
-- iban VARCHAR(50)
-- pin VARCHAR(4)
-- cvv INT
-- expire_date VARCHAR(10)
-- Creamos el foreign key para cambiar la relación con la tabla transaction

alter table credit_card
change column id id VARCHAR(20) not null,
change column iban iban VARCHAR(50) null default null,
change column pin pin VARCHAR(4) null default null,
change column cvv cvv int null default null,
change column expiring_date expiring_date VARCHAR(10) null default null;

alter table transactions.credit_card
ADD CONSTRAINT card_transaction
foreign key (id) references transactions.transaction (credit_card_id)
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
SELECT t.id as id_transaction , name as nombre, surname as apellido, iban, company_name
FROM transaction t
INNER JOIN user ON t.user_id = user.id
INNER JOIN company ON t.company_id = company.id
INNER JOIN credit_card y ON t.company_id = company.id
ORDER BY id_transaction desc;

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


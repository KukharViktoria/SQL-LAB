
DROP DATABASE IF EXISTS `company`;
CREATE DATABASE `company`;
USE `company`;

-- departments
CREATE TABLE IF NOT EXISTS department (
  department_id INT NOT NULL AUTO_INCREMENT,
  department_name VARCHAR(30) NOT NULL UNIQUE,
  city VARCHAR(30) NOT NULL DEFAULT 'Lviv',
  street VARCHAR(50),                   -- зроблено NULL, бо в даних є NULL
  building_no INT,                      -- display width опущено
  PRIMARY KEY (department_id)
);

-- employee
CREATE TABLE IF NOT EXISTS employee (
  employee_id INT NOT NULL AUTO_INCREMENT,
  user_name VARCHAR(50) NOT NULL UNIQUE,
  first_name VARCHAR(30) NOT NULL,
  last_name VARCHAR(30) NOT NULL,
  position VARCHAR(50),
  employment_date DATE,
  department_id INT,          -- зробив NULL дозволеним (в даних є NULL)
  manager_id INT,
  rate DECIMAL(10,2) NOT NULL,
  bonus DECIMAL(10,2),
  PRIMARY KEY (employee_id)
);

-- customer
CREATE TABLE IF NOT EXISTS customer (
  customer_id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(30) NOT NULL,
  last_name VARCHAR(30) NOT NULL,
  gender CHAR(1),
  birth_date DATE,
  phone_number VARCHAR(20) UNIQUE,  -- VARCHAR щоб приймати формат з дефісами
  email VARCHAR(100) UNIQUE,
  discount INT,
  PRIMARY KEY (customer_id)
);

-- product
CREATE TABLE IF NOT EXISTS product (
  product_id INT NOT NULL AUTO_INCREMENT,
  product_name VARCHAR(100) NOT NULL,
  product_description VARCHAR(255),
  category VARCHAR(50),
  manufacture VARCHAR(50),
  product_type VARCHAR(50),
  amount INT,
  price DECIMAL(10,2),
  PRIMARY KEY (product_id)
);


CREATE TABLE IF NOT EXISTS invoice (
  invoice_id BIGINT NOT NULL,         
  employee_id INT,                      
  customer_id INT,                    
  payment_method TINYINT,
  transaction_moment DATETIME,
  `status` varchar(10) NOT NULL,
  PRIMARY KEY (invoice_id)
);


CREATE TABLE IF NOT EXISTS orders (
  orders_id INT NOT NULL AUTO_INCREMENT,
  invoice_id BIGINT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  order_datetime DATETIME NOT NULL,   
  PRIMARY KEY (orders_id)
);


ALTER TABLE employee
  ADD CONSTRAINT fk_employee_department FOREIGN KEY (department_id) REFERENCES department(department_id),
  ADD CONSTRAINT fk_employee_manager FOREIGN KEY (manager_id) REFERENCES employee(employee_id);

ALTER TABLE invoice
  ADD CONSTRAINT fk_invoice_employee FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
  ADD CONSTRAINT fk_invoice_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id);

ALTER TABLE orders
  ADD CONSTRAINT fk_orders_invoice FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
  ADD CONSTRAINT fk_orders_product FOREIGN KEY (product_id) REFERENCES product(product_id);

SELECT * FROM department;
SELECT * FROM employee; 
SELECT * FROM customer ;
SELECT * FROM product ;
SELECT * FROM invoice;
SELECT * FROM orders ;
  
USE company ;
SELECT *
FROM customer 
ORDER BY last_name  ;

select distinct
manufacture
from product 
order by manufacture ASC;

SELECT product_name,  manufacture, category ,product_type,  price 
FROM product
WHERE manufacture = 'DELL'
ORDER BY product_name ASC;

SELECT first_name ,last_name ,gender ,birth_date, phone_number
FROM customer 
WHERE gender= 'F' 
AND birth_date between'1989-12-31'AND '2000-12-31'
ORDER BY last_name ASC;

SELECT * 
FROM product
WHERE category = 'NOTEBOOK'
    AND product_description LIKE '%512GB%'
    AND amount > 0;
SELECT *
FROM product
WHERE
    amount > 0
    AND category IN ('NOTEBOOK', 'Desktops')
    AND (product_description LIKE '%512GB%' OR product_description LIKE '%1 TB%');
    
    SELECT *
FROM invoice
WHERE customer_id IS NULL;



USE  company ;
-- 1 завдання 
	SELECT
  o.orders_id AS 'Orders ID',
  p.product_name AS 'Product name',
  p.category AS 'Product category',
  i.invoice_id AS 'Invoice ID',
  i.transaction_moment AS 'Transaction moment',
  c.last_name AS 'Customer last name',
  c.first_name AS 'Customer first name'
FROM
  orders o
JOIN
  product p ON o.product_id = p.product_id
JOIN
  invoice i ON o.invoice_id = i.invoice_id
LEFT JOIN 
  customer c ON i.customer_id = c.customer_id
ORDER BY
  o.orders_id;
  
  -- 2 завдння 
SELECT
    o.orders_id AS 'Orders ID',
    p.product_name AS 'Product name',
    p.category AS 'Product category',
    i.invoice_id AS 'Invoice ID',
    i.transaction_moment AS 'Transaction moment',
    e.last_name AS 'Employee last name',
    e.first_name AS 'Employee first name'
FROM
    orders o
JOIN
    product p ON o.product_id = p.product_id
JOIN
    invoice i ON o.invoice_id = i.invoice_id
JOIN
    employee e ON i.employee_id = e.employee_id
JOIN
    department d ON e.department_id = d.department_id
WHERE
    d.department_name = 'Mercury'
    AND o.order_datetime >= '2023-07-01 00:00:00'
    AND o.order_datetime <= '2023-10-01 23:59:59'
ORDER BY `Orders ID`;  
  
  -- 3 завдання 
  SELECT
    c.customer_id AS 'Customer ID',
    c.last_name AS 'Last Name',
    c.first_name AS 'First Name',
    i.invoice_id AS 'Invoice ID',
    i.transaction_moment AS 'Transaction Moment'
FROM
    customer c
LEFT JOIN
    invoice i ON c.customer_id = i.customer_id
UNION
SELECT
    c.customer_id AS 'Customer ID',
    c.last_name AS 'Last Name',
    c.first_name AS 'First Name',
    i.invoice_id AS 'Invoice ID',
    i.transaction_moment AS 'Transaction Moment'
FROM
    customer c
RIGHT JOIN
    invoice i ON c.customer_id = i.customer_id
ORDER BY `Invoice ID`;

USE company;

-- лб 6 завдання 1
SELECT 
LPAD (product_id,4,'0') as 'Product ID',
concat(manufacture,' :: ',TRIM(SUBSTRING_INDEX(product_name, '/', 1))) as 'Product Name',
concat(UPPER(product_type),' - ',UPPER(category)) as 'Category'
FROM 
product
ORDER BY 
manufacture;

-- лб 6 завдання 2
SELECT
  LPAD(MONTH(i.transaction_moment), 2, '0') AS 'Month',
  SUM(o.quantity * p.price) AS 'Total revenue',
  CONCAT('Quater ', QUARTER(i.transaction_moment), ' - ', YEAR(i.transaction_moment)) AS 'Sales Period'
FROM
  invoice i
JOIN
  orders o ON i.invoice_id = o.invoice_id
JOIN
  product p ON o.product_id = p.product_id
GROUP BY
  YEAR(i.transaction_moment),       
  MONTH(i.transaction_moment),     
  LPAD(MONTH(i.transaction_moment), 2, '0'), 
  CONCAT('Quater ', QUARTER(i.transaction_moment), ' - ', YEAR(i.transaction_moment)) 
ORDER BY
  YEAR(i.transaction_moment),
  MONTH(i.transaction_moment);
  

-- лб 6 завдання 3 
-- 1 
SELECT 
p.product_id as 'Product ID',
p.product_name as 'Product name',
 p.price as 'Product price',
SUM(o.quantity) as 'Product Quantity',
SUM(o.quantity * p.price) as 'Total Amount'
FROM
product p
JOIN 
orders o 
on p.product_id = o.product_id
GROUP BY 
p.product_id, p.product_name, p.price
HAVING
    SUM(o.quantity * p.price) > 50000
ORDER BY 
'Total Amount' DESC;

-- 2 
SELECT
    LPAD(c.customer_id, 3, '0') AS "Customer ID",
    c.last_name AS "Customer last name",
    c.first_name AS "Customer first name",
 SUM(o.quantity * p.price) AS "Total Amount"
FROM
    customer c
JOIN
    invoice i
    ON c.customer_id = i.customer_id
JOIN
    orders o
    ON o.invoice_id = i.invoice_id
JOIN
    product p
    ON o.product_id = p.product_id
GROUP BY
    c.customer_id,
    c.last_name,
    c.first_name
ORDER BY
 SUM(o.quantity * p.price) DESC  
LIMIT 10;

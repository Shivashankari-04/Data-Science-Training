create database supply_chain_db;
use supply_chain_db;

create table suppliers( 
supplier_id int auto_increment primary key, 
name varchar(50) not null, 
email varchar(100) not null, 
phone varchar(15), 
location varchar(100)
);
INSERT INTO suppliers (name, email, phone, location) VALUES
('Alpha Supplies', 'alpha@supplies.com', '9876543210', 'Chennai'),
('Beta Traders', 'beta@traders.com', '9123456780', 'Mumbai'),
('Gamma Distributors', 'gamma@distributors.com', '9000001111', 'Delhi');


create table inventory(
inventory_id int auto_increment primary key,
product_name varchar(100) not null,
quantity int,
reorder_level int,
supplier_id int,
foreign key (supplier_id) references suppliers(supplier_id)
on update cascade
on delete set null
);
INSERT INTO inventory (product_name, quantity, reorder_level, supplier_id) VALUES
('Laptop Battery', 50, 20, 1),
('Keyboard', 15, 10, 2),
('HDMI Cable', 5, 10, 2),
('Monitor', 25, 15, 3),
('Wireless Mouse', 8, 10, 1);


CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  supplier_id INT NOT NULL,
  inventory_id INT NOT NULL,
  order_date DATE NOT NULL,
  delivery_date DATE,
  status VARCHAR(50) DEFAULT 'Pending',
  quantity INT NOT NULL,
  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);
INSERT INTO orders (supplier_id, inventory_id, order_date, delivery_date, status, quantity) VALUES
(1, 1, '2025-07-01', '2025-07-03', 'Delivered', 30),
(2, 2, '2025-07-05', NULL, 'Pending', 10),
(2, 3, '2025-07-06', '2025-07-09', 'Delivered', 20),
(3, 4, '2025-07-10', NULL, 'Shipped', 5),
(1, 5, '2025-07-12', NULL, 'Pending', 12);


--- Basic CRUD Operations
select * from suppliers;
select * from inventory;
select * from orders;

update suppliers set location= 'Bangalore' where supplier_id=2;

select supplier_id, name, email, location from suppliers
where location IN ('Chennai', 'Mumbai');

update orders
set status = 'Delivered',
    delivery_date = CURDATE()
WHERE order_id = 2;

SELECT COUNT(*) AS total_suppliers
FROM suppliers;

SELECT product_name, quantity, reorder_level
FROM inventory
WHERE quantity < reorder_level;

SELECT order_id, inventory_id, status
FROM orders
WHERE status = 'Pending';


--- Stored procedures
--- 1. Auto reorder trigger

DELIMITER //

CREATE PROCEDURE auto_reorder()
BEGIN
  INSERT INTO orders (supplier_id, inventory_id, order_date, status, quantity)
  SELECT 
    i.supplier_id,
    i.inventory_id,
    CURDATE(),
    'Pending',
    i.reorder_level * 2
  FROM inventory i
  WHERE i.quantity < i.reorder_level;
END //

DELIMITER ;

CALL auto_reorder;
SELECT * FROM orders;


--- 2. get inevntory status
DELIMITER //

CREATE PROCEDURE get_inventory_status()
BEGIN
  SELECT 
    product_name,
    quantity,
    reorder_level,
    CASE
      WHEN quantity < reorder_level THEN 'LOW STOCK'
      ELSE 'OK'
    END AS stock_status
  FROM inventory;
END //

DELIMITER ;

CALL get_inventory_status();





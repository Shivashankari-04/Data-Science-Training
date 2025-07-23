create database customer_order;
use customer_order;


create table customers (
  customer_id int primary key auto_increment,
  name varchar(100),
  email varchar(100),
  phone varchar(15),
  region varchar(50)
);
insert into customers (name, email, phone, region) values
('rahul kumar', 'rahul@example.com', '9876543210', 'north'),
('anita sharma', 'anita@example.com', '9123456780', 'south'),
('vijay rao', 'vijay@example.com', '9988776655', 'east'),
('swathi menon', 'swathi@example.com', '9090909090', 'west'),
('arjun das', 'arjun@example.com', '9012345678', 'central');


create table orders (
  order_id int primary key auto_increment,
  customer_id int,
  order_date date,
  delivery_date date,
  status varchar(50),
  foreign key (customer_id) references customers(customer_id)
);
insert into orders (customer_id, order_date, delivery_date, status) values
(1, '2024-07-01', '2024-07-03', 'delivered'),
(2, '2024-07-05', '2024-07-08', 'delivered'),
(3, '2024-07-10', '2024-07-12', 'pending'),      
(4, '2024-07-12', '2024-07-15', 'shipped'),
(1, '2024-07-18', '2024-07-20', 'pending');      


create table delivery_status (
  delivery_id int primary key auto_increment,
  order_id int,
  current_status varchar(50),
  last_updated datetime,
  foreign key (order_id) references orders(order_id)
);
insert into delivery_status (order_id, current_status, last_updated) values
(1, 'delivered', '2024-07-03 10:00:00'),
(2, 'delivered', '2024-07-08 15:30:00'),
(3, 'in transit', '2024-07-20 11:45:00'),
(4, 'shipped', '2024-07-21 09:00:00'),
(5, 'pending', '2024-07-23 08:00:00');


-- Basic CRUD operations
select * from customers;
select * from orders;
select * from delivery_status;

select * from orders where status in ('pending', 'delayed');

update orders
set status = 'delayed'
where delivery_date < curdate()
  and status in ('pending', 'shipped');

update delivery_status
set current_status = 'out for delivery'
where order_id = 4;

select * from customers where name like 'a%';

select * from orders
where order_date between '2024-07-01' and '2024-07-10';


--- Stored Procedure to fetch all delayed deliveries for a specific customer.

delimiter //

create procedure get_delayed_deliveries(in cust_id int)
begin
  select order_id, delivery_date, status
  from orders
  where customer_id = cust_id
    and delivery_date < curdate()
    and status != 'delivered';
end //

delimiter ;


call get_delayed_deliveries(1);




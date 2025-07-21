create database assignment_3;
use assignment_3;

create table books (
  book_id int primary key,
  title varchar(100),
  author varchar(100),
  genre varchar(50),
  price decimal(8,2)
);
insert into books values
(1, 'Python Basics', 'John Doe', 'Programming', 600.00),
(2, 'Data Science 101', 'Jane Smith', 'Data', 750.00),
(3, 'Fictional Minds', 'A. Writer', 'Fiction', 450.00),
(4, 'Hyderabad Diaries', 'S. Rao', 'Travel', 500.00),
(5, 'SQL Guide', 'M. Kumar', 'Programming', 550.00);

create table customers (
  customer_id int primary key,
  name varchar(100),
  email varchar(100),
  city varchar(50)
);
insert into customers values
(1, 'Amit Sharma', 'amit@gmail.com', 'Delhi'),
(2, 'Neha Reddy', 'neha@gmail.com', 'Hyderabad'),
(3, 'Faizan Ali', 'faizan@gmail.com', 'Mumbai'),
(4, 'Divya Mehta', 'divya@gmail.com', 'Hyderabad'),
(5, 'Ravi Verma', 'ravi@gmail.com', 'Chennai');


create table orders (
  order_id int primary key,
  customer_id int,
  book_id int,
  order_date date,
  quantity int,
  foreign key (customer_id) references customers(customer_id),
  foreign key (book_id) references books(book_id)
);
insert into orders values
(1, 1, 1, '2023-01-10', 1),
(2, 2, 2, '2023-02-15', 2),
(3, 3, 3, '2023-03-01', 1),
(4, 4, 4, '2023-03-25', 3),
(5, 2, 1, '2023-04-01', 1),
(6, 5, 5, '2023-04-05', 2),
(7, 1, 2, '2023-05-10', 1);
insert into books values
(6, 'Untouched Title', 'Unknown Author', 'History', 480.00);


 -- 1. List all books with price above 500.
 select * from books where price > 500;

 -- 2. Show all customers from the city of ‘Hyderabad’.
 select * from customers where city = 'Hyderabad';

 -- 3. Find all orders placed after ‘2023-01-01’.
 select * from orders where order_date > '2023-01-01';

 -- Joins & Aggregations
 -- 4. Show customer names along with book titles they purchased.
select c.name, b.title
from orders o
join customers c on o.customer_id = c.customer_id
join books b on o.book_id = b.book_id;

-- 5. List each genre and total number of books sold in that genre.
select b.genre, sum(o.quantity) as total_sold 
from orders o
join books b on o.book_id = b.book_id
group by b.genre;

 -- 6. Find the total sales amount (price × quantity) for each book.
 select b.title, sum(b.price * o.quantity) as total_sales
from orders o
join books b 
on o.book_id = b.book_id
group by b.title;

 -- 7. Show the customer who placed the highest number of orders.
select c.name, count(o.order_id) as total_orders
from customers c
join orders o on c.customer_id = o.customer_id
group by c.name
order by total_orders desc
limit 1;

 -- 8. Display average price of books by genre.
 select genre, avg(price) as avg_price from books
group by genre;

 -- 9. List all books that have not been ordered.
 select * from books
where book_id not in (select distinct book_id from orders);

 -- 10. Show the name of the customer who has spent the most in total
select c.name, sum(b.price * o.quantity) as total_spent
from customers c
join orders o on c.customer_id = o.customer_id
join books b on o.book_id = b.book_id
group by c.name
order by total_spent desc
limit 1;



create database assignment_4;
use assignment_4;

create table movies (
  movie_id int primary key,
  title varchar(100),
  genre varchar(50),
  release_year int,
  rental_rate decimal(8,2)
);
insert into movies values
(1, 'Inception', 'Sci-Fi', 2010, 100.00),
(2, 'Joker', 'Drama', 2019, 90.00),
(3, 'RRR', 'Action', 2022, 120.00),
(4, 'Interstellar', 'Sci-Fi', 2014, 110.00),
(5, 'Shershaah', 'War', 2021, 80.00);

create table customers (
  customer_id int primary key,
  name varchar(100),
  email varchar(100),
  city varchar(50)
);
insert into customers values
(1, 'Amit Sharma', 'amit@gmail.com', 'Delhi'),
(2, 'Neha Reddy', 'neha@gmail.com', 'Hyderabad'),
(3, 'Faizan Ali', 'faizan@gmail.com', 'Bangalore'),
(4, 'Divya Mehta', 'divya@gmail.com', 'Bangalore'),
(5, 'Ravi Verma', 'ravi@gmail.com', 'Mumbai');
insert into customers values (6, 'Anbu', 'anbu@gmail.com', 'Pune');


create table rentals (
  rental_id int primary key,
  customer_id int,
  movie_id int,
  rental_date date,
  return_date date,
  foreign key (customer_id) references customers(customer_id),
  foreign key (movie_id) references movies(movie_id)
);
insert into rentals values
(1, 1, 1, '2023-01-05', '2023-01-10'), 
(2, 1, 2, '2023-02-10', '2023-02-15'), 
(3, 2, 3, '2023-03-01', '2023-03-07'),  
(4, 3, 2, '2023-03-10', '2023-03-15'),  
(5, 4, 4, '2023-04-01', null), 
(6, 5, 5, '2023-04-10', '2023-04-14'), 
(7, 1, 3, '2023-05-01', '2023-05-06'),
(8, 3, 1, '2023-06-01', null);
-- SECTION 3: Query Execution:
-- BASIC QUERIES
 -- 1. Retrieve all movies rented by a customer named 'Amit Sharma'.
select m.* from movies m
join rentals r on m.movie_id = r.movie_id
join customers c on r.customer_id = c.customer_id
where c.name = 'Amit Sharma';

 -- 2. Show the details of customers from 'Bangalore'.
 select * from customers where city = 'Bangalore';

 -- 3. List all movies released after the year 2020.
 select * from movies where release_year > 2020;

 -- AGGREGATE QUERIES
 -- 4. Count how many movies each customer has rented.
select c.name, count(r.rental_id) as rental_count
from customers c
left join rentals r 
on c.customer_id = r.customer_id
group by c.name;

 -- 5. Find the most rented movie title.
select m.title, count(r.rental_id) as times_rented
from rentals r
join movies m 
on r.movie_id = m.movie_id
group by m.title
order by times_rented desc
limit 1;

 -- 6. Calculate total revenue earned from all rentals.
select sum(m.rental_rate) as total_revenue from rentals r
join movies m 
on r.movie_id = m.movie_id;

 -- ADVANCED QUERIES
 -- 7. List all customers who have never rented a movie.
select c.name
from customers c
left join rentals r 
on c.customer_id = r.customer_id
where r.rental_id is null;

 -- 8. Show each genre and the total revenue from that genre.
select m.genre, sum(m.rental_rate) as genre_revenue
from rentals r
join movies m 
on r.movie_id = m.movie_id
group by m.genre;

 -- 9. Find the customer who spent the most money on rentals.
select c.name, sum(m.rental_rate) as total_spent
from rentals r
join customers c on r.customer_id = c.customer_id
join movies m 
on r.movie_id = m.movie_id
group by c.name
order by total_spent desc
limit 1;

 -- 10. Display movie titles that were rented and not yet returned (NULL )
select m.title
from rentals r
join movies m 
on r.movie_id = m.movie_id
where r.return_date is null;


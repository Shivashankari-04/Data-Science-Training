create database travel_planner;
use travel_planner;


create table destinations (
  destination_id int primary key,
  city varchar(50),
  country varchar(50),
  category varchar(30), 
  avg_cost_per_day decimal(10,2)
);
insert into destinations values
(1, 'goa', 'india', 'beach', 2500.00),
(2, 'agra', 'india', 'historical', 1800.00),
(3, 'bali', 'indonesia', 'beach', 3000.00),
(4, 'paris', 'france', 'historical', 5000.00),
(5, 'queenstown', 'new zealand', 'adventure', 4000.00),
(6, 'kyoto', 'japan', 'nature', 3500.00);


create table trips (
  trip_id int primary key,
  destination_id int,
  traveler_name varchar(50),
  start_date date,
  end_date date,
  budget decimal(10,2),
  foreign key (destination_id) references destinations(destination_id)
);
insert into trips values
(101, 1, 'ravi shah', '2023-12-01', '2023-12-07', 18000.00),
(102, 2, 'meera nair', '2024-01-10', '2024-01-15', 12000.00),
(103, 3, 'arjun verma', '2024-03-05', '2024-03-12', 24000.00),
(104, 4, 'sneha rao', '2024-04-01', '2024-04-08', 36000.00),
(105, 5, 'karan joshi', '2024-06-01', '2024-06-20', 80000.00),
(106, 6, 'zoya khan', '2024-07-01', '2024-07-05', 15000.00),
(107, 1, 'ravi shah', '2024-08-10', '2024-08-14', 10000.00),
(108, 5, 'meera nair', '2024-09-01', '2024-09-11', 45000.00),
(109, 3, 'arjun verma', '2024-10-05', '2024-10-15', 36000.00),
(110, 2, 'john paul', '2022-11-01', '2022-11-05', 7000.00);


-- 1. show all trips to destinations in “india”.
select t.*
from trips t
join destinations d on t.destination_id = d.destination_id
where d.country = 'india';

-- 2. list all destinations with an average cost below 3000.
select * from destinations
where avg_cost_per_day < 3000;

-- 3. calculate the number of days for each trip.
select trip_id, datediff(end_date, start_date) as trip_duration
from trips;

-- 4. list all trips that last more than 7 days.
select *
from trips
where datediff(end_date, start_date) > 7;

-- 5. list traveler name, destination city, and total trip cost (duration × avg_cost_per_day).
select t.traveler_name, d.city, 
       datediff(t.end_date, t.start_date) * d.avg_cost_per_day as total_trip_cost
from trips t
join destinations d on t.destination_id = d.destination_id;

-- 6. find the total number of trips per country.
select d.country, count(*) as total_trips
from trips t
join destinations d on t.destination_id = d.destination_id
group by d.country;

-- 7. show average budget per country.
select d.country, avg(t.budget) as avg_budget
from trips t
join destinations d on t.destination_id = d.destination_id
group by d.country;

-- 8. find which traveler has taken the most trips.
select traveler_name, count(*) as trip_count
from trips
group by traveler_name
order by trip_count desc
limit 1;

-- 9. show destinations that haven’t been visited yet.
select *
from destinations
where destination_id not in (
  select distinct destination_id from trips
);

-- 10. find the trip with the highest cost per day.
select *, budget / nullif(datediff(end_date, start_date), 0) as cost_per_day
from trips
order by cost_per_day desc
limit 1;

-- 11. update the budget for a trip that was extended by 3 days.
update trips
set budget = budget + (3 * (
  select avg_cost_per_day from destinations 
  where destinations.destination_id = trips.destination_id
))
where trip_id = 101;

-- 12. delete all trips that were completed before jan 1, 2023.
delete from trips where end_date < '2023-01-01';


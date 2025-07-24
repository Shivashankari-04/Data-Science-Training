create database pet;
use pet;

 CREATE TABLE Pets ( 
pet_id INT PRIMARY KEY, 
name VARCHAR(50), 
type VARCHAR(20), 
breed VARCHAR(50), 
age INT, 
owner_name VARCHAR(50) 
); 
INSERT INTO Pets VALUES  
(1, 'Buddy', 'Dog', 'Golden Retriever', 5, 'Ayesha'), 
(2, 'Mittens', 'Cat', 'Persian', 3, 'Rahul'), 
(3, 'Rocky', 'Dog', 'Bulldog', 6, 'Sneha'), 
(4, 'Whiskers', 'Cat', 'Siamese', 2, 'John'), 
(5, 'Coco', 'Parrot', 'Macaw', 4, 'Divya'), 
(6, 'Shadow', 'Dog', 'Labrador', 8, 'Karan');

 CREATE TABLE Visits ( 
visit_id INT PRIMARY KEY, 
pet_id INT, 
visit_date DATE, 
issue VARCHAR(100), 
fee DECIMAL(8,2), 
FOREIGN KEY (pet_id) REFERENCES Pets(pet_id) 
); 
INSERT INTO Visits VALUES 
(101, 1, '2024-01-15', 'Regular Checkup', 500.00), 
(102, 2, '2024-02-10', 'Fever', 750.00), 
(103, 3, '2024-03-01', 'Vaccination', 1200.00), 
(104, 4, '2024-03-10', 'Injury', 1800.00), 
(105, 5, '2024-04-05', 'Beak trimming', 300.00), 
(106, 6, '2024-05-20', 'Dental Cleaning', 950.00), 
(107, 1, '2024-06-10', 'Ear Infection', 600.00);

-- 1. list all pets who are dogs.
select * from pets where type = 'dog';

-- 2. show all visit records with a fee above 800.
select * from visits where fee > 800;

-- 3. list pet name, type, and their visit issues.
select p.name as pet_name, p.type, v.issue
from pets p
join visits v on p.pet_id = v.pet_id;

-- 4. show the total number of visits per pet.
select p.name as pet_name, count(v.visit_id) as total_visits
from pets p
join visits v on p.pet_id = v.pet_id
group by p.name;

-- 5. find the total revenue collected from all visits.
select sum(fee) as total_revenue from visits;

-- 6. show the average age of pets by type.
select type, avg(age) as average_age from pets
group by type;

-- 7. list all visits made in the month of march.
select * from visits where month(visit_date) = 3;

-- 8. show pet names who visited more than once.
select p.name as pet_name, count(v.visit_id) as visit_count
from pets p
join visits v on p.pet_id = v.pet_id
group by p.name
having count(v.visit_id) > 1;

-- 9. show the pet(s) who had the costliest visit.
select p.* from pets p
join visits v on p.pet_id = v.pet_id
where v.fee = (select max(fee) from visits);

-- 10. list pets who haven’t visited the clinic yet.
select * from pets where pet_id not in (
  select distinct pet_id from visits
);

-- 11. update the fee for visit_id 105 to 350.
update visits
set fee = 350
where visit_id = 105;

-- 12. delete all visits made before feb 2024.
delete from visits where visit_date < '2024-02-01';

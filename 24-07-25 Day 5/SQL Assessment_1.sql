create  database assessment_1;
use assessment_1;

create table Exercises (
  exercise_id INT PRIMARY KEY,
  exercise_name varchar(50),
  category varchar(30),
  calories_burn_per_min INT
);
insert into Exercises values 
(1, 'Running', 'Cardio', 10),
(2, 'Cycling', 'Cardio', 8),
(3, 'Yoga', 'Flexibility', 4),
(4, 'Weight Lifting', 'Strength', 7),
(5, 'Jump Rope', 'Cardio', 12);


create table WorkoutLog (
  log_id INT PRIMARY KEY,
  exercise_id INT,
  date DATE,
  duration_min INT,
  mood varchar(20),
  FOREIGN KEY (exercise_id) REFERENCES Exercises(exercise_id)
);
insert into WorkoutLog values
(101, 1, '2025-03-01', 30, 'Energized'),
(102, 2, '2025-03-03', 45, 'Normal'),
(103, 3, '2025-03-05', 60, 'Tired'),
(104, 4, '2025-03-10', 40, 'Normal'),
(105, 1, '2025-03-15', 25, 'Tired'),
(106, 5, '2025-02-20', 20, 'Energized'),
(107, 2, '2025-03-20', 30, 'Tired'),
(108, 4, '2025-03-22', 35, 'Energized'),
(109, 3, '2025-04-01', 50, 'Normal'),
(110, 5, '2025-03-25', 15, 'Normal');


-- 1. Show all exercises under the “Cardio” category.
select * from Exercises where category = 'Cardio';

-- 2. Show workouts done in the month of March 2025.
select * from WorkoutLog where  MONTH(date) = 3 AND YEAR(date) = 2025;

-- 3. Calculate total calories burned per workout (duration × calories_burn_per_min).
select W.log_id, E.exercise_name, W.duration_min, (W.duration_min * E.calories_burn_per_min) AS total_calories
from WorkoutLog W
JOIN Exercises E ON W.exercise_id = E.exercise_id;

-- 4. Calculate average workout duration per category.
select E.category, AVG(W.duration_min) AS avg_duration
from WorkoutLog W
join Exercises E ON W.exercise_id = E.exercise_id
GROUP BY E.category;

-- 5. List exercise name, date, duration, and calories burned using a join.
select E.exercise_name, W.date, W.duration_min,
       (W.duration_min * E.calories_burn_per_min) AS calories_burned
from WorkoutLog W
join Exercises E ON W.exercise_id = E.exercise_id;

-- 6. Show total calories burned per day.
select  W.date, SUM(W.duration_min * E.calories_burn_per_min) AS total_calories
from WorkoutLog W
join Exercises E ON W.exercise_id = E.exercise_id
GROUP BY W.date;

-- 7. Find the exercise that burned the most calories in total.
select  E.exercise_name, SUM(W.duration_min * E.calories_burn_per_min) AS total_burned
from WorkoutLog W
join Exercises E ON W.exercise_id = E.exercise_id
GROUP BY E.exercise_name
ORDER BY total_burned DESC
LIMIT 1;

-- 8. List exercises never logged in the workout log.
select * from Exercises where exercise_id NOT IN (
select DISTINCT exercise_id from WorkoutLog);

-- 9. Show workouts where mood was “Tired” and duration > 30 mins.
select * from WorkoutLog where mood = 'Tired' AND duration_min > 30;

-- 10. Update a workout log to correct a wrongly entered mood.
update WorkoutLog
set mood = 'Energized'
where log_id = 105;

-- 11. Update the calories per minute for “Running”.
update Exercises
set calories_burn_per_min = 11
where exercise_name = 'Running';

-- 12. Delete all logs from February 2024.
delete from WorkoutLog
where MONTH(date) = 2 AND YEAR(date) = 2024;

-----Data Exploration of performance of my work in the Family Care Facility 
-----as Chart Prepper last 7.50 hours (450 minutes).

---See Data
SELECT *
FROM performance_work
---Create a Table for test
CREATE TABLE performance_worktest1(
Date date,
Time_Notes_Done_Min float,
Notes_Done float,
Weeks varchar(100)
)
INSERT INTO performance_worktest1
SELECT*
FROM performance_work

SELECT *
FROM performance_worktest1

---Calculate and Add a column of hours of notes done
SELECT *,ROUND(Time_Notes_Done_Min/60,2) as Time_Notes_Done_Hour 
FROM performance_worktest1

ALTER TABLE performance_worktest1
ADD Time_Notes_Done_Hour float

UPDATE performance_worktest1
SET Time_Notes_Done_Hour=ROUND(Time_Notes_Done_Min/60,2)

---Calculate and Add a column of minutes of other tasks
SELECT *,450-Time_Notes_Done_Min as Time_Other_Task 
FROM performance_worktest1

ALTER TABLE performance_worktest1
ADD Time_Other_Task float

UPDATE performance_worktest1
SET Time_Other_Task=450-Time_Notes_Done_Min 

---Calculate and Add a column of estimation of average of minutes per each note done in minutes 
SELECT *, ROUND(Time_Notes_Done_Min/Notes_Done,2) as Ave_Time_Per_Note_Done
FROM performance_worktest1

ALTER TABLE performance_worktest1
ADD Ave_Time_Per_Note_Done float

UPDATE performance_worktest1
SET Ave_Time_Per_Note_Done=ROUND(Time_Notes_Done_Min/Notes_Done,2)

---Calculate the average of Time_Notes_Done_Min
SELECT ROUND(AVG(Time_Notes_Done_Min),0,1) AS Average_Time_Notes_Done_Min
FROM performance_worktest1

---Calculate the average of Ave_Time_Per_Note_Done
SELECT ROUND(AVG(Ave_Time_Per_Note_Done),2) AS Average_Ave_Time_Per_Note_Done
FROM performance_worktest1

---Calculate the average of Time_Other_Task
SELECT ROUND(AVG(Time_Other_Task),0,1) AS Average_Time_Other_Task
FROM performance_worktest1
---Calculate the SUM of Notes_Done
SELECT SUM(Notes_Done)
FROM performance_worktest1

---Calculate the Max and Min of Notes Done
SELECT MAX(Notes_Done) AS 'Maximum of Notes Done', MIN(Notes_Done) AS 'Minimum of Notes Done'
FROM performance_worktest1

---Calculate the Max and Min of Ave_Time_Per_Note_Done
SELECT MAX(Ave_Time_Per_Note_Done) AS 'Maximum of Ave_Time_Per_Note_Done', MIN(Ave_Time_Per_Note_Done) AS 'Minimum of Ave_Time_Per_Note_Done'
FROM performance_worktest1

---Calculate the average per weeks of Time_Notes_Done_Min, Ave_Time_Per_Note_Done AND how many days are there per week?  
---Also calculate the sum of notes done per week 
SELECT Weeks,ROUND(AVG(Time_Notes_Done_Min),0,1) AS Average_Per_Weeks_Time_Notes_Done_Min,
ROUND(AVG(Ave_Time_Per_Note_Done),2) AS Average_Ave_Time_Per_Note_Done,
ROUND(AVG(Time_Other_Task),0,1) AS Average_Time_Other_Task,
SUM(Notes_Done) AS Notes_Done_Per_Week,
Count(Date) As Amount_of_days_per_week
FROM performance_worktest1
GROUP BY Weeks

------Calculate the average per month of Time_Notes_Done_Min, Ave_Time_Per_Note_Done,Time_Notes_Done_Min, Ave_Time_Per_Note_Done AND how many days are there per month?  
------Also calculate the sum of notes done per month  
SELECT ROUND(AVG(Time_Notes_Done_Min),0,1) AS Average_Per_Weeks_Time_Notes_Done_Min_Month,
ROUND(AVG(Ave_Time_Per_Note_Done),2) AS Average_Ave_Time_Per_Note_Done_Month,
ROUND(AVG(Time_Other_Task),0,1) AS Average_Time_Other_Task_Month,
SUM(Notes_Done) AS Notes_Done_Per_Month,
Count(Date) As Amount_of_days_per_Month
FROM performance_worktest1
GROUP BY MONTH(Date)

------CREATE and ADD a column to segregate the performance at work 
SELECT Date, Ave_Time_Per_Note_Done,
 CASE 
   WHEN Ave_Time_Per_Note_Done BETWEEN 3.98 AND 4.50 THEN 'Efficient'
   WHEN Ave_Time_Per_Note_Done<3.98 THEN 'Outstanding' 
   ELSE 'Subpar'
 END AS Performance
 FROM performance_worktest1

ALTER TABLE performance_worktest1
ADD Performance varchar(100)

UPDATE performance_worktest1
SET Performance=
(CASE 
   WHEN Ave_Time_Per_Note_Done BETWEEN 3.98 AND 4.50 THEN 'Efficient'
   WHEN Ave_Time_Per_Note_Done<3.98 THEN 'Outstanding' 
   ELSE 'Subpar'
 END)
FROM performance_worktest1

---Calculate the amount of days where I get each performance at work 
---and group by kind of performance

SELECT DISTINCT(Performance), COUNT(Date) OVER(PARTITION BY Performance) AS 'Amount of day per Performance'
FROM performance_worktest1

---Select the days where I get subpar performance at work for try 
---to figure out what happened on this days that affect my performance.
SELECT *
FROM performance_worktest1
WHERE Performance='Subpar'

---Data for use in Visualization in Power BI
SELECT Date, Performance
FROM performance_worktest1


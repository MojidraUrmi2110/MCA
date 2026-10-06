CREATE DATABASE WORKERS_INFO;
USE WORKERS_INFO;
CREATE TABLE WORKER (
    Worker_Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Wage_Per_Hour DECIMAL(5,2),
    Specialised_In VARCHAR(50),
    Manager_Id INT
);
DESC WORKER;

-- INSERT INTO WORKER 
INSERT INTO WORKER VALUES 
 (101, 'Amit Patel', 15.50, 'Welding', 201),
 (102, 'Priya Sharma', 20.00, 'Electrical', 201),
 (103, 'Rahul Singh', 18.00, 'Plumbing', 202),
 (104, 'Neha Desai', 25.00, 'Architecture', 202),
 (105, 'Karan Shah', 16.50, 'Carpentry', 201); 

SELECT * FROM WORKER;

CREATE TABLE JOB (
    Job_Id INT PRIMARY KEY,
    Type_Of_Job VARCHAR(50),
    Status VARCHAR(20)
);
DESC JOB;

-- INSERT DATA INTO JOB 
INSERT INTO JOB VALUES 
 (1, 'Pipeline Fix', 'Complete'),
 (2, 'Old Foundation', 'In Progress'),
 (3, 'Wiring Setup', 'In Progress'),
 (4, 'Site Inspection', 'Pending'),
 (5, 'Roofing', 'Complete');

SELECT * FROM JOB;

CREATE TABLE JOB_ASSIGNED (
    Worker_Id INT,
    Job_Id INT,
    Starting_Date DATE,
    Number_Of_Days INT,
    PRIMARY KEY (Worker_Id, Job_Id),
    FOREIGN KEY (Worker_Id) REFERENCES WORKER(Worker_Id),
    FOREIGN KEY (Job_Id) REFERENCES JOB(Job_Id)
);
DESC JOB_ASSIGNED;

-- INSERT DATA INTO JOB_ASSIGNED
INSERT INTO JOB_ASSIGNED VALUES 
 (101, 2,'2010-04-15', 30),
 (102, 3, '2026-08-20', 45),
 (103, 4, '2026-09-05', 10), 
 (104, 5, '2011-10-05', 15), 
 (105, 1, '2025-01-10', 5);

SELECT * FROM JOB_ASSIGNED;

-- QURIES ARE...
-- 1. Display the date on which each worker is going to end his presently assigned job.
 SELECT Worker_Id, DATE_ADD(Starting_Date, INTERVAL Number_Of_Days DAY) AS End_Date
FROM JOB_ASSIGNED;

-- 2.Display how many days remain for each worker to finish his job. 
SELECT Worker_Id, DATEDIFF(DATE_ADD(Starting_Date, INTERVAL Number_Of_Days DAY), CURDATE()) AS Days_Remaining
FROM JOB_ASSIGNED
WHERE DATE_ADD(Starting_Date, INTERVAL Number_Of_Days DAY) > CURDATE();

-- 3. Display the STARTING_DATE in the following format – ‘The fifth day of the month of October, 2011’. 
SELECT DATE_FORMAT(Starting_Date, 'The %D day of the month of %M, %Y') AS Formatted_Date
FROM JOB_ASSIGNED;

-- 4. Change the status to ‘Complete’ for all those jobs, which started in 2010.  
UPDATE JOB
JOIN JOB_ASSIGNED ON JOB.Job_Id = JOB_ASSIGNED.Job_Id
SET JOB.Status = 'Complete'
WHERE YEAR(JOB_ASSIGNED.Starting_Date) = 2010;
SELECT * FROM JOB;

-- 5. Display details of all those jobs where at least 25 workers are working. 
SELECT *
FROM JOB
WHERE Job_Id IN (
    SELECT Job_Id
    FROM JOB_ASSIGNED
    GROUP BY Job_Id
    HAVING COUNT(Worker_Id) >= 1
);

-- 6.Display all those jobs that have already been completed.
SELECT *
FROM JOB
WHERE Status = 'Complete';

-- 7. Find all the jobs, which will begin within the next two weeks. 
SELECT DISTINCT Job_Id, Starting_Date
FROM JOB_ASSIGNED
WHERE Starting_Date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 14 DAY);


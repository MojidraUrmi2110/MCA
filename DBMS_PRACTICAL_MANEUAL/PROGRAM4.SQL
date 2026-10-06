create database Movie;
use Movie;
create table Screen
( 
	Screen_Id VARCHAR(5) PRIMARY KEY CHECK (Screen_Id LIKE 'S%'),
	Location varchar(2) CHECK (Location in('FF','SF','TF')),
	Seating_Capacity int
);
desc Screen;

-- insert data 
INSERT INTO Screen VALUES ('S1', 'FF', 250);
INSERT INTO Screen VALUES ('S2', 'SF', 180);
INSERT INTO Screen VALUES ('S3', 'TF', 120);
INSERT INTO Screen VALUES ('S4', 'FF', 300);
INSERT INTO Screen VALUES ('S5', 'SF', 200);

select * from Screen;

create table Movie(Movie_Id int PRIMARY KEY,
	Movie_Name VARCHAR(50) NOT NULL,
	Date_Of_Release date
);
desc Movie;

-- insert data
INSERT INTO Movie VALUES (101, 'Iron Man', '2008-05-02');
INSERT INTO Movie VALUES (102, 'The Incredible Hulk', '2008-06-13');
INSERT INTO Movie VALUES (103, 'Iron Man 2', '2010-05-07');
INSERT INTO Movie VALUES (104, 'Thor', '2011-05-06');
INSERT INTO Movie VALUES (105, 'Captain America', '2011-07-22');
INSERT INTO Movie VALUES (106, 'The Avengers', '2012-05-04');
INSERT INTO Movie VALUES (107, 'Iron Man 3', '2013-05-03');
INSERT INTO Movie VALUES (108, 'Thor: The Dark World', '2013-11-08');
INSERT INTO Movie VALUES (109, 'Captain America: The Winter Soldier', '2014-04-04');
INSERT INTO Movie VALUES (110, 'Guardians of the Galaxy', '2014-08-01');
INSERT INTO Movie VALUES (111, 'Avengers: Age of Ultron', '2015-05-01');
INSERT INTO Movie VALUES (112, 'Captain America: Civil War', '2016-05-06');
INSERT INTO Movie VALUES (113, 'Doctor Strange', '2016-11-04');
INSERT INTO Movie VALUES (114, 'Guardians of the Galaxy Vol. 2', '2017-05-05');
INSERT INTO Movie VALUES (115, 'Thor: Ragnarok', '2017-11-03');
INSERT INTO Movie VALUES (116, 'Avengers: Infinity War', '2018-04-27');
INSERT INTO Movie VALUES (117, 'Avengers: Endgame', '2019-04-26');
INSERT INTO Movie VALUES (118, 'The Dark Knight', '2011-09-26');

select * from Movie;
Create table Current1(Screen_Id Varchar(5) REFERENCES Screen(Screen_Id),
	Movie_Id int REFERENCES Movie(Movie_Id),
	Date_Of_Arrival date,
	Date_Of_Closure date
);
desc Current1;

-- insert data 
INSERT INTO Current1 VALUES ('S1', 101, '2008-05-02', '2008-06-15');
INSERT INTO Current1 VALUES ('S2', 102, '2008-06-13', '2008-07-20');
INSERT INTO Current1 VALUES ('S3', 103, '2010-05-07', '2010-06-20');
INSERT INTO Current1 VALUES ('S4', 104, '2011-05-06', '2011-06-25');
INSERT INTO Current1 VALUES ('S5', 105, '2011-07-22', '2011-08-30');
INSERT INTO Current1 VALUES ('S1', 106, '2012-05-04', '2012-07-15');
INSERT INTO Current1 VALUES ('S2', 107, '2013-05-03', '2013-06-20');
INSERT INTO Current1 VALUES ('S3', 108, '2013-11-08', '2013-12-25');
INSERT INTO Current1 VALUES ('S4', 109, '2014-04-04', '2014-05-25');
INSERT INTO Current1 VALUES ('S5', 110, '2014-08-01', '2014-09-20');
INSERT INTO Current1 VALUES ('S1', 111, '2015-05-01', '2015-06-30');
INSERT INTO Current1 VALUES ('S2', 112, '2016-05-06', '2016-06-25');
INSERT INTO Current1 VALUES ('S3', 113, '2016-11-04', '2016-12-20');
INSERT INTO Current1 VALUES ('S4', 114, '2017-05-05', '2017-06-25');
INSERT INTO Current1 VALUES ('S5', 115, '2017-11-03', '2017-12-30');

select * from Current1;
INSERT INTO Current1 VALUES ('S1', 116, '2018-04-27', '2018-06-30');
INSERT INTO Current1 VALUES ('S4', 117, '2019-04-26', '2019-07-15');
INSERT INTO Current1 VALUES ('S4', 118, '2019-04-26', '2011-12-24');

-- queries are ...
-- 1.
SELECT * FROM SCREEN WHERE Screen_Id LIKE 'S%';

-- 2.
SELECT * FROM SCREEN WHERE Location IN ('FF', 'SF', 'TF');

-- 3.
SELECT M.Movie_Name FROM MOVIE M
JOIN CURRENT1 C  ON M.Movie_Id = C.Movie_Id
ORDER BY DATEDIFF(C.Date_Of_Closure, C.Date_Of_Arrival) DESC;

-- 4.
SELECT ROUND(
    AVG(DATEDIFF(Date_Of_Closure, Date_Of_Arrival)), 2
) AS Average_Duration_Days
FROM `CURRENT1`
WHERE Screen_Id = 'S4';

-- 5.
SELECT M.Movie_Name
FROM MOVIE M
JOIN `CURRENT1` C
ON M.Movie_Id = C.Movie_Id
WHERE C.Date_Of_Closure = '2011-12-24';
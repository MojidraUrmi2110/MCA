create database Books;
use Books;
-- 1. Create PUBLISHER table
CREATE TABLE PUBLISHER (
    publ_id VARCHAR(10) PRIMARY KEY,
    publ_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    contact_addr VARCHAR(255),
    contact_phone VARCHAR(20)
);
desc PUBLISHER;

-- Insert Publishers
INSERT INTO PUBLISHER VALUES 
('P101', 'Pearson', 'John Doe', 'London, UK', '9876543210'),
('P102', 'O Reilly', 'Sarah Smith', 'California, USA', '9876543211'),
('P103', 'McGraw Hill', 'Robert Brown', 'New York, USA', '9876543212');

select * from PUBLISHER;

-- 2. Create CATEGORY table
CREATE TABLE CATEGORY (
    cat_id VARCHAR(10) PRIMARY KEY,
    cat_details VARCHAR(100),
    max_books INT,
    duration INT -- Duration in years
);
desc CATEGORY;
-- Insert Categories
INSERT INTO CATEGORY VALUES 
('C1', 'Student', 3, 3),
('C2', 'Faculty', 10, 5),
('C3', 'General', 2, 1);

SELECT * FROM CATEGORY;

-- 3. Create BOOK_MASTER table
CREATE TABLE BOOK_MASTER (
    book_id VARCHAR(10) PRIMARY KEY,
    bname VARCHAR(150) NOT NULL,
    isbn_no VARCHAR(20),
    total_copies INT NOT NULL,
    publ_id VARCHAR(10),
    FOREIGN KEY (publ_id) REFERENCES PUBLISHER(publ_id)
);
desc BOOK_MASTER;
-- Insert Books
INSERT INTO BOOK_MASTER VALUES 
('B101', 'Data Structures and Algorithms', 'ISBN-001', 2, 'P101'),
('B102', 'Database Management Systems', 'ISBN-002', 3, 'P101'),
('B103', 'Operating Systems Concepts', 'ISBN-003', 1, 'P102'),
('B104', 'Big Data Analytics', 'ISBN-004', 2, 'P103');

SELECT * FROM BOOK_MASTER;

-- 4. Create MEMBER table
CREATE TABLE MEMBER (
    member_id VARCHAR(10) PRIMARY KEY,
    mname VARCHAR(100) NOT NULL,
    cat_id VARCHAR(10),
    mem_ship_dt DATE,
    FOREIGN KEY (cat_id) REFERENCES CATEGORY(cat_id)
);
desc MEMBER;

-- Add a column to the MEMBER table,which will allow us to store the address of the member
ALTER TABLE MEMBER 
ADD address VARCHAR(255);
DESC MEMBER;

-- Create a table LIBRARY_USERS which has a structure similar to that of the MEMBER table but with no records. 
CREATE TABLE LIBRARY_USERS AS 
SELECT * FROM MEMBER 
WHERE 1 = 0;
DESC LIBRARY_USERS;

-- Insert Members (with address)
INSERT INTO MEMBER VALUES 
('M101', 'Alice Green', 'C1', '2010-01-15', '12 Elm Street'),
('M102', 'Bob Martin', 'C2', '2011-03-20', '45 Oak Avenue'),
('M103', 'Charlie Ray', 'C1', '2011-07-10', '89 Pine Road');

SELECT * FROM MEMBER;

-- 5. Create ISSUE table
CREATE TABLE ISSUE (
    issue_id VARCHAR(10) PRIMARY KEY,
    member_id VARCHAR(10),
    book_id VARCHAR(10),
    issu_ret CHAR(1),
    issue_ret_dt DATE,
    FOREIGN KEY (member_id) REFERENCES MEMBER(member_id),
    FOREIGN KEY (book_id) REFERENCES BOOK_MASTER(book_id)
);
desc ISSUE;

-- . Change the table design of ISSUE table to add a constraint, which will allow only ‘I’ or ‘R’ to be entered in the ISSUE_RETcolumn, which stores the action whether the book is being issued or returned. 
ALTER TABLE ISSUE 
ADD CONSTRAINT chk_issue_ret CHECK (issu_ret IN ('I', 'R'));
desc ISSUE;

INSERT INTO ISSUE VALUES 
('I1', 'M101', 'B101', 'I', '2011-02-10'),
('I2', 'M101', 'B101', 'R', '2011-02-25'),
('I3', 'M102', 'B101', 'I', '2011-05-12'),
('I4', 'M103', 'B101', 'I', '2011-08-19'),
('I5', 'M102', 'B103', 'I', '2023-01-15'), 
('I6', 'M101', 'B102', 'I', '2023-02-10');

SELECT * FROM ISSUE;

-- OUERIES ARE...
-- 1. Give details about members who have issued books, which contain the word ‘DATA’ somewhere in their titles.

SELECT DISTINCT m.member_id, m.mname, m.cat_id, m.address
FROM MEMBER m
JOIN ISSUE i ON m.member_id = i.member_id
JOIN BOOK_MASTER b ON i.book_id = b.book_id
WHERE UPPER(b.bname) LIKE '%DATA%'
  AND i.issu_ret = 'I';
  
  -- 2. Display the books that have been issued at the most three times in the year 2011.
  SELECT b.book_id, b.bname, COUNT(i.issue_id) AS total_issues_2011
FROM BOOK_MASTER b
LEFT JOIN ISSUE i ON b.book_id = i.book_id 
    AND i.issu_ret = 'I' 
    AND i.issue_ret_dt BETWEEN '2011-01-01' AND '2011-12-31'
GROUP BY b.book_id, b.bname
HAVING COUNT(i.issue_id) <= 3;

-- 3.Display the details of books issued right now that are published by “Pearson”. 
SELECT DISTINCT b.book_id, b.bname, b.isbn_no, b.total_copies, p.publ_name
FROM BOOK_MASTER b
JOIN PUBLISHER p ON b.publ_id = p.publ_id
JOIN ISSUE i ON b.book_id = i.book_id
WHERE p.publ_name = 'Pearson'
  AND i.issu_ret = 'I';
  
  -- 4.Display the details of books whose all copies are issued. 
  SELECT b.book_id, b.bname, b.total_copies
FROM BOOK_MASTER b
JOIN ISSUE i ON b.book_id = i.book_id
GROUP BY b.book_id, b.bname, b.total_copies
HAVING SUM(CASE WHEN i.issu_ret = 'I' THEN 1 WHEN i.issu_ret = 'R' THEN -1 ELSE 0 END) >= b.total_copies;
  


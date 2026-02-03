-- Enable readable output format
.mode columns
.headers on

-- Instructions for students:
-- 1. Open SQLite in terminal: sqlite3 library.db
-- 2. Load this script: .read code.sql
-- 3. Exit SQLite: .exit


-- write your sql code here
SELECT B.title, M.name, L.loan_date 
FROM Books B LEFT JOIN Loans L ON B.id = L.book_id LEFT JOIN Members M ON L.member_id = M.id;

SELECT B.title, L.*
FROM Books B LEFT JOIN Loans L ON B.id = L.book_id;

SELECT B.title, Li.*
FROM Books B LEFT JOIN LibraryBranch Li ON B.branch_id = Li.id;

SELECT Li.*, COUNT(B.id) AS NumberOfBooks
FROM Books B LEFT JOIN LibraryBranch Li ON B.branch_id = Li.id
GROUP BY Li.id;
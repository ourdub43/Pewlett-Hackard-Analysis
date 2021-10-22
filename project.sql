--- Project Module 7 ---

Select e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	s.from_date,
	ti.to_date,
	s.salary
INTO retiring_emp
FROM Employees as e
INNER JOIN salaries as s
ON e.emp_no = s.emp_no
INNER JOIN titles as ti
ON s.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31');

Select COUNT (*), title
FROM retiring_emp
GROUP BY title;

DROP TABLE retiring_emp;
SELECT * from retiring_emp;

-- Partition the data to show only most recent title per employee
SELECT emp_no,
	first_name,
	last_name,
	title,
	from_date,
	salary
INTO silver_tsunami
FROM
 (SELECT emp_no,
  first_name,
  last_name,
  title,
  from_date,
  salary, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY from_date DESC) rn
 FROM retiring_emp) tmp WHERE rn = 1
ORDER BY emp_no;

select count(*) from new_retirees
GROUP BY title;


--- Mentorship Program ---
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO Mentorship
FROM Employees as e
INNER JOIN Titles as ti
ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-01');

select * from Mentorship;

--Create Mentorship Table w/o duplicates
SELECT emp_no,
	first_name,
	last_name,
	title,
	to_date
INTO mentorship_fox
FROM
 (SELECT emp_no,
  first_name,
  last_name,
  title,
  to_date,
  ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM Mentorship) tmp WHERE rn = 1
ORDER BY emp_no;

select * from mentorship_fox;

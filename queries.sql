SELECT first_name, last_name 
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- RETIREMENT ELIGIBILITY
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1952-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


SELECT * FROM retirement_info;


SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;



--Current Employees Eligible for Retirement
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date <= ('9999-01-01');







-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
BY de.dept_no
ORDER BY de.dept_no;


--Employee Information

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT emp_no, 
	first_name,
	last_name,
	gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' and '1988-12-31');

select * from emp_info;

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
FROM emp_info as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE de.to_date <= '9999-01-01';

-- List of managers per department
SELECT dm.dept_no,
	d.dept_name,
	dm.emp_no,
	ce.first_name,
	ce.last_name,
	dm.from_date,
	dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments AS d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp as ce
		ON (dm.emp_no = ce.emp_no);
	
-- Department Retirees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

--Create a Tailored List (Sales Team Only)
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
FROM current_emp as ce
INNER JOIN dept_emp as de
ON ce.emp_no = de.emp_no
INNER JOIN departments as d
ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

--Create a Tailored List (Sales and Development Team)
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
FROM current_emp as ce
INNER JOIN dept_emp as de
ON ce.emp_no = de.emp_no
INNER JOIN departments as d
ON de.dept_no = d.dept_no
WHERE d.dept_name IN('Sales', 'Development');

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


--create schema public

-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/fBkrxm
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

CREATE TABLE "titles" (
    "title_id" VARCHAR(5)   NOT NULL,
    "title" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title" VARCHAR(5)   NOT NULL,
    "birth_date" VARCHAR(10)   NOT NULL,
    "first_name" VARCHAR(30)   NOT NULL,
    "last_name" VARCHAR(30)   NOT NULL,
    "sex" VARCHAR(2)   NOT NULL,
    "hire_date" VARCHAR(10)   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR(5)   NOT NULL,
    "dept_name" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "employee_depts" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR(5)   NOT NULL,
    CONSTRAINT "pk_employee_depts" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "dept_managers" (
    "dept_no" VARCHAR(5)   NOT NULL,
    "emp_no" INT   NOT NULL,
    CONSTRAINT "pk_dept_managers" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("title_id");

ALTER TABLE "employee_depts" ADD CONSTRAINT "fk_employee_depts_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employee_depts" ADD CONSTRAINT "fk_employee_depts_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_managers" ADD CONSTRAINT "fk_dept_managers_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_managers" ADD CONSTRAINT "fk_dept_managers_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");
--END OF IMPORTED CODE --


-- List the following details of each employee:
-- employee number, last name, first name, sex, and salary.
SELECT e.emp_no, e.first_name, e.last_name, e.sex, s.salary
FROM employees AS e
LEFT JOIN salaries AS s
ON e.emp_no = s.emp_no;
----------------------------------------------------------

-- List first name, last name, and hire date for employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
	WHERE hire_date LIKE '%1986';
----------------------------------------------------------

-- List the manager of each department with the following information:
-- department number, department name, the manager's employee number,
-- last name, first name
SELECT d.dept_no AS "Dept No.", d.dept_name AS "Dept Name", m.emp_no AS "Emp No.",
		e.last_name AS "Last Name", e.first_name AS "First Name" 
FROM employees AS e
INNER JOIN departments AS d
	INNER JOIN dept_managers AS m
		ON d.dept_no = m.dept_no
ON e.emp_no = m.emp_no
ORDER BY d.dept_no, e.emp_no;
--alternate method (without join):
SELECT  d.dept_no AS "Dept No.", d.dept_name AS "Dept Name", m.emp_no AS "Emp No.",
		e.last_name AS "Last Name", e.first_name AS "First Name" 
FROM employees AS e, departments AS d, dept_managers AS m
	WHERE d.dept_no = m.dept_no
	AND e.emp_no = m.emp_no
ORDER BY d.dept_no, e.emp_no;
------------------------------------------------

-- List the department of each employee with the following information:
-- employee number, last name, first name, and department name.
SELECT e.emp_no AS "Emp No.", e.last_name AS "Last Name", 
		e.first_name AS "First Name", d.dept_name AS "Dept Name"
FROM employees AS e, employee_depts AS ed, departments AS d
	WHERE e.emp_no = ed.emp_no
	AND ed.dept_no = d.dept_no;
----------------------------------------------------------------------------

-- List first name, last name, and sex for employees whose
-- first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name, sex
FROM employees
	WHERE first_name = 'Hercules'
	AND last_name LIKE 'B%';
-----------------------------------------------------------------------------
	
-- List all employees in the Sales department, including their
-- employee number, last name, first name, and department name.
SELECT e.emp_no AS "Emp No.", e.last_name AS "Last Name", 
		e.first_name AS "First Name", d.dept_name AS "Dept Name"
FROM employees AS e, employee_depts AS ed, departments AS d
	WHERE e.emp_no = ed.emp_no
	AND ed.dept_no = d.dept_no
	AND d.dept_name = 'Sales';
----------------------------------------------------------------------------

-- List all employees in the Sales and Development departments, including their
-- employee number, last name, first name, and department name.
SELECT e.emp_no AS "Emp No.", e.last_name AS "Last Name", 
		e.first_name AS "First Name", d.dept_name AS "Dept Name"
FROM employees AS e, employee_depts AS ed, departments AS d
	WHERE e.emp_no = ed.emp_no
	AND ed.dept_no = d.dept_no
	AND (d.dept_name = 'Sales'
		 OR d.dept_name = 'Development');
------------------------------------------------------------------------------

-- In descending order, list the frequency count of employee last names,
-- i.e., how many employees share each last name.
SELECT last_name, count(last_name) as Total
FROM employees
GROUP BY last_name
ORDER BY Total DESC;
-------------------------------------------------------------------------------

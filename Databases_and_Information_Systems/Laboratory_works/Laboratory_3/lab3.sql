-- Лабораторна робота 3 «Операція вибірки», варіант 1

SELECT * FROM emp;

SELECT ename, (sal*0.22) as "SSC" FROM emp;

SELECT empno, sal, (sal*1.001) AS "New Salary" FROM emp;

SELECT empno, sal, (sal*1.001) as "New Salary",((sal*1.001)-sal) as "Increase" FROM emp;

SELECT (5+5)*20-3/2 as "Task 4";

SELECT 5+5*20-3/2 as "Task 5";

SELECT (ename || '-' || job) as "Task 6" FROM emp;

SELECT 'department ''' || dname || ''' is placed at ''' || loc || '''' as "Task 7" FROM dept;

SELECT 'department ''' || dname || ''' is placed at ''' || loc || '''' as "Task 8.1" FROM dept;

SELECT E'department \'' || dname || E'\' is placed at \'' || loc || E'\'' as "Task 8.2" FROM dept;

SELECT $$department '$$ || dname || $$' is placed at '$$ || loc || $$'$$ as "Task 8.3" FROM dept;

SELECT ename, sal FROM emp WHERE sal > 1200;

SELECT ename FROM emp WHERE comm > sal*0.2;

SELECT ename, sal FROM emp WHERE sal<1500 OR sal > 2000;

SELECT ename, job, sal FROM emp WHERE (job = 'ANALYST' OR job = 'MANAGER') AND (sal != 1500 AND sal != 2850);

SELECT ename, job, sal, deptno FROM emp WHERE deptno = 10 OR deptno = 20 OR deptno = 30;

SELECT ename, sal FROM emp WHERE sal NOT BETWEEN 1500 and 2000;

SELECT ename, deptno FROM emp WHERE deptno = 10 OR deptno = 20 ORDER BY ename;

SELECT ename, job, hiredate FROM emp WHERE ename IN ('SCOTT', 'ADAMS', 'ALLEN') ORDER BY hiredate;

SELECT ename, deptno, sal FROM emp WHERE (sal BETWEEN 1500 and 5000) AND (deptno = 10 OR deptno = 20);

SELECT ename, hiredate FROM emp WHERE hiredate < '2021-11-13';

SELECT ename, job FROM emp WHERE mgr is NULL;

SELECT DISTINCT job FROM emp WHERE mgr is NULL OR comm is NULL;

SELECT ename, comm FROM emp WHERE comm > 0;

SELECT ename FROM emp WHERE comm is NULL AND mgr is NULL;

SELECT ename, sal, comm FROM emp WHERE (comm IS NULL AND sal > 3000) OR (comm IS NOT NULL AND sal + comm > 3000);

SELECT ename FROM emp WHERE ename LIKE '__A%';

SELECT ename FROM emp WHERE ename LIKE '_L%N';

SELECT loc FROM dept WHERE loc LIKE '%\_%';

-- Варіант 1
-- (додавання операцій 2026 року)
INSERT INTO operations (account_id, target_account_id, type_code, amount, requested_by, confirmed_by, status_code, created_at, confirmed_at, note) VALUES
    (1, NULL, 'deposit', 2000.00, 1, 1, 'done', '2026-02-10 10:00:00+01', '2026-02-10 10:05:00+01', 'Внесення готівки'),
    (2, NULL, 'deposit', 150.00, 2, 2, 'done', '2026-05-18 12:30:00+02', '2026-05-18 12:34:00+02', 'Внесення готівки'),
    (4, NULL, 'deposit', 10000.00, 1, 3, 'done', '2026-09-03 09:15:00+02', '2026-09-03 09:20:00+02', 'Внесення на рахунок компанії'),
    (1, NULL, 'withdrawal', 500.00, 1, 1, 'done', '2026-03-01 11:00:00+01', '2026-03-01 11:04:00+01', 'Зняття готівки');

SELECT count(*) FROM operations;

SELECT first_name AS first_name_of_person, middle_name AS middle_name_of_person, last_name AS last_name_of_person FROM persons;
SELECT concat_ws(' ', first_name, middle_name, last_name ) AS full_name_of_person FROM persons;

SELECT operation_id, account_id, type_code, amount, status_code, created_at, confirmed_at
FROM operations
WHERE confirmed_at > '2026-01-01 00:00:00'
  AND type_code = 'deposit'
  AND confirmed_at < '2027-01-01 00:00:00'
  AND status_code = 'done';

INSERT INTO clients (person_id) VALUES (6);

SELECT person_id FROM employees;

SELECT * FROM clients WHERE person_id IN (6, 7, 8, 9, 10);

SELECT concat_ws(' ', first_name, middle_name, last_name) AS full_name_employees_of_clients
FROM persons
WHERE person_id = 6;


SELECT * FROM positions WHERE name = 'касир';

SELECT * FROM employees WHERE position_id = 1;

SELECT * FROM accounts WHERE iban = 'UA000000000000000000000000005';

SELECT * FROM company_members WHERE company_id = 2 AND  revoked_at is NULL;

SELECT concat_ws(' ', first_name, middle_name, last_name) AS full_name_company_members_of_persons
FROM persons
WHERE person_id =3;

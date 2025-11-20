CREATE USER 'student'@'localhost' IDENTIFIED BY 'student123';
GRANT ALL PRIVILEGES ON northwind.* TO 'student'@'localhost';
FLUSH PRIVILEGES;

SELECT USER(), CURRENT_USER();
ALTER USER 'root'@'localhost' IDENTIFIED BY 'eleanorfox';
FLUSH PRIVILEGES;

ALTER USER 'student'@'localhost' IDENTIFIED BY 'student123';
FLUSH PRIVILEGES;

SELECT User, Host FROM mysql.user;

ALTER TABLE dim_employees ADD PRIMARY KEY (employee_key);





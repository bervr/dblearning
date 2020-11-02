create database if not exists example;
use example;
create table if not exists users (id INT, name VARCHAR (265));

-- c:\Program Files\MySQL\MySQL Server 8.0\bin>mysqldump.exe -u root -p example > D:\WFolders\Documents\dblearning\example.sql
-- c:\Program Files\MySQL\MySQL Server 8.0\bin>mysql.exe -u root -p
-- mysql> create database sample;
-- mysql> use sample
-- mysql> source D:\WFolders\Documents\dblearning\example.sql
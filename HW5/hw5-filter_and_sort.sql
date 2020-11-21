/*Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.*/
use shop;
select * from users;
update users set created_at = null , updated_at =null; -- теперь не заполнены
update users set created_at = now(), updated_at  = now(); -- готово


/*2. Таблица users была неудачно спроектирована. 
Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время 
помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, 
сохранив введённые ранее значения.*/

alter table users modify created_at VARCHAR(255);
alter table users  change  updated_at updated_at VARCHAR(255); -- поменяли тип данных 
update users set created_at = '20.10.2017 8:10' , updated_at = '20.10.2017 8:10'; -- незатейливо заполнили
/*-- ----------
SELECT created_at, cast(created_at, datetime) from users;
select  created_at, 
concat(SUBSTRING(created_at, 1, 2),SUBSTRING(created_at, 4, 2),SUBSTRING(created_at, 7, 4),SUBSTRING(created_at, -5, 2),SUBSTRING(created_at, -2, 2)),
date_format(concat(SUBSTRING(created_at, 1, 2),SUBSTRING(created_at, 4, 2),SUBSTRING(created_at, 7, 4),SUBSTRING(created_at, -5, 2),SUBSTRING(created_at, -2, 2)), '%Y%m%d %h%i' ) 
from users;

select  created_at from users;
update users set created_at = date_format(created_at, '%d-%m-%Y' );
alter table users modify created_at datetime; 


это все не работает и дебри
-- -------------------------------------*/

SELECT * from users;
select  created_at
, str_to_date (created_at,'%d.%m.%Y %h:%i') 
from users;

update users  set created_at
= str_to_date (created_at,'%d.%m.%Y %h:%i');
update users  set updated_at 
= str_to_date (updated_at,'%d.%m.%Y %h:%i'); -перестроили в нужный формат
alter table users modify created_at datetime;
alter table users  change  updated_at updated_at datetime; --поменяли обратно
SELECT * from users;

/*3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
 0, если товар закончился и выше нуля, если на складе имеются запасы. 
 Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
 Однако нулевые запасы должны выводиться в конце, после всех записей.
 */ 


select * from storehouses_products; -- хм...там  пусто оказалось

INSERT INTO storehouses_products  -- не беда, сейчас будет
(storehouse_id , product_id, value)
VALUES
  (1, 7890.00, 0),
  (2, 12700.00, 11),
  (3, 4780.00, 10),
  (4, 7120.00, 51),
  (5, 19310.00, 20),
  (6, 4790.00, 0),
  (11, 5060.00, 2204);
  
 select 
 id, value, 1/value as counter from storehouses_products 
order by counter desc;  -- осталось придумать как каунтер не выводить...


/*4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
Месяцы заданы в виде списка английских названий (may, august)  */
select name, MONTHNAME(birthday_at )
from users  where 
date_format (birthday_at, '%m' ) = 08 or
date_format (birthday_at, '%m' ) = 05;

/* 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. 
SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.*/


SELECT * FROM catalogs WHERE id IN (5, 1, 2)  order by FIELD (id,5,1,2);






 
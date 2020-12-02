/*В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции. */

select * from users;
use sample;
select * from users; -- Угу, структура не совпадает...
alter table users add birthday_at date,  add  created_at datetime,  add  updated_at datetime; -- теперь получше

use shop;
start transaction;
insert into sample.users  select * from users where id = 1;
delete  from users where id = 1;
commit; -- готово

/* Создайте представление, которое выводит название name товарной позиции из 
таблицы products и соответствующее название каталога name из таблицы catalogs*/ 

create  view forsales as select p.name `наименование`, c.name `категория` from products p join catalogs c on p.catalog_id = c.id;
select * from forsales; -- вроде так, не знаю что тут добавить

/*по желанию) Пусть имеется таблица с календарным полем created_at.
 В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17.
 Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1,
  если дата присутствует в исходном таблице и 0, если она отсутствует.
  */
-- если успею
/*
(по желанию) Пусть имеется любая таблица с календарным полем created_at. 
Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
*/

-- если успею

-- ---------------------------------------------------admin
/*Создайте двух пользователей которые имеют доступ к базе данных shop. 
 * Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
 * второму пользователю shop — любые операции в пределах базы данных shop.
 */
create user shop_read identified with sha256_password by 'pass';
create user shop identified with sha256_password by '1234';
grant all on shop.* to shop;
grant select, show view on shop.* to shop_read;

/*(по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ,
 *  имя пользователя и его пароль. Создайте представление username таблицы accounts, 
 * предоставляющий доступ к столбца id и name. Создайте пользователя user_read, 
 * который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.
 */

-- если успею
-- --------------------------------------------------------trigg
/*Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
 * С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу 
 * "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
 */
drop function if exists hello;
delimiter //
create function hello ()
returns varchar(60) no sql
begin
declare now_time time;
select date_format(now(), '%H:%i:%s') into now_time ;
	case 
		when  '12:00:00'< now_time and now_time <= '18:00:00' 
	then return concat ('Добрый день ' , now_time);
		when  '18:00:00'< now_time and now_time <= '23:59:59' -- даааа) 
	then return concat ('Добрый вечер ', now_time);
		when  '00:00:00' < now_time and now_time <= '06:00:00'
	then return concat ('Добрый ноч ', now_time) ;
		when  '06:00:00'< now_time and now_time <= '12:00:00'
	then return concat ('Добрый утр ', now_time);
else return concat ('чьёрт побьери ', now_time);
	end case;
end //
delimiter ;

select hello();


/*В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
  Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение 
  NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
ри попытке присвоить полям NULL-значение необходимо отменить операцию.*/
drop trigger if exists check_null;
delimiter //
create trigger check_null before update on products
for each row
begin
	if (new.name is null and new.description is null) or
		(old.name is null and new.description is null) or 
		(new.name is null and old.description is null)
		then 
			signal sqlstate '45000'
			set message_text = 'forbidden value! one of them must be not null!';
	end if;

end //
delimiter ;

update products set name = null where id =1; -- проверим. сначала вычистим name у id =1
update products set description = null where id =2; -- и дескрипшн у 2
update products set description = null, name = null where id =1; -- ок
update products set name = null where id =2; -- а теперь на оборот. ок
update products set description = null where id =1; -- тоже ок

--  осталось сделать такой же триггер на инсёрт, точнее добавим в этот
drop trigger if exists check_null;
drop trigger if exists check_null_ins;
delimiter //
create trigger check_null before update on products
for each row
begin
	if (new.name is null and new.description is null) or
		(old.name is null and new.description is null) or 
		(new.name is null and old.description is null)
		then 
			signal sqlstate '45000'
			set message_text = 'forbidden value! one of them must be not null!';
	end if;
end//

create trigger check_null_ins before insert on products
for each row
begin
	if (new.name is null and new.description is null) 
		then 
			signal sqlstate '45000'
			set message_text = 'forbidden value! one of them must be not null!';
	end if;
end //
delimiter ;

insert products  (name, description, price, catalog_id) values (123, 456,789 ,3); -- контрольный  ок
insert products  ( description) values ( 984561); -- отлично
insert products  ( name) values ( 984561); -- тоже хорошо
insert products (price, catalog_id) values (789 ,3); -- есть сработка

/*(по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
Вызов функции FIBONACCI(10) должен возвращать число 55.*/


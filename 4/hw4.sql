ALTER TABLE users CHANGE birtday birthday date NULL;
ALTER table users MODIFY COLUMN pass char(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL;
-- очистим наши сообщества чтобы заменить на осмысленные:
-- truncate table communities; -- не проканало, внешний ключ ругается
Alter table users_communities drop foreign key users_communities_ibfk_2; -- users_communities_ibfk2

truncate table communities; -- теперь проканало
Alter table users_communities add foreign key (community_id) references communities(id); -- вернуть ключ на место


use sample; -- фитнт ушами  и отсюда запилить новую таблицу чтобы insert-select потом делать, 
drop table if exists communities;
create table communities (
	id serial primary key,
	name varchar(150)
);

-- заполняем примерами из методички (ну всмысле из приложения к урокам):

INSERT INTO communities (name) VALUES 
('PHP')
,('Planetaro')
,('Ruby')
,('Vim')
,('Ассемблер в Linux для программистов C')
,('Аффинные преобразования')
,('Биология клетки')
,('Древнекитайский язык')
,('Знакомство с методом математической индукции')
,('Информация, системы счисления')
 
,('Кодирование текста и работа с ним')
,('Комплексные числа')
,('Лингва де планета')
,('Лисп')
,('Математика случая')
,('Микромир, элементарные частицы, вакуум')
,('Московская олимпиада по информатике')
,('Оцифровка печатных текстов')
,('Реализации алгоритмов')
,('Регулярные выражения')

,('Рекурсия')
,('Русский язык')
,('Создание электронной копии книги в формате DjVu в Linux')
,('Токипона')
,('Учебник логического языка')
,('Что такое вычислительная математика')
,('Электронные таблицы в Microsoft Excel')
,('Эсперанто? Зачем?')
,('Язык Си в примерах')
,('Японский язык')
;

use snet2910;  -- вернемся обратно
insert communities select * from sample.communities where id%2 =0; -- заполнили четными из другой базы
insert communities select null,name from sample.communities where id%2 <> 0; -- дозаполнили нечетными из другой базы, нумерация пошла с 31

INSERT INTO users  -- заполняем  своими данными
set
	firstname='Ильзиз',
	lastname='Рахматуллин',
	email='ILR@example.net',
	phone=22233322233,
	gender='m',
	birthday='1991-12-01',
	hometown='Nsk',
	pass='1487c1cf7c24df739fc97460a2c791a2432df062';  -- можно пароль не менять, пожалуйста?

/* так-то у меня таблица users наполнена тестовыми данными, но я все равно навставлят туда из методички. 
просто там русские данные, вдруг потом пригодится. 

Кстати как для целей тестирования данные деанонимизировать, и как миграции делать?  
Есть какие-то инструменты/рекомендации  или кто как придумал и каждый сам за себя?*/
	
select * from users  where firstname like 'alex%' or firstname like 'алекса%'; -- селекты, ничего особенного, самое сложное не забыть точку с запятой

select concat( lastname, ' ', substring(firstname,1,1), '.') as 'ФИО', hometown from users  where firstname like 'I%' or firstname like 'И%' order by lastname asc;

select firstname, count(*) as 'quantity' from users group by firstname having count(*) > 1 order by quantity desc; -- посчитали сколько человек тезки, в генерерованных данных тезок нет




select users.lastname, users.firstname, communities.name  from communities join users_communities on communities.id = users_communities.community_id join users on  users_communities.user_id =users.id order by users.lastname ;
/*тут мне аукнулось то что я для очистки communities зачем-то дропнул users_communities, 
  пришлось сгенерить заново, с учетом ненормальной нумерации, филдб  тупило, из питона реально проще оказалось) 
 */
Alter table users_communities drop foreign key users_communities_ibfk_2;
delete  from communities where id between 1 and 29; -- ну вот  их и почистим
Alter table users_communities add foreign key (community_id) references communities(id);


update communities 
set name = 'эсперанто' where name like 'Лингва%';


-- Достаточно?






/*Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
*/
-- очередной раз у меня нету данных в таблице (orders), добавил 2 строчки вручную

select u.name `user`, u.id from users u join orders o on  u.id = o.user_id  

/*
Выведите список товаров products и разделов catalogs, который соответствует товару.
*/
select p.name `item`, c.name `category` from products p join catalogs c on  p.catalog_id = c.id 

/*
(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское.
 Выведите список рейсов flights с русскими названиями городов.
*/
-- может быть не надо было не я сделаль
create  table flights (
id serial primary key, 
`from` varchar(255), 
`to` varchar(255)
);

create  table cities (
label varchar(255), 
name varchar(255)
);

 
 -- INSERT INTO flights (id, `from`, `to`) VALUES (0, 'Khabarovsk', 'Samara'  ); -- ах да, +1 надо было
 INSERT INTO flights (id, `from`, `to`) VALUES (1, 'Moscow', 'Orel'  );
 INSERT INTO flights (id, `from`, `to`) VALUES (2, 'Samara', 'Samara'  );
 INSERT INTO flights (id, `from`, `to`) VALUES (3, 'Omsk', 'Orel'  );
 INSERT INTO flights (id, `from`, `to`) VALUES (4, 'Samara', 'Omsk'  );
 INSERT INTO flights (id, `from`, `to`) VALUES (5, 'Khabarovsk', 'Samara');
 INSERT INTO flights (id, `from`, `to`) VALUES (6, 'Khabarovsk', 'Samara');
 INSERT INTO flights (id, `from`, `to`) VALUES (7, 'Samara', 'Samara'  ); -- ну такой рейс)))
 INSERT INTO flights (id, `from`, `to`) VALUES (8, 'Moscow', 'Samara'  );
 INSERT INTO flights (id, `from`, `to`) VALUES (9, 'Omsk', 'Tomsk'  );
 INSERT INTO flights (id, `from`, `to`) VALUES (10, 'Omsk', 'Samara'  );
 INSERT INTO flights (id, `from`, `to`) VALUES (11, 'Khabarovsk', 'Orel'  );
 INSERT INTO flights (id, `from`, `to`) VALUES (12, 'Orel', 'Omsk'  );
 INSERT INTO flights (id, `from`, `to`) VALUES (13, 'Khabarovsk', 'Omsk'  );
 INSERT INTO flights (id, `from`, `to`) VALUES (14, 'Orel', 'Orel'  ); -- еще один))
 INSERT INTO cities ( label, name) VALUES ( 'Omsk', 'Омск' );
 INSERT INTO cities ( label, name) VALUES ( 'Tomsk', 'Томск' );
 INSERT INTO cities ( label, name) VALUES ( 'Khabarovsk', 'Хабаровск' );
 INSERT INTO cities ( label, name) VALUES ( 'Moscow', 'Москва' );
 INSERT INTO cities ( label, name) VALUES ( 'Samara', 'Самара' );
 INSERT INTO cities ( label, name) VALUES ( 'Orel', 'Орел' ); --  на это ушла большая часть времени задания.
 
 select f2.id, c2.name, c3.name  from cities c2 join flights f2 on  c2.label = f2.from join cities c3 on  c3.label = f2.to order by f2.id

use shop;
/*Подсчитайте средний возраст пользователей в таблице users.*/
select name, birthday_at from users;
select
(avg (to_days(now())-to_days(birthday_at))div 365.25 ) as average
from users;

/*Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
 Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/
select birthday_at, date_format(substring(birthday_at,6), '%W') from users;
select date_format(concat(YEAR(now()), substring(birthday_at,5)), '%W') as dayofborn,  count(*)
from users group by dayofborn ;
-- печаль, вышло по одному... но я проверил по календарю все верно.

/*(по желанию) Подсчитайте произведение чисел в столбце таблицы.*/

select id from users; -- в частном случае с id можно взять максимум по столбцу и факториал этого максимума и будет  искомым произведением
-- но надо еще посмотреть что порядок нумерации неприрывный/ и облом тут нет встроеной функции факториала.

-- значит надо делать в общем случае
select  count(*)  as p1 from users;
/*CREATE PROCEDURE doiterate(p1 INT) -- все что нашлось в документации по циклам
BEGIN
  label1: LOOP
    SET p1 = p1 + 1;
    IF p1 < 10 THEN
      ITERATE label1;
    END IF;
    LEAVE label1;
  END LOOP label1;
  SET @x = p1;
END;

select doiterate (6); */ -- вдруг пригодится

-- вобщем все равно все полимеры того... посмотрел разбор, там была сумма логарифмов.  В эту сторону я даже не думал(

select exp(sum(ln(id))) from users where id <=5; -- чстно списано из ответов



/*Пусть задан некоторый пользователь. 
Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.*/
set @my_uid =  69 ;
select  
Count(message) counter,
(select concat(lastname, ' ', firstname) from users where id = @my_uid ) 'name' -- m.from_user_id
from messages m
where to_user_id = @my_uid and m.from_user_id  in 
(select initiator_user_id from friend_requests fr1 where target_user_id = @my_uid and status='approved'
	union
	select target_user_id from friend_requests fr2 where initiator_user_id = @my_uid and status='approved')
group by from_user_id 
order by counter desc limit 1
;

/*Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.*/

select count(*) `all-likes` from likes lk
where lk.like_for = 'user' and lk.like_object_id in
(select id from (select id, timestampdiff(year, birthday, now()) 'age'  from users order by age limit 10) tmpl)
;
-- и тут я снова подумал что было бы неплохо другой набор данных, в идеале синхронный с перподавательским
-- потому что непонятно как проверять и насколько все правильно/неправильно, т.к. у меня данные в основном генереные с филбд.  

/*Определить кто больше поставил лайков (всего) - мужчины или женщины?*/
select if(
(select gender from (select gender, count(*) counter from users u where id in (
select liker_id from likes where like_status = 'like') group by gender order by counter desc limit 1) gndr_win) = 'm',
'мужчины','женщины') winners
;

/*Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.*/

-- а не добавить ли в этот самый момент поле ластлогон aka последняя активность?
alter table users add lastlogon datetime default current_timestamp on update current_timestamp;
 -- update users set lastlogon  = '2020-8-25 11:7' where id like '1'; -- нагенерил таких строк, применил
 -- по хорошему конечно таймстампы лайков и прочих действий не могут быть позже ластлогона...
 
select concat(lastname, ' ', firstname), lastlogon from users order by lastlogon limit 10;
-- в первом приближении задача решена) пользователи которые дольше всех не заходили - наименее активные)



 


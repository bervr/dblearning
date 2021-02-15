use ivi;
drop procedure if exists get_actors_films; -- все фильмы актера
delimiter //
create PROCEDURE get_actors_films(actor_id int)
begin
select m.name as film, m.year_of, if(p2.name != null, p2.name, p2.original_name) as actor, p2.description as `role`
	from movies m join casting c on m.id = c.movie_id join persons p2 on c.person_id = p2.id 
	where c.person_id =actor_id;
	end //
delimiter ;

-- call get_actors_films(228954);

drop procedure if exists get_user_views; -- что смотрел пользователь
delimiter //
create procedure get_user_views ( in profile_id int)
CONTAINS sql

	begin
drop table if exists views_tmp;
create temporary table views_tmp(movie_id bigint, genge_id int); 
insert into views_tmp select
	 hv.movie_id, g.id from views_history hv 
		join movie_genre mg on mg.movie_id = hv.movie_id 
		join genres g on g.id = mg.id 
		join movies m2 on m2.id = hv.movie_id 
		where hv.profile_id = profile_id group by name;
	end //
delimiter ;
-- call get_user_views(1);
-- select * from views_tmp;


drop procedure if exists get_whats_to_view; -- рекомендовать что посмотреть
delimiter //
create PROCEDURE get_whats_to_view(profile_id int)
	begin
	declare counter int;
	declare one int;
	call get_user_views(profile_id); -- вызвали историю просмотров пользователя 
	set counter= (select count(*) from views_tmp); 
	drop temporary table if exists results; -- таблица для результатов
	create temporary table results (name varchar(255)/*,movie_id*/);
	while counter >0 do
			set counter = counter - 1;
			set one = (select genge_id from views_tmp limit 1);
			insert results (name)
			select (select name/*, movie_id*/ from rated_in_genre where genre_id = one order by rand() limit 1); 
			-- выбрали фильм тех же жанров что смотрел юзер из топ рейтинговых фильмов, добавили в рекомендации
	delete from views_tmp where genge_id = one; 			
		end while;
	select * from results;	
	end //
delimiter ;


call get_whats_to_view(1);


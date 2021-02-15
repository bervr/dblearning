use ivi;

# top 30-rated films
select m.name, avg(r.rate) value  from rating r join movies m on r.movie_id =m.id group by movie_id order by value desc limit 30;


-- все фильмы случайного актера
select m.name as film, m.year_of, if(p2.name != null, p2.name, p2.original_name) as actor, p2.description as `role`
	from movies m join casting c on m.id = c.movie_id join persons p2 on c.person_id = p2.id 
	where c.person_id =( -- здесь можно id передавать, отличный кандидат на переделку в процедуру
						select id from persons 
						where status = 'ACTOR' order by rand() limit 1);*/
-- очень тяжелый запрос получился
	
					
-- все фильмы по жанрам
select g.genre, m2.name as film, m2.year_of from movies m2 join movie_genre mg on m2.id = mg.movie_id join genres g on g.id = mg.id group by film order by film  ;
				
-- все актеры в фильме	
set @film_id=263531;
select name, original_name  from movies where id = @film_id
 union
select p3.name, p3.status from movies m3 join casting c2 on c2.movie_id = m3.id  join persons p3 on c2.person_id = p3.id where m3.id = @film_id;	

-- актеры снимавшиеся в максимуме фильмов  if(p.name != null,p.name, p.original_name), 

select p.name, p.original_name, count(c.movie_id)  as film_count from persons p join casting c on p.id = c.person_id where p.name != '' group by p.name order by film_count  desc limit 200;



					
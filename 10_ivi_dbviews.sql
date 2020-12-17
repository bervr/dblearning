use ivi;

drop view if exists novelty;
CREATE VIEW novelty AS 
	SELECT name, year_of, country, description  
	from movies where year_of like '201%';

drop view if exists cartoons;
CREATE VIEW cartoons AS 
	SELECT name, g.genre, year_of, country, description  
	from movies m join movie_genre mg on m.id=mg.movie_id join genres g on mg.id = g.id 
	where g.genre like 'мульт%';


drop view if exists short_films;
CREATE VIEW short_films AS 
	SELECT name, year_of, country, duration, description  
	from movies m  
	where duration between  	'00:00:01' and 	'00:35:00';


drop view if exists recently;
CREATE VIEW recently AS 
	SELECT name, year_of, country, duration, vh.viewed_at   
	from movies m join views_history vh on m.id = vh.movie_id  
	where vh.viewed_at > date_sub(now(), interval 5 day);

drop view if exists rated_in_genre;
CREATE VIEW rated_in_genre AS 
select mg.id as genre_id, g.genre, mg.movie_id, m.name, avg(r2.rate) 
from movie_genre mg join rating r2 on mg.movie_id = r2.movie_id 
join movies m on mg.movie_id= m.id 
join genres g on g.id = mg.id 
group by mg.movie_id order by mg.id;

drop view if exists rated_in_genre;
CREATE VIEW rated_in_genre AS 


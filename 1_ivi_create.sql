drop database if exists ivi;
create database ivi;
use ivi;


drop table if exists accounts;
create table accounts(
	id serial primary key,
	nikname varchar(50) unique,
	firstname varchar(50),
	lastname varchar(50) comment 'Фамилия пользователя',
	email varchar(120) unique,
	email_confirmed bool default 0,
	phone varchar(20) unique,
	phone_confirmed bool default 0,
	birthday date,
	photo_id bigint unsigned,
	created_at datetime default now(),
	subscription bool,
	subscription_before datetime,
	pass char(45)
) comment 'Основные настройки аккаунта';
create index indx_accounts_name ON accounts (firstname);
create index indx_accounts_email ON accounts (email);
create index indx_accounts_phone ON accounts (phone(6) );
create index indx_accounts_nikname ON accounts (nikname);

drop table if exists notification; 
create table notification(
account_id bigint unsigned,
send_adw_sms  bool default 0,
send_adw_email  bool default 1,
send_adw_push  bool default 0,
send_ivinews_sms  bool default 0,
send_ivinews_email  bool default 1,
send_ivinews_push  bool default 0,
send_novelty_sms  bool default 0,
send_novelty_email  bool default 1,
send_novelty_push  bool default 0,
send_account_sms  bool default 1,
send_account_email  bool default 1,
send_account_push  bool default 0,
foreign key (account_id) references accounts(id)
) comment 'Настройки уведомлений';
create index indx_notification ON notification (account_id);


drop table if exists profiles; 
create table profiles(
	id serial primary key,
	account_id bigint unsigned,
	name varchar(50),
	created_at datetime default now(),
	photo_id bigint unsigned,
	is_active bool default 1,
	language_set enum('ru', 'en') default 'ru',
	adult_restriction enum ('allowed','denied'),
	foreign key (account_id) references accounts(id)
)comment 'Профили аккаунта'; /* по сути  у аккаунта может быть больше одного пользователя с разными настройками просмотра, историей и рекомендациями, 
например основной  и детский. Или руский и английский*/
create index indx_profiles_name ON profiles (name);
create index indx_profiles_id ON profiles (account_id);

drop table if exists genres; 
create table genres( 
id serial primary key,
genre varchar(50)
)comment 'Жанры, у фильма может быть больше одного жанра';


drop table if exists movies;
create table movies( 
id serial primary key,
name varchar(255),
original_name varchar(255),
year_of year,
country varchar(20),
duration time comment 'длительность',
description text,
poster_id bigint unsigned
)comment 'Фильмы';
create index indx_movies_name  ON movies(name);
create index indx_movies_name_orig  ON movies(original_name);



drop table if exists movie_genre;
create table movie_genre( 
id bigint unsigned,
movie_id bigint unsigned,
foreign key (id) references genres(id),
foreign key (movie_id) references movies(id)
)comment 'жанры и фильмы';
create index indx_movie_genre_name  ON movie_genre(movie_id);

drop table if exists persons;
create table  persons(
id serial primary key,
name varchar(255),
original_name varchar(255),
photo_id bigint unsigned,
description text,
biography text,
status tinytext
)comment 'Актеры и создатели ';
-- drop index  indx_persons_name ON persons;
create index indx_persons_name ON persons (name);


drop table if exists casting; 
create table  casting(
person_id bigint unsigned,
movie_id bigint unsigned,
foreign key (person_id) references persons(id),
foreign key (movie_id) references movies(id)
)comment 'Актеры в ролях фильмов и фильмы с участием актера';
create index indx_casting_person ON casting (person_id);
create index indx_casting_movie ON casting (movie_id);

drop table if exists purchases;
create table  purchases(
account_id bigint unsigned,
movie_id bigint unsigned,
purchase_date timestamp,
purchase_type enum('temporary', 'permanent'),
timebond datetime,
foreign key (account_id) references accounts(id),
foreign key (movie_id) references movies(id)
)comment 'Оплаченные фильмы  аккаунта';


drop table if exists views_history;
create table  views_history( 
profile_id bigint unsigned,
movie_id bigint unsigned,
timeline time default 0,
viewed_at datetime default current_timestamp,
foreign key (profile_id) references profiles(id),
foreign key (movie_id) references movies(id)
) COMMENT = 'история просмотров'; 


drop table if exists wanted_to_view;
create table  wanted_to_view ( 
profile_id bigint unsigned,
movie_id bigint unsigned,
check_up datetime default current_timestamp on update current_timestamp,
foreign key (profile_id) references profiles(id),
foreign key (movie_id) references movies(id)
)COMMENT = 'фильмы отмеченые чтобы смотреть позже'; 

drop table if exists rating;
create table  rating ( 
id serial primary key,
movie_id bigint unsigned,
profile_id bigint unsigned,
rated_at datetime default current_timestamp on update current_timestamp,
rate tinyint,
foreign key (profile_id) references profiles(id),
foreign key (movie_id) references movies(id)
)COMMENT = 'оценки пользователей для фильмов'; 
create index indx_rating_rate ON rating (rate);
create index indx_rating_movie ON rating (movie_id);


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
	email_confirmed bool,
	phone varchar(20) unique,
	phone_confirmed bool,
	birtday date,
	photo_id bigint unsigned,
	created_at datetime default now(),
	subscription bool,
	subscription_before datetime,
	pass char(30)
) comment 'Основные настройки аккаунта';


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


drop table if exists profiles; 
create table profiles(
	id serial primary key,
	account_id bigint unsigned,
	name varchar(50),
	created_at datetime default now(),
	photo_id bigint unsigned,
	is_active bool default 1,
	language_set enum('ru', 'en'),
	adult_restriction enum ('allowed','denied'),
	foreign key (account_id) references accounts(id)
)comment 'Профили аккаунта'; /* по сути  у аккаунта может быть больше одного пользователя с разными настройками просмотра, историей и рекомендациями, 
например основной  и детский. Или руский и английский*/


drop table if exists movie_categories; 
create table movie_categories( 
id serial primary key,
category varchar(50)
)comment 'Категории, у фильма может быть больше одной категории';


drop table if exists movie_genre; 
create table movie_genre( 
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
poster_id bigint unsigned,
genre bigint unsigned,
movie_category bigint unsigned,
foreign key (genre) references movie_genre(id),
foreign key (movie_category) references movie_categories(id)
)comment 'Фильмы';


drop table if exists actors;
create table  actors(
id serial primary key,
name varchar(255),
original_name varchar(255),
photo_id bigint unsigned,
description text,
biography text
)comment 'Актеры ';


drop table if exists casting; 
create table  casting(
actor_id bigint unsigned,
movie_id bigint unsigned,
foreign key (actor_id) references actors(id),
foreign key (movie_id) references movies(id)
)comment 'Актеры в ролях фильмов и фильмы с участием актера';
 

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

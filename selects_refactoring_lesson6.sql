-- первые два я не придумал как оптимизировать, в 3-м  очевидно нужно избавиться от дублирования кода
set @my_uid =  76 ; -- добавим переменнную чтобы не указывать в 3-х местах этого пользователя
select * from
((select 
	(select concat(firstname, ' ', lastname) from users u where u.id = p.user_id) 'author',
	post,
	created_at,
	(select count(*) from likes lp where lp.like_for = 'post' and  lp.like_object_id = p.id ) 'likes_count' -- тут немного допилил под свою базу
from posts p where user_id =  @my_uid /*)
union
(select (select concat(firstname, ' ', lastname) from users u where u.id = p.user_id) 'author',
	post,
	created_at,
	(select count(*) from likes lp where lp.like_for= 'post' and  lp.like_object_id = p.id ) 'likes_count'
from posts p where*/  -- этот кусок полностью повторяет предыдущий
or 
user_id in (select initiator_user_id from friend_requests fr1 where target_user_id =  @my_uid and status='approved'
		union
	select target_user_id from friend_requests fr2 where initiator_user_id =  @my_uid and status='approved')) 
)tmp_tbl;


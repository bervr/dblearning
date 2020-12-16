

use ivi;
-- функция заполнения фото id если его нет  равным id пользователя
-- написать
drop trigger if exists create_first_profile;
drop trigger if exists create_nikname;
delimiter //

create trigger create_first_profile after insert on accounts
for each row
begin
	insert profiles (account_id, name, photo_id, adult_restriction) values (new.id, new.nikname, new.id, 'allowed')  ;
	insert notification (account_id) values (new.id);
end //

create trigger create_nikname before insert on accounts
for each row
begin
	if new.photo_id is null then 
		SET new.photo_id = new.id;
	end if;
	if new.nikname is null then 
		SET new.nikname = new.email;
	end if;
end //
delimiter ;

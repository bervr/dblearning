use ivi;

drop trigger if exists create_first_profile;
delimiter //
create trigger create_first_profile after insert on accounts
for each row
begin
	insert profiles (account_id, name, photo_id, adult_restriction) select new.id, new.nikname, new.id, 'allowed'  from accounts;
	insert notification (account_id) select new.id from accounts;
end //
delimiter ;



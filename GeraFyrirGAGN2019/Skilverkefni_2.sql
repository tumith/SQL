use Skilaverkefni_2;

/* 1:
	Smíðið trigger fyrir insert into Restrictors skipunina. 
	Triggernum er ætlað að koma í veg fyrir að einhver áfangi sé undanfari eða samfari síns sjálfs. 
	með öðrum orðum séu courseNumber og restrictorID með sama innihald þá stoppar triggerinn þetta með
	því að kasta villu og birta villuboð.
	Dæmi um insert sem triggerinn á að stoppa: insert into Restrictors values('GSF2B3U','GSF2B3U',1);
*/
delimiter $$
drop trigger if exists viluboð $$
create trigger viluboð
before update on Restrictors
for each row
	begin
		declare msg varchar(255);
        if (new.courseNumber = new.restrictorID) then
			set msg = concat('courseNumer er það sama og restrictorsID', cast(new.restrictorID as char));
            signal sqlstate '45000' set message_text = msg;
		end if;
            
	end $$

delimiter ;
drop table Restrictors;
insert into Restrictors(courseNumber,restrictorID,restrictorType)
values('GSF2A3U','GSF2A3U',1);

select * from Restrictors;

-- 2:
-- Skrifið samskonar trigger fyrir update Restrictors skipunina.
delimiter $$
drop trigger if exists UpdateRestrictors $$
create trigger UpdateRestrictors
after update on Restrictors;
for each row
	begin
    
    end $$
delimiter ;

/*
	3:
	Skrifið stored procedure sem leggur saman allar einingar sem nemandinn hefur lokið.
    Birta skal fullt nafn nemanda, heiti námsbrautar og fjölda lokinna eininga(
	Aðeins skal velja staðinn áfanga. passed = true
*/


/*
	4:
	Skrifið 3 stored procedure-a:
    AddStudent()
    AddMandatoryCourses()
    Hugmyndin er að þegar AddStudent hefur insertað í Students töfluna þá kallar hann á AddMandatoryCourses() sem skráir alla
    skylduáfanga á nemandann.
    Að endingu skrifið þið stored procedure-inn StudentRegistration() sem nota skal við sjálfstæða skráningu áfanga nemandans.
*/


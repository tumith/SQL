delimiter $$
drop procedure if exists CursorDemo $$

create procedure CursorDemo()
begin
	-- breyta til að taka á móti aircraftID
	declare a_craft_id char(6);
    -- breyta til að taka við aircraftType
	declare a_craft_type varchar(35);
	-- stoppbreytan fyrir cursor lúppuna skilgreindur
	declare done int default false;
	-- cursorinn sjálfur skilgreindur með tilheyrandi fyrirspurn
	declare aircraftCursor cursor 
		for select aircraftID,aircraftType from Aircrafts;
	-- stopp höndlarinn er alltaf skilgreindur á eftir cursornum sjálfum
	declare continue handler for not found set done = true;
    
    drop table if exists UppercaseAircrafts;
    create temporary table UppercaseAircrafts(a_ID char(6),a_Type varchar(35));
    
	-- við það að opna cursorinn er fyrirspurnin keyrð og resultið úr henni gert aðgengilegt röð fyrir röð
	open aircraftCursor;
	-- Nú er kominn aðgangur í hverja einustu röð á það sem að select fyrirspurnin skilaði
	-- og byrjað er að lúppa "efst / fremst/"
	read_loop: loop
		-- innihaldið í viðkomandi röð sett í breyturnar
		fetch aircraftCursor into a_craft_id,a_craft_type;
		-- Tékkað á því hvort að það eigi að hætta(ef ekkert kom út úr fetch aðgerðinni)
		if done then
		  leave read_loop;
		end if;

		-- Hérna er svo unnið með gögnin í cursornum:
		-- Í hverri umferð eru gögnin í breytunum sett í uppercase og insertuð í 
		-- temporary töfluna UppercaseAircrafts
		insert into UppercaseAircrafts values(upper(a_craft_id),upper(a_craft_type));
	end loop;

	close aircraftCursor;	-- Cursorinn endar hér..
	-- Og svo í lokinn selectar procedurinn úr temp töflunni 
    select * from UppercaseAircrafts;
END $$

delimiter ;

call CursorDemo();


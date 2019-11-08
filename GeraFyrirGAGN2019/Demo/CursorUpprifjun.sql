delimiter $$
drop procedure if exists getAircraftListXML $$

/*
		Þessi SP notar Cursor til að sækja AirCraftID og AircraftType úr FreshAir grunninum og 
		"embedda" í XML skrá:
		Í línu 26 er tekin frá svona loop control breyta sem síðan er notuð í cursornum.
		í línu 29 er sjálfur Cursorinn skilgreindur en það er alltaf gert á þennan hátt.  Fyrirspurnin sem liggur til grundvallar er 
		hnýtt við cursorinn með for skipuninni.
		Í línu 33 er skilgreindur svokallaður continue handler en það er eiginlega skipun sem flippar gildinu á done
		breytunni þegar cursorinn er kominn á enda í resultsettinu sem select fyrirspurnin skilaði.
		lÍna 39 opnar cursorinn
		Línur 42 - 52 eru cursorinn sjálfur að fara í gegn um resultsettið og vinna með breyturnar
		lína 56 lokar svo cursornum, en það verður alltaf að gera se´rstaklega af keyra á hann aftir í sömu "session"
*/
create procedure getAircraftListXML()
begin
	-- breytur til að taka á móti gögnum úr cursornum(1 stk. per dálk sem á að nota)
	declare a_craft_id char(6);
	declare a_craft_type varchar(35);

	-- inn í þennan streng fer xml-ið sem búið er til í cursornum
	declare xml_string text;

	-- stoppbreytan fyrir cursor lúppuna skilgreindur
	declare done int default false;

	-- cursorinn sjálfur skilgreindur með tilheyrandi fyrirspurn
	declare aircraftCursor cursor 
		for select aircraftID,aircraftType from Aircrafts;

	-- stopp höndlarinn er alltaf skilgreindur á eftir cursornum sjálfum
	declare continue handler for not found set done = true;

	-- skilastrengurinn frumstilltur á rótarelementið sem nota skal.  getur endað með leiðindum ef það er ekki gert
	set xml_string = '<aircrafts>';
	
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

		-- Hérna er svo gagnavinnslufjörið
		set xmL_string = concat(xmL_string,'<aircraft><id>',a_craft_id,'</id><type>',a_craft_type,'</type></aircraft>');
	end loop;
	-- rótar elementinu lokað utan um herlegheitin
	set xmL_string = concat(xmL_string,'</aircrafts>');

	close aircraftCursor;
	-- Cursorinn endar hér..
	select xml_string;
END $$

delimiter ;

call getAircraftListXML();


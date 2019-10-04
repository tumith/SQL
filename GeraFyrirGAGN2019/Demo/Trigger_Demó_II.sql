-- ------------------------------------ DEMO II ------------------------------------------------
use ProgressTracker_V6;

-- Við setjum þennan trigger á Semesters töfluna í ProgressTracker gagnagrunninum
-- vegna þess að þar eru góð not fyrir hann!!

delimiter $$
drop trigger if exists check_semester_dates $$
-- Eitt af þeim verkefnum sem við verðum að leysa með triggerum í MySQL er að setja reglur um innihald dálka.
-- Í flestum gagnagrunnskerfum er þetta gert með check klausunni en hana hefur MySQL ekki.
-- Dæmi um svona regluverk er að passa uppá að upphafsdagsetning seḿesturs sé ekki á eftir(eða jöfn) 
-- endagsetningu.  
-- check_semester_dates triggerinn framkvæmir þetta test í hvert sinn sem keyrt er insert into á Semesters töfluna.
-- Hann er skilgreindur sem "before trigger" vegna þess að hann þarf að geta stoppað insertið ef það inniheldur
-- ólöglegar dagsetningar.
-- Setningin if (new.semesterEnds <= new.semesterStarts) then  er svo tékkið sjálft
create trigger check_semester_dates
before insert on Semester
for each row
begin
     declare msg varchar(255);
	 -- tímagildin úr insert skipuninni skoðuð
     if (new.semesterEnds <= new.semesterStarts) then
			-- Villuskilaboðin undirbúin og sett í breytuna msg
            set msg = concat('Semester end must be after Semester start', cast(new.semesterEnds as char));
			-- Villu er kastað og villuskilaboðin birt
            signal sqlstate '45000' set message_text = msg;
     end if;
end $$
delimiter ;

-- Setjum gögn í Semester töfluna með insert skipun sem gangsetur trigger
insert into Semester(semesterStarts,semesterEnds,semesterName,academicYear)values('2012-08-01','2012-12-15','Haustönn','2012-2013');	-- Virkar
insert into Semester(semesterStarts,semesterEnds,semesterName,academicYear)values('2013-01-01','2012-12-15','Vorönn','2012-2013');		-- Virkar ekki
insert into Semester(semesterStarts,semesterEnds,semesterName,academicYear)values('2013-08-01','2013-08-01','Haustönn','2013-2014');	-- Virkar ekki

select * from Semester;



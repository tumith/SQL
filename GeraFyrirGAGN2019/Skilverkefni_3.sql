use Skilaverkefni;
/*
1:
	Skrifið stored procedure: StudentListJSon() sem notar cursor til að breyta vensluðum gögnum í JSon string.
	JSon-formuð gögnin eru listi af objectum.
	OBS: StudentListJSon skilar texta sem þið hafið formað.

	Niðurstöðurnar ættu að líta einhvern vegin svona út:

	[
		  {"first_name": "Guðrún", "last_name": "Ólafsdóttir", "date_of_birth": "1999-03-31"},
		  {"first_name": "Andri Freyr", "last_name": "Kjartansson", "date_of_birth": "2000-11-01"},
		  {"first_name": "Tinna Líf", "last_name": "Björnsson", "date_of_birth": "1998-08-14"},
		  {"first_name": "Magni Þór", "last_name": "Sigurðsson", "date_of_birth": "2000-05-27"},
		  {"first_name": "Rheza Már", "last_name": "Hamid-Davíðs", "date_of_birth": "2001-09-17"},
		  {"first_name": "Hadría Gná", "last_name": "Schmidt", "date_of_birth": "1999-07-29"},
		  {"first_name": "Jasmín Rós", "last_name": "Stefánsdóttir", "date_of_birth": "1996-02-29"}
	]
*/
delimiter $$
drop procedure if exists StudentJSon $$
create procedure StudentJSon()
begin
declare fn varchar(255);
declare ln varchar(255);
declare dob date;
declare done int default false;
    declare nemendur longtext;
   
    declare cursorName cursor 
		for select Students.firstName, Students.lastName, Students.dob from Students;
           
declare continue handler for not found set done = true;
set nemendur = '[';
open cursorName;
   
    -- EKKI nota getcursorname.  Nota allsstaðar cursorName.
    -- Og á meðan ég man:  cursorName er algerlaga glatað nafn á cusros :-)
coursorName: loop
fetch cursorName into fn,ln,dob;
        if done then leave coursorName;
end if;
        -- Nota concat fallið til að setja saman JSon strenginn
        set nemendur = concat(nemendur, '{"first_name": ','"', fn,'", ',
										'"last_name": ','"', ln, '", ',
                                        '"date_of_birth": ','"', dob, '"},');
end loop;

	set nemendur = trim(trailing ',' from nemendur);
set nemendur = concat(nemendur,']');

close cursorName;
select nemendur;
end $$
delimiter ;
call StudentJSon();

/*
	2:
	Skrifið nú SingleStudentJSon()þannig að nemandinn innihaldi nú lista af þeim áföngum sem hann hefur tekið.
	Śé nemandinn enn við nám þá koma þeir áfangar líka með.
	ATH: setjið nemandann sem object.
	Líkleg niðurstaða:

	{
		"student_id": "1",
		"first_name": "Guðrún",
		"last_name": "Ólafsdóttir",
		"date_of_birth": "1999-03-31",
		"courses" :[
		  {"course_number": "STÆ103","course_credits": "5","status": "pass"},
		  {"course_number": "EÐL103","course_credits": "5","status": "pass"},
		  {"course_number": "STÆ203","course_credits": "5","status": "pass"},
		  {"course_number": "EÐL203","course_credits": "5","status": "pass"},
		  {"course_number": "STÆ303","course_credits": "5","status": "pass"},
		  {"course_number": "GSF2A3U","course_credits": "5","status": "pass"},
		  {"course_number": "FOR3G3U","course_credits": "5","status": "pass"},
		  {"course_number": "GSF2B3U","course_credits": "5","status": "pass"},
		  {"course_number": "GSF3B3U","course_credits": "5","status": "fail"},
		  {"course_number": "FOR3D3U","course_credits": "5","status": "fail"}
		]
	}
*/
delimiter $$
drop procedure if exists SingleStudentJSon $$
create procedure SingleStudentJSon()
begin
declare cn varchar(255);
declare st varchar(255);
declare done int default false;
    declare nemendur longtext;
   
    declare cursorName
cursor for
select Courses.courseNumber, Courses.courseCredits from Courses;

declare continue handler for not found set done = true;
set nemendur = '[';

open cursorName;

coursorName: loop
fetch cursorName into cn,st;
        if done then leave coursorName;
end if;
        -- Nota concat fallið til að setja saman JSon strenginn
        set nemendur = concat(nemendur, '{"courseNumber": ','"', cn,'", ',
                                        '"courseCredits": ','"', st, '"},');
end loop;

	set nemendur = trim(trailing ',' from nemendur);
set nemendur = concat(nemendur,']');

close cursorName;
select nemendur;

end $$
delimiter ;
call SingleStudentJSon();
/*
	3:
	Skrifið stored procedure: SemesterInfoJSon() sem birtir uplýsingar um ákveðið semester.
	Semestrið inniheldur lista af nemendum sem eru /hafa verið á þessu semestri.
	Og að sjálfsögðu eru gögnin á JSon formi!

	Gæti litið út einhvern veginn svona(hérna var semesterID 8 notað á original gögnin:
	[
		{"student_id": "1", "first_name": "Guðrún", "last_name": "Ólafsdóttir", "courses_taken": "2"},
		{"student_id": "2", "first_name": "Andri Freyr", "last_name": "Kjartansson", "courses_taken": "1"},
		{"student_id": "5", "first_name": "Rheza Már", "last_name": "Hamid-Davíðs", "courses_taken": "2"},
		{"student_id": "6", "first_name": "Hadríra Gná", "last_name": "Schmidt", "courses_taken": "2"}
	]
*/
delimiter $$
drop procedure if exists SemesterInfoJSon $$
create procedure SemesterInfoJSon()
begin
declare si int;
declare fn varchar(255);
declare ln varchar(255);
declare ct int;

declare done int default false;
    
    declare nemendur longtext;
   
    declare cursorName
cursor for
select Students.studentID, Students.firstName, Students.lastName, count(courseNumber) as number_of_courses
from Students
inner join Registration on Students.studentID = Registration.studentID
and Registration.semesterID = semester_id
group by Students.studentID;

declare continue handler for not found set done = true;
set nemendur = '[';

open cursorName;

coursorName: loop
fetch cursorName into si,fn,ln,ct;
        if done then leave coursorName;
end if;
        -- Nota concat fallið til að setja saman JSon strenginn
        set nemendur = concat(nemendur, '{"student_id": ','"', si,'", ',
										'"first_name": ','"', fn,'", ',
                                        '"last_name": ','"', ln,'", ',
                                        '"course_taken": ','"', ct, '"},');
end loop;

	set nemendur = trim(trailing ',' from nemendur);
set nemendur = concat(nemendur,']');

close cursorName;
select nemendur;

end $$
delimiter ;
call SemesterInfoJSon();
-- ACHTUNG:  2 og 3 nota líka cursor!


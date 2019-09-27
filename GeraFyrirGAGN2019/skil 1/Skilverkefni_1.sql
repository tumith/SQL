use Skilaverkefni_1;
-- 1:
-- Birtið lista af öllum áföngum sem geymdir eru í gagnagrunninum.
-- Áfangarnir eru birtir í stafrófsröð
delimiter $$
drop procedure if exists CourseList $$

create procedure CourseList()
begin
	select courseName from Courses;
end $$
delimiter ;

call CourseList();

-- 2:
-- Birtið upplýsingar um einn ákveðin áfanga.
delimiter $$
drop procedure if exists SingleCourse $$

create procedure SingleCourse()
begin
	select * from Courses where courseName = ("3D leikjaforritun");
end $$
delimiter ;

call SingleCourse();

-- 3:
-- Nýskráið áfanga í gagnagrunninn.
-- Það þarf að skrá áfanganúmerið, áfangaheitið og einingafjöldann
delimiter $$
drop procedure if exists NewCourse $$

create procedure NewCourse(in courseNumer char(10),courseNafn varchar(75),courseStig int)
begin
	insert into courses(courseNumber,courseName,courseCredits)
    values (courseNumer,courseNafn,courseStig);
    
end $$
delimiter ;

call NewCourse('STÆ209', 'Stærfræði fyrir kennara',5);

-- 4:
-- Uppfærið réttan kúrs.
-- row_count() fallið er hér notað til að birta fjölda raða sem voru uppfærðar.
delimiter $$
drop procedure if exists UpdateCourse $$

create procedure UpdateCourse(in CNumer char(10),CNafn varchar(75),CStig int)
begin
	  update courses
      set courseName = CNafn,courseCredits = CStig
      where courseNumber = CNumer;
end $$
delimiter ;

call UpdateCourse('GSF2A3U','fyrir kennara', 5);
-- 5:
-- ATH: Ef verið er að nota áfangann einhversstaðar(sé hann skráður á TrackCourses töfluna) þá má EKKI eyða honum.
-- Sé hins vegar hvergi verið að nota hann má eyða honum úr bæði Courses og Restrictor töflunum.
delimiter $$
drop procedure if exists DeleteCourse $$

create procedure DeleteCourse(in CuNumer char(10))
begin
	  delete from courses where courseNumber = CuNumer;
end $$
delimiter ;

call DeleteCourse('CNA103');
-- 6:
-- fallið skilar heildarfjölda allra áfanga í grunninum
delimiter $$
drop function if exists NumberOfCourses $$
    
create function NumberOfCourses()
returns int
no sql
begin
	return(
	select count(courseNumber)
    from courses);
end $$
delimiter ;
select NumberOfCourses();

-- 7:
-- Fallið skilar heildar einingafjölda ákveðinnar námsleiðar(Track)
-- Senda þarf brautarNumer inn sem færibreytu
delimiter $$
drop function if exists TotalTrackCredits $$
    
create function TotalTrackCredits(braut int)
returns int
no sql
begin
	-- Join track to trackcourse og Join trackcourse to courses nota inner join
    return(
    select sum(courseCredits) 
    from Tracks
		inner join TrackCourses on Tracks.trackID = TrackCourses.trackID
		inner join Courses on TrackCourses.courseNumber = Courses.courseNumber
    where Tracks.trackID = braut
    );
end $$
delimiter ;

select TotalTrackCredits(9);
-- 8: 
-- Fallið skilar heildarfjölda áfanga sem eru í boði á ákveðinni námsleið
delimiter $$
drop function if exists TotalNumberOfTrackCourses $$
    
create function TotalNumberOfTrackCourses(braut2 int)
returns int
no sql
begin
	return(
		select count(braut2)
		from Tracks
			inner join TrackCourses on Tracks.trackID = TrackCourses.trackID
			inner join Courses on TrackCourses.courseNumber = Courses.courseNumber
		where TrackCourses.trackID = braut2
    );
end $$
delimiter ;

select TotalNumberOfTrackCourses(9)
-- 9:
-- Fallið skilar true ef áfanginn finnst í töflunni TrackCourses
delimiter $$
drop function if exists CourseInUse $$
    
create function CourseInUse(CouNumber char(10))
returns boolean
no sql
begin
	return(
		if (
        (select count(courseNumber) from TrackCourses where courseNumber = CouNumber),true,false)
    );
end $$
delimiter ;

select CourseInUse('GSF2A3U')

-- 10:
-- Fallið skilar true ef +arið er hlaupár annars false
delimiter $$
drop function if exists IsLeapyear $$

create function IsLeapYear(ar int)
returns boolean
no sql
begin
	case
		when ar % 400 = 0 then return(true);
        when ar % 100 = 0 then return(false);
        when ar % 4 = 0 then return(true);
        else return(false);
    end case;
end $$
delimiter ;
select IsLeapYear(2011);

-- 11:
-- Fallið reiknar út og skilar aldri ákveðins nemanda
delimiter $$
drop function if exists StudentAge $$
    
create function StudentAge(nemandaID int)
returns int
no sql
begin
	return(
		Year(current_date) - year((select dob from Students where studentID = nemandaID))
    );
end $$
delimiter ;
select StudentAge(2);

-- 12:
-- Fallið skilar fjölda þeirra eininga sem nemandinn hefur tekið(lokið)
delimiter $$
drop function if exists StudentCredits $$
    
create function StudentCredits()
returns int
no sql
begin
	-- Registration þarf að tengjast við Courses. Registration segir hvaða áfangi hver nemadni er í en courses inni heldur einkuninna á hverjum áfanga svo það þarf að teingja þá saman svo Registration getur náð í einganirnr frá courses og lagt þær samman
	return(
		join Registration on Courses 
    );
end $$
delimiter ;
select studentID,registrationDate,sum(courseCredits)
from Registration
	NATURAL JOIN Courses
where studentID = 1 and passed = 1;

-- 14:
-- Hér þarf skila lista af öllum áföngum ásamt restrictorum og tegund þeirra.
-- Hafi áfangi enga undanfara eða samfara þá birtast þeir samt í listanum.
delimiter $$
drop procedure if exists CourseRestrictorList $$

create procedure CourseRestrictorList()
begin
	SELECT courses.courseNumber, courses.courseName, courses.courseCredits, Restrictors.courseNumber, Restrictors.restrictorID, Restrictors.restrictorType
    FROM courses
    LEFT outer JOIN Restrictors ON courses.courseNumber = Restrictors.courseNumber;
end $$
delimiter ;
call CourseRestrictorList();

-- 15:
-- RestrictorList birtir upplýsingar um alla restrictora ásamt áföngum.
-- Með öðrum orðum: Gemmér alla restrictora(undanfara, samfara) og þá áfanga sem þeir hafa áhrif á.
delimiter $$
drop procedure if exists RestrictorList $$

create procedure RestrictorList()
begin
	SELECT *
    FROM courses
    LEFT outer JOIN Restrictors ON courses.courseNumber = Restrictors.courseNumber;
end $$
delimiter ;
call RestrictorList();
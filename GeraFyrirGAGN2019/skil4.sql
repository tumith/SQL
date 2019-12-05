use ProgressTracker_V6;

select * from Courses;
-- Courses
delimiter $$
drop procedure if exists GetCourse $$

create procedure GetCourse(CNumber char(10))
begin
	select * from Courses where courseName = CNumber;
end $$
delimiter ;

-- call GetCourse('CNA104');

delimiter $$
drop procedure if exists NewCourse $$

create procedure NewCourse(in courseNumer char(10),courseNafn varchar(75),courseStig int)
begin
	insert into courses(courseNumber,courseName,courseCredits)
    values (courseNumer,courseNafn,courseStig);
    
end $$
delimiter ;

-- call NewCourse('CNA104', 'Netkefun sem nemendur kenna ',5);


delimiter $$
drop procedure if exists UpdateCourse $$

create procedure UpdateCourse(in CNumer char(10),CNafn varchar(75),CStig int)
begin
	  update courses
      set courseName = CNafn,courseCredits = CStig
      where courseNumber = CNumer;
end $$
delimiter ;

delimiter $$
drop procedure if exists DeleteCourse $$

create procedure DeleteCourse(in CuNumer char(10))
begin
	  delete from courses where courseNumber = CuNumer;
end $$
delimiter ;

-- call DeleteCourse('CNA104');

select * from Students;
-- Students
delimiter $$
drop procedure if exists GetStudent $$

create procedure GetStudent(getSID int)
begin
	select * from Students where firstname = getSID;
end $$
delimiter ;

-- call GetStudent(9);

delimiter $$
drop procedure if exists NewStudent $$

create procedure NewStudent(in fname varchar(55),lname varchar(55),dob date, startsem int)
begin
	insert into Students (firstname,lastname,dob,startSemester)
    values (fname,lname,dob,startsem);
    
end $$
delimiter ;

-- call NewStudent('Big', 'Ben', '2091-8-2', 9);


delimiter $$
drop procedure if exists UpdateStudent $$

create procedure UpdateStudent(in fnafn varchar(55),lnafn varchar(75), ndob date, nstartsem int)
begin
	  update Students
      set firstname = fnafn,startSemester = nstartsem
      where dob = ndob;
end $$
delimiter ;

delimiter $$
drop procedure if exists DeleteStudent $$

create procedure DeleteStudent(in inSchID char(10))
begin
	  delete from Students where studentID = inSchID;
end $$
delimiter ;

-- call DeleteStudent(9);

select * from Schools
-- Schools
delimiter $$
drop procedure if exists GetSchool $$

create procedure GetSchool(SchNumber int)
begin
	select * from Schools where schoolID = SchNumber;
end $$
delimiter ;

-- call GetSchool(2);

delimiter $$
drop procedure if exists NewSchool $$

create procedure NewSchool(in SchoolNafn varchar(55))
begin
	insert into Schools(schoolName)
    values (SchoolNafn);
    
end $$
delimiter ;

-- call NewSchool('HrólfaSkóli');


delimiter $$
drop procedure if exists UpdateSchool $$

create procedure UpdateSchool(in SchName varchar(55), SchID int)
begin
	  update Schools
      set schoolName = SchName
      where schoolID = SchID;
end $$
delimiter ;

delimiter $$
drop procedure if exists DeleteSchool $$

create procedure DeleteSchool(in schNumer int)
begin
	  delete from Schools where schoolID = schNumer;
end $$
delimiter ;

-- call DeleteSchool(2);
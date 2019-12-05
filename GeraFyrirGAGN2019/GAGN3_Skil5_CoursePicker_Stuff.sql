delimiter $$
drop procedure if exists CoursePicker $$

create procedure CoursePicker(student_id int, current_semester int)
begin
	drop table if exists PossibleCourses;
	create temporary table PossibleCourses(courseNumber char(15), restrictorID char(15));
    
    insert into PossibleCourses(courseNumber, restrictorID)
    select Courses.courseNumber, Restrictors.restrictorID
	from Courses
	left outer join Restrictors on Courses.courseNumber = Restrictors.courseNumber
	where Courses.courseNumber not in(select courseNumber from Registration 
					  where (passed = true or semesterID >= current_semester) and StudentID = student_id)
	order by Courses.courseNumber;

    select distinct courseNumber from PossibleCourses where restrictorID is null;
end $$
delimiter ;

call CoursePicker(1,9);

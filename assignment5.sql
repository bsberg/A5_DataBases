use university;


select "1.";
#1. List how many students for each department. 
select department.dept_name, ifnull(count(ID), 0) as count
from department left join student
on (student.dept_name = department.dept_name)
group by department.dept_name;

select "2.";
#2. List the total number of sections by courses offered by each department in Spring 2008
select department.dept_name, ifnull(count(course_id), 0) as total_offering  
from department left join 
(select * from course natural join section where semester="Spring" and year= 2008) as a 
on department.dept_name = a.dept_name 
group by department.dept_name order by total_offering desc;

select "3.";
#3.List the course and how many sections that it has been offered in history in  
# descending order.
select course.course_id, course.title,ifnull(count(section.course_id), 0) as total_offering
from course left join section on (course.course_id = section.course_id)
group by course.course_id
order by total_offering desc;


select "4.";
# 4.List the total credit hours for instructors who taught in Spring 2008 in  
# descending. You need to include all instructors in  the output, even the ones who 
# didn’t teach. The total credit hours is calculated by the sum of course  credit * student 
# number  for all classes that an instructor teaches.
select instructor.ID, instructor.name, ifNull(sum(credits * numStudents), 0) as credit_hours
from instructor left join
(select *
from (select *
from teaches natural join course
where semester="Spring" and year =2008
) as aa
natural join
(select course_id, count(*) as numStudents
from student natural join takes
where year=2008 and semester="Spring"
group by course_id
) as c
) as ccc
on (instructor.ID = ccc.ID)
group by instructor.ID
order by credit_hours desc;


select "5.";
# 5.Generate the transcript for student whose id is 1000 chronologically. For 
# example: Spring  2002 is before Fall 2002.
select course.course_id, title, credits, grade, semester, year 
from (select * from student natural join takes where student.ID = 1000 and takes.ID = 1000)as a,  course 
where course.course_id = a.course_id 
order by year, semester desc;

select "6.";
# 6.List the top 20 students of highest GPAs in Math department. List student 
# id, name, overall GPA, and order the output by GPA from highest to  lowest. 
select ID, name, sum(credits), Truncate(sum(point * credits)/sum(credits), 2) as GPA
from course inner join
(select *
from gradepoint natural join student natural join takes
where student.dept_name = "Math") as s
on course.course_id = s.course_id
group by ID
order by GPA desc
limit 20;


select "7.";
# 7.List section information for classes offered in 2008 Spring, include 
# course_id, course_title, section_id, capacity, actual, remaining, instructor  name,   
# building and room_number.
select section.course_id, a.title, section.sec_id, section.capacity, c.actual, section.capacity - c.actual as remaining, a.name as "instructor", building, room_number
from
(select *
from instructor
natural join teaches
natural join course
where year = 2008 and semester="Spring") as a
natural join
(select course_id, count(*) as actual
from student natural join takes
where year=2008 and semester="Spring"
group by course_id) as c
inner join section
on(section.course_id = a.course_id)
where section.year=2008 and section.semester="Spring"
order by section.course_id;





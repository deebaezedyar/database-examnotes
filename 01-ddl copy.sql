
1 /*Get all enrolled students for a specific period,program,year ?*/

select c.contact_first_name, c.contact_last_name, s.*from students s
left join contacts c on c.contact_email = s.student_contact_ref
where s.student_population_year_ref = 2021 and s.student_population_code_ref = 'CS';
-- or (Other solution)

select * from students s where s.student_population_year_ref = 2021 and s.student_population_code_ref = 'CS';


2 /*Get number of enrolled students for a specific period,program,year*/

select count(1) from students s where s.student_population_year_ref = 2021 and s.student_population_code_ref = 'CS';

3 - /*Get All defined exams for a course from grades table*/

select c.course_code, g.grade_exam_type_ref from grades g
left join courses c on g.grade_course_code_ref = c.course_code
left join exams e on e.exam_course_code = c.course_code where c.course_code = 'PG_PYTHON';

4 - /*Get all grades for a student*/

select * from grades g where grade_student_epita_email_ref = 'marjory.mastella@epita.fr' and grade_score
select * from students s

select * from grades g
where grade_student_epita_email_ref = 'simona.morasca@epita.fr';


5 - /*Get all grades for a specific Exam*/

select * from grades g
where grade_course_code_ref = 'SE_ADV_JS'

6 - /*Get students Ranks in an Exam for a course*/

select * from grades
select g.grade_student_epita_email_ref, g.grade_course_code_ref, g.grade_score,
rank() over(order by g.grade_score desc) student_rank
from grades g
where g.grade_course_code_ref = 'SE_ADV_JS' and g.grade_exam_type_ref = 'Project';

7 - /*Get students Ranks in all exams for a course*/

select g.grade_student_epita_email_ref, g.grade_course_code_ref, g.grade_score, g.grade_exam_type_ref,
rank() over(order by g.grade_score desc) student_rank
from grades g
where g.grade_course_code_ref = 'DT_RDBMS';

8 - /*Get students Rank in all exams in all courses */

select g.grade_student_epita_email_ref, g.grade_course_code_ref, g.grade_score,
rank() over(partition by g.grade_course_code_ref order by g.grade_score desc) student_rank
from grades g;

9 - /*Get all courses for one program*/

select * from programs p
where program_assignment = 'SE';


10 - /*Get courses in common between 2 programs*/

select * from courses

select * from programs p
where program_course_code_ref in('DT_RDBMS', 'PG_PYTHON') and program_assignment in('CS', 'SE');


11 - /*Get all programs following a certain course*/

select program_assignment, program_course_code_ref from programs p
order by program_assignment;

12 - /*get course with the biggest duration*/

select * from courses
order by duration desc limit 2;

13 - /*get courses with the same duration*/

select * from courses c
where duration in('24', '11', '21')

-- or (other solution)
select * from courses c where c.duration in(select c2.duration from courses c2 group by c2.duration having count(c2.duration) > 1) order by c.duration asc


14 - /*Get all sessions for a specific course*/

select * from sessions
where session_course_ref = 'PM_AGILE'

15 - /*Get all session for a certain period*/

select * from sessions s
where session_date in('2020-10-04', '2020-10-05', '2020-10-06', '2020-10-07', '2020-10-08')

16 - /*Get one student attendance sheet*/

select a.attendance_student_ref, a.attendance_presence from attendance a
where attendance_student_ref = 'kanisha.waycott@epita.fr';


17 - /*Get one student summary of attendance*/

select * from attendance a
where attendance_student_ref = 'kris.marrier@epita.fr'


18 - /*Get student with most absences*/

select * from attendance
select attendance_student_ref, attendance_presence from attendance a
order by attendance_presence asc

1 /hard questions - get all exams for a specific course/

select * from exams 
where exam_course_code in ('CS_SOFTWARE_SECURITY', 'exam_type'); 




select e.exam_course_code, e.exam_weight, e.exam_type from exams e
where e.exam_course_code in 'SE_ADV_JAVA'

2 /get all grades for a specific student/

select * from grades
where grade_student_epita_email_ref  in ('kallie.blackwood@epita.fr', 'grade_score')




select c.contact_first_name,c.contact_last_name, g.grade_course_code_ref, g.grade_score from grades g
inner join students s on g.grade_student_epita_email_ref = s.student_epita_email 
inner join contacts c on s.student_contact_ref = c.contact_email 
where g.grade_student_epita_email_ref='kallie.blackwood@epita.fr'

3 /Get the final grades for a student on a specifique course or all courses/

select * from courses
select * from grades

select* from grades g
where grade_student_epita_email_ref in ('albina.glick@epita.fr', 'DT_RDBMS', 'grade_score')

or

select s.student_epita_email ,g.grade_course_code_ref, sum(e.exam_weight * g.grade_score)/sum(e.exam_weight) from grades g 
inner join exams e on g.grade_course_code_ref = e.exam_course_code
inner join students s on g.grade_student_epita_email_ref =s.student_epita_email 
where s.student_epita_email ='kallie.blackwood@epita.fr' 
group by g.grade_course_code_ref, s.student_epita_email  

4 /Get the students with the top 5 scores for specific course/
with total_grade_course as (
	select c.contact_first_name, c.contact_last_name ,g.grade_course_code_ref, sum(e.exam_weight * g.grade_score)/sum(e.exam_weight) as total_grade,
	rank() over (partition by g.grade_course_code_ref order by sum(e.exam_weight * g.grade_score)/sum(e.exam_weight) desc) as rnk
	from grades g 
	inner join exams e on g.grade_course_code_ref = e.exam_course_code
	inner join students s on g.grade_student_epita_email_ref = s.student_epita_email
	inner join contacts c on s.student_contact_ref = c.contact_email 
	group by g.grade_course_code_ref, c.contact_first_name, c.contact_last_name
)
select contact_first_name, contact_last_name, grade_course_code_ref, total_grade, rnk
from total_grade_course
where rnk <=5 and grade_course_code_ref ='DT_RDBMS'

5 /Get the students with the top 5 scores for specific course/


6 /Get the class average for a course/


select g.grade_course_code_ref, (sum(e.exam_weight * g.grade_score)/sum(e.exam_weight)::float) as class_average
from grades g inner join exams e on g.grade_course_code_ref = e.exam_course_code
inner join students s on g.grade_student_epita_email_ref =s.student_epita_email 
group by g.grade_course_code_ref




/*get number of students*/
	select count(1) from students;
	

	/*get students population in each year*/
	select student_population_year_ref, count(1) from students
	group by student_population_year_ref;
	

	/*get students population in each program*/
	select student_population_code_ref, count(1) from students
	group by student_population_code_ref;
	

	/* calculate age from dob */
	SELECT contact_first_name, date_part('year',age(contact_birthdate)) as contact_age,* FROM contacts;
	

	/*add age column to contacts*/
	alter table contacts add column contact_age integer NULL;
	

	/*calculate age from dob and insert in col contact_age*/
	update contacts as c1 set contact_age = 
	(SELECT date_part('year',age(contact_birthdate)) as c_age 
	 FROM contacts as c2 where c1.contact_email=c2.contact_email);
	

	/*avg student age*/
	select avg(c.contact_age) as student_avg_age from students as s left join contacts as c
	on c.contact_email=s.student_contact_ref
	

	/*avg session duration for a course*/
	select avg(EXTRACT(EPOCH FROM TO_TIMESTAMP(session_end_time, 'HH24:MI:SS')::TIME - TO_TIMESTAMP(session_start_time, 'HH24:MI:SS')::TIME)/3600) as duration 
	from sessions as s left join courses as c
	on c.course_code=s.session_course_ref
	where c.course_code='SE_ADV_DB'
	

	

	

	/*find the student with most absents*/
	select count(a.attendance_student_ref) as absents,
	c.contact_first_name, c.contact_last_name
	from contacts as c
	left join students as s on s.student_contact_ref=c.contact_email
	left join attendance as a on s.student_epita_email=a.attendance_student_ref
	where a.attendance_presence=1
	group by c.contact_first_name, c.contact_last_name
	order by absents ASC
	limit 2
	

	/*find the course with most absents*/
	SELECT b.course_name, count(a.attendance_presence) Absences
	    FROM attendance a
	        LEFT JOIN courses b
	            ON a.attendance_course_ref = b.course_code
	                WHERE attendance_presence = 0 
	                    GROUP BY a.attendance_course_ref, b.course_name
	                        ORDER BY Absences DESC LIMIT 1;
				
	

	/*find students who are not graded*/
	/*first solution*/
	SELECT a.student_epita_email, b.grade_score 
	    FROM students a 
	        LEFT JOIN grades b 
	            ON a.student_epita_email=b.grade_student_epita_email_ref
	                WHERE b.grade_score IS NULL
	

	/*second solution*/
	SELECT s.student_epita_email
	FROM students as s
	WHERE NOT EXISTS
	  (SELECT *
	   FROM grades as g
	   WHERE s.student_epita_email = g.grade_student_epita_email_ref)
	   
	/*third solution*/
	SELECT s.student_epita_email
	FROM students as s
	LEFT OUTER JOIN grades as g
	  ON (s.student_epita_email = g.grade_student_epita_email_ref)
	  WHERE g.grade_student_epita_email_ref IS NULL
	

	

	/*find the teachers who are not in any session*/
	SELECT c.contact_first_name, c.contact_last_name, t.teacher_epita_email
	from contacts as c
	inner join teachers as t
	on c.contact_email = t.teacher_contact_ref
	LEFT OUTER JOIN sessions as s
	  ON t.teacher_epita_email = s.session_prof_ref
	  WHERE s.session_prof_ref IS NULL
	

	/*list of teacher who attend the total session */
	select con.contact_first_name, con.contact_last_name, tea.teacher_contact_ref, count(session_prof_ref)
		from teachers tea
		inner join contacts con
		on con.contact_email = tea.teacher_contact_ref
		inner join sessions sess
		on tea.teacher_epita_email = sess.session_prof_ref
	

	group by con.contact_first_name, con.contact_last_name, tea.teacher_contact_ref
	order by count
	

	

	

	*/ find the DSA students details with grades */
	

	select con.contact_first_name, con.contact_last_name, stud.student_population_code_ref,
		grad.grade_course_code_ref as course_name, grad.grade_score
		from grades grad
		
		inner join students stud
		on grad.grade_student_epita_email_ref = stud.student_epita_email
		
		inner join contacts con
		on stud.student_contact_ref = con.contact_email
		
	where
		student_population_code_ref = 'DSA'
		
	

	/* attendance percentage for a student */
	

	select (sum_atten/total_atten::float)*100 attendance_percentage, res.attendance_student_ref, res.attendance_course_ref, res.attendance_population_year_ref from
	(
	select count(1) as total_atten, sum(s.attendance_presence) as sum_atten,
	s.attendance_student_ref, s.attendance_course_ref, s.attendance_population_year_ref
	from attendance as s
	where s.attendance_student_ref='jamal.vanausdal@epita.fr'
	group by s.attendance_student_ref, s.attendance_course_ref, s.attendance_population_year_ref
	) res
	order by attendance_percentage
	  
	

	/* avg grade for DSA students*/
	select avg(g.grade_score) as avg_grade, pop.population_code as population
	from grades as g inner join programs as p
	on g.grade_course_code_ref=p.program_course_code_ref
	inner join populations as pop
	on pop.population_code=p.program_assignment
	where pop.population_code='DSA'
	group by pop.population_code
	

	/* All student average grade*/
	

	Select cont.contact_first_name, cont.contact_last_name, stud.student_epita_email, avg(g.grade_score)
	from students stud
		inner join contacts cont
		on cont.contact_email = stud.student_contact_ref
		
		inner join grades g
		on stud.student_epita_email = g.grade_student_epita_email_ref
	

	group by cont.contact_first_name, cont.contact_last_name, stud.student_epita_email
	

	

	/* list the course tought by teacher */
	select distinct con.contact_first_name, con.contact_last_name, sess.session_course_ref
		from teachers tea
		
		inner join contacts con
		on con.contact_email = tea.teacher_contact_ref
		
		inner join sessions sess
		on tea.teacher_epita_email = sess.session_prof_ref
		
	

	

	-- find the teachers who are not giving any courses
	select s.student_epita_email
	from students as s 
	where s.student_epita_email not in 
	(select g.grade_student_epita_email_ref from grades as g)
	

	TRUE ANSWER for the last question is: 
-	select * from teachers t left join sessions s on s.session_prof_ref = t.teacher_epita_email left join courses c on s.session_course_ref = c.course_code where s.session_course_ref is null ;

	

	select * from teachers
	select * from sessions
	select * from courses
	select * from contacts
	select * from students
	select * from grades
	select * from attendance

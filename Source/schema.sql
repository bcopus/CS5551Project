drop database if exists ontarget;
create database ontarget;
use ontarget;


create table Course (
  course_id int unsigned not null auto_increment,
  dept_prefix varchar(6) not null,
  course_num smallint not null,
  course_name varchar(50) not null,
  credit_hours smallint unsigned not null,
  primary key (course_id),
  index(course_id),
  index(dept_prefix, course_num)
);

create table Prerequisite (
  prerequisite_id int unsigned not null auto_increment,
  for_course int unsigned default null,    #fk Course.course_id
  prereq_course int unsigned default null, #fk Course.course_id
  parent_prereq int unsigned default null, #fk Prerequisite.prerequisite_id
  primary key (prerequisite_id),
  index(prerequisite_id),
  index(for_course)
);

create table CourseCompletion (
  completion_id int unsigned not null auto_increment,
  course int unsigned not null,   #fk
  student int unsigned not null,  #fk
  semester int unsigned not null, #fk
  primary key (completion_id),
  index(completion_id),
  index(student)
);

create table Major (
  major_id int unsigned not null auto_increment,
  name varchar(50) not null,
  primary key (major_id),
  index(major_id)
);

create table Concentration (
  concentration_id int unsigned not null auto_increment,
  name varchar(50) not null,
  major int unsigned not null, #fk
  primary key (concentration_id),
  index(concentration_id)
);

create table Campus (
  campus_id int unsigned not null auto_increment,
  name varchar(50) not null,
  primary key (campus_id),
  index(campus_id)
);

create table PlanOfStudy (
  pos_id int unsigned not null auto_increment,
  dateLastModified datetime default null,
  student int unsigned not null, #fk
  primary key (pos_id),
  index(pos_id),
  index(student)
);

create table Student (
  student_id int unsigned not null,
  l_name varchar(50) not null,
  f_name varchar(50) not null,
  major int unsigned not null, #fk
  concentration int unsigned not null, #fk
  preferred_load smallint default null,
  preferred_campus int unsigned default null, #fk
  primary key (student_id),
  index(student_id),
  index(l_name),
  index(f_name),
  index(l_name, f_name)
);

create table Semester (
  semester_id int unsigned not null auto_increment,
  academic_year smallint not null,
  semester_code smallint not null,
  primary key (semester_id),
  index(semester_id)
);

create table CourseOffering (
  offering_id int unsigned not null auto_increment,
  course int unsigned not null, #fk
  semester int unsigned not null, #fk
  campus int unsigned not null, #fk
  primary key (offering_id),
  index(offering_id),
  index(semester),
  index(campus)
);

create table CourseCatalog (
  catalog_id int unsigned not null auto_increment,
  catalog_year smallint not null,
  concentration int unsigned not null, #fk
  primary key (catalog_id),
  index(catalog_id),
  index(concentration)
);

create table CourseGroup (
  group_id int unsigned not null auto_increment,
  name varchar(50) not null,
  catalog_id int unsigned not null, #fk CourseCatalog.catalog_id
  parent_id int unsigned default null, #fk CourseGroup.group_id
  minimum_hours smallint unsigned not null,
  primary key (group_id),
  index(group_id),
  index(catalog_id),
  index(parent_id)
);

create table CourseMapCourseGroup (
  id int unsigned not null auto_increment,
  course_id int unsigned not null, #fk Course.course_id
  course_group_id int unsigned not null, #fk CourseGroup.group_id
  primary key (id),
  index (id),
  index (course_id),
  index (course_group_id)
);

create table DegreeRequirement (
  requirement_id int unsigned not null auto_increment,
  catalog_id int unsigned not null, #fk CourseCatalog.catalog_id
  concentration_id int unsigned not null, #fk Concentration.concentration_id
  course_group_id int unsigned not null, #fk CourseGroup.group_id
  primary key (requirement_id),
  index (requirement_id),
  index (catalog_id),
  index (concentration_id),
  index (course_group_id)
);


alter table Prerequisite
  add foreign key(for_course)
  references Course(course_id);
 
alter table Prerequisite
  add foreign key(prereq_course)
  references Course(course_id);
  
alter table Prerequisite
  add foreign key(parent_prereq)
  references Prerequisite(prerequisite_id);

alter table CourseCompletion
  add foreign key(course)
  references Course(course_id); 
  
alter table CourseCompletion
  add foreign key(student)
  references Student(student_id); 
  
alter table CourseCompletion
  add foreign key(semester)
  references Semester(semester_id);   
  
alter table Concentration
  add foreign key(major)
  references Major(major_id);  
    
alter table PlanOfStudy
  add foreign key(student)
  references Student(student_id);  
      
alter table Student
  add foreign key(major)
  references Major(major_id);   
  
alter table Student
  add foreign key(concentration)
  references Concentration(concentration_id);   
  
alter table Student
  add foreign key(preferred_campus)
  references Campus(campus_id);  

alter table CourseOffering
  add foreign key(course)
  references Course(course_id);  
  
alter table CourseOffering
  add foreign key(semester)
  references Semester(semester_id);  
  
alter table CourseOffering
  add foreign key(campus)
  references Campus(campus_id);  
    
alter table CourseCatalog
  add foreign key(concentration)
  references Concentration(concentration_id);  
    
alter table CourseGroup
  add foreign key(catalog_id)
  references CourseCatalog(catalog_id);  
  
alter table CourseGroup
  add foreign key(parent_id)
  references CourseGroup(group_id); 
  
alter table DegreeRequirement
  add foreign key(catalog_id)
  references CourseCatalog(catalog_id);
    
alter table DegreeRequirement
  add foreign key(concentration_id)
  references Concentration(concentration_id);
    
alter table DegreeRequirement
  add foreign key(course_group_id)
  references CourseGroup(group_id);
  
alter table CourseMapCourseGroup
  add foreign key(course_group_id)
  references CourseGroup(group_id);
    
alter table CourseMapCourseGroup
  add foreign key(course_id)
  references Course(course_id);
  
 
  
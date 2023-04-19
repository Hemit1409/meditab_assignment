
   
-----------------------------------------------/////////////////ASSIGNMENT 03//////////////////////-------------------------------


   
   
--(1) get by id
create or replace function PatientGetbyID(
                patientid int
                
                )
returns table (
                patient_id int,
                firstname varchar,
                lastname varchar,
                middlename varchar,
                sex_id int,
                dob date
)
language plpgsql
as
$$
declare 
--_query varchar :='';
 _query varchar:= 'select patient_id,firstname , lastname,middlename,sex_id,dob from Patients'; 
 
 begin
     _query := _query || ' where patient_id='||$1;
     raise notice '%',_query;
     return query execute _query using patient_id,firstname,lastname,middlename,sex_id,dob;
 end;
$$  

select *  from PatientGetbyID(2);






--(2) get list by pagination and sorting
   create  or replace function  
patientget(
			PageNumber INTEGER = 1,
  			PageSize INTEGER = 20,
			first_Name varchar default '',
			last_Name varchar default '',
			gender varchar default '',
			dateofbirth varchar default null,
			orderby in varchar default 'Patients.patient_id'
			)
returns table( 	patientid integer, firstname varchar, lastname varchar, dob date, chart_number varchar, sex varchar
)
language plpgsql
as
$$
declare 
initialquery varchar(2000) := 'Select Patients.patient_id, Patients.firstname, Patients.lastname, Patients.dob, Patients.chart_number, sex.sex
From
    Patients
    LEFT JOIN sex ON Patients.sex_id = sex.sex_id where Patients.isdeleted=false and 1=1';
conditional varchar(3000) := '';
 
begin
	initialquery := initialquery
	|| case when $3 != '' then ' and Patients.firstname = '''||$3||'''' else '' end 
	||case when $4 != '' then ' and Patients.lastname = '''||$4||'''' else '' end 
	||case when $5 != '' then ' and sex.sex = '''||$5||'''' else '' end
	||case when $6 != '' then ' and Patients.dob = '''||$6::date||'''' else '' end
	||' ORDER BY '|| $7|| ' ASC LIMIT '|| $2 ||' OFFSET (('||$1||'-1) *'|| $2||')';

	raise notice 'sql %' , initialquery;
	return query execute initialquery using PageNumber,PageSize,first_Name,last_Name,gender,dateofbirth,orderby;
end;
$$
   
 select * from patientget();  
   select * from patientget(first_Name=>'HEMIT',dateofbirth=>'2000-01-01');

   
select * from Patients;







------(3)Create
CREATE or replace function patientcreate(fname varchar(100), mname varchar(100), lname varchar(100),
                          s_id INT, do_b date)
returns INT 

AS 
$$
declare
primarykey integer;
BEGIN
    INSERT INTO Patients(firstname,lastname,middlename,sex_id,dob) VALUES(fname,mname,lname,s_id,do_b) returning patient_id into primarykey; 
    return primarykey;

End;
$$ language plpgsql;

select patientcreate('PRIYA','PATEL','R',2,'1994-1-13');






--(4) update
--function to update 
create or replace function patientupdate(
                patientid int,
                first_name varchar,
                last_name varchar,
                middle_name varchar,
                sex varchar,
                dateofbirth date
                )
returns table (
                patient_id int
                
)
language plpgsql
as
$$
declare 
_query varchar :='';
 _update varchar:= 'update Patients set firstname = '''||$2||''',lastname='''||$3||''',middlename='''||$4||''',sex_id=('; 
 _select varchar:= 'select sex_id from sex where sex = '''||$5||'''),';
 begin
     _query := _update || _select ||'dob='''||$6||''' where patient_id='||$1||' and isdeleted=false returning patient_id';
     raise notice '%',_query;
     return query execute _query using patient_id,first_name,last_name,middle_name,sex,dateofbirth;
 end;
$$  

select * from patientupdate(11,'SHRUTI','RANA','S','FEMALE','2002-01-01');

select * from patientupdate(14,'SUMEET','PATEL','S','MALE','2003-01-01');
select * from Sex;  
  
 select * from Patients;
  
  


  
  --(5) softdelete
--function to softdelete 
create or replace function patientdelete(
                patientid int
                
                )
returns table (
                patient_id int,
                firstname varchar,
                lastname varchar,
                middlename varchar,
                sex_id int,
                dob date
)
language plpgsql
as
$$
declare 
--_query varchar :='';
 _query varchar:= 'update Patients set isdeleted=true'; 
 
 begin
     _query := _query || ' where patient_id='||$1||' returning patient_id,firstname , lastname,middlename,sex_id,dob';
     raise notice '%',_query;
     return query execute _query using patient_id,firstname,lastname,middlename,sex_id,dob;
 end;
$$  

select * from patientdelete(17);

select * from Sex;  
  
 select * from Patients;
  
  
  
  
  
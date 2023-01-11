
-----------------------------------------------/////////////////ASSIGNMENT 03//////////////////////-------------------------------

   
   
--(1) get by id
create or replace function GetById(
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

select *  from GetById(2);



--(2) get list by pagination and sorting
   create  or replace function  
getlist_search_patient_and_pagination(
			PageNumber INTEGER = 1,
  			PageSize INTEGER = 20,
			first_Name varchar default '',
			last_Name varchar default '',
			gender varchar default '',
			dateofbirth date default null,
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
	||case when $6 is not null then ' and Patients.dob = '''||$6||'''' else '' end
	||' ORDER BY '|| $7|| ' ASC LIMIT '|| $2 ||' OFFSET (('||$1||'-1) *'|| $2||')';

	raise notice 'sql %' , initialquery;
	return query execute initialquery using PageNumber,PageSize,first_Name,last_Name,gender,dateofbirth,orderby;
end;
$$
   
 select * from getlist_search_patient_and_pagination();  
   select * from getlist_search_patient_and_pagination(first_Name=>'HEMIT');

   
select * from Patients;




--get all list by pagintion and sorting

create  or replace function  
getlist_search_patient_and_pagination2(
			PageNumber INTEGER = 1,
  			PageSize INTEGER = 10,
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
    LEFT JOIN sex ON Patients.sex_id = sex.sex_id where Patients.isdeleted=false';

 
begin
	initialquery := initialquery||' ORDER BY '|| $3|| ' ASC LIMIT '|| $2 ||' OFFSET (('||$1||'-1) *'|| $2||')';

	raise notice 'sql %' , initialquery;
	return query execute initialquery using PageNumber,PageSize,orderby;
end;
$$

 select * from getlist_search_patient_and_pagination2(1,5,'patients.firstname');






------(3)Create


CREATE or replace function Insert_PatientData(fname varchar(100), mname varchar(100), lname varchar(100),
                          s_id INT, do_b date)
returns INT 

AS 
$$
declare
primarykey integer;
BEGIN
    INSERT INTO Patients(firstname,lastname,middlename,sex_id,dob) VALUES(fname,mname,lname,s_id,do_b) returning patient_id into primarykey; 
    return primarykey;
--   (SELECT patient_id FROM Patients ORDER BY created_on DESC LIMIT 1);  
End;
$$ language plpgsql;

select Insert_PatientData('PRIYA','PATEL','R',2,'1994-1-13');





--(4) update


--function to update 
create or replace function UpdateRecord(
                patientid int,
                first_name varchar,
                last_name varchar,
                middle_name varchar,
                sex varchar,
                dateofbirth date
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
_query varchar :='';
 _update varchar:= 'update Patients set firstname = '''||$2||''',lastname='''||$3||''',middlename='''||$4||''',sex_id=('; 
 _select varchar:= 'select sex_id from sex where sex = '''||$5||'''),';
 begin
     _query := _update || _select ||'dob='''||$6||''' where patient_id='||$1||' and isdeleted=false returning patient_id,firstname , lastname,middlename,sex_id,dob';
     raise notice '%',_query;
     return query execute _query using patient_id,firstname,lastname,middlename,sex,dob;
 end;
$$  

select * from UpdateRecord(11,'SHRUTI','RANA','S','FEMALE','2002-01-01');

select * from UpdateRecord(14,'SUMEET','PATEL','S','MALE','2003-01-01');
select * from Sex;  
  
 select * from Patients;
  


  
  --(5) softdelete

  
--function to softdelete 
create or replace function DeleteRecord(
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

select * from DeleteRecord(17);

select * from Sex;  
  
 select * from Patients;
  
  
  
  
  


--________________________________________________________//////*ASSIGNMENT 02*//////_________________________________________________________________



-------(1)Create View to fetch the result of FirstName, LastName, MiddleName, DOB, Chart Number, Sex , Race , Primary Address, Primary Phone, Primary Fax.

Create or replace View information as
Select t1.patient_id, t1.firstname, t1.lastname, t1.dob, t1.chart_number, t2.sex, t4.race, t5.country, t5.zip, t5.city, t5._state, t5.street, t8.phone
From
    Patients as t1
    LEFT JOIN sex as t2 ON t1.sex_id = t2.sex_id
    LEFT JOIN RACE as t3 ON t1.patient_id = t3.patient_id
    LEFT join raceTYPE as t4 on t1.patient_id = t3.patient_id and t3.race_type_id=t4.race_type_id
    left join Contact_preference_type as t6 on t6.peference_type_value='primary'
    LEFT JOIN Contact_preference as t7 on t1.patient_id = t7.patient_id and t7.peference_type_id =t6.preference_type_id 
    LEFT join Addresses as t5 on t1.patient_id = t5.patient_id and t7.address_id = t5.address_id
    LEFT join phone as t8 on t8.ph_id = t7.phone_id order by patient_id;

SELECT * FROM information;
select * from Contact_preference;




-----(2)Write Query to fetch unique record from the Patient table based on Firstname, LastName, DOB and Sex with number of occurance(count) of same data.


select firstname,lastname,dob,sex_id,count(concat(firstname,lastname,dob,sex_id)) as occurance 
from Patients group by firstname,lastname,dob,sex_id;

-- unique record based on first_name, last_name, dob, sex_id 
select firstname,lastname,dob,sex_id, count(patient_id) from Patients group by firstname,lastname,dob,sex_id;

-- unique record based on first name
select firstname, count(*) as patient_first_name_occurance from Patients group by firstname;

-- unique record based on last name
select lastname, count(*) as patient_last_name_occurance from Patients group by lastname;

-- unique record based on dob
select dob, count(*) as pateint_dob_occurance from Patients group by dob;

--unique record based on sex
select t1.sex_id, count(*) as pateint_dob_occurance from Patients as t1 left join sex as t2 on t1.sex_id = t2.sex_id group by t1.sex_id;





------(3)Create Function to stored the data into patient table. Pass all the value in the function parameter and function should return the created new primary key value of the table.
CREATE or replace function Insert_PatientData(fname varchar(100), mname varchar(100), lname varchar(100),
                          s_id INT, do_b date)
returns INT 

AS 
$$
declare
primarykey integer;
BEGIN
    INSERT INTO Patients(firstname,lastname,middlename,sex_id,dob) VALUES(fname,mname,lname,s_id,do_b)
    returning patient_id into primarykey; 
    return primarykey;
End;
$$ language plpgsql;


select Insert_PatientData('SANJAY','RANA','T',1,'1975-01-01');
select Insert_PatientData('BHAVYA','RANA','T',1,'2009-01-01');
select Insert_PatientData('HIMANI','RANA','T',2,'2005-01-01');
select Insert_PatientData('GAYATRI','RANA','T',2,'1983-01-01');
select Insert_PatientData('RUPAL','RANA','T',2,'1982-01-01');
select Insert_PatientData('SHAILESH','RANA','T',1,'1978-01-01');
select Insert_PatientData('HARSHANG','RANA','T',1,'1996-01-01');
select Insert_PatientData('RANA','PATEL','T',1,'1996-01-01');
select Insert_PatientData('PRIYA','PATEL','R',2,'1994-1-13');

select * from Patients;





-------(4)Create Function to get the result of patient’s data by using patientId, lastname, firstname, sex, dob. Need to implement the pagination and sorting(LastName, Firstname, Sex, DOB) in this function.


--with dynamic query

create  or replace function  
search_patient_and_pagination2(
			PageNumber INTEGER = 3,
  			PageSize INTEGER = 3,
			first_Name varchar default null,
			last_Name varchar default null,
			gender varchar default null,
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
    LEFT JOIN sex ON Patients.sex_id = sex.sex_id where 1=1';
conditional varchar(3000) := '';
 
begin
	initialquery := initialquery
	|| case when $3 is not NULL then ' and Patients.firstname = '''||$3||'''' else '' end 
	||case when $4 is not null then ' and Patients.lastname = '''||$4||'''' else '' end 
	||case when $5 is not null then ' and sex.sex = '''||$5||'''' else '' end
	||case when $6 is not null then ' and Patients.dob = '''||$6||'''' else '' end
	||' ORDER BY '|| $7|| ' ASC LIMIT '|| $2 ||' OFFSET (('||$1||'-1) *'|| $2||')';

	raise notice 'sql %' , initialquery;
	return query execute initialquery using PageNumber,PageSize,first_Name,last_Name,gender,dateofbirth,orderby;
end;
$$

--with fname and Lname
select * from search_patient_and_pagination2(1,8,first_Name=>'HEMIT',last_Name=>'RANA');

-- search by fname and Lname orderby dob
select * from search_patient_and_pagination2(1,1,first_Name=>'HEMIT',last_Name=>'RANA',gender=>'MALE',dateofbirth=>'2000-01-01',orderby=>'Patients.dob');

--serahc by Lname and dob with default sort by patient id
select * from search_patient_and_pagination2(1,1,first_Name=>null,last_Name=>'RANA',gender=>null,dateofbirth=>'2000-01-01');

--search by lastname and order by dob
select * from search_patient_and_pagination2(1,2,first_Name=>null,last_Name=>'RANA',gender=>null,dateofbirth=>null,orderby=>'Patients.dob');

--search by lastname and order by firstname
select * from search_patient_and_pagination2(1,8,first_Name=>null,last_Name=>'RANA',gender=>null,dateofbirth=>null,orderby=>'Patients.firstname');

--search by firstname and order by lastname
select * from search_patient_and_pagination2(1,5,first_Name=>'KHUSHI',last_Name=>null,gender=>null,dateofbirth=>null,orderby=>'Patients.lastname');

--search by gender and order by firstname
select * from search_patient_and_pagination2(1,5,first_Name=>null,last_Name=>NULL,gender=>'MALE',dateofbirth=>null,orderby=>'Patients.firstname');

--search by lastname and order by gender
select * from search_patient_and_pagination2(1,8,first_Name=>null,last_Name=>'RANA',gender=>null,dateofbirth=>null,orderby=>'sex.sex');


--returns all data with default 3 pagesize and 3 rows having all data ordered by default patientid
select * from search_patient_and_pagination2();


select * from Patients;




-----(5)Write Query to search the patient by patient’s phone no

SELECT 
    t3.phone,firstname,lastname,dob,sex_id
FROM 
    Patients as t1
    LEFT JOIN Addresses as t2 ON t1.patient_id = t2.patient_id
    LEFT JOIN phone as t3 ON t2.address_id = t3.phoneID
WHERE 
    t3.phone = '123456789';
-- END

   





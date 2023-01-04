--************************************************************************
--1. Create View to fetch the result of FirstName, LastName, MiddleName, DOB, Chart Number, Sex , Race , Primary Address, Primary Phone, Primary Fax.
--************************************************************************


create or replace view patient_details as
select 	p.first_name,p.last_name, p.middle_name, p.date_of_birth,p.chart_pattern,
		g.g_type, 
		rt.r_type, 
		a.street, a.zip,
		city.city,
		s.state_name,
		ctry.country_name,
		phone.phone_number,
		fax.fax_number
from patient p
left join gender_type g
on p.gender_type_id = g.id
left join contact_preference cp
on p.contact_preference_id = cp.id
left join phone
on cp.phone_id = phone.id
left join fax
on cp.fax_id = fax.id
left join address a 
on cp.address_id = a.id
left join city 
on a.zip = city.zip 
left join state s 
on a.state_id = s.id 
left join country ctry 
on s.country_id = ctry.id 
left join patient_race pr 
on pr.patient_id  = p.id
left join race_type rt 
on pr.race_type_id = rt.id;


select * from patient_details;


--************************************************************************
-- 2. Write Query to fetch unique record from the Patient table based on Firstname, LastName, DOB and Sex with number of occurance(count) of same data.
--************************************************************************



select first_name, Last_name, date_of_birth, gender_type_id, count(id) as count
from patient p group by (first_name, Last_name, date_of_birth, gender_type_id);




--************************************************************************
--3.Create Function to stored the data into patient table. Pass all the value in the function parameter and function should return the created new primary key value of the table.
--************************************************************************


create or replace function insertPatient
(
	fname varchar(255), lname varchar(255), mname varchar(255), dob date, chart_pattern varchar(100) ,
	gender varchar(10)
--	race_type varchar(10)
--	phone varchar(10), fax varchar(10), 
--	street text, zip varchar(15), state varchar(100), country varchar(100)
)
returns integer as
$$
declare
    pk_value integer;
   	g_id integer;
begin
	g_id = (select id from gender_type where g_type = gender);
    insert into patient (first_name, last_name, middle_name, chart_pattern, date_of_birth, gender_type_id) values(fname,lname,mname,chart_pattern,dob, g_id )
    returning id into pk_value;
    return pk_value;
end;
$$ language plpgsql;

select  insertPatient('shyam','mendpara', 'ashvinbhai', date('1998-11-01'), 'chart', 'male');

--************************************************************************
-- 4. Create Function to get the result of patient’s data by using patientId, lastname, firstname, sex, dob. Need to implement the pagination and sorting(LastName, Firstname, Sex, DOB) in this function.
--************************************************************************

create or replace function getPatientData(	p_id integer default null,
											lastname varchar default null,
											firstname varchar default null,
											gender varchar default null,
											dob varchar default null 
)				
returns table(
	id int,
	first_name varchar,
	last_name varchar,
	middle_name varchar,
	date_of_birth date,
	chart_pattern varchar,
	g_type varchar,
	r_type varchar,
	street text,
	zip varchar,
	city varchar,
	state_name varchar,
	country_name varchar,
	phone_number varchar,
	fax_number varchar
) as
$$
declare
	declare flag integer := 0;
	declare qry varchar ;
	declare d date; 
begin  
		qry = 'select * from patient_details pd ' ;
		if p_id > 0 then
			qry:= qry || 'where pd.id = ' || p_id;
			flag := 1;
		end if;
		if lastname <> '' then
			if flag then
				qry:= qry ||  ' and pd.last_name = '''|| lastname || ''''; 
			else
				qry:= qry || 'where pd.last_name = '''|| lastname || '''';
				flag := 1;
			end if;
		end if;
		if firstname <> '' then
				if flag then
					qry:= qry || ' and pd.first_name = '''|| firstname || '''';
				else
					qry:= qry || 'where pd.first_name = '''|| firstname || '''';
					flag := 1;
				end if;
		end if;
		if gender  <> '' then
				if flag then
					qry:= qry || ' and pd.g_type = '''|| gender || '''';
				else
					qry:= qry || 'where pd.g_type = '''|| gender || '''';
					flag := 1;
				end if;
		end if;
		if dob  <> '' then
				d = TO_DATE(dob,'YYYY-MM-DD');
				if flag then
					qry:= qry || ' and pd.date_of_birth = '''|| d || '''';
				else
					qry:= qry || 'where pd.date_of_birth = '''|| d || '''';
					flag := 1;
				end if;
		end if;
		qry:= qry || ' ; ';
		return query execute qry;
end;
$$ language plpgsql; 

select * from getPatientData();
select * from getPatientData(p_id=> '1');
select * from getPatientData(firstname=> 'shyam');
select * from getPatientData(firstname=> 'shyam', p_id => '3');
select * from getPatientData(dob=>'1980-10-10');




--************************************************************************
--5.Write Query to search the patient by patient’s phone no
--************************************************************************

select p.first_name, p.last_name, p.middle_name, p.chart_pattern, p.date_of_birth
from patient p where p.id in (select pa.patient_id  from patient_address pa 
left join address a on a.id = pa.address_id  
left join phone_atteched_to_address pata on pata.id = a.id 
left join phone p2 on p2.id  = pata.phone_id 
where p2.phone_number = '9800980025');

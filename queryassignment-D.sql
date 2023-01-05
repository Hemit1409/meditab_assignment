
create table if not exists sex (
sex_id serial primary key,
sex varchar(25),
created_at timestamp default current_timestamp,
updated_at timestamp
);

insert into sex(sex) values ('male');
insert into sex(sex) values ('female');
insert into sex(sex) values ('unknown');

select * from sex;

create table if not exists patient(
patient_id serial primary key,
first_name varchar(25),
last_name varchar (25),
middle_name varchar(25),
sex_id int references sex(sex_id),
chart_id varchar(25) generated always as ( 'PT00' || patient_id::text) stored,
dob date,
created_at timestamp default current_timestamp,
updated_at timestamp
);

insert into patient(first_name,last_name,middle_name,sex_id,dob) values ('dhruvil','chaudhary','rakesh',1,'2001-08-02');
insert into patient(first_name,last_name,middle_name,sex_id,dob) values ('heeya','chaudhary','rakesh',2,'2005-11-22');
insert into patient(first_name,last_name,middle_name,sex_id,dob) values ('hemit','rana','sanjay',1,'2001-09-14');
insert into patient(first_name,last_name,middle_name,sex_id,dob) values ('deepika','chaudhary','rakesh',2,'1979-02-10');

select * from patient;


create table if not exists race(
race_id serial primary key ,
race varchar(25),
created_at timestamp default current_timestamp,
updated_at timestamp
);

insert into race(race) values ('african');
insert into race(race) values ('asian');
insert into race(race) values ('american');

select * from race;

create table if not exists patient_race (
patient_race_id  serial primary key,
race_id int references race(race_id),
patient_id int references patient(patient_id),
created_at timestamp default current_timestamp,
updated_at timestamp
);

insert into patient_race(patient_id,race_id) values ('1','2');
insert into patient_race(patient_id,race_id) values ('1','3');
insert into patient_race(patient_id,race_id) values ('2','3');
insert into patient_race(patient_id,race_id) values ('3','3');
insert into patient_race(patient_id,race_id) values ('4','3');

select * from patient_race;

create table if not exists address_type (
address_type_id serial primary key,
address_type varchar(25),
created_at timestamp default current_timestamp,
updated_at timestamp
);

insert into address_type (address_type) values ('home');
insert into address_type (address_type) values ('work');
insert into address_type (address_type) values ('others');

select * from address_type;

create table if not exists address (
address_id serial primary key ,
patient_id int references patient(patient_id),
address_type int references address_type(address_type_id),
street varchar(25),
zip int not null,
city varchar(25),
state varchar(25),
country varchar(25),
created_at timestamp default current_timestamp,
updated_at timestamp
);

insert into address(patient_id,address_type,street,zip,city,state,country) values
(1,1,'g-1 sunrise park',380004,'ahmedabad','gujarat','india');
insert into address(patient_id,address_type,street,zip,city,state,country) values
(2,2,'g-1 sunrise park',380004,'ahmedabad','gujarat','india');
insert into address(patient_id,address_type,street,zip,city,state,country) values
(3,1,'g-1 sunrise park',380004,'ahmedabad','gujarat','india');
insert into address(patient_id,address_type,street,zip,city,state,country) values
(4,1,'g-1 sunrise park',380004,'ahmedabad','gujarat','india');

select * from address;


create table if not exists phone_type (
phone_type_id serial primary key,
phone_type varchar(25),
created_at timestamp default current_timestamp,
updated_at timestamp
);

insert into phone_type(phone_type) values ('cell');
insert into phone_type(phone_type) values ('landline');

select * from phone_type;


create table if not exists phone (
phone_id serial primary key,
phone_number  numeric,
phone_type_id int references phone_type(phone_type_id),
address_id int references address(address_id),
created_at timestamp default current_timestamp,
updated_at timestamp
);

insert into phone(phone_number,phone_type_id,address_id) values ('9016873801',1,1);
insert into phone(phone_number,phone_type_id,address_id) values ('7922868506',2,1);
insert into phone(phone_number,phone_type_id,address_id) values ('7922868506',2,1);
insert into phone(phone_number,phone_type_id,address_id) values ('7041518506',1,2);
insert into phone(phone_number,phone_type_id,address_id) values ('6353937476',1,3);

select * from phone;

create table if not exists fax (
fax serial primary key,
fax_number numeric,
address_id int references address(address_id),
created_at timestamp default current_timestamp,
updated_at timestamp
);

insert into fax(fax_number,address_id) values ('7486877290',1);
insert into fax(fax_number,address_id) values ('6353937476',3);
insert into fax(fax_number,address_id) values ('7041518506',2);

select * from fax;



create table if not exists preferences (
preferences_id serial primary key,
preference varchar(25),
phone_id int references phone(phone_id),
fax_id int references fax(fax),
address_id int references address(address_id),
patient_id int references patient(patient_id),
created_at timestamp default current_timestamp,
updated_at timestamp
);

insert into preferences(preference,phone_id,fax_id,address_id,patient_id) values ('primary',2,1,1,1);
insert into preferences(preference,phone_id,fax_id,address_id,patient_id) values ('primary',4,2,3,3);

select * from preferences;



--1.Create View to fetch the result of FirstName, LastName, MiddleName, DOB, Chart Number, Sex , Race , Primary Address, Primary Phone, Primary Fax.
 create or replace view  demographics as
  select patient.patient_id,first_name,last_name,dob,sex,race,address_type,street,zip,city,state,country,phone_number,fax_number
  from patient 
  left join sex on 
  patient.sex_id = sex.sex_id
  left join patient_race on 
  patient.patient_id = patient_race.patient_id
  left join race on 
  race.race_id = patient_race.patient_race_id
  left join preferences on 
  patient.patient_id = preferences.patient_id and preference='primary'
  left join address on 
  preferences.address_id = address.address_id
  left join phone on
  preferences.phone_id = phone.phone_id
  left join fax on 
  preferences.fax_id = fax.fax 

;
 
 
 select * from demographics;


--2.Write Query to fetch unique record from the Patient table based on Firstname, LastName, DOB and Sex with number of occurance(count) of same data.
select first_name,last_name,dob,sex,count(*) from patient 
left join sex on 
patient.sex_id = sex.sex_id
group by first_name,last_name,dob,sex
having count(*)>0;

--3.Create Function to stored the data into patient table. Pass all the value in the function parameter and function should return the created new primary key value of the table.

CREATE OR REPLACE  FUNCTION insert_data_return_PK(
first_name varchar(25),
last_name varchar (25),
middle_name varchar(25),
sex_id int ,
dob date
)
RETURNS int
LANGUAGE plpgsql
AS $$
BEGIN
insert into patient(first_name,last_name,middle_name,sex_id,dob) values (first_name,last_name,middle_name,sex_id,dob) ;
return 
  (select currval(pg_get_serial_sequence('patient','patient_id'))  );
END
$$;


select insert_data_return_PK('rakesh','chaudhary','jayantilal',1,'1973-09-29');

select * from patient;


--4.Create Function to get the result of patient’s data by using patientId, lastname, firstname, sex, dob. Need to implement the pagination and sorting(LastName, Firstname, Sex, DOB) in this function.
--drop function search_patient(id varchar(25) default null,PageNumber INTEGER = 1,
--PageSize INTEGER = 10);
create  or replace function  
search_patient	
			(
			pageNumber in integer default 1 ,
			pageSize in integer default 20,
			firstName in varchar default '',
			lastName in varchar default '',
			gender in varchar default '',
			dateofbirth in varchar default '',
			orderby in varchar default 'patient_id > 0')
returns table( 	patient_id int,
				first_name varchar,
				last_name varchar,
				dob date,
				sex varchar,
				race varchar,
				address_type int,
				street varchar,
				zip int,
				city varchar,
				state varchar,
				country varchar,
				phone_number numeric,
				fax_number numeric
)
language plpgsql
as
$$
declare 
query1 varchar(2000) := 'select * from demographics ';
conditional varchar(3000) := '';
 
begin

	if firstName != '' then
		 conditional := 'where first_name = '''||firstName||'''';
	end if;

	if lastName != '' then 
		if conditional != '' then
			conditional := conditional||' and last_name = '''||lastName||'''';
		else 
			conditional := 'where last_name = '''||lastName||'''';
		end if;
	end if;
	if gender != '' then 
		if conditional != '' then
			conditional := conditional||' and sex = '''||gender||'''';
		else 
			conditional := 'where sex = '''||gender||'''';
		end if;
	end if;
	if dateofbirth != '' then 
		if conditional != '' then
			conditional := conditional||' and dob = '''||dateofbirth||'''';
		else 
			conditional := 'where dob = '''||dateofbirth||'''';
		end if;
	end if;
	
	query1 := query1||conditional||' ORDER BY '|| orderby|| ' ASC LIMIT '|| pageSize ||' OFFSET (('||pageNumber||'-1) *'|| pageSize||')';
	raise notice 'sql %' , query1;
	return query execute query1;
end;
$$




select * from search_patient(1,2,firstName=>'',lastName=>'chaudhary');
select * from search_patient(2,2,firstName=>'',lastName=>'chaudhary',gender=>'male');

select * from search_patient(1,2,firstName=>'',lastName=>'chaudhary',gender=>'',dateofbirth=>'',orderby=>'dob');
select  from search_patient();



--5.Write Query to search the patient by patient’s phone no
select first_name,last_name,middle_name,dob,chart_id from
patient left join address on 
patient.patient_id = address.patient_id
left join phone on 
address.address_id = phone.address_id
where phone_number = '9016873801';


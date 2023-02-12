

/*CREATE TABLE SEX(
  SEX_ID SERIAL PRIMARY KEY,
  GENDER VARCHAR(20)
);
INSERT INTO SEX(GENDER) VALUES('male');
INSERT INTO SEX(GENDER) VALUES('female');
INSERT INTO SEX(GENDER) VALUES('unknown');
SELECT * FROM SEX;

CREATE TABLE PHONE_TYPE(
  PHONE_ID SERIAL PRIMARY KEY,
  PHONE_TYPE VARCHAR(20)
);
INSERT INTO PHONE_TYPE(PHONE_TYPE) VALUES('CELL');
INSERT INTO PHONE_TYPE(PHONE_TYPE) VALUES('LANDLINE');
SELECT * FROM PHONE_TYPE;


CREATE TABLE ADDRESS_TYPES(
  ADDRESS_ID SERIAL PRIMARY KEY,
  ADDRESS_TYPE VARCHAR(20)
);
INSERT INTO ADDRESS_TYPES(ADDRESS_TYPE) VALUES('WORK');
INSERT INTO ADDRESS_TYPES(ADDRESS_TYPE) VALUES('HOME');
SELECT * FROM ADDRESS_TYPES;


CREATE TABLE RACE_TYPE(
  RACE_ID SERIAL PRIMARY KEY,
  RACE_TYPE VARCHAR(20)
);
INSERT INTO RACE_TYPE(RACE_TYPE) VALUES('ASIAN');
INSERT INTO RACE_TYPE(RACE_TYPE) VALUES('AMERICAN');
SELECT * FROM RACE_TYPE;*/

CREATE TABLE IF NOT EXISTS Patient(
  PATIENT_ID SERIAL primary key,
  CHART_NUMBER VARCHAR(20) NOT null generated always as ('CHART'||PATIENT_ID::text) stored,
  FIRST_NAME VARCHAR(20) NOT NULL,
  LAST_NAME VARCHAR(20) NOT NULL,
  MIDDLE_NAME VARCHAR(20),
  DOB DATE,
  SEX INT,
  isDeleted boolean default false,
  created_on timestamp default CURRENT_TIMESTAMP not null,
  CONSTRAINT sex_constraint FOREIGN KEY(SEX) REFERENCES SEX(SEX_ID)
);
SET timezone = 'Asia/Calcutta';
--sex : 1 male 2 female 3 unknown
INSERT into Patient (FIRST_NAME,LAST_NAME,MIDDLE_NAME,SEX) VALUES ('NIKITA','MIRCHANDANI','Manojkumar',2);
INSERT into Patient (FIRST_NAME,LAST_NAME,MIDDLE_NAME,SEX) VALUES ('meet','Vachhani','nileshbhai',1);
INSERT into Patient (FIRST_NAME,LAST_NAME,MIDDLE_NAME,SEX) VALUES ('meet','Parekh','hareshbhai',1);
INSERT into Patient (FIRST_NAME,LAST_NAME,MIDDLE_NAME,SEX) VALUES ('saumya','Shah','Snehbhai',1);
SELECT * from Patient;
alter table Patient add isActive boolean default true not null;
alter table Patient add modified_on timestamp default CURRENT_TIMESTAMP not null;


create table AllergyMaster(
	AllergyMasterId SERIAL PRIMARY KEY,
	Code VARCHAR(20) NOT NULL,
	AllergyName VARCHAR(20) not null,
	createdDate timestamp default CURRENT_TIMESTAMP not null,
	LastModifiedDate timestamp default CURRENT_TIMESTAMP not null
)

insert into AllergyMaster(Code,AllergyName) values ('1234','Peanuts');
insert into AllergyMaster(Code,AllergyName) values ('1235','Eggs');
insert into AllergyMaster(Code,AllergyName) values ('1237','Spinach');
select * from allergymaster;

create table PatientAllergy(
	PatientAllergyId SERIAL PRIMARY KEY,
	PatientId INT,
	AllergyMasterId INT,
	Note VARCHAR(30),
	createdDate timestamp default CURRENT_TIMESTAMP not null,
	LastModifiedDate timestamp default CURRENT_TIMESTAMP not null,
	CONSTRAINT patient_id_constraint FOREIGN KEY(PatientId) REFERENCES Patient(PATIENT_ID),
	CONSTRAINT AllergyMasterId_constraint FOREIGN KEY(AllergyMasterId) REFERENCES AllergyMaster(AllergyMasterId)
)
alter table PatientAllergy add isDeleted boolean default false;
insert into PatientAllergy(PatientId,AllergyMasterId,Note) values (1,1,'patient hates peanuts');

insert into PatientAllergy(PatientId,AllergyMasterId,Note) values (1,2,'patient hates Eggs');

insert into PatientAllergy(PatientId,AllergyMasterId,Note) values (1,3,'patient hates Spinach');
select * from PatientAllergy;
/*

CREATE TABLE RACE(
  RACE_ID SERIAL PRIMARY KEY,
  RACE_TYPE INT NOT NULL,
  PATIENT_ID INT,
  CONSTRAINT race_id FOREIGN KEY(RACE_TYPE) REFERENCES RACE_TYPE(RACE_ID),
  CONSTRAINT patient_id FOREIGN KEY(PATIENT_ID) REFERENCES Patient(PATIENT_ID)
);
--race type 1 asian 2 american
INSERT INTO RACE(RACE_TYPE,PATIENT_ID) VALUES(1,1);
INSERT INTO RACE(RACE_TYPE,PATIENT_ID) VALUES(1,2);
INSERT INTO RACE(RACE_TYPE,PATIENT_ID) VALUES(1,3);
INSERT INTO RACE(RACE_TYPE,PATIENT_ID) VALUES(1,4);
SELECT * FROM RACE;


CREATE TABLE ADDRESS(
  ADDRESS_ID SERIAL PRIMARY KEY,
  ADDRESS_TYPE INT NOT NULL,
  STREET VARCHAR(20),
  CITY VARCHAR(20),
  ZIP INT,
  STATE VARCHAR(20),
  COUNTRY VARCHAR(20),
  PATIENT_ID INT,
  PRIMARY_ADDRESS BOOLEAN,
  CONSTRAINT user_id FOREIGN KEY(PATIENT_ID) REFERENCES Patient(PATIENT_ID),
  CONSTRAINT ADDRESS_TYPE_CONSTRAINT FOREIGN KEY(ADDRESS_TYPE) REFERENCES ADDRESS_TYPES(ADDRESS_ID)
);
--1 work and 2 home
INSERT INTO ADDRESS(ADDRESS_TYPE,STREET,CITY,ZIP,PATIENT_ID,PRIMARY_ADDRESS) VALUES(1,'STREET','kathlal',387630,1,true);
INSERT INTO ADDRESS(ADDRESS_TYPE,STREET,CITY,ZIP,PATIENT_ID,PRIMARY_ADDRESS) VALUES(1,'STREET','ahmedabad',369852,1,false);
INSERT INTO ADDRESS(ADDRESS_TYPE,STREET,CITY,ZIP,PATIENT_ID,PRIMARY_ADDRESS) VALUES(1,'STREET','rajkot',388552,2,true);
INSERT INTO ADDRESS(ADDRESS_TYPE,STREET,CITY,ZIP,PATIENT_ID,PRIMARY_ADDRESS) VALUES(1,'STREET','ahmedabad',369852,3,false);
INSERT INTO ADDRESS(ADDRESS_TYPE,STREET,CITY,ZIP,PATIENT_ID,PRIMARY_ADDRESS) VALUES(1,'STREET','nadiad',387899,4,true);
SELECT * FROM ADDRESS;

CREATE TABLE PHONE(
  PHONE_ID SERIAL PRIMARY KEY,
  PHONE_NUMBER VARCHAR(10) NOT NULL,
  PHONE_TYPE INT,
  PRIMARY_PHONE BOOLEAN,
  ADDRESS_ID INT,
  CONSTRAINT address_id_constraint FOREIGN KEY(ADDRESS_ID) REFERENCES ADDRESS(ADDRESS_ID),
  CONSTRAINT phone_type_constraint FOREIGN KEY(PHONE_TYPE) REFERENCES PHONE_TYPE(PHONE_ID)
);
--1 cell 2 landline
INSERT into PHONE(PHONE_NUMBER,PHONE_TYPE,PRIMARY_PHONE,ADDRESS_ID) VALUES (8849126581,1,true,1);
INSERT into PHONE(PHONE_NUMBER,PHONE_TYPE,PRIMARY_PHONE,ADDRESS_ID) VALUES (9856982563,1,false,2);
INSERT into PHONE(PHONE_NUMBER,PHONE_TYPE,PRIMARY_PHONE,ADDRESS_ID) VALUES (7788554411,1,true,3);
INSERT into PHONE(PHONE_NUMBER,PHONE_TYPE,PRIMARY_PHONE,ADDRESS_ID) VALUES (8855226699,1,false,4);
INSERT into PHONE(PHONE_NUMBER,PHONE_TYPE,PRIMARY_PHONE,ADDRESS_ID) VALUES (5599887745,2,true,5);

SELECT * from PHONE;

CREATE TABLE FAX(
  FAX_ID SERIAL PRIMARY KEY,
  FAX_NUMBER VARCHAR(10) NOT NULL,
  PRIMARY_FAX BOOLEAN,
  ADDRESS_ID INT,
  CONSTRAINT address_id_constraint FOREIGN KEY(ADDRESS_ID) REFERENCES ADDRESS(ADDRESS_ID)
);

INSERT into FAX(ADDRESS_ID,FAX_NUMBER,PRIMARY_FAX) VALUES (1,5313,true);
INSERT into FAX(ADDRESS_ID,FAX_NUMBER,PRIMARY_FAX) VALUES (2,9856,false);
INSERT into FAX(ADDRESS_ID,FAX_NUMBER,PRIMARY_FAX) VALUES (3,4642,true);
INSERT into FAX(ADDRESS_ID,FAX_NUMBER,PRIMARY_FAX) VALUES (4,4645,false);
INSERT into FAX(ADDRESS_ID,FAX_NUMBER,PRIMARY_FAX) VALUES (5,4645,true);
SELECT * from FAX;


CREATE TABLE PREFERENCE_TYPE_TABLE(
  PREF_ID SERIAL PRIMARY KEY,
  PREFERENCE_TYPE varchar(20)
);
insert into preference_type_table(PREFERENCE_TYPE) values('primary');
insert into preference_type_table(PREFERENCE_TYPE) values('secondary');
SELECT * from PREFERENCE_TYPE_TABLE;


CREATE TABLE PREFERENCE_TABLE(
  PREF_ID SERIAL PRIMARY KEY,
  ADDRESS_ID INT,
  PATIENT_ID INT,
  PREFERENCE_TYPE INT references PREFERENCE_TYPE_TABLE(PREF_ID),
  PHONE_ID INT,
  FAX_ID INT, 
  CONSTRAINT address_id_constraint FOREIGN KEY(ADDRESS_ID) REFERENCES ADDRESS(ADDRESS_ID),
  CONSTRAINT patient_id_constraint FOREIGN KEY(PATIENT_ID) REFERENCES Patient(PATIENT_ID),
  CONSTRAINT fax_id_constraint FOREIGN KEY(FAX_ID) REFERENCES FAX(FAX_ID),
  CONSTRAINT phone_id_constraint FOREIGN KEY(PHONE_ID) REFERENCES PHONE(PHONE_ID)
);
--pref type 1: primary 2 : secondary
select * from address;
select * from phone;
select * from fax;

insert into PREFERENCE_TABLE(ADDRESS_ID,PATIENT_ID,PREFERENCE_TYPE,PHONE_ID) values(1,1,1,1);
insert into PREFERENCE_TABLE(ADDRESS_ID,PATIENT_ID,PREFERENCE_TYPE,PHONE_ID) values(2,1,2,2);
insert into PREFERENCE_TABLE(ADDRESS_ID,PATIENT_ID,PREFERENCE_TYPE,PHONE_ID,FAX_ID) values(3,2,1,2,1);
insert into PREFERENCE_TABLE(ADDRESS_ID,PATIENT_ID,PREFERENCE_TYPE,PHONE_ID,FAX_ID) values(4,3,2,2,1);
insert into PREFERENCE_TABLE(ADDRESS_ID,PATIENT_ID,PREFERENCE_TYPE,PHONE_ID,FAX_ID) values(5,4,1,2,1);
SELECT * from PREFERENCE_TABLE;


---------------------==========================ASSIGNMENT-02=========================------------------------------------
--*Query1

CREATE or REPLACE VIEW demographics AS
    SELECT Patient.patient_id,Patient.FIRST_NAME,Patient.LAST_NAME,Patient.MIDDLE_NAME,Patient.DOB,Patient.CHART_NUMBER,SEX.gender,RACE.RACE_TYPE,ADDRESS.country,ADDRESS.STREET,ADDRESS.ZIP,ADDRESS.CITY,ADDRESS.STATE,PHONE.PHONE_NUMBER,FAX.FAX_NUMBER
    FROM Patient 
    LEFT JOIN SEX ON Patient.SEX = SEX.SEX_ID
    LEFT JOIN RACE ON RACE.PATIENT_ID =  Patient.PATIENT_ID 
    LEFT JOIN RACE_TYPE ON RACE.race_id  =  RACE_TYPE.race_id 
    LEFT JOIN PREFERENCE_TYPE_TABLE ON PREFERENCE_TYPE_TABLE.preference_type ='primary'
    LEFT JOIN PREFERENCE_TABLE ON  PREFERENCE_TABLE.PREF_ID = PREFERENCE_TYPE_TABLE.PREF_ID and PREFERENCE_TABLE.PATIENT_ID= patient.PATIENT_ID
    LEFT JOIN ADDRESS ON Patient.PATIENT_ID = ADDRESS.PATIENT_ID and ADDRESS.address_id = PREFERENCE_TABLE.address_id 
    LEFT JOIN FAX ON PREFERENCE_TABLE.FAX_ID = FAX.FAX_ID and ADDRESS.address_id = fax.address_id 
    LEFT JOIN PHONE ON PREFERENCE_TABLE.PHONE_ID = PHONE.PHONE_ID and ADDRESS.address_id = PHONE.address_id 
     ;

SELECT * FROM demographics;

--*Query2
SELECT FIRST_NAME,LAST_NAME,DOB,SEX,COUNT(*) 
FROM Patient 
GROUP BY FIRST_NAME,LAST_NAME,DOB,SEX;


--*Query3
Create or replace function patientcreate(FIRST_NAME VARCHAR(20), LAST_NAME VARCHAR(20),MIDDLE_NAME VARCHAR(20),DOB DATE, sextype Varchar)  
returns int  
language plpgsql  
as  
$$  
Declare 
primary_key integer;
sexid integer;
Begin  
	sexid = (select sex_id from sex where gender = sextype );
  INSERT INTO Patient(FIRST_NAME,LAST_NAME,MIDDLE_NAME,DOB,SEX) values(FIRST_NAME,LAST_NAME,MIDDLE_NAME,DOB,sexid) returning Patient_id into primary_key;
  return primary_key;  
End;  
$$;  

SELECT patientcreate('ruchit','shah','nehalbhai','2002-01-01','male');
-- SELECT create_patient('Dhruvil','Chaudhary','M','2002-11-12',1);
-- SELECT create_patient('Dhruv','shah','M','2002-11-12',1);
*/
SELECT * from Patient;
SELECT * from PatientAllergy;
SELECT * from  AllergyMaster;
select * from sex;

--create patient along with allergy details
Create or replace function patientallergy(PATIENT_ID INT, ALLERGYMASTER_ID INT,NOTE VARCHAR(30))  
returns int  
language plpgsql  
as  
$$  
Declare 
patientallergykey  integer;

Begin  
  INSERT INTO PatientAllergy(PatientId,AllergyMasterId,Note) values(PATIENT_ID,ALLERGYMASTER_ID,NOTE) returning PatientAllergyId into patientallergykey;
  return patientallergykey;  
End;  
$$;  


SELECT patientallergy(1,2,'Patient hate eggs'); 

--update query for patient allergy
create or replace function patientallergyupdate(
                patient_id int,
                PatientAllergyId int,
                allergyname varchar,
				Note varchar
                )
returns table (
                patientid int
)
language plpgsql
as
$$
declare 
	updatequery varchar:= 'update PatientAllergy set AllergyMasterId = (select AllergyMasterId from AllergyMaster where AllergyName ='''|| $3 ||'''),Note='''|| $4 ||''' where PatientAllergyId='||$2||' and PatientId='||$1||' returning PatientAllergyId ';
 	
 begin
	  raise notice '%',updatequery;
     return query execute updatequery;
 end;
$$
select * from PatientAllergy;
select * from AllergyMaster;

select * from patientallergyupdate(1,5,'Spinach','patient hates Spinach');
--select * from patientallergyupdate(49,1,'Peanuts','patient hates peanuts');

/* Delete query of patient allergy ( using  patientid , patientAllergyId and allergyname which is to be deleted) */
create or replace function patientallergydelete(
                patient_id int,
                PatientAllergyId int,
                allergyname varchar
                )
returns table(
 			patientid int
)
language plpgsql
as
$$
declare 
	deletequery varchar:= 'delete from PatientAllergy where patientid = '|| $1 ||' and AllergyMasterId = (select AllergyMasterId from AllergyMaster where AllergyName = '''|| $3 ||''' ) and PatientAllergyId= '|| $2 ||' returning PatientAllergyId';
 	
 begin
	  raise notice '%',deletequery;
     return query execute deletequery;
 end;
$$

--delete from PatientAllergy where patientid = 1 and AllergyMasterId = (select AllergyMasterId from AllergyMaster where AllergyName ='Spinach') and PatientAllergyId=5 returning PatientAllergyId

select * from patientallergydelete(1,3,'Peanuts');


CREATE OR REPLACE FUNCTION patientget(
 PageNumber integer default 1 ,
 PageSize integer default 20,
 lname VARCHAR default '',
 fname VARCHAR default '',
 mname VARCHAR default '',
 _sex VARCHAR default '',
 do_b VARCHAR default null,
 orderby VARCHAR default 'Patient.patient_id'
 )
 RETURNS TABLE (
 PATIENT_ID INT,
 CHART_NUMBER VARCHAR,
  LAST_NAME varchar,
  FIRST_NAME varchar, 
  MIDDLE_NAME varchar,
  SEX varchar,
  DOB date,
  allergyname VARCHAR
) AS
$BODY$
 declare
 query1 varchar(2000) := 'SELECT Patient.Patient_id, Patient.CHART_NUMBER,Patient.LAST_NAME,Patient.FIRST_NAME,Patient.MIDDLE_NAME,SEX.GENDER,Patient.DOB,allergymaster.allergyname 
FROM Patient 
left JOIN SEX ON Patient.SEX = SEX.SEX_ID 
LEFT JOIN patientallergy ON Patient.patient_id = patientallergy.patientid 
LEFT JOIN allergymaster ON patientallergy.allergymasterid = allergymaster.allergymasterid where Patient.isdeleted=false and 1=1 '; 


BEGIN
	query1 := query1 
	|| case when $4 != '' then ' and Patient.FIRST_NAME = $4' else ' ' end		
	|| case when $3 != '' then ' and Patient.LAST_NAME = $3' else ' ' end		
	|| case when $5 != '' then ' and Patient.MIDDLE_NAME = $5' else ' ' end				
	|| case when $6 != '' then ' and SEX.GENDER =$6' else ' ' end		
	|| case when $7 != '' then ' and Patient.DOB =$7::date' else  ' ' end		
	|| ' ORDER BY '||$8 ||' asc limit $2 OFFSET (($1 - 1) * $2);';	
--	raise notice 'sql %' , query1;	
	RETURN QUERY execute query1 using PageNumber,PageSize,lname,fname,mname,_sex,do_b,orderby;
END;
$BODY$
LANGUAGE plpgsql;

SELECT * from patientget(fname=>'NIKITA');
select * from patientget(lname=>'shah',orderby=>'Patient.first_name');
select * from patientget(lname=>'shah',orderby=>'Patient.DOB');
select * from patientget(_sex=>'male',orderby=>'Patient.last_name');
select * from patientget(do_b=>'2002-01-01');
select * from patientget();

/*
--*Query5
SELECT
              p.FIRST_NAME,Ph.PHONE_NUMBER,add.ADDRESS_ID
FROM
              Patient p
              INNER JOIN ADDRESS add ON add.PATIENT_ID = P.PATIENT_ID
              INNER JOIN Phone Ph ON ph.ADDRESS_ID = add.ADDRESS_ID
WHERE Ph.PHONE_NUMBER = '3355668822';

--function to update 
create or replace function patientupdate(
                patient_id int,
                first_name varchar,
                last_name varchar,
                middle_name varchar,
                sex varchar,
                dob date
                )
returns table (
                patientid int
)
language plpgsql
as
$$
declare 
	_query varchar :='';
 	_update varchar:= 'update Patient set FIRST_NAME = $2,LAST_NAME = $3, MIDDLE_NAME = $4,SEX=(';
 	_select varchar:= 'select sex_id from sex where GENDER = $5),';
 begin
     _query := _update || _select ||'dob=$6 where patient_id = $1 and isdeleted= false returning patient_id';
     raise notice '%',_query;
     return query execute _query using patient_id,first_name,last_name,middle_name,sex,dob;
 end;
$$
select * from patientupdate(1,'Nikita','Mirchandani','Manojkumar','female','2002-01-10');

select * from patient;
select * from SEX;


--function to delete 
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
 deletedEntry varchar;
 begin
     deletedEntry := 'update Patient set isDeleted = true where PATIENT_ID= '||$1||' returning  patient_id,FIRST_NAME , LAST_NAME,MIDDLE_NAME,SEX,DOB';
     raise notice '%',deletedEntry; 
    return query execute deletedEntry using patient_id;
 end;
$$
select * from patientdelete(8);
*/

--function to getbyId 
create or replace function patientgetbyId(
                patientid int
   )
	returns table (
                patient_id int,
                CHART_NUMBER VARCHAR,
                firstname varchar,
                lastname varchar,
                middlename varchar,
                sex_id int,
                sex varchar,
                dob date,
                allergyname varchar 
)
language plpgsql
as
$$
declare 
 GetById varchar;
 begin
     GetById := 'select PATIENT_ID,CHART_NUMBER ,FIRST_NAME , LAST_NAME,MIDDLE_NAME,SEX,SEX.GENDER,DOB,allergymaster.allergyname
            from Patient
left JOIN SEX ON Patient.SEX = SEX.SEX_ID 
LEFT JOIN patientallergy ON Patient.patient_id = patientallergy.patientid 
LEFT JOIN allergymaster ON patientallergy.allergymasterid = allergymaster.allergymasterid where Patient.isdeleted=false and PATIENT_ID = '|| $1;

     raise notice '%',GetById; 
    return query execute GetById using patient_id;
 end;
$$
select * from patientgetbyId(2);

--paging and sorting 
/*
CREATE OR REPLACE FUNCTION getlist(
 PageNumber integer default 1 ,
 PageSize integer default 20,
 orderby VARCHAR default 'Patient.patient_id'
 )
 RETURNS TABLE (
  LAST_NAME varchar,
  FIRST_NAME varchar,
  SEX varchar,
  DOB date
) AS
$BODY$
 declare
 query1 varchar(2000) := 'SELECT Patient.LAST_NAME,Patient.FIRST_NAME,SEX.GENDER,Patient.DOB FROM Patient left JOIN SEX ON 
Patient.SEX = SEX.SEX_ID where Patient.isdeleted=false and 1=1 '; 

BEGIN
	query1 := query1 	
	|| ' ORDER BY '||$3 ||' asc limit $2 OFFSET (($1 - 1) * $2);';	
--	raise notice 'sql %' , query1;	
	RETURN QUERY execute query1 using PageNumber,PageSize,orderby;
END;
$BODY$
LANGUAGE plpgsql;

SELECT * from getlist(fname=>'NIKITA');
select * from getlist(lname=>'shah',orderby=>'Patient.first_name');
select * from getlist(lname=>'shah',orderby=>'Patient.DOB');
select * from getlist(_sex=>'male',orderby=>'Patient.last_name');
select * from getlist(do_b=>'2002-01-01');
select * from getlist();
*/

select * from patient;
select * from patientallergy;
select * from allergymaster;

/*--getlist of patient with allergy
CREATE OR REPLACE FUNCTION getlist(
 PageNumber integer default 1 ,
 PageSize integer default 20,
 orderby VARCHAR default 'Patient.patient_id'
 )
 RETURNS TABLE (
  LAST_NAME varchar,
  FIRST_NAME varchar,
  SEX varchar,
  DOB date,
  allergyname varchar
) AS
$BODY$
 declare 
 query1 varchar(2000) := 'SELECT Patient.LAST_NAME,Patient.FIRST_NAME,SEX.GENDER,Patient.DOB,allergymaster.allergyname
FROM Patient 
LEFT JOIN SEX ON Patient.SEX = SEX.SEX_ID
LEFT JOIN patientallergy ON Patient.patient_id = patientallergy.patientid 
LEFT JOIN allergymaster ON patientallergy.allergymasterid = allergymaster.allergymasterid where Patient.isdeleted=false and 1=1 '; 

BEGIN
	query1 := query1 	
	|| ' ORDER BY '||$3 ||' asc limit $2 OFFSET (($1 - 1) * $2);';	
--	raise notice 'sql %' , query1;	
	RETURN QUERY execute query1 using PageNumber,PageSize,orderby;
END;
$BODY$
LANGUAGE plpgsql;

SELECT * from getlist(fname=>'NIKITA');
select * from getlist(lname=>'shah',orderby=>'Patient.first_name');
select * from getlist(lname=>'shah',orderby=>'Patient.DOB');
select * from getlist(_sex=>'male',orderby=>'Patient.last_name');
select * from getlist(do_b=>'2002-01-01');
select * from getlist();*/


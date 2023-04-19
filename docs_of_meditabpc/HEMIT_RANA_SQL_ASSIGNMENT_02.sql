--------------------
____________________________________________MAIN assignment_______________________________
-------------




create table AllergyMaster(
    AllergyMasterId SERIAL primary key,
	Code varchar(100) not null,
    AllergyName varchar(100) null,
    createdDate timestamp default CURRENT_TIMESTAMP not null,
    LastModifiedDate timestamp default current_timestamp not null
    
);
INSERT INTO AllergyMaster(Code,AllergyName) VALUES('166.63','MILK');
INSERT INTO AllergyMaster(Code,AllergyName) VALUES('166.89','PEANUT');
INSERT INTO AllergyMaster(Code,AllergyName) VALUES('166.23','LATEX');
select * from AllergyMaster;




create table PatientAllergy(
	PatientAllergyId SERIAL primary key,
	patient_id INT,
    AllergyMasterId INT,
	Note varchar(100) not null,
    --ChangeLog int,
    createdDate timestamp default CURRENT_TIMESTAMP not null,
    LastModifiedDate timestamp default current_timestamp not null,
    CONSTRAINT fk_pid  
    FOREIGN KEY(patient_id)   
    REFERENCES Patients(patient_id),
    CONSTRAINT fk_aid  
    FOREIGN KEY(AllergyMasterId)   
    REFERENCES AllergyMaster(AllergyMasterId)
);
INSERT INTO PatientAllergy(patient_id,AllergyMasterId,Note) VALUES(1,1,'note1');
INSERT INTO PatientAllergy(patient_id,AllergyMasterId,Note) VALUES(1,2,'note2');
INSERT INTO PatientAllergy(patient_id,AllergyMasterId,Note) VALUES(2,3,'note3');
select * from Note;


/*
'Select Patients.patient_id, Patients.firstname, Patients.lastname, Patients.dob, Patients.chart_number, sex.sex,AllergyMaster.AllergyName,PatientAllergy.Note,AllergyMaster.code
From
    Patients
    LEFT JOIN sex ON Patients.sex_id = sex.sex_id 
LEFT JOIN PatientAllergy ON Patients.patient_id = PatientAllergy.patient_id 
LEFT JOIN AllergyMaster ON PatientAllergy.AllergyMasterId = AllergyMaster.AllergyMasterId
where Patients.isdeleted=false and 1=1'*/

ALTER TABLE PatientAllergy
ADD isDeleted boolean default false not null;




------(1)GetById
create or replace function PatientAllergyGetbyID(
                patientid int
                
                )
returns table (
                patient_id int,
                chart_number varchar,
                firstname varchar,
                lastname varchar,
                middlename varchar,
                sex_id int,
                sex varchar,
                dob date,
                allergyname varchar,
                note varchar,
                code varchar
)
language plpgsql
as
$$
declare 
--_query varchar :='';
 _query varchar:= 'select Patients.patient_id,chart_number,firstname , lastname,middlename,Patients.sex_id,sex.sex,dob,AllergyMaster.AllergyName,PatientAllergy.Note,AllergyMaster.code from Patients 
left join sex on sex.sex_id=Patients.sex_id
LEFT JOIN PatientAllergy ON Patients.patient_id = PatientAllergy.patient_id 
LEFT JOIN AllergyMaster ON PatientAllergy.AllergyMasterId = AllergyMaster.AllergyMasterId'; 
 
 begin
     _query := _query || ' where Patients.isdeleted=false and Patients.patient_id='||$1||' LIMIT 1';
     raise notice '%',_query;
     return query execute _query using patient_id,chart_number,firstname,lastname,middlename,sex_id,dob;
 end;
$$ 


select * from PatientAllergyGetbyID(1);





------(2)GetList

--,AllergyMaster.AllergyName,PatientAllergy.Note,AllergyMaster.code

   create  or replace function  
patientallergyget(
			_PageNumber INTEGER = 1,
  			_PageSize INTEGER = 20,
			_first_Name varchar default '',
			_last_Name varchar default '',
			_gender varchar default '',
			_dateofbirth varchar default null,
			_allergy_name varchar default '',
			_orderby in varchar default 'Patients.patient_id',
			_ordertype in varchar default 'ASC'
			)
returns table( 	patientid integer,firstname varchar, lastname varchar, dob date, chart_number varchar, sex varchar--,AllergyName VARCHAR, Note varchar, code varchar
)
language plpgsql
as
$$
declare 
initialquery varchar(2000) := 'Select Patients.patient_id, Patients.firstname, Patients.lastname, Patients.dob, Patients.chart_number, sex.sex
From
    Patients
    LEFT JOIN sex ON Patients.sex_id = sex.sex_id 
LEFT JOIN PatientAllergy ON Patients.patient_id = PatientAllergy.patient_id 
LEFT JOIN AllergyMaster ON PatientAllergy.AllergyMasterId = AllergyMaster.AllergyMasterId
where Patients.isdeleted=false and 1=1';
conditional varchar(3000) := '';
 
begin
	initialquery := initialquery
	|| case when $3 != '' then ' and Patients.firstname = '''||$3||'''' else '' end 
	||case when $4 != '' then ' and Patients.lastname = '''||$4||'''' else '' end 
	||case when $5 != '' then ' and sex.sex = '''||$5||'''' else '' end
	||case when $6 != '' then ' and Patients.dob = '''||$6::date||'''' else '' end
	||case when $7 != '' then ' and AllergyMaster.AllergyName = '''||$7||'''' else '' end
	||' GROUP BY Patients.patient_id,sex.sex ORDER BY '|| $8|| ' ' || $9||' LIMIT '|| $2 ||' OFFSET (('||$1||'-1) *'|| $2||')';

	raise notice 'sql %' , initialquery;
	return query execute initialquery using PageNumber,PageSize,first_Name,last_Name,gender,dateofbirth,allergy_name,orderby,ordertype;
end;
$$

 select * from patientallergyget();
 select * from patientallergyget(ordertype=>'DESC'); 
   select * from patientallergyget(first_Name=>'HEMIT');
select * from patientallergyget(allergy_name=>'MILK');
  select * from patients order by patient_id asc;
 select * from AllergyMaster;


create  or replace function  
allergyget(
			Patientid int
			)
returns table( 	patient_id_ int,PatientAllergyId_ integer,AllergyMasterId_ int, Note_ varchar, AllergyName_ varchar, code_ varchar
)
language plpgsql
as
$$
declare 
initialquery varchar(2000) := 'select patient_id,PatientAllergy.PatientAllergyId,PatientAllergy.AllergyMasterId,PatientAllergy.Note,AllergyMaster.AllergyName,AllergyMaster.code  
from PatientAllergy 
LEFT JOIN AllergyMaster ON PatientAllergy.AllergyMasterId = AllergyMaster.AllergyMasterId where PatientAllergy.isdeleted=false and patient_id='||$1;
begin
	raise notice 'sql %' , initialquery;
	return query execute initialquery using Patientid;
end;
$$

select * from allergyget(1);
select * from PatientAllergy;

/*select PatientAllergy.PatientAllergyId,PatientAllergy.AllergyMasterId,PatientAllergy.Note,AllergyMaster.AllergyName,AllergyMaster.code  
from PatientAllergy 
LEFT JOIN AllergyMaster ON PatientAllergy.AllergyMasterId = AllergyMaster.AllergyMasterId where PatientAllergy.isdeleted=false and patient_id=101;*/


--*******************************************************
--*******************************************************
--*******************************************************

   create  or replace function  
patientallergygetCombined(
			PageNumber INTEGER = 1,
  			PageSize INTEGER = 20,
			_first_Name varchar default '',
			_last_Name varchar default '',
			_gender varchar default '',
			_dateofbirth varchar default null,
			_allergy_name varchar default '',
			_orderby in varchar default 'Patients.patient_id',
			_ordertype in varchar default 'ASC',
			_PatientId Integer default 0
			)
returns table( 	patientid integer,firstname varchar, lastname varchar, dob date, chart_number varchar, sex varchar,_PatientAllergyId int,_AlergyMasterID int,_AllergyName VARCHAR, _Note varchar, _code varchar, rownumber bigint
)
language plpgsql
as
$$
declare 
initialquery varchar(2000) := 'Select Patients.patient_id, Patients.firstname, Patients.lastname, Patients.dob, Patients.chart_number,sex.sex,COALESCE (PatientAllergy.PatientAllergyId,0) as patientAllergyid,COALESCE(PatientAllergy.AllergyMasterId,0) as AllergyMasterId ,COALESCE (AllergyMaster.AllergyName,'''') as AllergyName,COALESCE (PatientAllergy.note,'''') as note,AllergyMaster.code,
DENSE_RANK() OVER (
		ORDER BY Patients.patient_id
	) as denserow 
From
    Patients
    LEFT JOIN sex ON Patients.sex_id = sex.sex_id 
LEFT JOIN PatientAllergy ON Patients.patient_id = PatientAllergy.patient_id 
LEFT JOIN AllergyMaster ON PatientAllergy.AllergyMasterId = AllergyMaster.AllergyMasterId
where Patients.isdeleted=false and 1=1 ';
conditional varchar(3000) := '';
 
begin
	initialquery := 'select * from(' || initialquery
	|| case when $10 != 0 then ' and Patients.patient_id = '''||$10||'''' else '' end 
	|| case when $3 != '' then ' and Patients.firstname = '''||$3||'''' else '' end 
	||case when $4 != '' then ' and Patients.lastname = '''||$4||'''' else '' end 
	||case when $5 != '' then ' and sex.sex = '''||$5||'''' else ''  end
	|| case when $6 != '' then ' and Patients.dob = '''||$6::date||'''' else ''  end
	||case when $7 != '' then ' and AllergyMaster.AllergyName = '''||$7||'''' else '' end
	||' ORDER BY '|| $8|| ' ' || $9
	/*||
	' OFFSET (('||$1||'-1) *'|| $2||')'*/
	||')as table1 where denserow<='||$2||'*'||$1 ||'and denserow>'||$2||'*'||($1-1) ;--||'group by denserow';

	raise notice 'sql %' , initialquery;
	return query execute initialquery using PageNumber,PageSize,_first_Name,_last_Name,_gender,_dateofbirth,_allergy_name,_orderby,_ordertype;
end;
$$

--' LIMIT '|| $2 ||
--||' LIMIT '|| $2 

 select * from patientallergygetCombined(PageNumber=>1,PageSize=>5);
select * from patientallergy;

select * from (
Select Patients.patient_id, Patients.firstname, Patients.lastname, Patients.dob, Patients.chart_number,
row_number() over (ORDER BY Patients.patient_id) rownumber
From
    Patients
    LEFT JOIN sex ON Patients.sex_id = sex.sex_id
where Patients.isdeleted=false and 1=1) as table1 where rownumber<=10;






------(3)create
CREATE or replace function create_PatientAllergy(patientid INT, AllergyMaster_Id INT, note varchar(100))
returns INT 

AS 
$$
declare
primarykey integer;
BEGIN
    INSERT INTO PatientAllergy(patient_id,AllergyMasterId,Note) VALUES(patientid,AllergyMaster_Id,note) returning PatientAllergyId into primarykey; 
    return primarykey;
--   (SELECT patient_id FROM Patients ORDER BY created_on DESC LIMIT 1);  
End;
$$ language plpgsql;


select create_PatientAllergy(3,1,'bad');
select * from PatientAllergy;








------(4)Update
create or replace function Update_PatientAllergy(_PatientAllergy_Id int,_patient_id int,_AllergyName varchar,_Note varchar)
returns table (PatientAllergyId int)
language plpgsql
as
$$
declare 
_initialquery varchar :='update PatientAllergy set AllergyMasterId=(select AllergyMasterId from AllergyMaster where AllergyName = '''||$3||'''),Note='''||$4||''' where patient_id='||$2||' and PatientAllergyId='||$1||' returning PatientAllergyId';
-- _updatequery varchar:= ; 
-- _selectquery varchar:= '';
 begin
     --_initialquery := _updatequery || _selectquery ||'';
     raise notice '%',_initialquery;
     return query execute _initialquery using _PatientAllergy_Id,_patient_id,_AllergyName,_Note;
 end;
$$  

select * from Update_PatientAllergy(4,3,'MILK','S');

select * from Update_PatientAllergy(5,3,'LATEX','S');
--select * from Sex;  
--  
-- select * from Patients order by patient_id asc;


/*--(4) update
--function to update 
create or replace function patientupdate(_patientid int,_first_name varchar,_last_name varchar,_middle_name varchar,_sex varchar,_dateofbirth date)
returns table (patient_id int)
language plpgsql
as
$$
declare 
_initialquery varchar :='update Patients set firstname = '''||$2||''',lastname='''||$3||''',middlename='''||$4||''',sex_id=(select sex_id from sex where sex = '''||$5||'''),dob='''||$6||''' where patient_id='||$1||' and isdeleted=false returning patient_id';
-- _updatequery varchar:= ; 
-- _selectquery varchar:= '';
 begin
     --_initialquery := _updatequery || _selectquery ||'';
     raise notice '%',_initialquery;
     return query execute _initialquery using _patientid,_first_name,_last_name,_middle_name,_sex,_dateofbirth;
 end;
$$  

select * from patientupdate(11,'SHRUTI','RANA','S','FEMALE','2002-01-01');

select * from patientupdate(14,'SUMEET','PATEL','S','MALE','2003-01-01');
select * from Sex;  
  
 select * from Patients order by patient_id asc;
 select * from patientallergy order by patient_id asc;*/






------(5)Delete
create or replace function Deleted_PatientAllergy(
                PatientAllergy_Id int,
                --patientid int,
                --allergyname varchar
                )
returns table (
                PatientAllergyId int
                
)
language plpgsql
as
$$
declare 
--_query varchar :='';
 _query varchar:= 'update PatientAllergy set isdeleted=true'; 
 
 begin
     _query := _query || ' where PatientAllergyId='||$1||' returning PatientAllergyId';
     raise notice '%',_query;
     return query execute _query using patientid;
 end;
$$  

--and AllergyMasterId=(select AllergyMasterId from AllergyMaster where AllergyName='''||$2||''') 

select * from Deleted_PatientAllergy(19);
select * from patientallergy;

create or replace function Deleted_PatientanditsAllergy(
                --PatientAllergy_Id int,
                patientid int

                )
returns table (
                PatientAllergyId int
                
)
language plpgsql
as
$$
declare 
--_query varchar :='';
 _query varchar:= 'update PatientAllergy set isdeleted=true'; 
 
 begin
     _query := _query || ' where patient_id='||$1||' returning PatientAllergyId';
     raise notice '%',_query;
     return query execute _query using patientid;
 end;
$$ 

select * from Deleted_PatientanditsAllergy(2);
select * from patients;







------(6)Patch
create or replace function patchPatientAllergy(_PatientAllergy_Id int,_patient_id int default null,_allergyname varchar default null , _note varchar default null)
returns  TABLE(
    PatientAllergyId int
) 
LANGUAGE PLPGSQL
as 
$$
declare
    _initialquery varchar :='update PatientAllergy set '
	   || case when $3 != '' then 'AllergyMasterId=(select AllergyMasterId from AllergyMaster where AllergyName = '''||$3||''')' else 'AllergyMasterId=AllergyMasterId' end
	  || case when $4 != '' then ',Note='''||$4||'''' else ',Note=Note' end
	 ||',lastmodifieddate = current_timestamp ' ||'where patient_id='||$2||' and PatientAllergyId='||$1||' returning PatientAllergyId';
    begin

         RAISE notice '%',_initialquery;
    return query execute _initialquery using _PatientAllergy_Id,_patient_id,_allergyname,_note;
    end;
$$


select* from patchPatientAllergy(PatientAllergy_Id=>14, patient_id=> 4,note=>'note354356463');

create or replace function patchPatientData(_patientid int,_first_name varchar default null,_last_name varchar default null , _middle_name varchar default null, _sex varchar default null,_dateofbirth varchar default null)
returns  TABLE(
    patient_id int
) 
LANGUAGE PLPGSQL
as 
$$
declare
    _initialquery varchar :='update Patients set '
    ||case when $2 != '' then 'firstname='''||$2||'''' else 'firstname=firstname' end
    ||case when $3 != '' then ',lastname='''||$3||'''' else ',lastname=lastname' end
    ||case when $4 != '' then ',middlename='''||$4||'''' else ',middlename=middlename' end
	   || case when $5 != '' then ',sex_id=(select sex_id from sex where sex = '''||$5||''')' else ',sex_id=sex_id' end
	  || case when $6 != '' then ',dob='''||$6::date||'''' else ',dob=dob' end
	 ||',modified_on = current_timestamp ' ||'where patient_id='||$1||' and isdeleted=false returning patient_id';
    begin

         RAISE notice '%',_initialquery;
    return query execute _initialquery using _patientid;
    end;
$$

 select * from Patients order by patient_id asc; 
select * from patientallergy;
select * from patchPatientData(patientid=>41,first_name=>'trusha');

/*create or replace function patientupdate(patientid int,first_name varchar,last_name varchar,middle_name varchar,sex varchar,dateofbirth date)
returns table (patient_id int)
language plpgsql
as
$$
declare 
_initialquery varchar :='update Patients set firstname = '''||$2||''',lastname='''||$3||''',middlename='''||$4||''',sex_id=(select sex_id from sex where sex = '''||$5||'''),dob='''||$6||''' where patient_id='||$1||' and isdeleted=false returning patient_id';
-- _updatequery varchar:= ; 
-- _selectquery varchar:= '';
 begin
     --_initialquery := _updatequery || _selectquery ||'';
     raise notice '%',_initialquery;
     return query execute _initialquery using patient_id,first_name,last_name,middle_name,sex,dateofbirth;
 end;
$$  

select * from patientupdate(patientid => 11,'SHRUTI','RANA','S','FEMALE','2002-01-01');

select * from patientupdate(14,'SUMEET','PATEL','S','MALE','2003-01-01');
select * from Sex;  
  
 select * from Patients order by patient_id asc;
 select * from patientallergy order by patient_id asc;*/












--*******************************************************************************************************************************
--*******************************************************************************************************************************
--*******************************************************************************************************************************
--*******************************************************************************************************************************
--*******************************************************************************************************************************

--run first 1
--CREATE SEQUENCE PATIENT_ID
--    increment 1
--    start 1;


-- #################  scrolldown for assignment 02 ##################

--________________________________________________________//////*ASSIGNMENT 01*//////_________________________________________________________________
--   2
create table Sex(
  sex_id SERIAL primary key,
  sex varchar(100),
  created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
   
);
INSERT INTO Sex(sex) VALUES('MALE');
INSERT INTO Sex(sex) VALUES('FEMALE');
INSERT INTO Sex(sex) VALUES('UNKNOWN');
select * from Sex;

--3
create table raceTYPE(
    race_type_id serial primary key,
   race varchar(20),
   created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
    
);
INSERT INTO raceTYPE(race) VALUES('AFRICAN');
INSERT INTO raceTYPE(race) VALUES('ASIAN');
INSERT INTO raceTYPE(race) VALUES('WHITE');
select * from raceTYPE;


--4
create table AddressesType(
    AddressesType_id SERIAL primary key,  
    Addresstype varchar(20),
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
);
INSERT INTO AddressesType(Addresstype) VALUES('HOME');
INSERT INTO AddressesType(Addresstype) VALUES('WORK');
INSERT INTO AddressesType(Addresstype) VALUES('OTHER');
select * from AddressesType;

--5
create table phonetype(
    type_id serial primary key, 
    phoneType varchar(20),
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
);
INSERT INTO phonetype(phoneType) VALUES('CELL');
INSERT INTO phonetype(phoneType) VALUES('LANDLINE');

select * from phonetype;


--6
create table Patients(
    patient_id SERIAL primary key,
--  	chartnumber AS 'CHART' + CAST(patient_id AS VARCHAR(10)) PERSISTED PRIMARY KEY
--	CHART_NUMBER VARCHAR(40) NOT null unique DEFAULT to_char(nextval('PATIENT_ID'), '"CHART"0000FM'), 
	CHART_NUMBER varchar(40) not null unique generated always as ('CHART00'||patient_id::text) stored,
	firstname varchar(100) not null,
    middlename varchar(100) null,
    lastname varchar(100) not null,
    sex_id INT,
    dob date,
    isDeleted boolean default false not null,
    created_on timestamp default CURRENT_TIMESTAMP not null,
    modified_on timestamp default current_timestamp not null,
    CONSTRAINT fk_sex  
    FOREIGN KEY(sex_id)   
    REFERENCES Sex(sex_id)
);
INSERT INTO Patients(firstname,lastname,middlename,sex_id,dob) VALUES('HEMIT','RANA','S',1,'2000-01-01');
INSERT INTO Patients(firstname,lastname,middlename,sex_id,dob) VALUES('KHUSHI','RANA','S',2,'2005-01-01');
INSERT INTO Patients(firstname,lastname,middlename,sex_id,dob) VALUES('KHUSHI','RANA','S',2,'2005-01-01');
select * from Patients;

ALTER TABLE Patients
ADD isActive boolean default true not null;

------(3)Create Function to stored the data into patient table. Pass all the value in the function parameter and function should return the created new primary key value of the table.
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


select Insert_PatientData('SANJAY','RANA','T',1,'1975-01-01');
select Insert_PatientData('BHAVYA','RANA','T',1,'2009-01-01');
select Insert_PatientData('HIMANI','RANA','T',2,'2005-01-01');
select Insert_PatientData('GAYATRI','RANA','T',2,'1983-01-01');
select Insert_PatientData('RUPAL','RANA','T',2,'1982-01-01');
select Insert_PatientData('SHAILESH','RANA','T',1,'1978-01-01');
select Insert_PatientData('HARSHANG','RANA','T',1,'1996-01-01');
select Insert_PatientData('RANA','PATEL','T',1,'1996-01-01');
select Insert_PatientData('PRIYA','PATEL','R',2,'1994-1-13');
--select insertPatient(fname=>'PRIYA',lname=>'PATEL',mname=>'R',sex_type=>2, dob=>);
select * from Patients;


--7
create table RACE(
race_id serial primary key,
patient_id INT,    
race_type_id INT,
created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null,
	CONSTRAINT fk_patientid  
    FOREIGN KEY(patient_id)   
    REFERENCES Patients(patient_id),
   CONSTRAINT fk_emp_racetype  
    FOREIGN KEY(race_type_id)   
    REFERENCES raceTYPE(race_type_id)
);

--//////////if you try to run this queris on different device then the reference ids may defer because the refered ids are autogenerated in their respective tables////////////

INSERT INTO RACE(patient_id,race_type_id) VALUES('1',1);
INSERT INTO RACE(patient_id,race_type_id) VALUES('1',2);
INSERT INTO RACE(patient_id,race_type_id) VALUES('2',2);
INSERT INTO RACE(patient_id,race_type_id) VALUES('3',2);
INSERT INTO RACE(patient_id,race_type_id) VALUES('4',2);
INSERT INTO RACE(patient_id,race_type_id) VALUES('5',2);
INSERT INTO RACE(patient_id,race_type_id) VALUES('6',2);
INSERT INTO RACE(patient_id,race_type_id) VALUES('7',2);
INSERT INTO RACE(patient_id,race_type_id) VALUES('8',2);
INSERT INTO RACE(patient_id,race_type_id) VALUES('9',2);
INSERT INTO RACE(patient_id,race_type_id) VALUES('10',2);
INSERT INTO RACE(patient_id,race_type_id) VALUES('10',1);

select * from RACE;
--8
create table Addresses(
    address_id SERIAL primary key,  
    patient_id INT,  --chartnumber is generated through patient_id , so I provided the chartnumber as in realtime patient address can be searched by their chartnumber, as petirntid is autoincremented 
    AddressesType_id INT,
    -- street VARCHAR(200),
    -- city VARCHAR(200),
    zip VARCHAR(200) unique,
    -- _state VARCHAR(200), 
    city VARCHAR(200),
    _state VARCHAR(200),
    street VARCHAR(200),
    country VARCHAR(200), 
    
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null,
    -- PRIMARY KEY(Department_id),  
    CONSTRAINT fk_patient  
    FOREIGN KEY(patient_id)   
    REFERENCES Patients(patient_id),
    CONSTRAINT fk_addresstype  
    FOREIGN KEY(AddressesType_id)   
    REFERENCES AddressesType(AddressesType_id)  
);

--//////////if you try to run this queris on different device then the reference ids may defer because the refered ids are autogenerated in their respective tables////////////

INSERT INTO Addresses(patient_id,AddressesType_id,zip,city,_state,street,country) VALUES('1',1,'390022','vadodara','Gujarat','vadodara','India');
INSERT INTO Addresses(patient_id,AddressesType_id,zip,city,_state,street,country) VALUES('1',1,'390033','vadodara','Gujarat','vadodara','US');
INSERT INTO Addresses(patient_id,AddressesType_id,zip,city,_state,street,country) VALUES('2',2,'390021','vadodara','Gujarat','vadodara','US');
INSERT INTO Addresses(patient_id,AddressesType_id,zip,city,_state,street,country) VALUES('3',1,'390023','vadodara','Gujarat','vadodara','India');
INSERT INTO Addresses(patient_id,AddressesType_id,zip,city,_state,street,country) VALUES('4',2,'390024','vadodara','Gujarat','vadodara','US');
INSERT INTO Addresses(patient_id,AddressesType_id,zip,city,_state,street,country) VALUES('5',1,'390025','vadodara','Gujarat','vadodara','India');
INSERT INTO Addresses(patient_id,AddressesType_id,zip,city,_state,street,country) VALUES('6',2,'390026','vadodara','Gujarat','vadodara','US');
INSERT INTO Addresses(patient_id,AddressesType_id,zip,city,_state,street,country) VALUES('7',1,'390027','vadodara','Gujarat','vadodara','India');
INSERT INTO Addresses(patient_id,AddressesType_id,zip,city,_state,street,country) VALUES('8',2,'390028','vadodara','Gujarat','vadodara','US');
INSERT INTO Addresses(patient_id,AddressesType_id,zip,city,_state,street,country) VALUES('9',2,'390029','vadodara','Gujarat','vadodara','US');
INSERT INTO Addresses(patient_id,AddressesType_id,zip,city,_state,street,country) VALUES('10',2,'390030','vadodara','Gujarat','vadodara','US');
select * from Addresses;

--9
create table phone(
    ph_id serial primary key, 
    phoneID INT,
    phone varchar(10),
    type_id INT,
    
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null,
    CONSTRAINT fk_emp_phone  
    FOREIGN KEY(phoneID)   
    REFERENCES Addresses(address_id),
    CONSTRAINT fk_emp_phonetype  
    FOREIGN KEY(type_id)   
    REFERENCES phonetype(type_id)
);

--//////////if you try to run this queris on different device then the reference ids may defer because the refered ids are autogenerated in their respective tables////////////

INSERT INTO phone(phoneID,phone,type_id) VALUES(1,'123456789',1);
INSERT INTO phone(phoneID,phone,type_id) VALUES(2,'987654321',2);
INSERT INTO phone(phoneID,phone,type_id) VALUES(3,'123456789',1);
INSERT INTO phone(phoneID,phone,type_id) VALUES(4,'987654321',2);
INSERT INTO phone(phoneID,phone,type_id) VALUES(5,'123456789',1);
INSERT INTO phone(phoneID,phone,type_id) VALUES(6,'987654321',2);
INSERT INTO phone(phoneID,phone,type_id) VALUES(7,'123456789',1);
INSERT INTO phone(phoneID,phone,type_id) VALUES(8,'987654321',2);
INSERT INTO phone(phoneID,phone,type_id) VALUES(9,'123456789',1);
INSERT INTO phone(phoneID,phone,type_id) VALUES(10,'987654321',2);
select * from phone;


--11
create table fax(
    fax_id serial primary key,
    address_id INT,
    fax varchar(10),
    
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null,
    CONSTRAINT fk_emp_fax  
    FOREIGN KEY(address_id)   
    REFERENCES Addresses(address_id)
);

--//////////if you try to run this queris on different device then the reference ids may defer because the refered ids are autogenerated in their respective tables////////////

INSERT INTO fax(address_id,fax) VALUES(1,'123456');
INSERT INTO fax(address_id,fax) VALUES(2,'654321');
INSERT INTO fax(address_id,fax) VALUES(5,'654367');
INSERT INTO fax(address_id,fax) VALUES(6,'123459');
INSERT INTO fax(address_id,fax) VALUES(7,'654320');
INSERT INTO fax(address_id,fax) VALUES(8,'654364');

select * from fax;
-- 12
create table Contact_preference_type(
    preference_type_id serial primary key,
    peference_type_value varchar(20) not null,
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
);
INSERT INTO Contact_preference_type(peference_type_value) VALUES('primary');
INSERT INTO Contact_preference_type(peference_type_value) VALUES('secondary');
select * from Contact_preference_type;
-- 13
create table Contact_preference(
    preference_contact_id serial primary key,
    peference_type_id INT,
    patient_id INT,
    address_id int,
    phone_id int,
    fax_id int,
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null,
    CONSTRAINT fk_patient  
    FOREIGN KEY(patient_id)   
    REFERENCES Patients(patient_id),
    CONSTRAINT fk_address  
    FOREIGN KEY(address_id)   
    REFERENCES Addresses(address_id),
    CONSTRAINT fk_phone  
    FOREIGN KEY(phone_id)   
    REFERENCES phone(ph_id),
     CONSTRAINT fk_fax  
    FOREIGN KEY(fax_id)   
    REFERENCES fax(fax_id),
     CONSTRAINT fk_contactpref  
    FOREIGN KEY(peference_type_id)   
    REFERENCES Contact_preference_type(preference_type_id)
);

--//////////if you try to run this queris on different device then the reference ids may defer because the refered ids are autogenerated in their respective tables////////////


INSERT INTO Contact_preference(peference_type_id,patient_id,address_id,phone_id,fax_id) VALUES(1,'1',1,1,1);
--INSERT INTO Contact_preference(peference_type_id,CHART_NUMBER,address_id,phone_id,fax_id) VALUES(1,'CHART002',3,3,1);

INSERT INTO Contact_preference(peference_type_id,patient_id,address_id,phone_id,fax_id) VALUES(1,'4',5,5,3);

INSERT INTO Contact_preference(peference_type_id,patient_id,address_id,phone_id,fax_id) VALUES(1,'5',6,6,4);
INSERT INTO Contact_preference(peference_type_id,patient_id,address_id,phone_id,fax_id) VALUES(1,'6',7,7,5);
INSERT INTO Contact_preference(peference_type_id,patient_id,address_id,phone_id,fax_id) VALUES(1,'7',8,8,6);

INSERT INTO Contact_preference(peference_type_id,patient_id,address_id,phone_id,fax_id) VALUES(2,'7',8,8,6);
INSERT INTO Contact_preference(peference_type_id,patient_id,address_id,phone_id,fax_id) VALUES(2,'6',7,7,5);

select * from addresses;
select * from patients;
select * from phone;
select * from fax;
select * from Contact_preference;





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
    -- LEFT JOIN Contact_preference as t4 ON t1.;

   

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



-------(4)Create Function to get the result of patient’s data by using patientId, lastname, firstname, sex, dob. Need to implement the pagination and sorting(LastName, Firstname, Sex, DOB) in this function.


--with dynamic query
 
create  or replace function  
search_patient_and_pagination(
			PageNumber INTEGER = 3,
  			PageSize INTEGER = 3,
			first_Name varchar default null,
			last_Name varchar default null,
			gender varchar default null,
			dateofbirth varchar default null,
			orderby in varchar default 'Patients.patient_id')
returns table( 	patientid integer, firstname varchar, lastname varchar, dob date, chart_number varchar, sex varchar
)
language plpgsql
as
$$
declare 
initialquery varchar(2000) := 'Select Patients.patient_id, Patients.firstname, Patients.lastname, Patients.dob, Patients.chart_number, sex.sex
From
    Patients
    LEFT JOIN sex ON Patients.sex_id = sex.sex_id';
conditional varchar(3000) := '';
 
begin
	if $3 is NULL and $4 is NULL and $5 is NULL and $6 is NULL then 
	conditional := ' where 1=1';
	end if;
	
	
	if $3 is not NULL then
		 conditional := ' where Patients.firstname = '''||$3||'''';
	end if;

	if $4 is not null then 
		if conditional != '' then
			conditional := conditional||' and Patients.lastname = '''||$4||'''';
		else 
			conditional := ' where Patients.lastname = '''||$4||'''';
		end if;
	end if;
	if $5 is not null then 
		if conditional != '' then
			conditional := conditional||' and sex.sex = '''||$5||'''';
		else 
			conditional := ' where sex.sex = '''||$5||'''';
		end if;
	end if;
	if $6 is not null then 
		if conditional is not null then
			conditional := conditional||' and Patients.dob = '''||$6||'''';
		else 
			conditional := ' where Patients.dob = '''||$6||'''';
		end if;
	end if;
	


	initialquery := initialquery||conditional||' ORDER BY '|| orderby|| ' ASC LIMIT '|| pageSize ||' OFFSET (('||pageNumber||'-1) *'|| pageSize||')';
	raise notice 'sql %' , initialquery;
	return query execute initialquery;
end;
$$



select * from search_patient_and_pagination(1,8,first_Name=>'HEMIT',last_Name=>'RANA');
select * from search_patient_and_pagination(2,2,first_Name=>null,last_Name=>'RANA',gender=>'MALE',dateofbirth=>NULL);
select * from search_patient_and_pagination(2,2,first_Name=>null,last_Name=>'RANA',gender=>null,dateofbirth=>'2000-01-01');
select * from search_patient_and_pagination(1,2,first_Name=>null,last_Name=>'RANA',gender=>null,dateofbirth=>null,orderby=>'Patients.dob');
select * from search_patient_and_pagination();



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

--with single parameter passing in arguement( previous attempt but didn't removed it incase of verifying)

CREATE OR REPLACE FUNCTION pagination(
  PageNumber INTEGER = 3,
  PageSize INTEGER = 3,search_id varchar default  null
  )
  RETURNS TABLE(
  patientid integer, firstname varchar, lastname varchar, dob date, chart_number varchar, sex varchar
) AS
  $BODY$
  BEGIN
  RETURN QUERY
  Select t1.patient_id, t1.firstname, t1.lastname, t1.dob, t1.chart_number, t2.sex
From
    Patients as t1
    LEFT JOIN sex as t2 ON t1.sex_id = t2.sex_id
    WHERE 
    (case 
	    when search_id is not null --and lname is null and chartnumber is null and se_x is null and do_b is null
	    then case when search_id in (t1.firstname) then t1.firstname=search_id
				    when search_id in (t1.lastname) then t1.lastname=search_id
				    when search_id in (t1.CHART_NUMBER) then t1.CHART_NUMBER=search_id
				    when search_id in (t2.sex) then t2.sex=search_id
				    when search_id in (t1.dob::VARCHAR) then search_id in (t1.dob::VARCHAR) --typecast for date to varchar comparison
	    		end
	    else 1=1 --this condition is always correct so if no parameter is passed then it will return all records
	    end)
  ORDER BY t1.lastname ASC ,t1.firstname ASC, t2.sex ASC, t1.dob ASC
  LIMIT PageSize
  OFFSET ((PageNumber-1) * PageSize);
END;
$BODY$
LANGUAGE plpgsql;

Select * from pagination(1,4,'HEMIT');--search by firstname
Select * from pagination(1,8,'RANA');--search by lastname
Select * from pagination(1,3,'CHART002');--search by chart number
Select * from pagination(3,1,'MALE');--search by sex
Select * from pagination(1,3,'1975-01-01');--search by dob
Select * from pagination(1,3);--returns all data if search parameter not passed
Select * from pagination(); ---returns all data with 3 pages and 3 records in each if parameter not passed

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

   
   select * from sex;
   
-----------------------------------------------/////////////////ASSIGNMENT 03//////////////////////-------------------------------


   
   
--(1) get by id
create or replace function PatientGetbyID(
                patientid int
                
                )
returns table (
                patient_id int,
                chart_number varchar,
                firstname varchar,
                lastname varchar,
                middlename varchar,
                sex_id int,
                sex varchar,
                dob date
)
language plpgsql
as
$$
declare 
--_query varchar :='';
 _query varchar:= 'select patient_id,chart_number,firstname , lastname,middlename,Patients.sex_id,sex.sex,dob from Patients left join sex on sex.sex_id=Patients.sex_id'; 
 
 begin
     _query := _query || ' where isdeleted=false and patient_id='||$1;
     raise notice '%',_query;
     return query execute _query using patient_id,chart_number,firstname,lastname,middlename,sex_id,dob;
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
returns table( 	patientid integer,firstname varchar, lastname varchar, dob date, chart_number varchar, sex varchar
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




--get all list by pagintion and orderby

create  or replace function  
patientget2(
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

 select * from patientget(1,5,'patients.firstname');


------(3)Create
CREATE or replace function patientcreate(fname varchar(100), mname varchar(100), lname varchar(100),
                          s_id varchar, do_b date)
returns INT 

AS 
$$
declare
primarykey integer;
sexid int;
begin
	sexid= (select sex_id from sex where sex=s_id);
    INSERT INTO Patients(firstname,lastname,middlename,sex_id,dob) VALUES(fname,mname,lname,sexid,do_b) returning patient_id into primarykey; 
    return primarykey;
--   (SELECT patient_id FROM Patients ORDER BY created_on DESC LIMIT 1);  
End;
$$ language plpgsql;

select patientcreate('RIMA','PATEL','R','FEMALE','1994-1-13');
select * from Patients;


--(4) update
--function to update 
create or replace function patientupdate(_patientid int,_first_name varchar,_last_name varchar,_middle_name varchar,_sex varchar,_dateofbirth date)
returns table (patient_id int)
language plpgsql
as
$$
declare 
_initialquery varchar :='update Patients set firstname = '''||$2||''',lastname='''||$3||''',middlename='''||$4||''',sex_id=(select sex_id from sex where sex = '''||$5||'''),dob='''||$6||''' where patient_id='||$1||' and isdeleted=false returning patient_id';
-- _updatequery varchar:= ; 
-- _selectquery varchar:= '';
 begin
     --_initialquery := _updatequery || _selectquery ||'';
     raise notice '%',_initialquery;
     return query execute _initialquery using _patientid,_first_name,_last_name,_middle_name,_sex,_dateofbirth;
 end;
$$  

select * from patientupdate(11,'SHRUTI','RANA','S','FEMALE','2002-01-01');

select * from patientupdate(14,'SUMEET','PATEL','S','MALE','2003-01-01');
select * from Sex;  
  
 select * from Patients order by patient_id asc;
 select * from patientallergy order by patient_id asc;
  
  --update Patients set firstname = @firstname where patient_id=@patient_id and isdeleted=false
  
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

select * from patientdelete(1000);

select * from Sex;  
  
 select * from Patients order by patient_id;
  
  
  
  
  
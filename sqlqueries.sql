--run first 1
--CREATE SEQUENCE PATIENT_ID
--    increment 1
--    start 1;
   
--   2
create table Sex(
  sex_id SERIAL primary key,
  sex varchar(100)
   
);
INSERT INTO Sex(sex) VALUES('MALE');
INSERT INTO Sex(sex) VALUES('FEMALE');
INSERT INTO Sex(sex) VALUES('UNKNOWN');
select * from Sex;

--3
create table raceTYPE(
    race_type_id serial primary key,
   race varchar(20)
    
);
INSERT INTO raceTYPE(race) VALUES('AFRICAN');
INSERT INTO raceTYPE(race) VALUES('ASIAN');
INSERT INTO raceTYPE(race) VALUES('WHITE');
select * from raceTYPE;


--4
create table AddressesType(
    AddressesType_id SERIAL primary key,  
    Addresstype varchar(20)    
);
INSERT INTO AddressesType(Addresstype) VALUES('HOME');
INSERT INTO AddressesType(Addresstype) VALUES('WORK');
INSERT INTO AddressesType(Addresstype) VALUES('OTHER');
select * from AddressesType;

--5
create table phonetype(
    type_id serial primary key, 
    phoneType varchar(20)   
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
    created_on timestamp default CURRENT_TIMESTAMP not null,
    CONSTRAINT fk_sex  
    FOREIGN KEY(sex_id)   
    REFERENCES Sex(sex_id)
);
INSERT INTO Patients(firstname,lastname,middlename,sex_id,dob) VALUES('HEMIT','RANA','S',1,'2000-01-01');
INSERT INTO Patients(firstname,lastname,middlename,sex_id,dob) VALUES('KHUSHI','RANA','S',2,'2005-01-01');
INSERT INTO Patients(firstname,lastname,middlename,sex_id,dob) VALUES('KHUSHI','RANA','S',2,'2005-01-01');
select * from Patients;

--7
create table RACE(
race_id serial primary key,
CHART_NUMBER VARCHAR(40),    
race_type_id INT,
	CONSTRAINT fk_patientid  
    FOREIGN KEY(CHART_NUMBER)   
    REFERENCES Patients(CHART_NUMBER),
   CONSTRAINT fk_emp_racetype  
    FOREIGN KEY(race_type_id)   
    REFERENCES raceTYPE(race_type_id)
);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART001',1);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART001',2);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART002',2);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART003',2);
select * from RACE;
--8
create table Addresses(
    address_id SERIAL primary key,  
    CHART_NUMBER VARCHAR(40) ,
    AddressesType_id INT,
    -- street VARCHAR(200),
    -- city VARCHAR(200),
    zip VARCHAR(200) unique,
    -- _state VARCHAR(200), 
    country VARCHAR(200), 
    prim BOOLEAN,
    -- PRIMARY KEY(Department_id),  
    CONSTRAINT fk_patient  
    FOREIGN KEY(CHART_NUMBER)   
    REFERENCES Patients(CHART_NUMBER),
    CONSTRAINT fk_addresstype  
    FOREIGN KEY(AddressesType_id)   
    REFERENCES AddressesType(AddressesType_id)  
);
INSERT INTO Addresses(CHART_NUMBER,AddressesType_id,zip,country,prim) VALUES('CHART001',1,'390022','India',TRUE);
INSERT INTO Addresses(CHART_NUMBER,AddressesType_id,zip,country,prim) VALUES('CHART002',2,'390021','US',FALSE);
select * from Addresses;

--9
create table phone(
    ph_id serial primary key, 
    phoneID INT,
    phone varchar(10),
    type_id INT,
    prim BOOLEAN,
    CONSTRAINT fk_emp_phone  
    FOREIGN KEY(phoneID)   
    REFERENCES Addresses(address_id),
    CONSTRAINT fk_emp_phonetype  
    FOREIGN KEY(type_id)   
    REFERENCES phonetype(type_id)
);
INSERT INTO phone(phoneID,phone,type_id,prim) VALUES(1,'123456789',1,TRUE);
INSERT INTO phone(phoneID,phone,type_id,prim) VALUES(2,'987654321',2,FALSE);
select * from phone;
--10
create table patient_zip(
zipid SERIAL primary key,
zip VARCHAR(200) unique,
    -- zip varchar(10),
    city VARCHAR(200),
    _state VARCHAR(200),
    street VARCHAR(200),
    CONSTRAINT fk_petient_zip  
    FOREIGN KEY(zip)   
    REFERENCES Addresses(zip)  
);
INSERT INTO patient_zip(zip,city,_state,street) VALUES(390022,'vadodara','Gujarat','vadodara');
INSERT INTO patient_zip(zip,city,_state,street) VALUES(390021,'vadodara','Gujarat','vadodara');
select * from patient_zip;



--11
create table fax(
    fax_id serial primary key,
    address_id INT,
    fax varchar(10),
    prim BOOLEAN,
    CONSTRAINT fk_emp_fax  
    FOREIGN KEY(address_id)   
    REFERENCES Addresses(address_id)
);
INSERT INTO fax(address_id,fax,prim) VALUES(1,'123456',TRUE);
INSERT INTO fax(address_id,fax,prim) VALUES(2,'654321',FALSE);
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
    CHART_NUMBER varchar(40),
    address_id int,
    phone_id int,
    fax_id int,
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null,
    CONSTRAINT fk_patient  
    FOREIGN KEY(CHART_NUMBER)   
    REFERENCES Patients(CHART_NUMBER),
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
INSERT INTO Contact_preference(peference_type_id,CHART_NUMBER,address_id,phone_id,fax_id) VALUES(1,'CHART001',1,1,1);
INSERT INTO Contact_preference(peference_type_id,CHART_NUMBER,address_id,phone_id,fax_id) VALUES(1,'CHART002',1,1,1);
select * from Contact_preference;



-------(1)
Create View information as
Select t1.firstname, t1.lastname, t1.dob, t1.chart_number, t2.sex, t4.race, t5.country, t5.zip, t6.city, t6._state, t6.street, t8.phone
From
    Patients as t1
    LEFT JOIN sex as t2 ON t1.sex_id = t2.sex_id
    LEFT JOIN RACE as t3 ON t1.CHART_NUMBER = t3.CHART_NUMBER
    LEFT join raceTYPE as t4 on t1.CHART_NUMBER = t3.CHART_NUMBER and t3.race_type_id=t4.race_type_id
    LEFT JOIN Contact_preference as t7 on t1.CHART_NUMBER = t7.CHART_NUMBER
    LEFT join Addresses as t5 on t1.CHART_NUMBER = t5.CHART_NUMBER and t7.address_id = t5.address_id
    LEFT join patient_zip as t6 on t5.zip = t6.zip
    LEFT join phone as t8 on t8.ph_id = t7.phone_id;
    -- LEFT JOIN Contact_preference as t4 ON t1.;
    
SELECT * FROM information;

-----(2)
-- SELECT COUNT (UNIQUE firstname,lastname,dob,sex_id) FROM Patients;

-- select count(*) from (select distinct firstname,lastname,dob,sex_id from Patients);
select firstname,lastname,dob,sex_id,count(concat(firstname,lastname,dob,sex_id)) as occurance 
from Patients group by firstname,lastname,dob,sex_id;


------(3)
CREATE function InsertPatientData(fname varchar(100), mname varchar(100), lname varchar(100),
                          s_id INT, do_b date)
returns INT 
language plpgsql
AS 
$$
Declare
BEGIN
    INSERT INTO Patients(firstname,lastname,middlename,sex_id,dob) VALUES(fname,mname,lname,s_id,do_b); 
    return (SELECT patient_id FROM Patients ORDER BY created_on DESC LIMIT 1);  
End;
$$;

select InsertPatientData('SANJAY','RANA','T',1,'1975-01-01');
select InsertPatientData('BHAVYA','RANA','T',1,'2009-01-01');
select InsertPatientData('HIMANI','RANA','T',2,'2005-01-01');
select InsertPatientData('GAYATRI','RANA','T',2,'1983-01-01');
select InsertPatientData('RUPAL','RANA','T',2,'1982-01-01');
select InsertPatientData('SHAILESH','RANA','T',1,'1978-01-01');

select * from Patients;




-- Create function generate_primary_key(FIRST_NAME VARCHAR(20), LAST_NAME VARCHAR(20),MIDDLE_NAME VARCHAR(20),DOB DATE, Sex INT)  
-- returns int  
-- language plpgsql  
-- as  
-- $$  
-- Declare 

-- Begin  
--   INSERT INTO Patient(FIRST_NAME,LAST_NAME,MIDDLE_NAME,DOB,SEX) values(FIRST_NAME,LAST_NAME,MIDDLE_NAME,DOB,Sex);
--   return (SELECT PATIENT_ID FROM Patient ORDER BY created_on DESC LIMIT 1);  
-- End;  
-- $$;  

-- SELECT generate_primary_key('ruchit','shah','M','2002-01-01',1);

-- SELECT generate_primary_key('Dhruvil','shah','M','2002-01-01',1);

-- SELECT generate_primary_key('Dhruvil','shah','M','2002-01-01',2);

-- SELECT generate_primary_key('Raj','chopda','M','2002-01-01',1);
-- SELECT * from Patient;

-------(4)
-- CREATE OR REPLACE FUNCTION get_data (condition VARCHAR, p_year INT) 
--     RETURNS TABLE (
--         film_title VARCHAR,
--         film_release_year INT
-- ) AS $$
-- DECLARE 
--     var_r record;
-- BEGIN
--     FOR var_r IN(SELECT 
--                 title, 
--                 release_year 
--                 FROM film 
--                 WHERE title ILIKE p_pattern AND 
--                 release_year = p_year)  
--     LOOP
--         film_title := upper(var_r.title) ; 
--         film_release_year := var_r.release_year;
--         RETURN NEXT;
--     END LOOP;
-- END; $$ 
-- LANGUAGE 'plpgsql';

create or replace FUNCTION getdata(id varchar)
returns TABLE(
  firstname varchar, lastname varchar, dob date, chart_number varchar, sex varchar, race varchar, country varchar, zip varchar, city varchar, _state varchar, street varchar, phone varchar
)

LANGUAGE 'plpgsql'

as 
$body$
BEGIN
return query
  Select t1.firstname, t1.lastname, t1.dob, t1.chart_number, t2.sex, t4.race, t5.country, t5.zip, t6.city, t6._state, t6.street, t8.phone
From
    Patients as t1
    LEFT JOIN sex as t2 ON t1.sex_id = t2.sex_id
    LEFT JOIN RACE as t3 ON t1.CHART_NUMBER = t3.CHART_NUMBER
    LEFT join raceTYPE as t4 on t1.CHART_NUMBER = t3.CHART_NUMBER and t3.race_type_id=t4.race_type_id
    LEFT JOIN Contact_preference as t7 on t1.CHART_NUMBER = t7.CHART_NUMBER
    LEFT join Addresses as t5 on t1.CHART_NUMBER = t5.CHART_NUMBER and t7.address_id = t5.address_id
    LEFT join patient_zip as t6 on t5.zip = t6.zip
    LEFT join phone as t8 on t8.ph_id = t7.phone_id 
    WHERE t1.firstname=id or t1.lastname=id or t1.CHART_NUMBER=id or t2.sex=id;
END;
$body$;


select * from getdata('HEMIT');
select * from getdata('RANA');
select * from getdata('CHART002');
select * from getdata('MALE');

create or replace FUNCTION getdata(id date)
returns TABLE(
  firstname varchar, lastname varchar, dob date, chart_number varchar, sex varchar, race varchar, country varchar, zip varchar, city varchar, _state varchar, street varchar, phone varchar
)

LANGUAGE 'plpgsql'

as 
$body$
BEGIN
return query
  Select t1.firstname, t1.lastname, t1.dob, t1.chart_number, t2.sex, t4.race, t5.country, t5.zip, t6.city, t6._state, t6.street, t8.phone
From
    Patients as t1
    LEFT JOIN sex as t2 ON t1.sex_id = t2.sex_id
    LEFT JOIN RACE as t3 ON t1.CHART_NUMBER = t3.CHART_NUMBER
    LEFT join raceTYPE as t4 on t1.CHART_NUMBER = t3.CHART_NUMBER and t3.race_type_id=t4.race_type_id
    LEFT JOIN Contact_preference as t7 on t1.CHART_NUMBER = t7.CHART_NUMBER
    LEFT join Addresses as t5 on t1.CHART_NUMBER = t5.CHART_NUMBER and t7.address_id = t5.address_id
    LEFT join patient_zip as t6 on t5.zip = t6.zip
    LEFT join phone as t8 on t8.ph_id = t7.phone_id 
    WHERE t1.dob=id;
END;
$body$;

select * from getdata('1975-01-01');




CREATE OR REPLACE FUNCTION paging(
  PageNumber INTEGER = NULL,
  PageSize INTEGER = NULL,id varchar = NULL
  )
  RETURNS TABLE(
  firstname varchar, lastname varchar, dob date, chart_number varchar, sex varchar, race varchar, country varchar, zip varchar, city varchar, _state varchar, street varchar, phone varchar
) AS
  $BODY$
  BEGIN
  RETURN QUERY
  Select t1.firstname, t1.lastname, t1.dob, t1.chart_number, t2.sex, t4.race, t5.country, t5.zip, t6.city, t6._state, t6.street, t8.phone
From
    Patients as t1
    LEFT JOIN sex as t2 ON t1.sex_id = t2.sex_id
    LEFT JOIN RACE as t3 ON t1.CHART_NUMBER = t3.CHART_NUMBER
    LEFT join raceTYPE as t4 on t1.CHART_NUMBER = t3.CHART_NUMBER and t3.race_type_id=t4.race_type_id
    LEFT JOIN Contact_preference as t7 on t1.CHART_NUMBER = t7.CHART_NUMBER
    LEFT join Addresses as t5 on t1.CHART_NUMBER = t5.CHART_NUMBER and t7.address_id = t5.address_id
    LEFT join patient_zip as t6 on t5.zip = t6.zip
    LEFT join phone as t8 on t8.ph_id = t7.phone_id
    WHERE t1.firstname=id or t1.lastname=id or t1.CHART_NUMBER=id or t2.sex=id
  ORDER BY t1.lastname ASC ,t1.firstname ASC, t2.sex ASC, t1.dob ASC
  LIMIT PageSize
  OFFSET ((PageNumber-1) * PageSize);
END;
$BODY$
LANGUAGE plpgsql;

Select * from paging(1,4,'HEMIT');
Select * from paging(2,3,'RANA');
Select * from paging(2,3,'MALE');



-----(5)
-- CREATE PROCEDURE SomeName(@UserStart DATETIME, @UserEnd DATETIME) 
-- AS BEGIN

-- SELECT somestuff
-- FROM sometable
-- WHERE somedate BETWEEN @UserStart AND @UserEnd

-- END

-- CREATE PROCEDURE searchByPhone(@number varchar(10)) 
-- AS BEGIN
SELECT 
    t3.phone,firstname,lastname,dob,sex_id
FROM 
    Patients as t1
    LEFT JOIN Addresses as t2 ON t1.CHART_NUMBER = t2.CHART_NUMBER
    LEFT JOIN phone as t3 ON t2.address_id = t3.phoneID
WHERE 
    t3.phone = '123456789';
-- END

select * from Addresses;










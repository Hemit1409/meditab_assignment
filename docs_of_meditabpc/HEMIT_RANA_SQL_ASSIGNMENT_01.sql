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


------(3)Create Function to stored the data into patient table. Pass all the value in the function parameter and function should return the created new primary key value of the table.
CREATE or replace function Insert_PatientData(fname varchar(100), mname varchar(100), lname varchar(100),
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



select Insert_PatientData('SANJAY','RANA','T',1,'1975-01-01');
select Insert_PatientData('BHAVYA','RANA','T',1,'2009-01-01');
select Insert_PatientData('HIMANI','RANA','T',2,'2005-01-01');
select Insert_PatientData('GAYATRI','RANA','T',2,'1983-01-01');
select Insert_PatientData('RUPAL','RANA','T',2,'1982-01-01');
select Insert_PatientData('SHAILESH','RANA','T',1,'1978-01-01');
select Insert_PatientData('HARSHANG','RANA','T',1,'1996-01-01');
select Insert_PatientData('RANA','PATEL','T',1,'1996-01-01');
select * from Patients;

--7
create table RACE(
race_id serial primary key,
CHART_NUMBER VARCHAR(40),    
race_type_id INT,
created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null,
	CONSTRAINT fk_patientid  
    FOREIGN KEY(CHART_NUMBER)   
    REFERENCES Patients(CHART_NUMBER),
   CONSTRAINT fk_emp_racetype  
    FOREIGN KEY(race_type_id)   
    REFERENCES raceTYPE(race_type_id)
);

--//////////if you try to run this queris on different device then the reference ids may defer because the refered ids are autogenerated in their respective tables////////////

INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART001',1);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART001',2);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART002',2);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART003',2);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART004',2);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART005',2);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART006',2);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART007',2);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART008',2);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART009',2);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART0010',2);
INSERT INTO RACE(CHART_NUMBER,race_type_id) VALUES('CHART0010',1);

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
--10
-- create table patient_zip(
-- zipid SERIAL primary key,
-- zip VARCHAR(200) unique,
--     -- zip varchar(10),
--     city VARCHAR(200),
--     _state VARCHAR(200),
--     street VARCHAR(200),--to identify the street,state and city through zip
--     created_on timestamp default current_timestamp not null,
--     modified_on timestamp default current_timestamp not null,
--     CONSTRAINT fk_petient_zip  
--     FOREIGN KEY(zip)   
--     REFERENCES Addresses(zip)  
-- );

-- --//////////if you try to run this queris on different device then the reference ids may defer because the refered ids are autogenerated in their respective tables////////////

-- INSERT INTO patient_zip(zip,city,_state,street) VALUES(390022,'vadodara','Gujarat','vadodara');
-- INSERT INTO patient_zip(zip,city,_state,street) VALUES(390021,'vadodara','Gujarat','vadodara');
-- INSERT INTO patient_zip(zip,city,_state,street) VALUES(390023,'vadodara','Gujarat','vadodara');
-- INSERT INTO patient_zip(zip,city,_state,street) VALUES(390024,'vadodara','Gujarat','vadodara');
-- INSERT INTO patient_zip(zip,city,_state,street) VALUES(390025,'vadodara','Gujarat','vadodara');
-- INSERT INTO patient_zip(zip,city,_state,street) VALUES(390026,'vadodara','Gujarat','vadodara');
-- INSERT INTO patient_zip(zip,city,_state,street) VALUES(390027,'vadodara','Gujarat','vadodara');
-- INSERT INTO patient_zip(zip,city,_state,street) VALUES(390028,'vadodara','Gujarat','vadodara');
-- INSERT INTO patient_zip(zip,city,_state,street) VALUES(390029,'vadodara','Gujarat','vadodara');
-- INSERT INTO patient_zip(zip,city,_state,street) VALUES(390030,'vadodara','Gujarat','vadodara');
-- INSERT INTO patient_zip(zip,city,_state,street) VALUES(390033,'vadodara','Gujarat','vadodara');

-- select * from patient_zip;



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

--//////////if you try to run this queris on different device then the reference ids may defer because the refered ids are autogenerated in their respective tables////////////


INSERT INTO Contact_preference(peference_type_id,CHART_NUMBER,address_id,phone_id,fax_id) VALUES(1,'CHART001',1,1,1);
--INSERT INTO Contact_preference(peference_type_id,CHART_NUMBER,address_id,phone_id,fax_id) VALUES(1,'CHART002',3,3,1);

INSERT INTO Contact_preference(peference_type_id,CHART_NUMBER,address_id,phone_id,fax_id) VALUES(1,'CHART004',5,5,3);

INSERT INTO Contact_preference(peference_type_id,CHART_NUMBER,address_id,phone_id,fax_id) VALUES(1,'CHART005',6,6,4);
INSERT INTO Contact_preference(peference_type_id,CHART_NUMBER,address_id,phone_id,fax_id) VALUES(1,'CHART006',7,7,5);
INSERT INTO Contact_preference(peference_type_id,CHART_NUMBER,address_id,phone_id,fax_id) VALUES(1,'CHART007',8,8,6);

select * from addresses;
select * from patients;
select * from phone;
select * from fax;
select * from Contact_preference;

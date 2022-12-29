--1
CREATE SEQUENCE PATIENT_ID
    increment 1
    start 1;
   
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
    race_id serial primary key,
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
--    patient_id SERIAL primary key,
--  	chartnumber AS 'CHART' + CAST(patient_id AS VARCHAR(10)) PERSISTED PRIMARY KEY
	CHART_NUMBER VARCHAR(40) NOT null unique DEFAULT to_char(nextval('PATIENT_ID'), 'CHART0000FM'), 
	firstname varchar(100) not null,
    middlename varchar(100) null,
    lastname varchar(100) not null,
     sex INT,
     
    dob date,
    CONSTRAINT fk_sex  
    FOREIGN KEY(sex)   
    REFERENCES Sex(sex_id)
);
INSERT INTO Patients(firstname,lastname,middlename,dob) VALUES('HEMIT','RANA','S','2000-01-01');
INSERT INTO Patients(firstname,lastname,middlename,dob) VALUES('KHUSHI','RANA','S','2005-01-01');
select * from Patients;

--6.5
create table RACE(
race_id serial primary key,
patient_id VARCHAR(40),    
race_type_id INT,
	CONSTRAINT fk_patientid  
    FOREIGN KEY(patient_id)   
    REFERENCES Patients(CHART_NUMBER),
   CONSTRAINT fk_emp_racetype  
    FOREIGN KEY(race_type_id)   
    REFERENCES raceTYPE(race_id)
);

--7
create table Addresses(
    address_id SERIAL primary key,  
    patient_id VARCHAR(40) ,
    address_type INT,
    -- street VARCHAR(200),
    -- city VARCHAR(200),
    zip VARCHAR(200) unique,
    -- _state VARCHAR(200), 
    country VARCHAR(200), 
    prim BOOLEAN,
    -- PRIMARY KEY(Department_id),  
    CONSTRAINT fk_patient  
    FOREIGN KEY(patient_id)   
    REFERENCES Patients(CHART_NUMBER),
    CONSTRAINT fk_addresstype  
    FOREIGN KEY(address_type)   
    REFERENCES AddressesType(AddressesType_id)  
);
INSERT INTO Addresses(patient_id,zip,country,prim) VALUES('HART0001','390022','India',TRUE);
INSERT INTO Addresses(patient_id,zip,country,prim) VALUES('HART0002','390021','US',FALSE);
select * from Addresses;

--8
create table phone(
    ph_id serial primary key, 
    phoneID INT,
    phone varchar(10),
    ph_type INT,
    prim BOOLEAN,
    CONSTRAINT fk_emp_phone  
    FOREIGN KEY(phoneID)   
    REFERENCES Addresses(address_id),
    CONSTRAINT fk_emp_phonetype  
    FOREIGN KEY(ph_type)   
    REFERENCES phonetype(type_id)
);

--9
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





create table fax(
    f_ID serial primary key,
    faxID INT,
    fax varchar(10),
    prim BOOLEAN,
    CONSTRAINT fk_emp_fax  
    FOREIGN KEY(faxID)   
    REFERENCES Addresses(address_id)
);



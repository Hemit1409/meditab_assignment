create table Patients(
    patient_id SERIAL primary key,
  -- 	chartnumber AS 'CHART' + CAST(patient_id AS VARCHAR(10)) PERSISTED PRIMARY KEY
	firstname varchar(100) not null,
    middlename varchar(100) null,
    lastname varchar(100) not null,
    sex varchar(10),
    -- race varchar(10),
    dob date
);

create table Addresses(
    address_id SERIAL primary key,  
    patient_id INT ,  
    -- street VARCHAR(200),
    -- city VARCHAR(200),
    zip VARCHAR(200) unique,
    -- _state VARCHAR(200), 
    country VARCHAR(200), 
    prim BOOLEAN,
    -- PRIMARY KEY(Department_id),  
    CONSTRAINT fk_employee  
    FOREIGN KEY(patient_id)   
    REFERENCES Patients(patient_id)  
);

create table patient_zip(
zip varchar(10) unique,
    -- zip varchar(10),
    city VARCHAR(200),
    _state VARCHAR(200),
    street VARCHAR(200),
    CONSTRAINT fk_employee_zip  
    FOREIGN KEY(zip)   
    REFERENCES Addresses(zip)  
);

create table phone(
    ph_id serial primary key, 
    phoneID INT,
    phone varchar(10),
    prim BOOLEAN,
    CONSTRAINT fk_emp_phone  
    FOREIGN KEY(phoneID)   
    REFERENCES Addresses(address_id)
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

create table race(
    raceid serial primary key,
    patient_id INT,
    CONSTRAINT fk_emp_race  
    FOREIGN KEY(patient_id)   
    REFERENCES Patients(patient_id) 
)
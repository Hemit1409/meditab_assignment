create table Patient(
  	chartnumber varchar(20) SERIAL primary key,
	firstname varchar(100) not null,
    middlename varchar(100) null,
    lastname varchar(100) not null,
    sex varchar(10),
    race varchar(10),
    dob date
);
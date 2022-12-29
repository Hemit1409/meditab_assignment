create table sex_type(
	sex_id serial primary key,
	sex_type varchar(20) not null,
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
)

create table patient_demographics(
	patient_id serial primary key,
	fname text not null,
	mname text,
	lname text not null,
	dob date not null,
	sex_type int references sex_type(sex_id),
	chart_no varchar(30) not null,
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
)

create table race_type(
	race_type_id serial primary key,
	race_type_value varchar(30) not null,
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
)

create table race(
	race_id serial primary key,
	patient_id int references patient_demographics(patient_id),
	race_type int references race_type(race_type_id),
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
)

create table address_type(
	address_type_id serial primary key,
	address_type_value varchar(20) not null,
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
)

create table address(
	address_id serial primary key,
	patient_id int references patient_demographics(patient_id),
	address_type int references address_type(address_type_id),
	street text not null,
	zip varchar(20) not null,
	city text not null,
	state varchar(20) not null,
	country varchar(20) not null,
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
)

create table phone_type(
	phone_type_id serial primary key,
	phone_type_value varchar(10) not null,
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
)

create table phone(
	phone_id serial primary key,
	phone_type int references phone_type(phone_type_id),
	address_id int references address(address_id),
	phone_no varchar(10) not null,
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
)

create table fax(
	fax_id serial primary key,
	address_id int references address(address_id),
	fax_no varchar(10) not null,
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
)

create table primary_contact(
	primary_contact_id serial primary key,
	patient_id int references patient_demographics(patient_id),
	address_id int references address(address_id),
	phone_id int references phone(phone_id),
	fax_id int references fax(fax_id),
    created_on timestamp default current_timestamp not null,
    modified_on timestamp default current_timestamp not null
)
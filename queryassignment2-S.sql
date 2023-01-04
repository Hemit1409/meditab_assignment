-- changes are made in query - 4
-----------------------------------------------------------------------------------------------------------------/*
--Please delete this column and add again 

ALTER TABLE public.patient  DROP COLUMN chart;

ALTER TABLE public.patient ADD chart varchar(50) NULL GENERATED ALWAYS AS ((('CHART00'::text || patient_id::text))) STORED;

-----------------------------------------------------------------------------------------------------------------/*

-- Query - 1

CREATE VIEW patient_primary_detail AS
select 
	p.first_name, 
	p.middle_name, 
	p.last_name, 
	p.chart, 
	p.date_of_birth, 
	g.sex_type as gender, 
	r2.race_type as race, 
	concat(pa.street,',' , pa.city ,',', pa.zip ,',', pa.state ,',', pa.country ) as address , 
	ph.phone_number as Phone_number , 
	f.fax_number as fax 
	from (((((((patient as p 
	left join gender as g on p.sex_id = g.sex_id) 
	left join race as r  on p.patient_id = r.patient_id ) 
	left join racetype as r2 on r.race_id = r2.race_id) 
	left join contact_preference as cp on p.patient_id = cp.patient_id and cp.preference_type_id = 3 )
	left join patient_address as pa on cp.address_id = pa.address_id  ) 
	left join phone as ph on cp.phone_id = ph.phone_id) 
	left join fax as f on  f.fax_id = cp.fax_id)
	
-----------------------------------------------------------------------------------------------------------------/*
	
-- Query - 2
	
select p.first_name, p.last_name, p.date_of_birth, g.sex_type , count(*) from ( patient as p inner join gender as g on p.sex_id = g.sex_id  )  group by  p.first_name, p.last_name, p.date_of_birth, g.sex_type

-----------------------------------------------------------------------------------------------------------------/*

-- Query - 3

CREATE OR REPLACE FUNCTION store_patient_data(fname varchar(20), mname varchar(50), lname varchar(50), patient_race varchar(10), gen varchar(7), dob date) RETURNS int AS
$$
declare 
	p_gender numeric;
	p_race numeric;
	p_id int;
begin
	p_gender = (select sex_id  from "Shyamm".public.gender where sex_type = gen );
	p_race = (select rt.race_id  from "Shyamm".public.racetype rt where rt.race_type = patient_race);
	
    INSERT INTO patient(first_name, middle_name, last_name, date_of_birth, sex_id) VALUES (fname, mname, lname, dob, p_gender);
   
   	p_id = (SELECT p.patient_id  FROM "Shyamm".public.patient as p where first_name = fname and middle_name=mname and last_name = lname limit 1);
   	insert into race (patient_id, race_id) values (p_id, p_race);
   
    return (p_id);
end;
$$
  LANGUAGE 'plpgsql'
  
-- drop function store_patient_data(fname varchar(20), mname varchar(50), lname varchar(50), patient_race varchar(10), gen varchar(7), dob date);

-- select store_patient_data(
-- 	fname => 'rishi', 
-- 	mname => 'mukeshbhai', 
-- 	lname => 'shukla',
-- 	patient_race => 'african',
-- 	gen   => 'male', 
-- 	dob   => '2002-01-07'
-- );

-----------------------------------------------------------------------------------------------------------------/*
	
  
  -- Query - 4

CREATE OR REPLACE FUNCTION get_patient_data(
		id integer =  0,
		fname varchar = '',
		lname varchar = '' ,
		dob varchar = '',
		PageNumber integer default  null,
		PageSize integer default null
) returns table ( 
		first_name varchar, 
		middle_name varchar, 
		last_name varchar, 
		chart varchar, 
		date_of_birth date, 
		gender varchar ) 
as $$
declare 
		declare F integer := 0;
		declare Q varchar;
begin
	Q := 'select p.first_name, p.middle_name, p.last_name, p.chart, p.date_of_birth, g.sex_type  from patient as p left join gender as  g on  p.sex_id = g.sex_id where ';
	
	if id > 0 then
		Q := Q || ' p.patient_id  ='||id||' ';
		F := 1;
	end if;
	

	if not fname = '' then
		if F then
			Q := Q || ' and p.first_name = '''|| fname ||'''';
		else
			Q := Q || ' p.first_name = '''|| fname ||'''';
			F := 1;
		end if;
	end if;


	if not lname = '' then
		if F then
			Q := Q || ' and p.last_name = '''|| lname ||'''';
		else
			Q := Q || ' p.last_name = '''|| lname ||'''';
			F := 1;
		end if;
	end if;

	if not dob = '' then
		if F then
			Q := Q || ' and p.date_of_birth = '''|| dob ||'''';
		else
			Q := Q || ' p.date_of_birth = '''|| dob ||'''';
			F := 1;
		end if;
	end if;

	Q := Q || ' order by  p.patient_id, p.first_name, p.last_name, p.date_of_birth ';
	Q := Q || ' LIMIT '||PageSize||' OFFSET (('||PageNumber||'-1) * '||PageSize||');';
	return QUERY execute Q;
	
end;
$$
  LANGUAGE 'plpgsql';

-- drop function get_patient_data(id integer,fname varchar, lname varchar, dob varchar,  PageNumber integer, PageSize integer)

-- select * from get_patient_data( id => 0 , fname => '', lname => 'patel', dob => '', PageNumber =>  1, PageSize => 5);

-----------------------------------------------------------------------------------------------------------------/*
 
 -- Query - 5

select *  from phone ph 
	left join patient_address pa on pa.address_id = ph.address_id  
	left join patient p on pa.patient_id = p.patient_id  
	where ph.phone_number = '9724536214'

-----------------------------------------------------------------------------------------------------------------/*
 
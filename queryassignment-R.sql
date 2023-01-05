--Question-1
create or replace view patient_info as
	select pd.fname, pd.mname, pd.lname, pd.dob, pd.chart_no, st.sex_type_value, (select string_agg(rt.race_type_value, ', ') as race_type_value), at2.address_type_value, a.street, a.city, a.zip, a.state, a.country, pt.phone_type_value, p.phone_no, f.fax_no
	from patient_demographics pd
	left join sex_type st on st.sex_type_id=pd.sex_type_id
	left join race r on r.patient_id=pd.patient_id
	left join race_type rt on rt.race_type_id=r.race_type_id
	left join preference_contact pc on pc.patient_id=pd.patient_id and pc.preference_type_id=1
	left join address a on a.address_id=pc.address_id
	left join address_type at2 on at2.address_type_id=a.address_type_id
	left join phone p on p.phone_id=pc.phone_id
	left join phone_type pt on pt.phone_type_id=p.phone_type_id
	left join fax f on f.fax_id=pc.fax_id
group by pd.patient_id, st.sex_type_value, at2.address_type_value, a.address_id, pt.phone_type_value, p.phone_no, f.fax_no;

select * from patient_info;

--drop view patient_info;


--Questio-2
select distinct pd.fname, pd.lname, st.sex_type_value, pd.dob, count(concat(pd.fname, pd.lname, st.sex_type_value, pd.dob))  from patient_demographics pd
	left join sex_type st on st.sex_type_id=pd.sex_type_id group by pd.fname, pd.lname, st.sex_type_value, pd.dob;

--Questio-3
create or replace function insert_patient_info(_fname varchar(30), _mname varchar(30), _lname varchar(30), _dob date, _sex_type_id int)
returns integer as
$$ 
declare
	pid integer;
begin
	insert into patient_demographics (fname, mname, lname, dob, sex_type_id) values (_fname, _mname, _lname, _dob, _sex_type_id);
	select patient_id into pid from patient_demographics order by patient_id desc limit 1;
	return pid;
end;
$$ language plpgsql;

select insert_patient_info('Ruchit', 'Jitendrabhai', 'Shah', '2001-09-19', 1) as patient_id;
select insert_patient_info('Meet', 'Mehulbhai', 'Patel', '2000-01-23', 1) as patient_id;



--Questio-4
create or replace function get_patient_info(_patient_id int default null, _fname varchar(30) default null, _lname varchar(30) default null, _dob date default null, _sex_type_id int default null, _pagenumber int default 1, _pagesize int default 10)
returns table(fname varchar, mname varchar, lname varchar, dob date, chart_no varchar, sex_type_value varchar, race_type_value text, address_type_value varchar, street varchar, city varchar, zip varchar, state varchar, country varchar, phone_type_value varchar, phone_no varchar, fax_no varchar) as
$$
declare
--	str text;
--	_fname text:=null;
--	_lname text:=null;
begin
--	select into _fname, _lname split_part(nv, '=', 1),
--	       split_part(nv, '=', 2)
--	from (
--  		select unnest(string_to_array(_filter,';'))
--	) as t (nv);

--	select into str from string_to_array('fname=Raj;lnamde=Chopda',';');

--	select into str string_to_array(_filter,';');
--raise notice 'str: %', fname from str;
	
--	str := concat('pd.', replace(_filter, '&', ' or pd.'));
--	raise notice 'str: %', str;
	
	return query select pd.fname, pd.mname, pd.lname, pd.dob, pd.chart_no, st.sex_type_value, (select string_agg(rt.race_type_value, ', ') as race_type_value), at2.address_type_value, a.street, a.city, a.zip, a.state, a.country, pt.phone_type_value, p.phone_no, f.fax_no
	from patient_demographics pd
	left join sex_type st on st.sex_type_id=pd.sex_type_id
	left join race r on r.patient_id=pd.patient_id
	left join race_type rt on rt.race_type_id=r.race_type_id
	left join preference_contact pc on pc.patient_id=pd.patient_id and pc.preference_type_id=1
	left join address a on a.address_id=pc.address_id
	left join address_type at2 on at2.address_type_id=a.address_type_id
	left join phone p on p.phone_id=pc.phone_id
	left join phone_type pt on pt.phone_type_id=p.phone_type_id
	left join fax f on f.fax_id=pc.fax_id
	where (
			case when "_patient_id" is not null then pd.patient_id="_patient_id" else true end
		)
		and
		(
			case when "_fname" is not null then pd.fname="_fname" else true end		
		)
		and
		(
			case when "_lname" is not null then pd.lname="_lname" else true end		
		)
		and
		(
			case when "_dob" is not null then pd.dob="_dob" else true end		
		)
		and
		(
			case when "_sex_type_id" is not null then pd.sex_type_id="_sex_type_id" else true end		
		)
--	where true
	group by pd.patient_id, st.sex_type_value, at2.address_type_value, a.address_id, pt.phone_type_value, p.phone_no, f.fax_no
	order by pd.lname, pd.fname, st.sex_type_value, pd.dob
	limit _pagesize offset ((_pagenumber - 1) * _pagesize);
end;
$$ language plpgsql;

--select * from get_patient_info(_filter=>'fname=Raj;lname=Chopda');
--select * from get_patient_info(_filter=>'fname=Raj');
select * from get_patient_info(_patient_id=>1, _fname=>'Raj', _lname=>'Chopda', _dob=>'2002-02-13', _sex_type_id=>1);
select * from get_patient_info(_sex_type_id=>1, _lname=>'Chopda');



select * from array_to_json(string_to_array('fname:Raj;lname:Chopda',';'));




select * from get_patient_info(_dob=>'2002-02-13');
select * from get_patient_info(_patient_id=>1,_sex_type_id=>1);
select * from get_patient_info(_sex_type_id=>1, _pagesize=>2);
select * from get_patient_info(_sex_type_id=>1, _pagenumber=>2, _pagesize=>2);

drop function get_patient_info;


--Questio-5
select * from patient_demographics pd
	left join address a on a.patient_id=pd.patient_id
	left join phone p on p.address_id=a.address_id
	where p.phone_no = '1111111111';
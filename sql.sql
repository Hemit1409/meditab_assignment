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

    
SELECT * FROM information;

-----(2)

select firstname,lastname,dob,sex_id,count(concat(firstname,lastname,dob,sex_id)) as occurance 
from Patients group by firstname,lastname,dob,sex_id;


------(3)
CREATE PROCEDURE InsertPatientData(fname varchar(100), mname varchar(100), lname varchar(100),
                          s_id INT, do_b date)
LANGUAGE SQL
AS $$
    INSERT INTO Patients(firstname,lastname,middlename,sex_id,dob) VALUES(fname,mname,lname,s_id,do_b);   
$$;

CALL InsertPatientData('SANJAY','RANA','T',1,'1975-01-01');


select * from Patients;



-------(4)


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








-----(5)

SELECT 
    t3.phone,firstname,lastname,dob,sex_id
FROM 
    Patients as t1
    LEFT JOIN Addresses as t2 ON t1.CHART_NUMBER = t2.CHART_NUMBER
    LEFT JOIN phone as t3 ON t2.address_id = t3.phoneID
WHERE 
    t3.phone = '123456789';
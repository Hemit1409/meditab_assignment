--________________________________________________________//////*ASSIGNMENT 02*//////_________________________________________________________________






-------(1)Create View to fetch the result of FirstName, LastName, MiddleName, DOB, Chart Number, Sex , Race , Primary Address, Primary Phone, Primary Fax.

Create or replace View information as
Select t1.patient_id, t1.firstname, t1.lastname, t1.dob, t1.chart_number, t2.sex, t4.race, t5.country, t5.zip, t5.city, t5._state, t5.street, t8.phone
From
    Patients as t1
    LEFT JOIN sex as t2 ON t1.sex_id = t2.sex_id
    LEFT JOIN RACE as t3 ON t1.CHART_NUMBER = t3.CHART_NUMBER
    LEFT join raceTYPE as t4 on t1.CHART_NUMBER = t3.CHART_NUMBER and t3.race_type_id=t4.race_type_id
    LEFT JOIN Contact_preference as t7 on t1.CHART_NUMBER = t7.CHART_NUMBER and peference_type_id=1
    LEFT join Addresses as t5 on t1.patient_id = t5.patient_id and t7.address_id = t5.address_id
    LEFT join phone as t8 on t8.ph_id = t7.phone_id;
    -- LEFT JOIN Contact_preference as t4 ON t1.;

   

SELECT * FROM information;

-----(2)Write Query to fetch unique record from the Patient table based on Firstname, LastName, DOB and Sex with number of occurance(count) of same data.

-- SELECT COUNT (UNIQUE firstname,lastname,dob,sex_id) FROM Patients;
--
-- select count(*) from (select distinct firstname,lastname,dob,sex_id from Patients);
select firstname,lastname,dob,sex_id,count(concat(firstname,lastname,dob,sex_id)) as occurance 
from Patients group by firstname,lastname,dob,sex_id;


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


-------(4)Create Function to get the result of patient’s data by using patientId, lastname, firstname, sex, dob. Need to implement the pagination and sorting(LastName, Firstname, Sex, DOB) in this function.


CREATE OR REPLACE FUNCTION pagination(
  PageNumber INTEGER = NULL,
  PageSize INTEGER = NULL,id varchar default  null, do_b date default null
  )
  RETURNS TABLE(
  patientid integer, firstname varchar, lastname varchar, dob date, chart_number varchar, sex varchar, race varchar, country varchar, zip varchar, city varchar, _state varchar, street varchar, phone varchar
) AS
  $BODY$
  BEGIN
  RETURN QUERY
  Select t1.patient_id, t1.firstname, t1.lastname, t1.dob, t1.chart_number, t2.sex, t4.race, t5.country, t5.zip, t5.city, t5._state, t5.street, t8.phone
From
    Patients as t1
    LEFT JOIN sex as t2 ON t1.sex_id = t2.sex_id
    LEFT JOIN RACE as t3 ON t1.CHART_NUMBER = t3.CHART_NUMBER
    LEFT join raceTYPE as t4 on t1.CHART_NUMBER = t3.CHART_NUMBER and t3.race_type_id=t4.race_type_id
    LEFT JOIN Contact_preference as t7 on t1.CHART_NUMBER = t7.CHART_NUMBER and peference_type_id=1
    LEFT join Addresses as t5 on t1.patient_id = t5.patient_id and t7.address_id = t5.address_id
    LEFT join phone as t8 on t8.ph_id = t7.phone_id
    WHERE 
    (case 
	    when id is not null --and lname is null and chartnumber is null and se_x is null and do_b is null
	    then case when id in (t1.firstname) then t1.firstname=id
				    when id in (t1.lastname) then t1.lastname=id
				    when id in (t1.CHART_NUMBER) then t1.CHART_NUMBER=id
				    when id in (t2.sex) then t2.sex=id
	    		end
	    when do_b is not null
	    then case when do_b in (t1.dob) then t1.dob=do_b
	    		end
	    else 1=1
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
Select * from pagination(3,1,'MALE');--serach by sex
Select * from pagination(1,3,do_b=>'1975-01-01');--search by dob
Select * from pagination(1,3);--returns all data if parameter not passed


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

select * from Addresses;

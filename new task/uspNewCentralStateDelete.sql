
DROP FUNCTION IF EXISTS uspnewcentralstatedelete;

/*
-- Author : Nayan Rudani
-- Date : 
-- Purpose : To delete record for  centralstate Table
*/

CREATE FUNCTION uspnewcentralstatedelete
(_centralstateid BIGINT,
_lastmodifieddate TIMESTAMP,
_clientid SMALLINT,
_machineid VARCHAR (50),
_oldsystemid VARCHAR (100),
_userid BIGINT,
_langid VARCHAR(10))
RETURNS BIGINT AS
$$
DECLARE errormsg VARCHAR(500);
BEGIN

IF EXISTS(SELECT 1 FROM centralstate WHERE centralstate.centralstateid = _centralstateid AND centralstate.lastmodifieddate = _lastmodifieddate AND centralstate.isdeleted = false) THEN

UPDATE centralstate SET 
isdeleted = true,
lastmodifiedbyid = _userId,
lastmodifieddate = (now() at time zone 'utc') :: timestamp(3)
WHERE centralstate.centralstateid = _centralstateid;
RETURN 1;

ELSE
SELECT fnErrorMessageRead('Concurrency') INTO errormsg;
RAISE EXCEPTION '%',errormsg; 
END IF;
END;
$$
LANGUAGE PLPGSQL;


DROP FUNCTION IF EXISTS uspnewcentralstateupdate;

/*
-- Author : Nayan Rudani
-- Date : 
-- Purpose : To update record for  centralstate Table
*/

CREATE FUNCTION uspnewcentralstateupdate
(_centralstateid INTEGER,
_code VARCHAR(5),
_name VARCHAR(60),
_isactive BOOLEAN,
_createddate TIMESTAMP,
_createdbyid BIGINT,
_lastmodifieddate TIMESTAMP,
_lastmodifiedbyid BIGINT,
_clientid SMALLINT,
_machineid VARCHAR(40),
_oldsystemid VARCHAR(40),
_isdeleted BOOLEAN,
_issample BOOLEAN,
_requestid UUID,
_userid BIGINT,
_langid VARCHAR(10))
RETURNS BIGINT AS
$$
DECLARE errormsg VARCHAR(500);
BEGIN

IF EXISTS(SELECT 1 FROM centralstate WHERE centralstate.centralstateid = _centralstateid AND centralstate.lastmodifieddate = _lastmodifieddate AND centralstate.isdeleted = false) THEN

UPDATE centralstate SET 
code = _code,
name = _name,
isactive = _isactive,
lastmodifieddate = (now() at time zone 'utc') :: timestamp(3),
lastmodifiedbyid = _userid,
issample = _issample,
requestid = _requestid
WHERE centralstate.centralstateid = _centralstateid;
RETURN _centralstateid;

ELSE
SELECT fnErrorMessageRead('Concurrency') INTO errormsg;
RAISE EXCEPTION '%',errormsg; 
END IF;
END;
$$
LANGUAGE PLPGSQL;



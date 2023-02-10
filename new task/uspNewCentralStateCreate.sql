
DROP FUNCTION IF EXISTS uspnewcentralstatecreate;

/*
-- Author : Nayan Rudani
-- Date : 
-- Purpose : To add new record for  centralstate Table
*/

CREATE FUNCTION uspnewcentralstatecreate
(_centralstateid INTEGER,
_code VARCHAR(5),
_name VARCHAR(60),
_isactive BOOLEAN,
_createddate  TIMESTAMP,
_createdbyid BIGINT,
_lastmodifieddate  TIMESTAMP,
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
DECLARE NEW_ID BIGINT;
BEGIN

INSERT INTO centralstate(
code,
name,
isactive,
createddate,
createdbyid,
lastmodifieddate,
lastmodifiedbyid,
clientid,
machineid,
oldsystemid,
isdeleted,
issample,
requestid
) VALUES(_code,
_name,
_isactive,
(now() at time zone 'utc') :: timestamp(3),
_userid,
(now() at time zone 'utc') :: timestamp(3),
_userid,
_clientid,
_machineid,
_oldsystemid,
false,
_issample,
_requestid)

RETURNING  centralstateid INTO NEW_ID; 
RETURN NEW_ID;
  
END
$$
LANGUAGE PLPGSQL;



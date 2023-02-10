
DROP FUNCTION IF EXISTS uspnewcentralstateread;

/*
-- Author : Nayan Rudani
-- Date : 
-- Purpose : To Read, Filter, Query, Search centralstate Table
*/

  CREATE FUNCTION uspnewcentralstateread
(
_centralstateid TEXT DEFAULT NULL,
_code VARCHAR(4000) DEFAULT NULL,
_name VARCHAR(4000) DEFAULT NULL,
_isactive BOOLEAN DEFAULT NULL,
_createddate TIMESTAMP DEFAULT NULL,
_createdbyid VARCHAR(8000) DEFAULT NULL,
_lastmodifieddate TIMESTAMP DEFAULT NULL,
_lastmodifiedbyid VARCHAR(8000) DEFAULT NULL,
_clientid VARCHAR(8000) DEFAULT NULL,
_machineid VARCHAR(4000) DEFAULT NULL,
_oldsystemid VARCHAR(4000) DEFAULT NULL,
_isdeleted BOOLEAN DEFAULT NULL,
_issample BOOLEAN DEFAULT NULL,
_requestid UUID DEFAULT NULL,
_clientidin VARCHAR(8000) DEFAULT NULL,
_clientidnotin VARCHAR(8000) DEFAULT NULL,
_tpauserid INT DEFAULT NULL,
_userid BIGINT DEFAULT 0,
_langid VARCHAR(10) DEFAULT NULL,
_page INT DEFAULT 0,
_size INT DEFAULT 0,
_orderby VARCHAR(400) DEFAULT NULL)
RETURNS SETOF JSON AS
$$
	DECLARE v_queryStatement TEXT;
	
	BEGIN

v_queryStatement =  'SELECT centralstate.centralstateid,centralstate.code,centralstate.name,centralstate.isactive,centralstate.createddate,centralstate.createdbyid,centralstate.lastmodifieddate,centralstate.lastmodifiedbyid,centralstate.clientid,centralstate.machineid,centralstate.oldsystemid,centralstate.isdeleted,centralstate.issample,centralstate.requestid
FROM centralstate WHERE  1 = 1 '

|| CASE WHEN _centralstateid IS NOT NULL THEN ' AND (centralstate.centralstateid  = ANY(STRING_TO_ARRAY($1, '','')::int[]) )'  ELSE '' END
|| CASE WHEN _code IS NOT NULL THEN ' AND (centralstate.code ILIKE ANY(ARRAY[$2]))'  ELSE '' END
|| CASE WHEN _name IS NOT NULL THEN ' AND (centralstate.name ILIKE ANY(ARRAY[$3]))'  ELSE '' END
|| CASE WHEN _isactive IS NOT NULL THEN ' AND (centralstate.isactive = $4)'  ELSE '' END
|| CASE WHEN _createddate IS NOT NULL THEN ' AND (centralstate.createddate = $5)'  ELSE '' END
|| CASE WHEN _createdbyid IS NOT NULL THEN ' AND (centralstate.createdbyid  = ANY(STRING_TO_ARRAY($6, '','')::bigint[]) )'  ELSE '' END
|| CASE WHEN _lastmodifieddate IS NOT NULL THEN ' AND (centralstate.lastmodifieddate = $7)'  ELSE '' END
|| CASE WHEN _lastmodifiedbyid IS NOT NULL THEN ' AND (centralstate.lastmodifiedbyid  = ANY(STRING_TO_ARRAY($8, '','')::bigint[]) )'  ELSE '' END
|| CASE WHEN _isdeleted IS NOT NULL THEN ' AND (centralstate.isdeleted = $12)'  ELSE '' END
|| CASE WHEN _issample IS NOT NULL THEN ' AND (centralstate.issample = $13)'  ELSE '' END
|| CASE WHEN _clientidin IS NOT NULL THEN ' AND (centralstate.clientid  = ANY(STRING_TO_ARRAY($15, '','')::int[]))'  ELSE '' END
|| CASE WHEN _clientidnotin IS NOT NULL THEN ' AND (centralstate.clientid  != ALL(STRING_TO_ARRAY($16, '','')::int[]))'  ELSE '' END
|| CASE WHEN _tpauserid IS NOT NULL THEN ' AND (centralstate.clientid IN (select clientid from userdetail where userdetail.centraluserid = $17))'  ELSE '' END
|| CASE WHEN _orderby IS NOT NULL THEN ' ORDER BY ' || _orderby  ELSE ' ORDER BY centralstateid' END
|| CASE WHEN _page > 0 THEN ' LIMIT '||_size||' OFFSET '|| (_page-1)*_size  ELSE '' END;  

v_queryStatement =  'SELECT ARRAY_TO_JSON(ARRAY_AGG(ROW_TO_JSON(A))) FROM ('|| v_queryStatement ||' ) A';  
RETURN QUERY
execute v_queryStatement using 
_centralstateid,_code,_name,_isactive,_createddate,_createdbyid,_lastmodifieddate,_lastmodifiedbyid,_clientid,_machineid,_oldsystemid,_isdeleted,_issample,_requestid,_clientidin,_clientidnotin,_tpauserid;
  
END
$$
LANGUAGE PLPGSQL;



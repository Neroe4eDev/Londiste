
-- usage: logtriga(flds, query)
--
-- query should include 2 args:
--   $1 - for op type I/U/D,
--   $2 - for op data

CREATE OR REPLACE FUNCTION logtriga() RETURNS trigger
AS '$libdir/logtriga', 'logtriga' LANGUAGE C;


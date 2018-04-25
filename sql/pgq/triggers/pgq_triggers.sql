
-- ----------------------------------------------------------------------
-- Function: pgq.logtriga()
--
--      Deprecated - non-automatic SQL trigger.  It puts row data in partial
--      SQL form into queue.  It does not auto-detect table structure,
--      it needs to be passed as trigger arg.
--
-- Purpose:
--      Used by Londiste to generate replication events.  The "partial SQL"
--      format is more compact than the urlencoded format but cannot be
--      parsed, only applied.  Which is fine for Londiste.
--
-- Parameters:
--      arg1 - queue name
--      arg2 - column type spec string where each column corresponds to one char (k/v/i).
--              if spec string is shorter than column list, rest of columns default to 'i'.
--
-- Column types:
--      k   - pkey column
--      v   - normal data column
--      i   - ignore column
--
-- Queue event fields:
--    ev_type     - I/U/D
--    ev_data     - partial SQL statement
--    ev_extra1   - table name
--
-- ----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pgq.logtriga() RETURNS trigger
AS '$libdir/pgq_triggers', 'pgq_logtriga' LANGUAGE C;

-- ----------------------------------------------------------------------
-- Function: pgq.sqltriga()
--
--      Automatic SQL trigger.  It puts row data in partial SQL form into
--      queue.  It autodetects table structure.
--
-- Purpose:
--      Written as more flexible version of logtriga to handle exceptional cases
--      where there is no primary key index on table etc.
--
-- Parameters:
--      arg1 - queue name
--      argX - any number of optional arg, in any order
--
-- Optinal arguments:
--      SKIP                - The actual operation should be skipped
--      ignore=col1[,col2]  - don't look at the specified arguments
--      pkey=col1[,col2]    - Set pkey fields for the table, autodetection will be skipped
--      backup              - Put urlencoded contents of old row to ev_extra2
--
-- Queue event fields:
--    ev_type     - I/U/D
--    ev_data     - partial SQL statement
--    ev_extra1   - table name
--    ev_extra2   - optional urlencoded backup
--
-- ----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pgq.sqltriga() RETURNS trigger
AS '$libdir/pgq_triggers', 'pgq_sqltriga' LANGUAGE C;

-- ----------------------------------------------------------------------
-- Function: pgq.logutriga()
--
--      Trigger function that puts row data in urlencoded form into queue.
--
-- Purpose:
--	Used as producer for several PgQ standard consumers (cube_dispatcher, 
--      queue_mover, table_dispatcher).  Basically for cases where the
--      consumer wants to parse the event and look at the actual column values.
--
-- Trigger parameters:
--      arg1 - queue name
--      argX - any number of optional arg, in any order
--
-- Optinal arguments:
--      SKIP                - The actual operation should be skipped
--      ignore=col1[,col2]  - don't look at the specified arguments
--      pkey=col1[,col2]    - Set pkey fields for the table, autodetection will be skipped
--      backup              - Put urlencoded contents of old row to ev_extra2
--
-- Queue event fields:
--      ev_type      - I/U/D ':' pkey_column_list
--      ev_data      - column values urlencoded
--      ev_extra1    - table name
--      ev_extra2    - optional urlencoded backup
--
-- Regular listen trigger example:
-- >   CREATE TRIGGER triga_nimi AFTER INSERT OR UPDATE ON customer
-- >   FOR EACH ROW EXECUTE PROCEDURE pgq.logutriga('qname');
--
-- Redirect trigger example:
-- >   CREATE TRIGGER triga_nimi BEFORE INSERT OR UPDATE ON customer
-- >   FOR EACH ROW EXECUTE PROCEDURE pgq.logutriga('qname', 'SKIP');
-- ----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION pgq.logutriga() RETURNS TRIGGER
AS '$libdir/pgq_triggers', 'pgq_logutriga' LANGUAGE C;


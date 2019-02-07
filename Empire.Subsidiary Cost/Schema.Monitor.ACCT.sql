
/*
Create Schema.Monitor.ACCT.sql
*/

use Monitor
go

-- Create the database schema
if	schema_id('ACCT') is null begin
	exec sys.sp_executesql N'create schema ACCT authorization dbo'
end
go


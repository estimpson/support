
/*
Create Schema.MONITOR.Audit.sql
*/

use MONITOR
go

-- Create the database schema
if	schema_id('Audit') is null begin
	exec sys.sp_executesql N'create schema Audit authorization dbo'
end
go


/*
Create Table.FxPLM.Audit.DataChanges.sql
*/

use MONITOR
go

/*
drop table Audit.DataChanges
*/
if	objectproperty(object_id('Audit.DataChanges'), 'IsTable') is null begin

	create table Audit.DataChanges
	(	ConnectionID uniqueidentifier
	,	TransactionID bigint
	,	TableName varchar(255) not null
	,	OldData xml null
	,	NewData xml null
	,	ConnectionInfo xml null
	,	SessionInfo xml null
	,	TransactionInfo xml null
	,	RowID int identity(1,1) primary key clustered
	,	RowCreateUser sysname default(suser_name())
	,	RowModifiedDT datetime default(getdate())
	,	RowTS timestamp
	)
end
go


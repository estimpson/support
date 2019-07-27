
/*
Create Table.tempdb.dbo.PartLabelDefn.sql
*/

use tempdb
go

/*
exec FT.sp_DropForeignKeys

drop table dbo.PartLabelDefn

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('dbo.PartLabelDefn'), 'IsTable') is null begin

	create table dbo.PartLabelDefn
	(	AxCustomer varchar(50)
	,	AxPart varchar(50)
	,	CustomerPart varchar(50)
	,	LabelName varchar(50)
	,	PiecesPerLabel int
	,	PrinterPort varchar(50)
	,	Copies int
	,	RowCreateDT datetime default(getdate())
	,	RowCreateUser sysname default(suser_name())
	,	RowModifiedDT datetime default(getdate())
	,	RowModifiedUser sysname default(suser_name())
	)
end
go

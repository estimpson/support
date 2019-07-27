
/*
Create Table.tempdb.dbo.AxPartCustomerDef.sql
*/

use tempdb
go


/*
exec FT.sp_DropForeignKeys

drop table dbo.AxPartCustomerDef

exec FT.sp_AddForeignKeys
*/
if objectproperty(object_id('dbo.AxPartCustomerDef'), 'IsTable') is null begin
	create table dbo.AxPartCustomerDef
	(	AxCustomer varchar(50)
	,	AxPart varchar(50)
	,	CustomerPart varchar(50)
	,	PartName varchar(50)
	,	PiecesPerBox int
	,	BoxesPerCarton int
	,	BoxesPerPallet int
	,	LidsPerPallet int
	,	QtyDunnage1 int
	,	QtyDunnage2 int
	,	BoxInformation varchar(50)
	,	MasterCartonInformation varchar(50)
	,	PalletInformation varchar(50)
	,	PalletText varchar(50)
	,	Notes1 varchar(50)
	,	Notes2 varchar(50)
	,	IndividualLabelFormat varchar(50)
	,	MasterLabelFormat varchar(50)
	,	InternalLabelFormat varchar(50)
	,	UPC_Individual varchar(50)
	,	UPC_Master varchar(50)
	,	Description1 varchar(50)
	,	Description2 varchar(50)
	,	Description3 varchar(50)
	,	Other1 varchar(50)
	,	Other2 varchar(50)
	,	SizeInches varchar(50)
	,	AdditionalInfo varchar(50)
	,	BoxLabelFormat varchar(50)
	,	PalletLabelFormat varchar(50)
	,	CustomerPO varchar(50)
	,	DockCode varchar(50)
	,	LineFeedCode varchar(50)
	,	ZoneCode varchar(50)
	,	EngineeringLevel varchar(50)
	,	SupplierCode varchar(50)
	,	UnitWeight numeric(20, 6)
	,	ReturnableContainer varchar(50)
	,	RowID int identity(1, 1) primary key clustered
	,	RowCreateDT datetime default (getdate())
	,	RowCreateUser sysname default (suser_name())
	,	RowModifiedDT datetime default (getdate())
	,	RowModifiedUser sysname default (suser_name())
	)
end
go


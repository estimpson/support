
/*
Create Table.MONITOR.EEIUser.acctg_csm_import_quote_material_cost.sql
*/

use MONITOR
go

/*
exec FT.sp_DropForeignKeys

drop table EEIUser.acctg_csm_import_quote_material_cost

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('EEIUser.acctg_csm_import_quote_material_cost'), 'IsTable') is null begin

	create table EEIUser.acctg_csm_import_quote_material_cost
	(	BasePart char(7)
	,	MaterialCost numeric(20,6)
	,	RowID int identity(1,1) primary key clustered
	)
end
go


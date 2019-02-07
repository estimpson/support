
/*
Create View.Monitor.ACCT.SubsidiaryPartStandard.sql
*/

use Monitor
go

--drop table ACCT.SubsidiaryPartStandard
if	objectproperty(object_id('ACCT.SubsidiaryPartStandard'), 'IsView') = 1 begin
	drop view ACCT.SubsidiaryPartStandard
end
go

create view ACCT.SubsidiaryPartStandard
as
select
	sps.Subsidiary
,	sps.Part
,	sps.EffectiveDate
,	sps.Status
,	sps.Type
,	sps.Material
,	sps.MaterialAccum
,	sps.Labor
,	sps.LaborAccum
,	sps.Burden
,	sps.BurdenAccum
,	sps.SalesPrice
,	sps.RowID
,	sps.RowCreateDT
,	sps.RowCreateUser
,	sps.RowModifiedDT
,	sps.RowModifiedUser
from
	EEH.ACCT.SubsidiaryPartStandard sps with (readuncommitted)
go


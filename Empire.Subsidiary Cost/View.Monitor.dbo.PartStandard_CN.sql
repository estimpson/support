
/*View.Monitor.dbo.PartStandard_CN.sql
Create 
*/

use Monitor
go

--drop table dbo.PartStandard_CN
if	objectproperty(object_id('dbo.PartStandard_CN'), 'IsView') = 1 begin
	drop view dbo.PartStandard_CN
end
go

create view dbo.PartStandard_CN
as
select
	psCN.Part
,	psCN.Status
,	psCN.Type
,	psCN.Material
,	psCN.Labor
,	psCN.Burden
,	psCN.SalesPrice
,	psCN.MaterialAccum
,	psCN.LaborAccum
,	psCN.BurdenAccum
,	psCN.SalesPriceAccum
,	psCN.Quoted_Material
,	psCN.Quoted_Burden
,	psCN.Quoted_SalesPrice
,	psCN.Quoted_MaterialAccum
,	psCN.Quoted_LaborAccum
,	psCN.Quoted_BurdenAccum
,	psCN.Quoted_SalesPriceAccum
,	psCN.Planned_Material
,	psCN.Planned_Burden
,	psCN.Planned_SalesPrice
,	psCN.Planned_MaterialAccum
,	psCN.Planned_LaborAccum
,	psCN.Planned_BurdenAccum
,	psCN.Planned_SalesPriceAccum
,	psCN.Frozen_Material
,	psCN.Frozen_Burden
,	psCN.Frozen_SalesPrice
,	psCN.Frozen_MaterialAccum
,	psCN.Frozen_LaborAccum
,	psCN.Frozen_BurdenAccum
,	psCN.Frozen_SalesPriceAccum
,	psCN.RowID
,	psCN.RowCreateDT
,	psCN.RowCreateUser
,	psCN.RowModifiedDT
,	psCN.RowModifiedUser
from
	EEH.dbo.PartStandard_CN psCN with (readuncommitted)
go


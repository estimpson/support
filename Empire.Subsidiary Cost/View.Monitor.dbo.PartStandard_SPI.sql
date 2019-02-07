
/*
Create View.Monitor.dbo.PartStandard_SPI.sql
*/

use Monitor
go

--drop table dbo.PartStandard_SPI
if	objectproperty(object_id('dbo.PartStandard_SPI'), 'IsView') = 1 begin
	drop view dbo.PartStandard_SPI
end
go

create view dbo.PartStandard_SPI
as
select
	psSPI.Part
,	psSPI.Status
,	psSPI.Type
,	psSPI.Material
,	psSPI.Labor
,	psSPI.Burden
,	psSPI.SalesPrice
,	psSPI.MaterialAccum
,	psSPI.LaborAccum
,	psSPI.BurdenAccum
,	psSPI.SalesPriceAccum
,	psSPI.Quoted_Material
,	psSPI.Quoted_Burden
,	psSPI.Quoted_SalesPrice
,	psSPI.Quoted_MaterialAccum
,	psSPI.Quoted_LaborAccum
,	psSPI.Quoted_BurdenAccum
,	psSPI.Quoted_SalesPriceAccum
,	psSPI.Planned_Material
,	psSPI.Planned_Burden
,	psSPI.Planned_SalesPrice
,	psSPI.Planned_MaterialAccum
,	psSPI.Planned_LaborAccum
,	psSPI.Planned_BurdenAccum
,	psSPI.Planned_SalesPriceAccum
,	psSPI.Frozen_Material
,	psSPI.Frozen_Burden
,	psSPI.Frozen_SalesPrice
,	psSPI.Frozen_MaterialAccum
,	psSPI.Frozen_LaborAccum
,	psSPI.Frozen_BurdenAccum
,	psSPI.Frozen_SalesPriceAccum
,	psSPI.RowID
,	psSPI.RowCreateDT
,	psSPI.RowCreateUser
,	psSPI.RowModifiedDT
,	psSPI.RowModifiedUser
from
	EEH.dbo.PartStandard_SPI psSPI with (readuncommitted)
go


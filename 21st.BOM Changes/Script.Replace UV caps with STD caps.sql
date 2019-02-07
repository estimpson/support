select
	bome.parent_part
,	bome.part
,	NewPart = left(bome.part, 4) + substring(bome.part, 7, 5)
,	bome.type
,	bome.quantity
,	bome.unit_measure
,	bome.reference_no
,	bome.std_qty
,	bome.scrap_factor
,	bome.substitute_part
,	bome.ID
,	bome.LastUser
,	bome.LastDT
from
	dbo.bill_of_material_ec bome
where
	bome.part like '126[56]UV%'
	and bome.part not like '126[56]UVDSK'
	and getdate() between coalesce(bome.start_datetime, getdate()) and coalesce(bome.end_datetime, getdate())
go

begin transaction

update
	bome
set part = left(bome.part, 4) + substring(bome.part, 7, 5)
from
	dbo.bill_of_material_ec bome
where
	bome.part like '126[56]UV%'
	and bome.part not like '126[56]UVDSK'


select
	bom.parent_part
,	bom.part
,	NewPart = left(bom.part, 4) + substring(bom.part, 7, 5)
,	bom.type
,	bom.quantity
,	bom.unit_measure
,	bom.reference_no
,	bom.std_qty
,	bom.scrap_factor
,	bom.substitute_part
,	bom.ID
,	bom.LastUser
,	bom.LastDT
from
	dbo.bill_of_material bom
where
	bom.part like '126[56]UV%'
go

declare
	@TranDT datetime
,	@Result int;
exec dbo.usp_Scheduling_BuildXRt
	@TranDT = @TranDT output -- datetime
,	@Result = @Result output -- int
,	@Debug = 0				 -- int

go

--commit
rollback
go

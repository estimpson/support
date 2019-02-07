use Monitor
go

alter procedure FT.Ftsp_SpaceIndentedBOMPerPart (@part varchar(25))

--
--FT.Ftsp_SpaceIndentedBOMPerPart 'ALC0001-HF08'

as
/*
select	FinishedGood = XRt.TopPart,
	BOM = Space(XRt.BOMLevel * 5) + XRt.ChildPart,
	BOMDescription = part.name,
	Commodity = part.commodity,
	Qty = BOM.quantity,
	Unit = BOM.unit_measure,
	ScrapFactor = BOM.scrap_factor,
	Machine = PM.machine,
	PPH = PM.parts_per_hour,
	ActivityCode = AR.code
from	FT.XRt XRT
	join part on XRt.ChildPart = part.part
	left join dbo.bill_of_material_ec BOM on XRt.BOMID = BOM.ID
	left join dbo.part_machine PM on XRt.ChildPart = PM.part and
		PM.sequence = 1
	left join dbo.activity_router AR on XRt.ChildPart = AR.parent_part
where	XRt.TopPart in (select part from dbo.part where type = 'F') and
		XRt.TopPart = @Part
order by
	XRt.TopPart,
	XRt.Sequence
*/
select
	FinishedGood = XRT.TopPart
,	BOM = space(XRT.BOMLevel * 5) + XRT.ChildPart
,	BOMDescription = part.name
,	product_line
,	Commodity = part.commodity
,	Qty = BOM.quantity
,	Unit = BOM.unit_measure
,	ScrapFactor = BOM.scrap_factor
,	Machine = PM.machine
,	PPH = PM.parts_per_hour
,	ActivityCode = AR.code
,	MaterialCum = material_cum
,	ExtendedMaterialCUM = material_cum * BOM.quantity
--	CostCum = cost_cum,
--	ExtendedCostCum = cost_cum*BOM.Quantity,
,	PrimaryVendor = default_vendor
,	PartClassification =
		case
			when class = 'P' then
				'Purchased'
			when class = 'M' then
				'Manufactured'
			else
				'Other'
		end
,	SPI_MasterialAccum = spsSPI.MaterialAccum
,	SPI_LaborAccum = spsSPI.LaborAccum
,	SPI_BurdenAccum = spsSPI.BurdenAccum
,	CN_MasterialAccum = spsCN.MaterialAccum
,	CN_LaborAccum = spsCN.LaborAccum
,	CN_BurdenAccum = spsCN.BurdenAccum
from
	FT.XRt XRT
	join part
		on XRT.ChildPart = part.part
	join part_online
		on part.part = part_online.part
	join part_standard
		on part.part = part_standard.part
	left join dbo.PartStandard_SPI spsSPI
		on spsSPI.Part = XRT.TopPart
	left join dbo.PartStandard_CN spsCN
		on spsCN.Part = XRT.TopPart
	left join dbo.bill_of_material_ec BOM
		on XRT.BOMID = BOM.ID
	left join dbo.part_machine PM
		on XRT.ChildPart = PM.part
		   and PM.sequence = 1
	left join dbo.activity_router AR
		on XRT.ChildPart = AR.parent_part
where
	XRT.TopPart in
	(
		select
			part
		from
			dbo.part
		where
			type = 'F'
	)
	and XRT.TopPart = @part
order by
	XRT.TopPart
,	XRT.Sequence;
go

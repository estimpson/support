use Monitor
go

alter procedure FT.Ftsp_BOMPerPart (@part varchar(25))

--
--FT.Ftsp_BOMPerPart 'AUT0105-HB07'

as
select
	FinishedGood = XRT.TopPart
,	PrimaryVendor = default_vendor
,	BOM = XRT.ChildPart
,	BOMDescription = part.name
,	Commodity = part.commodity
--class,
,	PartClassification = (case
							  when class = 'P' then
								  'Purchased'
							  when class = 'M' then
								  'Manufactured'
							  else
								  'Other'
						  end
						 )
,	Qty = sum(XRT.XQty)
,	UOM = BOM.unit_measure
,	ScrapFactor = BOM.scrap_factor
,	MaterialCum = avg(material_cum)
,	ExtendedMaterialCUM = avg(material_cum) * sum(XRT.XQty)
,	SPI_MasterialAccum = min(spsSPI.MaterialAccum)
,	SPI_LaborAccum = min(spsSPI.LaborAccum)
,	SPI_BurdenAccum = min(spsSPI.BurdenAccum)
,	CN_MasterialAccum = min(spsCN.MaterialAccum)
,	CN_LaborAccum = min(spsCN.LaborAccum)
,	CN_BurdenAccum = min(spsCN.BurdenAccum)
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
	and class <> 'M'
group by
	XRT.TopPart
,	XRT.ChildPart
,	part.name
,	part.commodity
,	BOM.unit_measure
,	BOM.scrap_factor
,	default_vendor
,	class
order by
	XRT.TopPart
,	default_vendor
,	XRT.ChildPart;

go


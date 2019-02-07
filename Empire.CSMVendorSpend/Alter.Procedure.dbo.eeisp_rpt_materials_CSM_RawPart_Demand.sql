--exec sys.sp_rename 'dbo.eeisp_rpt_materials_CSM_RawPart_Demand', 'dbo.eeisp_rpt_materials_CSM_RawPart_Demand(Andre)'
--go
use Monitor
go

alter procedure dbo.eeisp_rpt_materials_CSM_RawPart_Demand
as
set nocount on
declare
	@ActiveParts table
(	BasePart char(7) primary key
,	ActiveOrderPart varchar(25)
,	CurrentRevLevel varchar(25)
,	LastShippedPart varchar(25)
,	LastHN varchar(25)
,	LastPT varchar(25)
,	ActiveOrderPart1 varchar(25)
,	CurrentRevLevel1 varchar(25)
,	LastShippedPart1 varchar(25)
)

insert
	@ActiveParts
(	BasePart
,	ActiveOrderPart
,	CurrentRevLevel
,	LastShippedPart
,	LastHN
,	LastPT
,	ActiveOrderPart1
,	CurrentRevLevel1
,	LastShippedPart1
)
select 
	fcafp.BasePart
,	fcafp.ActiveOrderPart
,	fcafp.CurrentRevLevel
,	fcafp.LastShippedPart
,	fcafp.LastHN
,	fcafp.LastPT
,	fcafp.ActiveOrderPart1
,	fcafp.CurrentRevLevel1
,	fcafp.LastShippedPart1
from
	FT.fn_CSM_ActiveFinishedPart() fcafp

declare
	@BOM table
(	BasePart varchar(25)
,	TopPart varchar(25)
,	RawPart varchar(25)
,	QtyPer numeric(20, 6) primary key (BasePart, RawPart)
)

insert
	@BOM
(	BasePart
,	TopPart
,	RawPart
,	QtyPer
)
select
	ap.BasePart
,	BOM.TopPart
,	BOM.ChildPart
,	BOM.Quantity
from
	dbo.vw_RawQtyPerFinPart BOM
	join @ActiveParts ap
		on BOM.TopPart = coalesce(ap.ActiveOrderPart, ap.CurrentRevLevel, ap.LastShippedPart, ap.LastHN, ap.LastPT)
		
declare
	@Countries table
(	CountryCode varchar(15) not null primary key
,	CountryName varchar(255) null
)

insert
	@Countries
(	CountryCode
,	CountryName
)
select
	c.CountryCode
,	c.CountryName
from
	dbo.countries c;

declare
	@HTSCode table
(	HTSCode varchar(50) not null primary key
,	HTSDescription varchar(255) null
,	Country varchar(50) null
,	Type varchar(50) null
)

insert
	@HTSCode
(	HTSCode
,	HTSDescription
,	Country
,	Type
)
select
	hc.HTSCode
,	hc.HTSDescription
,	hc.Country
,	hc.Type
from
	dbo.HTSCode hc

select
	*
into
	#CSMDemand
from
(
	select
		*
	from
		openquery
		(EEISQL1, '
select
	*
from
	MONITOR.EEIUser.acctg_csm_vw_select_sales_forecast as CSMDemand
'		)
) CSMDemand

select
	CSMDemand.base_part
,	p.name
,	CSMDemand.program
,	CSMDemand.manufacturer
,	CSMDemand.badge
,	CSMDemand.status
,	CSMDemand.CSM_eop_display
,	CSMDemand.CSM_sop_display
,	FGDemand2016 = Cal_16_TOTALdemand
,	FGDemand2017 = Cal_17_TOTALdemand
,	FGDemand2018 = Cal_18_TOTALdemand
,	FGDemand2019 = Cal_19_TOTALdemand
,	FGDemand2020 = Cal_20_TOTALdemand
,	FGDemand2021 = Cal_21_TOTALdemand
,	FGDemand2022 = Cal_22_TOTALdemand
,	FGDemand2023 = Cal_23_TOTALDemand
,	FGDemand2024 = Cal_24_TOTALdemand
,	FGDemand2025 = Cal_25_TOTALdemand
,	BOM.RawPart
,	Commodity = coalesce(p2.commodity, 'NoCommdityDefined')
,	BOM.QtyPer
,	RawPartDemand2016 = QtyPer * Cal_16_TOTALdemand
,	RawPartDemand2017 = QtyPer * Cal_17_TOTALdemand
,	RawPartDemand2018 = QtyPer * Cal_18_TOTALdemand
,	RawPartDemand2019 = QtyPer * Cal_19_TOTALdemand
,	RawPartDemand2020 = QtyPer * Cal_20_TOTALdemand
,	RawPartDemand2021 = QtyPer * Cal_21_TOTALdemand
,	RawPartDemand2022 = QtyPer * Cal_22_TOTALdemand
,	RawPartDemand2023 = QtyPer * Cal_23_TOTALdemand
,	RawPartDemand2024 = QtyPer * Cal_24_TOTALdemand
,	RawPartDemand2025 = QtyPer * Cal_25_TOTALdemand
,	RawPartSpend2016 = material_cum * QtyPer * Cal_16_TOTALdemand
,	RawPartSpend2017 = material_cum * QtyPer * Cal_17_TOTALdemand
,	RawPartSpend2018 = material_cum * QtyPer * Cal_18_TOTALdemand
,	RawPartSpend2019 = material_cum * QtyPer * Cal_19_TOTALdemand
,	RawPartSpend2020 = material_cum * QtyPer * Cal_20_TOTALdemand
,	RawPartSpend2021 = material_cum * QtyPer * Cal_21_TOTALdemand
,	RawPartSpend2022 = material_cum * QtyPer * Cal_22_TOTALdemand
,	RawPartSpend2023 = material_cum * QtyPer * Cal_23_TOTALdemand
,	RawPartSpend2024 = material_cum * QtyPer * Cal_24_TOTALdemand
,	RawPartSpend2025 = material_cum * QtyPer * Cal_25_TOTALdemand
,	po.default_vendor
,	pInv.standard_pack
,	HTSCode = coalesce(USHTSCode.HTSCode, HNHTSCode.HTSCode)
,	HTSDescription = coalesce(USHTSCode.HTSDescription, HNHTSCode.HTSDescription)
,	HTSCountry = coalesce(USHTSCode.Country, HNHTSCode.Country)
,	HTSType = coalesce(USHTSCode.Type, HNHTSCode.Type)
,	PartInventoryCountryName = pInv.CountryCode
,	POShipTo = nullif(poh.ship_to_destination, '')
,	LeadTime = coalesce
		(	(	select
					pv.FABAuthDays / 7
				from
					dbo.part_vendor pv
				where
					pv.vendor = po.default_vendor
					and pv.part = po.part
			)
		,	0
		)
,	StandardCost = ps.material_cum
,	LeadTimeFlag = 
		case when coalesce
			(	(	select
						pv.FABAuthDays / 7
					from
						dbo.part_vendor pv
					where
						pv.vendor = po.default_vendor
						and pv.part = po.part
				)
			,	0
			) >= 8 then 'Excessive Lead Time'
			else ''
		end
,	TariffName = tariff.Tariff_Name
,	TariffRate = tariff.Tariff_Rate
,	TariffEffectiveDate = tariff.Tariff_Effective_Date
,	TariffImposingCountry = tariff.Country_Imposing_Tariff
,	RelatedTariffList =
		(	select
				FT.ToList(tl.HTS_Code)
			from
				EEH.dbo.tariff_lists tl
			where
				left(replace(coalesce(USHTSCode.HTSCode, HNHTSCode.HTSCode), '.', ''), 4) = left(tl.HTS_Code, 4)
		)
into
	#results
from
	#CSMDemand CSMDemand
	left join @BOM BOM
		on CSMDemand.base_part = BOM.BasePart
	left join dbo.part p2
		on p2.part = BOM.RawPArt
	join dbo.part_online po
		on po.part = BOM.RawPart
	join dbo.part p
		on p.part = BOM.RawPart
	join dbo.part_inventory pInv
		on pInv.part = BOM.RawPArt
	join dbo.part_standard ps
		on ps.part = BOM.RawPart
	left join po_header poh
		on poh.po_number = po.default_po_number
	left join @Countries c
		on c.CountryCode = pInv.CountryCode
	left join @HTSCode USHTSCode
		on USHTSCode.HTSCode = p2.HTSCodeUSCustoms
	left join @HTSCode HNHTSCode
		on HNHTSCode.HTSCode = p2.HTSCodeHNCustoms
	outer apply
		(	select top(1)
				tl.Tariff_Rate
			,	tl.Tariff_Effective_Date
			,	tl.Tariff_Name
			,	tl.Country_Imposing_Tariff
			from
				eeh.dbo.tariff_lists tl
			where
				tl.HTS_Code = left(replace(coalesce(USHTSCode.HTSCode, HNHTSCode.HTSCode), '.', ''), 8)
				and tl.Country_of_Origin_Affected = pInv.CountryCode
			order by
				tl.id
		) tariff
		

truncate table
	FT.CSM_VendorSpend

insert
	FT.CSM_VendorSpend
(	base_part
,	name
,	program
,	manufacturer
,	badge
,	status
,	CSM_eop_display
,	CSM_sop_display
,	FGDemand2016
,	FGDemand2017
,	FGDemand2018
,	FGDemand2019
,	FGDemand2020
,	FGDemand2021
,	FGDemand2022
,	FGDemand2023
,	FGDemand2024
,	FGDemand2025
,	RawPart
,	Commodity
,	QtyPer
,	RawPartDemand2016
,	RawPartDemand2017
,	RawPartDemand2018
,	RawPartDemand2019
,	RawPartDemand2020
,	RawPartDemand2021
,	RawPartDemand2022
,	RawPartDemand2023
,	RawPartDemand2024
,	RawPartDemand2025
,	RawPartSpend2016
,	RawPartSpend2017
,	RawPartSpend2018
,	RawPartSpend2019
,	RawPartSpend2020
,	RawPartSpend2021
,	RawPartSpend2022
,	RawPartSpend2023
,	RawPartSpend2024
,	RawPartSpend2025
,	default_vendor
,	standard_pack
,	HTSCode
,	HTSDescription
,	HTSCountry
,	HTSType
,	PartInventoryCountryName
,	POShipTo
,	LeadTime
,	StandardCost
,	LeadTimeFlag
,	TariffName
,	TariffRate
,	TariffEffectiveDate
,	TariffImposingCountry
,	RelatedTariffList
,	MaxCSMEOPforRawPart
,	MinCSMSOPforRawPart
,	AllRawPartInventory
,	VendorTerms
)
select
	r.base_part
,	r.name
,	r.program
,	r.manufacturer
,	r.badge
,	r.status
,	r.CSM_eop_display
,	r.CSM_sop_display
,	r.FGDemand2016
,	r.FGDemand2017
,	r.FGDemand2018
,	r.FGDemand2019
,	r.FGDemand2020
,	r.FGDemand2021
,	r.FGDemand2022
,	r.FGDemand2023
,	r.FGDemand2024
,	r.FGDemand2025
,	r.RawPart
,	r.Commodity
,	r.QtyPer
,	r.RawPartDemand2016
,	r.RawPartDemand2017
,	r.RawPartDemand2018
,	r.RawPartDemand2019
,	r.RawPartDemand2020
,	r.RawPartDemand2021
,	r.RawPartDemand2022
,	r.RawPartDemand2023
,	r.RawPartDemand2024
,	r.RawPartDemand2025
,	r.RawPartSpend2016
,	r.RawPartSpend2017
,	r.RawPartSpend2018
,	r.RawPartSpend2019
,	r.RawPartSpend2020
,	r.RawPartSpend2021
,	r.RawPartSpend2022
,	r.RawPartSpend2023
,	r.RawPartSpend2024
,	r.RawPartSpend2025
,	r.default_vendor
,	r.standard_pack
,	r.HTSCode
,	r.HTSDescription
,	r.HTSCountry
,	r.HTSType
,	r.PartInventoryCountryName
,	r.POShipTo
,	r.LeadTime
,	r.StandardCost
,	r.LeadTimeFlag
,	r.TariffName
,	r.TariffRate
,	r.TariffEffectiveDate
,	r.TariffImposingCountry
,	r.RelatedTariffList
,	MaxCSMEOPforRawPart =
		(	select
				MAX(r2.CSM_eop_display)
			from
				#results r2
			where
				r2.RawPart = r.RawPart
		)
,	MinCSMSOPforRawPart =
		(	select
				MIN(r2.CSM_sop_display)
			from
				#results r2
			where
				r2.RawPart = r.RawPart
		)
,	AllRawPartInventory =
		(	select
				sum(o.std_quantity)
			from
				dbo.object o
			where
				o.part = r.RawPart
		)
,	VendorTerms =
		(	select
				max(v.terms)
			from
				dbo.vendor v
			where
				v.code = r.default_vendor
		)
from
	#results r
order by
	1
,	2
go


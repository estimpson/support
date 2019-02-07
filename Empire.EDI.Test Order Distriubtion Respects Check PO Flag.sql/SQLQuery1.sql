begin transaction
go

declare
	@Current862s table
(	RawDocumentGUID uniqueidentifier
,	ReleaseNo varchar(50)
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	ConsigneeCode varchar(15)
,	CustomerPart varchar(35)
,	CustomerPO varchar(35)
,	CustomerModelYear varchar(35)
,	NewDocument int
)

insert
	@Current862s
select distinct
	RawDocumentGUID
,	ReleaseNo
,   ShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,	CustomerModelYear
,   NewDocument
from
	EDINAL.CurrentShipSchedules ()

declare
	@Current830s table
(	RawDocumentGUID uniqueidentifier
,	ReleaseNo varchar(50)
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	ConsigneeCode varchar(15)
,	CustomerPart varchar(35)
,	CustomerPO varchar(35)
,	CustomerModelYear varchar(35)
,	NewDocument int
)

insert
	@Current830s
select distinct
	RawDocumentGUID
,	ReleaseNo
,   ShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,	CustomerModelYear
,   NewDocument
from
	EDINAL.CurrentPlanningReleases ()


declare
	@BlanketOrderMatchRules table
(	EDIShipToCode varchar(25) primary key
,	CheckCustomerPOShipSchedule int
,	CheckModelYearShipSchedule int
)

insert
	@BlanketOrderMatchRules
(	EDIShipToCode
,	CheckCustomerPOShipSchedule
,	CheckModelYearShipSchedule
)
select
	bo.EDIShipToCode
,	bo.CheckCustomerPOShipSchedule
,	bo.CheckModelYearShipSchedule
from
	EDINAL.BlanketOrders bo
	cross apply
		(	select
				c.ShipToCode
			from
				@Current862s c
			where
				c.ShipToCode = bo.EDIShipToCode
			group by
				c.ShipToCode
		) c
group by
	bo.EDIShipToCode
,	bo.CheckCustomerPOShipSchedule
,	bo.CheckModelYearShipSchedule

declare
	@ShipSchedHeaders table
(	RawDocumentGUID uniqueidentifier primary key
,	NewDocument int
)

insert
	@ShipSchedHeaders
(	RawDocumentGUID
,	NewDocument
)
select
	ssh.RawDocumentGUID
,	NewDocument = max(c.NewDocument)
from
	EDINAL.ShipScheduleHeaders ssh
	join @Current862s c
		on c.RawDocumentGUID = ssh.RawDocumentGUID
where
	ssh.Status = 1
group by
	ssh.RawDocumentGUID

declare
	@ShipSchedules table
(	RawDocumentGuid uniqueidentifier
,	ShipToCode varchar(50)
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	CustomerModelYear varchar(50)
,	ReleaseNo varchar(50)
,	ReleaseDT datetime
,	ReleaseQty numeric(20,6)
)

insert
	@ShipSchedules
(	RawDocumentGuid
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	CustomerModelYear
,	ReleaseNo
,	ReleaseDT
,	ReleaseQty
)
select
	ss.RawDocumentGUID
,	ss.ShipToCode
,	ss.CustomerPart
,	ss.CustomerPO
,	ss.CustomerModelYear
,	ss.ReleaseNo
,	ss.ReleaseDT
,	ss.ReleaseQty
from
	EDINAL.ShipSchedules ss
	join @ShipSchedHeaders ssh
		on ssh.RawDocumentGUID = ss.RawDocumentGUID

declare
	@ShipScheduleAccums table
(	RawDocumentGUID uniqueidentifier
,	ShipToCode varchar(50)
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	CustomerModelYear varchar(50)
,	LastAccumQty numeric(20,6)
)

insert
	@ShipScheduleAccums
(	RawDocumentGUID
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	CustomerModelYear
,	LastAccumQty
)
select
	ssa.RawDocumentGUID
,	ssa.ShipToCode
,	ssa.CustomerPart
,	ssa.CustomerPO
,	ssa.CustomerModelYear
,	ssa.LastAccumQty
from
	EDINAL.ShipScheduleAccums ssa
where
	exists
		(	select
				*
			from
				@ShipSchedules ss
			where
				ss.RawDocumentGuid = ssa.RawDocumentGUID
				and ss.CustomerPart = ssa.CustomerPart
				and ss.ShipToCode = ssa.ShipToCode
				and coalesce(ss.CustomerPO, '') = coalesce(ssa.CustomerPO, '')
				and coalesce(ss.CustomerModelYear, '') = coalesce(ssa.CustomerModelYear, '')
		)


declare
	@ShipScheduleAuthAccums table
(	RawDocumentGUID uniqueidentifier
,	ShipToCode varchar(50)
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	CustomerModelYear varchar(50)
,	PriorCUM numeric(20,6)
)

insert
	@ShipScheduleAuthAccums
(	RawDocumentGUID
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	CustomerModelYear
,	PriorCUM
)
select
	ssaa.RawDocumentGUID
,	ssaa.ShipToCode
,	ssaa.CustomerPart
,	ssaa.CustomerPO
,	ssaa.CustomerModelYear
,	ssaa.PriorCUM
from
	EDINAL.ShipScheduleAuthAccums ssaa
where
	exists
		(	select
				*
			from
				@ShipSchedules ss
			where
				ss.RawDocumentGuid = ssaa.RawDocumentGUID
				and ss.CustomerPart = ssaa.CustomerPart
				and ss.ShipToCode = ssaa.ShipToCode
				and coalesce(ss.CustomerPO, '') = coalesce(ssaa.CustomerPO, '')
				and coalesce(ss.CustomerModelYear, '') = coalesce(ssaa.CustomerModelYear, '')
		)


declare
	@PlanningHeaders table
(	RawDocumentGUID uniqueidentifier primary key
,	NewDocument int
)

insert
	@PlanningHeaders
(	RawDocumentGUID
,	NewDocument
)
select
	ph.RawDocumentGUID
,	NewDocument = max(c.NewDocument)
from
	EDINAL.PlanningHeaders ph
	join @Current830s c
		on c.RawDocumentGUID = ph.RawDocumentGUID
where
	ph.Status = 1
group by
	ph.RawDocumentGUID

declare
	@PlanningReleases table
(	RawDocumentGuid uniqueidentifier
,	ShipToCode varchar(50)
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	CustomerModelYear varchar(50)
,	ReleaseNo varchar(50)
,	ReleaseDT datetime
,	ReleaseQty numeric(20,6)
,	ScheduleType varchar(50)
,	SupplierCode varchar(50)
,	UserDefined5 varchar(50)
)

insert
	@PlanningReleases
(	RawDocumentGuid
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	CustomerModelYear
,	ReleaseNo
,	ReleaseDT
,	ReleaseQty
,	ScheduleType
,	SupplierCode
,	UserDefined5
)
select
	pr.RawDocumentGUID
,	pr.ShipToCode
,	pr.CustomerPart
,	pr.CustomerPO
,	pr.CustomerModelYear
,	pr.ReleaseNo
,	pr.ReleaseDT
,	pr.ReleaseQty
,	pr.ScheduleType
,	pr.SupplierCode
,	pr.UserDefined5
from
	EDINAL.PlanningReleases pr
	join @PlanningHeaders ph
		on ph.RawDocumentGUID = pr.RawDocumentGUID
where
	pr.Status = 1

declare
	@PlanningAccums table
(	RawDocumentGUID uniqueidentifier
,	ShipToCode varchar(50)
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	CustomerModelYear varchar(50)
,	LastAccumQty numeric(20,6)
)

insert
	@PlanningAccums
(	RawDocumentGUID
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	CustomerModelYear
,	LastAccumQty
)
select
	pa.RawDocumentGUID
,	pa.ShipToCode
,	pa.CustomerPart
,	pa.CustomerPO
,	pa.CustomerModelYear
,	pa.LastAccumQty
from
	EDINAL.PlanningAccums pa
where
	exists
		(	select
				*
			from
				@ShipSchedules ss
			where
				ss.RawDocumentGuid = pa.RawDocumentGUID
				and ss.CustomerPart = pa.CustomerPart
				and ss.ShipToCode = pa.ShipToCode
				and coalesce(ss.CustomerPO, '') = coalesce(pa.CustomerPO, '')
				and coalesce(ss.CustomerModelYear, '') = coalesce(pa.CustomerModelYear, '')
		)

declare
	@PlanningAuthAccums table
(	RawDocumentGUID uniqueidentifier
,	ShipToCode varchar(50)
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	CustomerModelYear varchar(50)
,	PriorCUM numeric(20,6)
)

insert
	@PlanningAuthAccums
(	RawDocumentGUID
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	CustomerModelYear
,	PriorCUM
)
select
	paa.RawDocumentGUID
,	paa.ShipToCode
,	paa.CustomerPart
,	paa.CustomerPO
,	paa.CustomerModelYear
,	paa.PriorCUM
from
	EDINAL.PlanningAuthAccums paa
where
	exists
		(	select
				*
			from
				@PlanningReleases pr
			where
				pr.RawDocumentGuid = paa.RawDocumentGUID
				and pr.CustomerPart = paa.CustomerPart
				and pr.ShipToCode = paa.ShipToCode
				and coalesce(pr.CustomerPO, '') = coalesce(paa.CustomerPO, '')
				and coalesce(pr.CustomerModelYear, '') = coalesce(paa.CustomerModelYear, '')
		)

declare
	@BlanketOrders table
(	BlanketOrderNo numeric(8,0) primary key
,	PartCode varchar(25)
,	ShipToCode varchar(50)
,	EDIShipToCode varchar(50)
,	CustomerPart varchar(50)
,	CustomerPO varchar(50)
,	ModelYear varchar(50)
,	ModelYear862 varchar(4)
,	ModelYear830 varchar(4)
,	OrderUnit varchar(15)
,	AccumShipped numeric(20,6)
,	ReferenceAccum varchar(10)
,	AdjustmentAccum varchar(10)
,	CheckCustomerPOShipSchedule int
,	CheckModelYearShipSchedule int
,	CheckCustomerPOPlanning int
,	CheckModelYearPlanning int
,	ReleaseDueDTOffsetDays int
,	PlanningFlag char(1)
,	SupplierCode varchar(20)
)

insert
	@BlanketOrders
(	BlanketOrderNo
,	PartCode
,	ShipToCode
,	EDIShipToCode
,	CustomerPart
,	CustomerPO
,	ModelYear
,	ModelYear862
,	ModelYear830
,	OrderUnit
,	AccumShipped
,	ReferenceAccum
,	AdjustmentAccum
,	CheckCustomerPOShipSchedule
,	CheckModelYearShipSchedule
,	CheckCustomerPOPlanning
,	CheckModelYearPlanning
,	ReleaseDueDTOffsetDays
,	PlanningFlag
,	SupplierCode
)
select
	bo.BlanketOrderNo
,	bo.PartCode
,	bo.ShipToCode
,	bo.EDIShipToCode
,	bo.CustomerPart
,	bo.CustomerPO
,	bo.ModelYear
,	bo.ModelYear862
,	bo.ModelYear830
,	bo.OrderUnit
,	bo.AccumShipped
,	bo.ReferenceAccum
,	bo.AdjustmentAccum
,	bo.CheckCustomerPOShipSchedule
,	bo.CheckModelYearShipSchedule
,	bo.CheckCustomerPOPlanning
,	bo.CheckModelYearPlanning
,	bo.ReleaseDueDTOffsetDays
,	bo.PlanningFlag
,	bo.SupplierCode
from
	EDINAL.BlanketOrders bo
where
	exists
		(	select
				*
			from
				@ShipSchedules ss
			where
				ss.CustomerPart = bo.CustomerPart
				and ss.ShipToCode = bo.EDIShipToCode
				and
				(	bo.CheckCustomerPOShipSchedule = 0
					or ss.CustomerPO = bo.CustomerPO
				)
				and
				(	bo.CheckModelYearShipSchedule = 0
					or ss.CustomerModelYear = bo.ModelYear862
				)
		)

declare
	@RawReleases table
(	RowID int not null IDENTITY(1, 1) primary key
,	Status int default(0)
,	ReleaseType int
,	OrderNo int
,	Type tinyint
,	ReleaseDT datetime
,	BlanketPart varchar(25)
,	CustomerPart varchar(35)
,	ShipToID varchar(20)
,	CustomerPO varchar(20)
,	ModelYear varchar(4)
,	OrderUnit char(2)
,	QtyShipper numeric(20,6)
,	Line int
,	ReleaseNo varchar(30)
,	DockCode varchar(30) null
,	LineFeedCode varchar(30) null
,	ReserveLineFeedCode varchar(30) null
,	QtyRelease numeric(20,6)
,	StdQtyRelease numeric(20,6)
,	ReferenceAccum numeric(20,6)
,	CustomerAccum numeric(20,6)
,	RelPrior numeric(20,6)
,	RelPost numeric(20,6)
,	NewDocument int
,	unique
	(	OrderNo
	,	NewDocument
	,	RowID
	)
,	unique
	(	OrderNo
	,	RelPost
	,	QtyRelease
	,	StdQtyRelease
	,	RowID
	)
,	unique
	(	OrderNo
	,	Type
	,	ReleaseDT
	,	RowID
	)
,	unique
	(	OrderNo
	,	ReleaseType
	,	RowID
	,	StdQtyRelease
	)
)

insert
	@RawReleases
(	ReleaseType
,	OrderNo
,	Type
,	ReleaseDT
,	BlanketPart
,	CustomerPart
,	ShipToID
,	CustomerPO
,	ModelYear
,	OrderUnit
,	ReleaseNo
,	QtyRelease
,	StdQtyRelease
,	ReferenceAccum
,	CustomerAccum
,	NewDocument
)
select
	ReleaseType = 1
,	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	ReleaseDT = ft.fn_TruncDate('dd', getdate())
,	BlanketPart = min(bo.PartCode)
,	CustomerPart = min(bo.CustomerPart)
,	ShipToID = min(bo.ShipToCode)
,	CustomerPO = min(bo.CustomerPO)
,	ModelYear = min(bo.ModelYear)
,	OrderUnit = min(bo.OrderUnit)
,	ReleaseNo = 'Accum Demand'
,	QtyRelease = 0
,	StdQtyRelease = 0
,	ReferenceAccum =
		case bo.ReferenceAccum 
			when 'N' 
				then min(coalesce(convert(int,bo.AccumShipped),0))
			when 'C' 
				then min(coalesce(convert(int,fa.LastAccumQty),0))
			else min(coalesce(convert(int,bo.AccumShipped),0))
		end
,	CustomerAccum =
		case bo.AdjustmentAccum 
			when 'N' 
				then min(coalesce(convert(int,bo.AccumShipped),0))
			When 'P' 
				then min(coalesce(convert(int,faa.PriorCUM),0))
			else min(coalesce(convert(int,fa.LastAccumQty),0))
		end
,	max(fh.NewDocument)
from
	@ShipSchedHeaders fh
	join @ShipSchedules fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join @ShipScheduleAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join @ShipScheduleAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join @BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOShipSchedule = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearShipSchedule = 0
			or bo.ModelYear862 = fr.CustomerModelYear
		)
	join
		@Current862s c 
		on
			c.CustomerPart = bo.customerpart
			and c.ShipToCode = bo.EDIShipToCode
			and (	bo.CheckCustomerPOShipSchedule = 0
					or bo.CustomerPO = c.CustomerPO
				)
			and	(	bo.CheckModelYearShipSchedule = 0
					or bo.ModelYear862 = c.CustomerModelYear
				)
where
	not exists
	(	select
			*
		from
			EDINAL.ShipSchedules ss
		where
			ss.status = 1 and
			ss.RawDocumentGUID = c.RawDocumentGUID and
			ss.RawDocumentGUID = fr.RawDocumentGUID
			and ss.CustomerPart = fr.CustomerPart
			and ss.ShipToCode = fr.ShipToCode
			and	ss.ReleaseDT = ft.fn_TruncDate('dd', getdate())
	)
	and	c.RawDocumentGUID = fr.RawDocumentGUID
group by
	bo.BlanketOrderNo
,	fh.RawDocumentGUID
,	bo.ReferenceAccum
,	bo.AdjustmentAccum 
having
	case bo.AdjustmentAccum 
		when 'N' 
			then min(coalesce(convert(int,bo.AccumShipped),0))
		when 'P' 
			then min(coalesce(convert(int,faa.PriorCUM),0))
		else min(coalesce(convert(int,fa.LastAccumQty),0))
	end > 
	case bo.ReferenceAccum 
		when 'N' 
			then min(coalesce(convert(int,bo.AccumShipped),0))
		when 'C' 
			then min(coalesce(convert(int,fa.LastAccumQty),0))
		else min(coalesce(convert(int,bo.AccumShipped),0))
	end
union all
select
	ReleaseType = 1
,	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	ReleaseDT = dateadd(dd, bo.ReleaseDueDTOffsetDays, fr.ReleaseDT)
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = fr.ReleaseNo
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	ReferenceAccum =
		case bo.ReferenceAccum 
			when 'N' 
				then coalesce(convert(int,bo.AccumShipped),0)
			when 'C' 
				then coalesce(convert(int,fa.LastAccumQty),0)
			else coalesce(convert(int,bo.AccumShipped),0)
		end
,	CustomerAccum =
		case bo.AdjustmentAccum 
			when 'N' 
				then coalesce(convert(int,bo.AccumShipped),0)
			when 'P' 
				then coalesce(convert(int,faa.PriorCUM),0)
			else coalesce(convert(int,fa.LastAccumQty),0)
		end
,	fh.NewDocument
from
	@ShipSchedHeaders fh
	join @ShipSchedules fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join @ShipScheduleAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join @ShipScheduleAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join @BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOShipSchedule = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearShipSchedule = 0
			or bo.ModelYear862 = fr.CustomerModelYear
		)
	join
		@Current862s c 
		on
			c.CustomerPart = bo.customerpart
			and c.ShipToCode = bo.EDIShipToCode
			and (	bo.CheckCustomerPOShipSchedule = 0
					or bo.CustomerPO = c.CustomerPO
				)
			and	(	bo.CheckModelYearShipSchedule = 0
					or bo.ModelYear862 = c.CustomerModelYear
				)
where
	c.RawDocumentGUID = fr.RawDocumentGUID
union all
select
	ReleaseType = 2
,	OrderNo = bo.BlanketOrderNo
,	Type = (	case 
					when bo.PlanningFlag = 'P' then 2
					when bo.PlanningFlag = 'F' then 1
					when bo.planningFlag = 'A' and fr.ScheduleType not in ('C', 'A', 'Z') then 2
					else 1
					end
			  )
,	ReleaseDT = dateadd(dd, ReleaseDueDTOffsetDays, fr.ReleaseDT)
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = case  WHEN fr.suppliercode =  'A0144' then fr.Userdefined5 WHEN fr.suppliercode IN ( 'ARM701', 'ARM101' ) AND fr.Userdefined5 IS NOT NULL THEN fr.UserDefined5 ELSE fr.ReleaseNo end
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	ReferenceAccum = case bo.ReferenceAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'C' 
												then coalesce(convert(int,bo.AccumShipped),0)
												else coalesce(convert(int,bo.AccumShipped),0)
												end
,	CustomerAccum = case bo.AdjustmentAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'P' 
												then coalesce(convert(int,bo.AccumShipped),0)
												else coalesce(convert(int,bo.AccumShipped),0) -- 
												end
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current830s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	@PlanningHeaders fh
	join @PlanningReleases fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join @PlanningAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join @PlanningAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join @BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOPlanning = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearPlanning = 0
			or bo.ModelYear830 = fr.CustomerModelYear
		)
		join
			@Current830s c 
			on
				c.CustomerPart = bo.customerpart
				and c.ShipToCode = bo.EDIShipToCode
				and	(	bo.CheckCustomerPOShipSchedule = 0
						or bo.CustomerPO = c.CustomerPO
					)
				and	(	bo.CheckModelYearShipSchedule = 0
						or bo.ModelYear862 = c.CustomerModelYear
					)
where
	c.RawDocumentGUID = fr.RawDocumentGUID
order by
	2,1,4

update
	rr
set
	NewDocument =
	(	select
			max(NewDocument)
		from
			@RawReleases rr2
		where
			rr2.OrderNo = rr.OrderNo
	)
from
	@RawReleases rr

DELETE RRP   
FROM  @RawReleases RRP
OUTER APPLY ( SELECT TOP 1 ReleaseDT LastFirmDate FROM @RawReleases RRF WHERE RRF.OrderNo = RRP.OrderNo AND RRF.Type = 1 ORDER BY ReleaseDT DESC ) FirmReleases
WHERE RRP.Type = 2 AND RRP.ReleaseDT <= FirmReleases.LastFirmDate

update
	@RawReleases
set
	RelPost = CustomerAccum + coalesce (
	(	select
			sum (StdQtyRelease)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and ReleaseType = rr.ReleaseType
			and	RowID <= rr.RowID), 0)
from
	@RawReleases rr

update
	@RawReleases
set
	RelPost =  coalesce (
	(	select
			sum (StdQtyRelease)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and ReleaseType = rr.ReleaseType
			and	RowID <= rr.RowID
			AND ReleaseType = 2), 0) 
from
	@RawReleases rr
WHERE
	rr.ReleaseType = 2

update
	@RawReleases
set
	RelPost =  rr.relPost  + COALESCE(dbo.fn_GreaterOf(MaxFirmAccum.MaxSSAccum,RefPlanAccum.MaxPlnAccum) , rr.ReferenceAccum)
from
	@RawReleases rr
	outer apply
	(	select top 1 rr3.RelPost MaxSSAccum
		from
			@RawReleases rr3
		where
			rr3.ReleaseType =  1
			and rr3.OrderNo = rr.OrderNo
		order by
			rr3.RelPost desc
	) MaxFirmAccum
	OUTER APPLY (SELECT max(rr4.ReferenceAccum) MaxPlnAccum FROM @RawReleases rr4 WHERE rr4.ReleaseType =  2 AND rr4.OrderNo = rr.OrderNo ) AS RefPlanAccum
WHERE
	rr.ReleaseType = 2

update
	rr
set
	RelPost = case when rr.ReferenceAccum > rr.RelPost then rr.ReferenceAccum else rr.RelPost end
from
	@RawReleases rr

update
	rr
set
	RelPrior = coalesce (
	(	select
			max(RelPost)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and	RowID < rr.RowID), ReferenceAccum)
from
	@RawReleases rr

update
	rr
set
	QtyRelease = RelPost - RelPrior
,	StdQtyRelease = RelPost - RelPrior
from
	@RawReleases rr

update
	rr
set
	Status = -1
from
	@RawReleases rr
where
	QtyRelease <= 0


/* Move Planning Release dates beyond last Ship Schedule Date that has a quantity due*/
update
	rr
set
	ReleaseDT = dateadd(dd,1,(select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and ReleaseType = 1and Status>-1))
from
	@RawReleases rr
where
	rr.ReleaseType = 2
	and rr.ReleaseDT <= (select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and ReleaseType = 1 and Status>-1)
/*	Calculate order line numbers and committed quantity. */
update
	rr
set	Line =
	(	select
			count(*)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and	RowID <= rr.RowID
			and Status = 0
	)
,	QtyShipper = shipSchedule.qtyRequired
from
	@RawReleases rr
	left join
	(	select
			orderNo = sd.order_no
		,	qtyRequired = sum(qty_required)
		from
			dbo.shipper_detail sd
			join dbo.shipper s
				on s.id = sd.shipper
		where 
			s.type is null
			and s.status in ('O', 'A', 'S')
		group by
			sd.order_no
	) shipSchedule
		on shipSchedule.orderNo = rr.OrderNo
where
	rr.status = 0

select
	*
from
	@RawReleases rr
go

rollback
go

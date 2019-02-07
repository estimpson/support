--select
--	*
--from
--	EDI4010.ShipSchedules ss
--where
--	ss.ReleaseDT between '12/1/2017' and '12/20/2017'

declare
	@ReleaseDetails table
(	RawDocumentGUID uniqueidentifier
,	DocumentImportDT datetime
,	Release varchar(25)
,	DocumentDT datetime
,	CustomerPart varchar(25)
,	ReleaseQty numeric(20,6)
,	ReleaseDT datetime
,	LastQtyReceived numeric(20,6)
,	LastQtyDT datetime
,	LastShipper int
,	LastAccumQty numeric(20,6)
,	LastAccumDT datetime
,	RowID int not null IDENTITY(1, 1) primary key
)
insert
	@ReleaseDetails
	(
		RawDocumentGUID
	,	DocumentImportDT
	,	Release
	,	DocumentDT
	,	CustomerPart
	,	ReleaseQty
	,	ReleaseDT
	,	LastQtyReceived
	,	LastQtyDT
	,	LastShipper
	,	LastAccumQty
	,	LastAccumDT
	)
select
	ph.RawDocumentGUID
,	ph.DocumentImportDT
,	ph.Release
,	ph.DocumentDT
,	pr.CustomerPart
,	pr.ReleaseQty
,	pr.ReleaseDT
,	pa.LastQtyReceived
,	pa.LastQtyDT
,	pa.LastShipper
,	pa.LastAccumQty
,	pa.LastAccumDT
from
	EDI4010.PlanningHeaders ph
	join EDI4010.PlanningReleases pr
		on pr.RawDocumentGUID = ph.RawDocumentGUID
	left join EDI4010.PlanningAccums pa
		on pa.RawDocumentGUID = ph.RawDocumentGUID
		and pa.CustomerPart = pr.CustomerPart
where
	ph.DocumentDT between '12/1/2017' and '12/20/2017'
	and pr.CustomerPart = '22283AC'
order by
	ph.RowID
,	pr.ReleaseDT

declare
	@Releases table
(	DocumentDT datetime
,	DocumentImportDT datetime
,	RowID int not null IDENTITY(1, 1) primary key
)
insert
	@Releases
(	DocumentDT
,	DocumentImportDT
)
select distinct
	rd.DocumentDT
,	min(rd.DocumentImportDT)
from
	@ReleaseDetails rd
group by
	rd.DocumentDT

select
	rd.ReleaseDT
,	sum(case when r.DD1 = rd.DocumentDT then rd.ReleaseQty end)
,	sum(case when r.DD2 = rd.DocumentDT then rd.ReleaseQty end)
,	sum(case when r.DD3 = rd.DocumentDT then rd.ReleaseQty end)
,	max(case when r.DD1 = rd.DocumentDT then rd.LastAccumQty end)
,	max(case when r.DD2 = rd.DocumentDT then rd.LastAccumQty end)
,	max(case when r.DD3 = rd.DocumentDT then rd.LastAccumQty end)
from
	@ReleaseDetails rd
	cross apply
		(	select
				DD1 = max(case when r.RowID = 1 then r.DocumentDT end)
			,	DD2 = max(case when r.RowID = 2 then r.DocumentDT end)
			,	DD3 = max(case when r.RowID = 3 then r.DocumentDT end)
			from
				@Releases r
		) r
group by
	rd.ReleaseDT

select
	*
from
	@Releases
alter procedure dbo.ftsp_RecalcReleaseAccums_forShipper
@ShipperID int
as
declare @Releases table
(	RowID int identity primary key
,	OrderNo int
,	BlanketPart varchar(25)
,	CustomerPart varchar(35)
,	ShipToID varchar(20)
,	QtyRelease numeric(20, 6)
,	StdQtyRelease numeric(20, 6)
,	StartingAccum numeric(20, 6)
,	RelPrior numeric(20, 6)
,	RelPost numeric(20, 6)
,	ReleaseDT datetime
,	OrderDetailID int)

insert
	@Releases
(	OrderNo
,	BlanketPart
,	CustomerPart
,	ShipToID
,	QtyRelease
,	StdQtyRelease
,	StartingAccum
,	ReleaseDT
,	OrderDetailID
)
select
	OrderNo = oh.order_no
,	BlanketPart = oh.blanket_part
,	CustomerPart = oh.customer_part
,	ShipToID = oh.destination
,	QtyRelease = od.quantity
,	StdQtyRelease = od.std_qty
,	StartingAccum =
		(	select
				max(our_cum)
			from
				dbo.order_header
			where
				order_type = 'B'
				and status = 'A'
				and customer_part = oh.customer_part
				and destination = oh.destination
		)
,	ReleaseDT = od.due_date
,	OrderDetailID = od.id
from
	dbo.order_detail od
	join dbo.order_header oh
		on od.order_no = oh.order_no
where
	oh.order_type = 'B'
	and oh.customer_part + ':' + oh.destination in
		(	select
				customer_part + ':' + destination
			from
				order_header
			where
				order_no in
					(	select
							order_no
						from
							dbo.shipper_detail sd
						where
							shipper = @ShipperID
					)
		)
	and
	(	select
			count(*)
		from
			order_header
		where
			order_type = 'B'
			and status = 'A'
			and customer_part = oh.customer_part
			and destination = oh.destination
			and order_no in
				(
					select
						order_no
					from
						dbo.shipper_detail sd
					where
						shipper = @ShipperID
				)
	) = 1
order by
	oh.customer_part
,	oh.destination
,	od.due_date
,	coalesce(case when oh.status = 'A' then 1 end, 0)
,	od.part_number

update
	@Releases
set
	RelPrior = coalesce((
							select
								sum(StdQtyRelease)
							from
								@Releases
							where
								CustomerPart = Releases.CustomerPart
								and ShipToID = Releases.ShipToID
								and RowID < Releases.RowID
						)
					   , 0
					   )
from
	@Releases Releases;

update
	@Releases
set
	RelPost = RelPrior + QtyRelease;

update
	dbo.order_detail
set
	our_cum = StartingAccum + RelPrior
,	the_cum = StartingAccum + RelPost
from
	dbo.order_detail od
	join @Releases r
		on od.id = r.OrderDetailID
go

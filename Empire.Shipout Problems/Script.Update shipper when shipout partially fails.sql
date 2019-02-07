select
	*
from
	dbo.shipper s
where
	s.id in (116242 )

select
	*	
from
	dbo.shipper_detail sd
	outer apply
		(	select top 1
				sd2.accum_shipped
			from
				dbo.shipper_detail sd2
			where
				sd2.date_shipped is not null
				and sd2.shipper < sd.shipper
				and sd2.order_no = sd.order_no
			order by
				sd2.date_shipped desc
		) lastShip
	outer apply
		(	select
				ShipDate = min(at.date_stamp)
			,	Qty = sum(at.std_quantity)
			,	Boxes = count(*)
			from
				dbo.audit_trail at
			where
				type = 'S'
				and at.shipper = convert(varchar, sd.shipper)
				and at.part = sd.part_original
			group by
				at.shipper
			,	at.part
		) at
	outer apply
		(	select
				oh.our_cum
			from
				dbo.order_header oh
			where
				oh.order_no = sd.order_no
		) oh
where
	shipper in (116242 )
go


begin transaction
go

update
	sd
set	qty_required = coalesce(at.Qty, 0)
,	qty_packed = coalesce(at.Qty, 0)
,	alternative_qty = coalesce(at.Qty, 0)
,	sd.boxes_staged = at.Boxes
from
	dbo.shipper_detail sd
	outer apply
		(	select top 1
				sd2.accum_shipped
			from
				dbo.shipper_detail sd2
			where
				sd2.date_shipped is not null
				and sd2.shipper < sd.shipper
				and sd2.order_no = sd.order_no
			order by
				sd2.date_shipped desc
		) lastShip
	outer apply
		(	select
				ShipDate = min(at.date_stamp)
			,	Qty = sum(at.std_quantity)
			,	Boxes = count(*)
			from
				dbo.audit_trail at
			where
				type = 'S'
				and at.shipper = convert(varchar, sd.shipper)
				and at.part = sd.part_original
			group by
				at.shipper
			,	at.part
		) at
	outer apply
		(	select
				oh.our_cum
			from
				dbo.order_header oh
			where
				oh.order_no = sd.order_no
		) oh
where
	shipper in (116242 )

update
	s
set	s.status = 'C'
from
	dbo.shipper s
where
	s.id in (116242 )
go

rollback
go

commit
go


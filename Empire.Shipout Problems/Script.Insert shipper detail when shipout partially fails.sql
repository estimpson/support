select
	sd.shipper
,	sd.part
,	sd.qty_required
,	sd.qty_packed
,	sd.qty_original
,	sd.accum_shipped
,	sd.order_no
,	sd.customer_po
,	sd.release_no
,	sd.release_date
,	sd.price
,	sd.account_code
,	sd.salesman
,	sd.tare_weight
,	sd.gross_weight
,	sd.net_weight
,	sd.date_shipped
,	sd.note
,	sd.operator
,	sd.boxes_staged
,	sd.pack_line_qty
,	sd.alternative_qty
,	sd.alternative_unit
,	sd.week_no
,	sd.price_type
,	sd.customer_part
,	sd.part_name
,	sd.part_original
,	sd.total_cost
,	sd.stage_using_weight
,	sd.alternate_price
from
	dbo.shipper_detail sd
where
	sd.shipper = 116193

begin transaction
go
insert
	dbo.shipper_detail
(	shipper
,	part
,	qty_required
,	qty_packed
,	qty_original
,	accum_shipped
,	order_no
,	customer_po
,	release_no
,	release_date
,	price
,	account_code
,	salesman
,	tare_weight
,	gross_weight
,	net_weight
,	date_shipped
,	note
,	operator
,	boxes_staged
,	pack_line_qty
,	alternative_qty
,	alternative_unit
,	week_no
,	price_type
,	customer_part
,	part_name
,	part_original
,	total_cost
,	stage_using_weight
,	alternate_price
)
select
	shipper = at.shipper
,	part = at.part
,	qty_required = at.Qty
,	qty_packed = at.Qty
,	qty_original = at.Qty
,	accum_shipped = oh.our_cum
,	order_no = oh.order_no
,	customer_po = oh.customer_po
,	release_no = null
,	release_date = sd.release_date
,	price = oh.price
,	account_code = p.gl_account_code
,	salesman = oh.salesman
,	tare_weight = 0
,	gross_weight = 0
,	net_weight = 0
,	date_shipped = s.date_shipped
,	note = ''
,	operator = sd.operator
,	boxes_staged = at.Boxes
,	pack_line_qty = 0
,	alternative_qty = at.Qty
,	alternative_unit = 'EA'
,	week_no = sd.week_no
,	price_type = 'P'
,	customer_part = oh.customer_part
,	part_name = p.name
,	part_original = at.part
,	total_cost = oh.price * at.Qty
,	stage_using_weight = 'N'
,	alternate_price = oh.price
from
	(	select
			shipper = convert(int, at.shipper)
		,	at.part
		,	ShipDate = min(at.date_stamp)
		,	Qty = sum(at.std_quantity)
		,	Boxes = count(*)
		from
 			dbo.audit_trail at
		where
 			at.type = 'S'
 			and at.shipper in (116193)
		group by
 			at.shipper
		,	at.part
	) at
	join dbo.shipper s
		on s.id = at.shipper
	outer apply
		(	select top 1
				*
			from
				dbo.shipper_detail sd2
			where
				sd2.shipper = at.shipper
		) sd
	outer apply
		(	select top 1
				oh.*
			from
				dbo.order_header oh
				join dbo.order_detail od
					on od.order_no = oh.order_no
			where
				oh.blanket_part = at.part
				and oh.customer = s.customer
				and oh.destination = s.destination
			order by
				od.due_date
		) oh
	join dbo.part p
		on p.part = at.part
where
	not exists
	(	select
			*
		from
			dbo.shipper_detail sd
		where
			sd.shipper = at.shipper
			and sd.part_original = at.part
	)

select
	*
from
	dbo.shipper_detail sd
where
	sd.shipper = 116193
go

--rollback
--go

--commit
--go



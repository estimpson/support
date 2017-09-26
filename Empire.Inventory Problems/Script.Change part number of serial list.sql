use MONITOR
go

begin transaction
go

declare
	@serialList varchar(max) = '38352963,38610174,38607530,38546398,38612262,38612751,38616358,38573114,38573585,38568429,38603702,38605739,38365465,38586462,38620330,38622780'

select
	fsstr.Value
from
	dbo.fn_SplitStringToRows(@serialList, ',') fsstr
group by
	fsstr.Value
having
	count(*) > 1

select
	fsstr.Value
from
	dbo.fn_SplitStringToRows(@serialList, ',') fsstr
where
	not exists
	(	select
			*
		from
			dbo.object o
		where
			o.serial = fsstr.Value
	)

select
	*
from
	dbo.object o
	--left join dbo.part pNew
	--	on left(pNew.part,8)+substring(o.part,9,4)+substring(pNew.part,13,12) = o.part
	--	and pNew.part like '%HC00%'
where
	serial in
		(	select
				fsstr.Value
			from
				dbo.fn_SplitStringToRows(@serialList, ',') fsstr
		)

update
	o
set	part = pNew.part
from
	dbo.object o
	left join dbo.part pNew
		on left(pNew.part,8)+substring(o.part,9,4)+substring(pNew.part,13,12) = o.part
		and pNew.part like '%HC00%'
where
	serial in
		(	select
				fsstr.Value
			from
				dbo.fn_SplitStringToRows(@serialList, ',') fsstr
		)

insert
	dbo.audit_trail
(	serial
,	date_stamp
,	type
,	part
,	quantity
,	remarks
,	price
,	salesman
,	customer
,	vendor
,	po_number
,	operator
,	from_loc
,	to_loc
,	on_hand
,	lot
,	weight
,	status
,	shipper
,	flag
,	activity
,	unit
,	workorder
,	std_quantity
,	cost
,	control_number
,	custom1
,	custom2
,	custom3
,	custom4
,	custom5
,	plant
,	invoice_number
,	notes
,	gl_account
,	package_type
,	suffix
,	due_date
,	group_no
,	sales_order
,	release_no
,	dropship_shipper
,	std_cost
,	user_defined_status
,	engineering_level
,	posted
,	parent_serial
,	origin
,	destination
,	sequence
,	object_type
,	part_name
,	start_date
,	field1
,	field2
,	show_on_shipper
,	tare_weight
,	kanban_number
,	dimension_qty_string
,	dim_qty_string_other
,	varying_dimension_code
,	invoice
,	invoice_line
,	dbdate
,	gl_segment
,	ShipperToRAN
)
select
	serial = at.serial
,	date_stamp = getdate()
,	type = 'Q'
,	part = at.part
,	quantity = o.quantity
,	remarks = 'Quality'
,	price = 0
,	salesman = ''
,	customer = ''
,	vendor = ''
,	po_number = o.po_number
,	operator = 'OF'
,	from_loc = o.status
,	to_loc = 'S'
,	on_hand =
		(	select
				sum(o2.std_quantity)
			from
				dbo.object o2
			where
				o2.part = at.part
				and o2.status = 'A'
		)
,	lot = o.lot
,	weight = 0
,	status = 'S'
,	shipper = ''
,	flag = ''
,	activity = ''
,	unit = 'EA'
,	workorder = ''
,	std_quantity = o.quantity
,	cost =
		(	select
				ps.cost_cum
			from
				dbo.part_standard ps
			where
				ps.part = at.part
		)
,	control_number = ''
,	custom1 = o.custom1
,	custom2 = o.custom2
,	custom3 = o.custom3
,	custom4 = o.custom4
,	custom5 = o.custom5
,	plant = o.plant
,	invoice_number = ''
,	notes = ''
,	gl_account = pl.gl_segment
,	package_type = ''
,	suffix = null
,	due_date = null
,	group_no = ''
,	sales_order = ''
,	release_no = ''
,	dropship_shipper = 0
,	std_cost =
		(	select
				ps.cost_cum
			from
				dbo.part_standard ps
			where
				ps.part = at.part
		)
,	user_defined_status = 'Scrapped'
,	engineering_level = null
,	posted = 'N'
,	parent_serial = null
,	origin = ''
,	destination = ''
,	sequence = 0
,	object_type = null
,	part_name = ''
,	start_date = null
,	field1 = o.field1
,	field2 = o.field2
,	show_on_shipper = null
,	tare_weight = 0
,	kanban_number = ''
,	dimension_qty_string = ''
,	dim_qty_string_other = ''
,	varying_dimension_code = 0
,	invoice = null
,	invoice_line = null
,	dbdate = getdate()
,	gl_segment = null
,	ShipperToRAN = null
from
	dbo.object o
	outer apply
		(	select top 1
				*
			from
				dbo.audit_trail at
			where
				at.serial = o.serial
			order by
				at.date_stamp
		) at
	join dbo.product_line pl
		join dbo.part p
			on p.product_line = pl.id
		on p.part = at.part
where
	o.serial in
		(	select
				fsstr.Value
			from
				dbo.fn_SplitStringToRows(@serialList, ',') fsstr
		)

insert
	dbo.audit_trail
(	serial
,	date_stamp
,	type
,	part
,	quantity
,	remarks
,	price
,	salesman
,	customer
,	vendor
,	po_number
,	operator
,	from_loc
,	to_loc
,	on_hand
,	lot
,	weight
,	status
,	shipper
,	flag
,	activity
,	unit
,	workorder
,	std_quantity
,	cost
,	control_number
,	custom1
,	custom2
,	custom3
,	custom4
,	custom5
,	plant
,	invoice_number
,	notes
,	gl_account
,	package_type
,	suffix
,	due_date
,	group_no
,	sales_order
,	release_no
,	dropship_shipper
,	std_cost
,	user_defined_status
,	engineering_level
,	posted
,	parent_serial
,	origin
,	destination
,	sequence
,	object_type
,	part_name
,	start_date
,	field1
,	field2
,	show_on_shipper
,	tare_weight
,	kanban_number
,	dimension_qty_string
,	dim_qty_string_other
,	varying_dimension_code
,	invoice
,	invoice_line
,	dbdate
,	gl_segment
,	ShipperToRAN
)
select
	serial = at.serial
,	date_stamp = getdate()
,	type = 'D'
,	part = at.part
,	quantity = 0
,	remarks = 'Delete'
,	price = 0
,	salesman = ''
,	customer = ''
,	vendor = ''
,	po_number = o.po_number
,	operator = 'OF'
,	from_loc = o.location
,	to_loc = 'TRASH'
,	on_hand =
		(	select
				sum(o2.std_quantity)
			from
				dbo.object o2
			where
				o2.part = at.part
				and o2.status = 'A'
		)
,	lot = o.lot
,	weight = 0
,	status = 'S'
,	shipper = ''
,	flag = ''
,	activity = ''
,	unit = ''
,	workorder = ''
,	std_quantity = 0
,	cost =
		(	select
				ps.cost_cum
			from
				dbo.part_standard ps
			where
				ps.part = at.part
		)
,	control_number = ''
,	custom1 = o.custom1
,	custom2 = o.custom2
,	custom3 = o.custom3
,	custom4 = o.custom4
,	custom5 = o.custom5
,	plant = o.plant
,	invoice_number = ''
,	notes = ''
,	gl_account = pl.gl_segment
,	package_type = ''
,	suffix = null
,	due_date = null
,	group_no = ''
,	sales_order = ''
,	release_no = ''
,	dropship_shipper = 0
,	std_cost =
		(	select
				ps.cost_cum
			from
				dbo.part_standard ps
			where
				ps.part = at.part
		)
,	user_defined_status = 'Scrapped'
,	engineering_level = null
,	posted = 'N'
,	parent_serial = null
,	origin = ''
,	destination = ''
,	sequence = 0
,	object_type = null
,	part_name = ''
,	start_date = null
,	field1 = o.field1
,	field2 = o.field2
,	show_on_shipper = null
,	tare_weight = 0
,	kanban_number = ''
,	dimension_qty_string = ''
,	dim_qty_string_other = ''
,	varying_dimension_code = 0
,	invoice = null
,	invoice_line = null
,	dbdate = getdate()
,	gl_segment = null
,	ShipperToRAN = null
from
	dbo.object o
	outer apply
		(	select top 1
				*
			from
				dbo.audit_trail at
			where
				at.serial = o.serial
			order by
				at.date_stamp
		) at
	join dbo.product_line pl
		join dbo.part p
			on p.product_line = pl.id
		on p.part = at.part
where
	o.serial in
		(	select
				fsstr.Value
			from
				dbo.fn_SplitStringToRows(@serialList, ',') fsstr
		)

insert
	dbo.audit_trail
(	serial
,	date_stamp
,	type
,	part
,	quantity
,	remarks
,	price
,	salesman
,	customer
,	vendor
,	po_number
,	operator
,	from_loc
,	to_loc
,	on_hand
,	lot
,	weight
,	status
,	shipper
,	flag
,	activity
,	unit
,	workorder
,	std_quantity
,	cost
,	control_number
,	custom1
,	custom2
,	custom3
,	custom4
,	custom5
,	plant
,	invoice_number
,	notes
,	gl_account
,	package_type
,	suffix
,	due_date
,	group_no
,	sales_order
,	release_no
,	dropship_shipper
,	std_cost
,	user_defined_status
,	engineering_level
,	posted
,	parent_serial
,	origin
,	destination
,	sequence
,	object_type
,	part_name
,	start_date
,	field1
,	field2
,	show_on_shipper
,	tare_weight
,	kanban_number
,	dimension_qty_string
,	dim_qty_string_other
,	varying_dimension_code
,	invoice
,	invoice_line
,	dbdate
,	gl_segment
,	ShipperToRAN
)
select
	serial = o.serial
,	date_stamp = getdate()
,	type = 'A'
,	part = o.part
,	quantity = o.quantity
,	remarks = 'Manual Add'
,	price = 0
,	salesman = ''
,	customer = ''
,	vendor = ''
,	po_number = null
,	operator = 'OF'
,	from_loc = ''
,	to_loc = o.location
,	on_hand =
		(	select
				sum(o2.std_quantity)
			from
				dbo.object o2
			where
				o2.part = o.part
				and o2.status = 'A'
		)
,	lot = o.lot
,	weight = o.weight
,	status = 'A'
,	shipper = ''
,	flag = ''
,	activity = ''
,	unit = 'EA'
,	workorder = ''
,	std_quantity = o.std_quantity
,	cost =
		(	select
				ps.cost_cum
			from
				dbo.part_standard ps
			where
				ps.part = at.part
		)
,	control_number = ''
,	custom1 = o.custom1
,	custom2 = o.custom2
,	custom3 = o.custom3
,	custom4 = o.custom4
,	custom5 = o.custom5
,	plant = o.plant
,	invoice_number = ''
,	notes = ''
,	gl_account = pl.gl_segment
,	package_type = ''
,	suffix = null
,	due_date = null
,	group_no = ''
,	sales_order = ''
,	release_no = ''
,	dropship_shipper = 0
,	std_cost =
		(	select
				ps.cost_cum
			from
				dbo.part_standard ps
			where
				ps.part = at.part
		)
,	user_defined_status = 'Scrapped'
,	engineering_level = null
,	posted = 'N'
,	parent_serial = null
,	origin = ''
,	destination = ''
,	sequence = 0
,	object_type = null
,	part_name = ''
,	start_date = null
,	field1 = o.field1
,	field2 = o.field2
,	show_on_shipper = null
,	tare_weight = 0
,	kanban_number = ''
,	dimension_qty_string = ''
,	dim_qty_string_other = ''
,	varying_dimension_code = 0
,	invoice = null
,	invoice_line = null
,	dbdate = getdate()
,	gl_segment = null
,	ShipperToRAN = null
from
	dbo.object o
	outer apply
		(	select top 1
				*
			from
				dbo.audit_trail at
			where
				at.serial = o.serial
			order by
				at.date_stamp
		) at
	join dbo.product_line pl
		join dbo.part p
			on p.product_line = pl.id
		on p.part = o.part
where
	o.serial in
		(	select
				fsstr.Value
			from
				dbo.fn_SplitStringToRows(@serialList, ',') fsstr
		)
go

declare
	@serialList varchar(max) = '38352963,38610174,38607530,38546398,38612262,38612751,38616358,38573114,38573585,38568429,38603702,38605739,38365465,38586462,38620330,38622780'

select
	*
from
	dbo.audit_trail at
where
	at.serial in
		(	select
				fsstr.Value
			from
				dbo.fn_SplitStringToRows(@serialList, ',') fsstr
		)
	and at.date_stamp > getdate() - .1
go

--commit
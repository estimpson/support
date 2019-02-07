
begin transaction
go
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
,	group_no
,	sales_order
,	release_no
,	dropship_shipper
,	std_cost
,	user_defined_status
,	posted
,	parent_serial
,	origin
,	destination
,	sequence
,	object_type
,	part_name
,	field1
,	field2
,	show_on_shipper
,	tare_weight
,	dimension_qty_string
,	dim_qty_string_other
,	varying_dimension_code
)
select
	serial = o.serial
,	date_stamp = getdate()
,	type = 'Q'
,	part = o.part
,	quantity = o.quantity
,	remarks = 'Quality'
,	price = 0
,	salesman = ''
,	customer = ''
,	vendor = ''
,	po_number = o.po_number
,	operator = 'ees'
,	from_loc = o.status
,	to_loc = 'S'
,	on_hand = 0
,	lot = o.lot
,	weight = o.weight
,	status = 'S'
,	shipper = o.origin
,	flag = ''
,	activity = ''
,	unit = o.unit_measure
,	workorder = ''
,	std_quantity = o.std_quantity
,	cost = o.cost
,	control_number = ''
,	custom1 = o.custom1
,	custom2 = o.custom2
,	custom3 = o.custom3
,	custom4 = o.custom4
,	custom5 = o.custom5
,	plant = o.plant
,	invoice_number = ''
,	notes = 'Inventory Lost in Crowley Accident 08-13-2017'
,	gl_account = '11'
,	package_type = ''
,	group_no = ''
,	sales_order = ''
,	release_no = ''
,	dropship_shipper = 0
,	std_cost = o.std_cost
,	user_defined_status = 'Scrapped'
,	posted = 'N'
,	parent_serial = o.parent_serial
,	origin = ''
,	destination = ''
,	sequence = 0
,	object_type = null
,	part_name = o.name
,	field1 = o.field1
,	field2 = o.field2
,	show_on_shipper = null
,	tare_weight = o.tare_weight
,	dimension_qty_string = ''
,	dim_qty_string_other = ''
,	varying_dimension_code = 0
from
	dbo.object o
where
	o.origin in ('EEH-21295', 'EEH-21296')

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
,	group_no
,	sales_order
,	release_no
,	dropship_shipper
,	std_cost
,	user_defined_status
,	posted
,	parent_serial
,	origin
,	destination
,	sequence
,	object_type
,	part_name
,	field1
,	field2
,	show_on_shipper
,	tare_weight
,	dimension_qty_string
,	dim_qty_string_other
,	varying_dimension_code
)
select
	serial = o.serial
,	date_stamp = getdate()
,	type = 'D'
,	part = o.part
,	quantity = 0
,	remarks = 'Delete'
,	price = 0
,	salesman = ''
,	customer = ''
,	vendor = ''
,	po_number = o.po_number
,	operator = 'ees'
,	from_loc = o.location
,	to_loc = 'TRASH'
,	on_hand = 0
,	lot = o.lot
,	weight = o.weight
,	status = 'S'
,	shipper = o.origin
,	flag = ''
,	activity = ''
,	unit = o.unit_measure
,	workorder = ''
,	std_quantity = 0
,	cost = o.cost
,	control_number = ''
,	custom1 = o.custom1
,	custom2 = o.custom2
,	custom3 = o.custom3
,	custom4 = o.custom4
,	custom5 = o.custom5
,	plant = o.plant
,	invoice_number = ''
,	notes = ''
,	gl_account = '11'
,	package_type = ''
,	group_no = ''
,	sales_order = ''
,	release_no = ''
,	dropship_shipper = 0
,	std_cost = o.std_cost
,	user_defined_status = 'Scrapped'
,	posted = 'N'
,	parent_serial = o.parent_serial
,	origin = ''
,	destination = ''
,	sequence = 0
,	object_type = null
,	part_name = o.name
,	field1 = o.field1
,	field2 = o.field2
,	show_on_shipper = null
,	tare_weight = o.tare_weight
,	dimension_qty_string = ''
,	dim_qty_string_other = ''
,	varying_dimension_code = 0
from
	dbo.object o
where
	o.origin in ('EEH-21295', 'EEH-21296')

delete
	o
from
	dbo.object o
where
	o.parent_serial in
		(	select
				o2.parent_serial
			from
				dbo.object o2
			where
				o2.origin in ('EEH-21295', 'EEH-21296')
		)

delete
	o
from
	dbo.object o
where
	o.origin in ('EEH-21295', 'EEH-21296')

go

commit
go

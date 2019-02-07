select
	*
from
	dbo.audit_trail at
where
	at.serial = 39258015

select
	*
from
	dbo.audit_trail at
where
	at.serial = 39259066

/*	Create a manual add and corresponding object. */
insert
	dbo.audit_trail
(	type
,	remarks
,	operator
,	serial
,	date_stamp
,	part
,	quantity
,	price
,	salesman
,	customer
,	vendor
,	po_number
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
,	gl_segment
)
select
	type = 'A'
,	remarks = 'Manual Add'
,	operator = 'EES'
,	at.serial
,	date_stamp = getdate()
,	at.part
,	at.quantity
,	at.price
,	at.salesman
,	at.customer
,	at.vendor
,	at.po_number
,	at.from_loc
,	at.to_loc
,	at.on_hand
,	at.lot
,	at.weight
,	at.status
,	at.shipper
,	at.flag
,	at.activity
,	at.unit
,	at.workorder
,	at.std_quantity
,	at.cost
,	at.control_number
,	at.custom1
,	at.custom2
,	at.custom3
,	at.custom4
,	at.custom5
,	at.plant
,	at.invoice_number
,	at.notes
,	at.gl_account
,	at.package_type
,	at.suffix
,	at.due_date
,	at.group_no
,	at.sales_order
,	at.release_no
,	at.dropship_shipper
,	at.std_cost
,	at.user_defined_status
,	at.engineering_level
,	at.posted
,	at.parent_serial
,	at.origin
,	at.destination
,	at.sequence
,	at.object_type
,	at.part_name
,	at.start_date
,	at.field1
,	at.field2
,	at.show_on_shipper
,	at.tare_weight
,	at.kanban_number
,	at.dimension_qty_string
,	at.dim_qty_string_other
,	at.varying_dimension_code
,	at.invoice
,	at.invoice_line
,	at.gl_segment
from
	EEHSQL1.Monitor.dbo.audit_trail at
where
	at.serial in (39257871, 39257876)

insert
	dbo.object
(	serial
,	part
,	location
,	last_date
,	unit_measure
,	operator
,	status
,	destination
,	station
,	origin
,	cost
,	weight
,	parent_serial
,	note
,	quantity
,	last_time
,	date_due
,	customer
,	sequence
,	shipper
,	lot
,	type
,	po_number
,	name
,	plant
,	start_date
,	std_quantity
,	package_type
,	field1
,	field2
,	custom1
,	custom2
,	custom3
,	custom4
,	custom5
,	show_on_shipper
,	tare_weight
,	suffix
,	std_cost
,	user_defined_status
,	workorder
,	engineering_level
,	kanban_number
,	dimension_qty_string
,	dim_qty_string_other
,	varying_dimension_code
)
select
	o.serial
,	o.part
,	location = 'TRAN-AIR'
,	o.last_date
,	o.unit_measure
,	o.operator
,	status = 'A'
,	o.destination
,	o.station
,	o.origin
,	o.cost
,	o.weight
,	o.parent_serial
,	o.note
,	o.quantity
,	o.last_time
,	o.date_due
,	o.customer
,	o.sequence
,	o.shipper
,	o.lot
,	o.type
,	o.po_number
,	o.name
,	o.plant
,	o.start_date
,	o.std_quantity
,	o.package_type
,	o.field1
,	o.field2
,	o.custom1
,	o.custom2
,	o.custom3
,	o.custom4
,	o.custom5
,	o.show_on_shipper
,	o.tare_weight
,	o.suffix
,	o.std_cost
,	user_defined_status = 'Approved'
,	o.workorder
,	o.engineering_level
,	o.kanban_number
,	o.dimension_qty_string
,	o.dim_qty_string_other
,	o.varying_dimension_code
from
	EEHSQL1.Monitor.dbo.object o
where
	o.serial in (39257871, 39257876)
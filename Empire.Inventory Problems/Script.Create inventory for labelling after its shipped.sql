declare
	@shipperID varchar(25) = '118839'

select
	*
from
	dbo.object o
where
	o.shipper = @shipperID

begin transaction

delete
	o
from
	dbo.object o
where
	o.shipper = @shipperID


--insert
--	dbo.object
--(	serial
--,	part
--,	location
--,	last_date
--,	unit_measure
--,	operator
--,	status
--,	destination
--,	origin
--,	cost
--,	weight
--,	parent_serial
--,	note
--,	quantity
--,	last_time
--,	customer
--,	sequence
--,	shipper
--,	lot
--,	type
--,	po_number
--,	name
--,	plant
--,	start_date
--,	std_quantity
--,	package_type
--,	field1
--,	field2
--,	custom1
--,	custom2
--,	custom3
--,	custom4
--,	custom5
--,	show_on_shipper
--,	tare_weight
--,	suffix
--,	std_cost
--,	user_defined_status
--,	workorder
--,	engineering_level
--,	kanban_number
--,	dimension_qty_string
--,	dim_qty_string_other
--,	varying_dimension_code
--)
--select
--	at.serial
--,	at.part
--,	location = at.from_loc
--,	at.date_stamp
--,	at.unit
--,	at.operator
--,	at.status
--,	at.destination
--,	at.origin
--,	at.cost
--,	at.weight
--,	at.parent_serial
--,	note = 'Per Adam'
--,	at.quantity
--,	at.date_stamp
--,	at.customer
--,	at.sequence
--,	at.shipper
--,	at.lot
--,	at.object_type
--,	at.po_number
--,	at.part_name
--,	at.plant
--,	at.start_date
--,	at.std_quantity
--,	at.package_type
--,	at.field1
--,	at.field2
--,	at.custom1
--,	at.custom2
--,	at.custom3
--,	at.custom4
--,	at.custom5
--,	at.show_on_shipper
--,	at.tare_weight
--,	at.suffix
--,	at.std_cost
--,	at.user_defined_status
--,	at.workorder
--,	at.engineering_level
--,	at.kanban_number
--,	at.dimension_qty_string
--,	at.dim_qty_string_other
--,	at.varying_dimension_code
--from
--	dbo.audit_trail at
--where
--	at.type = 'S'
--	and at.shipper = @shipperID
go

--commit
rollback
go

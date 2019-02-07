insert
	HistoricalData.dbo.object_historical
(	Time_stamp
,	fiscal_year
,	period
,	reason
,	serial
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
,	posted
,	ObjectBirthday
)
select
	oh.Time_stamp
,	oh.fiscal_year
,	oh.period
,	oh.reason
,	serial = at.serial
,	part = at.part
,	location = at.to_loc
,	oh.last_date
,	oh.unit_measure
,	oh.operator
,	oh.status
,	oh.destination
,	oh.station
,	oh.origin
,	cost = at.cost
,	oh.weight
,	parent_serial = at.parent_serial
,	oh.note
,	quantity = at.quantity
,	oh.last_time
,	oh.date_due
,	oh.customer
,	oh.sequence
,	oh.shipper
,	oh.lot
,	oh.type
,	po_number = at.po_number
,	oh.name
,	oh.plant
,	oh.start_date
,	std_quantity = at.std_quantity
,	oh.package_type
,	field1 = cssl.Field1
,	oh.field2
,	oh.custom1
,	oh.custom2
,	oh.custom3
,	oh.custom4
,	oh.custom5
,	oh.show_on_shipper
,	oh.tare_weight
,	oh.suffix
,	std_cost = at.std_cost
,	oh.user_defined_status
,	oh.workorder
,	oh.engineering_level
,	oh.kanban_number
,	oh.dimension_qty_string
,	oh.dim_qty_string_other
,	oh.varying_dimension_code
,	oh.posted
,	oh.ObjectBirthday
from
	dbo.audit_trail at
	join FT.CommonSerialShipLog cssl
		on at.serial = cssl.Serial
	cross apply
		(	select top 1
				*
			from
				HistoricalData.dbo.object_historical oh
			where
				oh.serial in
					(	select
							Serial
						from
							FT.CommonSerialShipLog
						where
							Shipper = 24474
					)
		) oh
where
	at.serial in
		(	90742866
		,	90742867
		,	90742868
		,	90752618
		)
	and at.type = 'R'

insert
	HistoricalData.dbo.object_historical_daily
(	Time_stamp
,	fiscal_year
,	period
,	reason
,	serial
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
,	posted
,	MONTHEND
,	ObjectBirthday
)
select
	oh.Time_stamp
,	oh.fiscal_year
,	oh.period
,	oh.reason
,	serial = at.serial
,	part = at.part
,	location = at.to_loc
,	oh.last_date
,	oh.unit_measure
,	oh.operator
,	oh.status
,	oh.destination
,	oh.station
,	oh.origin
,	cost = at.cost
,	oh.weight
,	parent_serial = at.parent_serial
,	oh.note
,	quantity = at.quantity
,	oh.last_time
,	oh.date_due
,	oh.customer
,	oh.sequence
,	oh.shipper
,	oh.lot
,	oh.type
,	po_number = at.po_number
,	oh.name
,	oh.plant
,	oh.start_date
,	std_quantity = at.std_quantity
,	oh.package_type
,	field1 = cssl.Field1
,	oh.field2
,	oh.custom1
,	oh.custom2
,	oh.custom3
,	oh.custom4
,	oh.custom5
,	oh.show_on_shipper
,	oh.tare_weight
,	oh.suffix
,	std_cost = at.std_cost
,	oh.user_defined_status
,	oh.workorder
,	oh.engineering_level
,	oh.kanban_number
,	oh.dimension_qty_string
,	oh.dim_qty_string_other
,	oh.varying_dimension_code
,	oh.posted
,	oh.MONTHEND
,	oh.ObjectBirthday
from
	dbo.audit_trail at
	join FT.CommonSerialShipLog cssl
		on at.serial = cssl.Serial
	cross apply
		(	select top 1
				*
			from
				HistoricalData.dbo.object_historical_daily ohd
			where
				ohd.serial in
					(	select
							Serial
						from
							FT.CommonSerialShipLog
						where
							Shipper = 24474
					)
				and ohd.Time_stamp between '2018-08-31' and '2018-09-01'
			order by
				ohd.Time_stamp asc
			,	ohd.serial
		) oh
where
	at.serial in
		(	90742866
		,	90742867
		,	90742868
		,	90752618
		)
	and at.type = 'R'

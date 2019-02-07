select distinct
	pq.Printed, pq.LabelFormat
from
	dbo.PrintQueue pq
where
	pq.PrintServer = 'ELPASO1'

select
	pq.Printed, pq.LabelFormat
,	at.part
from
	dbo.PrintQueue pq
	join dbo.audit_trail at
		on at.serial = pq.SerialNumber
where
	pq.PrintServer = 'ELPASO1'
	and pq.Printed = -1

select
	*
from
	dbo.part_inventory pInv
where
	pInv.part = 'LAT67F-V2AB-24-1'

select
	pInv.label_format
,	Ft.ToList(pInv.part)
from
	dbo.part_inventory pInv
where
	pInv.primary_location = 'ELP-STAGE'
	and pInv.label_format not in ('RAW', 'RAW_PCB')
group by
	pInv.label_format

select
	*
from
	dbo.report_library rl
where
	rl.name = 'L_CKTWIP4X1_3'
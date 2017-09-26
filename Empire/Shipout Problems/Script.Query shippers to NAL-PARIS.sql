select
	Shipper = sd.shipper
,	Part = sd.part
,	Qty = sd.qty_packed
from
	dbo.shipper s
		join dbo.shipper_detail sd on
			sd.shipper = s.id
where
	s.date_shipped > '2017-09-19'
	and s.destination = 'NALPARIS'
	and sd.qty_packed > 0
select
	s.id
,	s.date_shipped
,	sd.part
,	sd.qty_packed
,	sd.accum_shipped
,	sd.order_no
,	sd.release_no
,	sd.release_date
,	sd.customer_part
,	sd.part_original
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
where
	s.date_shipped between '11/26/2017' and '12/20/2017'
	and s.destination = 'DECOMA#3'
	and sd.customer_part = '22283AC'
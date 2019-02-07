select
	at.part
,	at.shipper
,	sum(at.quantity)
from
	dbo.audit_trail at
where
	at.type = 'R'
	and at.shipper in ('EEH-21295', 'EEH-21296')
group by
	at.part
,	at.shipper
order by
	1

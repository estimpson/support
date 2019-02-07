delete
	oh
from
	HistoricalData.dbo.object_historical oh
where
	oh.Time_stamp > '2018-11-30 08:00'
	and oh.serial in
		(	select
				at.serial
			from
				dbo.audit_trail at
			where
				at.shipper = '125297'
				and at.type = 'V'
		)

delete
	ohd
from
	HistoricalData.dbo.object_historical_daily ohd
where
	ohd.Time_stamp > '2018-11-30 08:00'
	and ohd.serial in
		(	select
				at.serial
			from
				dbo.audit_trail at
			where
				at.shipper = '125297'
				and at.type = 'V'
		)
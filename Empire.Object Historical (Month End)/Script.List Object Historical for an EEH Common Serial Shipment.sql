select
	*
from
	FT.CommonSerialShipLog cssl
where
	Shipper = 24474

select
	*
from
	HistoricalData.dbo.object_historical oh
where
	oh.serial in
	(	select
			cssl.Serial
		from
			FT.CommonSerialShipLog cssl
		where
			Shipper = 24474
	)
	and datediff(day, '2018-08-31', oh.Time_stamp) between 0 and 1


select
	*
from
	HistoricalData.dbo.object_historical_daily ohd
where
	ohd.serial in
	(	select
			cssl.Serial
		from
			FT.CommonSerialShipLog cssl
		where
			Shipper = 24474
	)
	and datediff(day, '2018-08-31', ohd.Time_stamp) = 0
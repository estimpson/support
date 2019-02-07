set nocount on
go

begin transaction
go
update
	sd
set
	qty_required = coalesce(qty_packed, 0)
from
	dbo.shipper_detail sd
where
	shipper = 116057


delete
	sd
from
	dbo.shipper_detail sd
where
	shipper = 116057
	and sd.qty_required = 0

exec dbo.msp_reconcile_shipper
	@shipper = 116057

select
	*
from
	dbo.shipper_detail sd
	join dbo.shipper s
		on s.id = sd.shipper
where
	sd.shipper = 116057
	and left (sd.part_original, 7) = 'VNA0232'

--exec dbo.usp_GetBlanketOrderReleases
--	@ActiveOrderNo = 31807
--,	@TranDT = null
--,	@Result = null

--exec dbo.usp_GetBlanketOrderDistributedReleases
--	@TranDT = null
--,	@Result = null
--,	@Debug = 0				 -- int

--exec dbo.usp_SaveBlanketOrderDistributedReleases
--	@TranDT = null
--,	@Result = null

--select
--	*
--from
--	dbo.order_detail od
--where
--	od.order_no in (30829, 31807)
--order by
--	od.due_date


exec dbo.msp_shipout
	@shipper = 116057
go

select
	*
from
	dbo.order_detail od
where
	od.order_no in (30829, 31807)
order by
	od.due_date

go
rollback
go

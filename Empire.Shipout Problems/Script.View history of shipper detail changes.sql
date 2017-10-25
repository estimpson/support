
declare
	@ShipperID int = 112864

select
	*
from
	Audit.DataChanges dc
where
	dc.OldData.value('d[1]/@shipper', 'int') = @ShipperID

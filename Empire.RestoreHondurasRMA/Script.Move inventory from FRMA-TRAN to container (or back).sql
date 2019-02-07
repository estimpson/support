/*	Move inventory from FMA-TRAN to container (or back)*/
update
	dbo.object
set
	location = 'TRAN1-51FR'
where
	serial in
	(select
		serial
	from
		dbo.audit_trail at
	where
		at.type = 'T'
		and at.date_stamp > getdate() - 5
		and at.from_loc = 'TRAN1-51FR'
		and at.to_loc = 'RMA-TRAN'
	)

update
	dbo.object
set
	location = 'RMA-TRAN'
where
	serial in
	(select
		serial
	from
		dbo.audit_trail at
	where
		at.type = 'T'
		and at.date_stamp > getdate() - 5
		and at.from_loc = 'TRAN1-51FR'
		and at.to_loc = 'RMA-TRAN'
	)
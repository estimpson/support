alter procedure dbo.usp_SaveBlanketOrderDistributedReleases
	@TranDT datetime = null out
,	@Result integer out
as
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
declare	@DistributedReleases table
(	ActiveOrderNo int,
	OrderNo int,
	OrderType char(1) NULL,
	OrderPart varchar(25),
	CustomerPart varchar(35),
	ShipToID varchar(20),
	CustomerPO varchar(20),
	ModelYear varchar(4),
	ReleaseNo varchar(30),
	OrderUnit char(2),
	QtyRelease numeric(20,6),
	RelPost numeric(20,6),
	QtyCommitted numeric(20,6),
	ReleaseDT datetime,
	Line int,
	RowID int not null IDENTITY(1, 1) primary key )

insert
	@DistributedReleases
(	ActiveOrderNo,
	OrderNo
,	OrderType
,	OrderPart
,	CustomerPart
,	ShipToID
,	CustomerPO
,	ModelYear
,	ReleaseNo
,	OrderUnit
,	QtyRelease
,	ReleaseDT
)
select
	ActiveOrderNo = bodre.ActiveOrderNo
,	OrderNo = bodre.OrderNo
,	OrderType = bodre.ReleaseType
,	OrderPart = oh.blanket_part
,	CustomerPart = oh.customer_part
,	ShipToID = oh.destination
,	CustomerPO = oh.customer_po
,	ModelYear = oh.model_year
,	ReleaseNo = bodre.ReleaseNo
,	OrderUnit = oh.unit
,	QtyRelease = bodre.QtyRelease
,	ReleaseDT = bodre.ReleaseDT
from
	##BlanketOrderDistributeReleases_Edit bodre
	join dbo.order_header oh
		on oh.order_no = bodre.OrderNo
where
	SPID = @@SPID
order by
	bodre.ActiveOrderNo
,	bodre.OrderNo
,	bodre.ReleaseDT
,	bodre.ReleaseNo -- Added 12/4/2014 to provide for Autoliv RAN sorting Andre S.Boulanger 

print 'Here'

update
	dr
set
	RelPost = (select sum (QtyRelease) from @DistributedReleases where ActiveOrderNo = dr.ActiveOrderNo and RowID <= dr.RowID),
	Line = (select count(1) from @DistributedReleases where OrderNo = dr.OrderNo and ReleaseDT <= dr.ReleaseDT /*AND ReleaseNo<= dr.ReleaseNo [commented 7/10/16 Andre, FT, LLC]*/)
from
	@DistributedReleases dr

select
	*
from
	@DistributedReleases dr

update
	dr
set
	QtyCommitted = coalesce(
	case
		when ShipperQty > RelPost then QtyRelease
		when ShipperQty > RelPost - QtyRelease then ShipperQty - (RelPost - QtyRelease)
	end, 0)
from
	@DistributedReleases dr
	left join
	(	select
			OrderNo = shipper_detail.order_no,
			ShipperPart = shipper_detail.part_original,
			ShipperQty = sum (qty_required)		
		from
			shipper_detail
			JOIN shipper ON shipper_detail.shipper = shipper.id
		WHERE
			shipper.TYPE IS NULL AND
			shipper.STATUS IN ('O', 'A', 'S')
		GROUP BY
			shipper_detail.order_no,
			shipper_detail.part_original
	) ShipRequirements
		ON dr.OrderNo = ShipRequirements.OrderNo
		AND dr.OrderPart = ShipRequirements.ShipperPart

DECLARE	@EEIQtys TABLE
(	ShipToID VARCHAR(20)
,	CustomerPart VARCHAR(35)
,	DueDT DATETIME
,	EEIQty NUMERIC (20,6))

INSERT
	@EEIQtys
SELECT
	dr.ShipToID
,	dr.CustomerPart
,	dr.ReleaseDT
,	EEIQty =dr.QtyRelease
	/*case
		when dr.ReleaseDT <= EEIQtyHorizon then
			(	select
					sum(eeiqty)
				from
					order_detail
				where
					destination = dr.ShipToID
					and customer_part = dr.CustomerPart
					and due_date > coalesce
					(	(	select
								max(ReleaseDT)
							from
								@DistributedReleases
							where
								ShipToID = dr.ShipToID
								and CustomerPart = dr.CustomerPart
								and ReleaseDT < dr.ReleaseDT
						)
					,	due_date - 1
					)
					and due_date <= dr.ReleaseDT
			)	
		else dr.QtyRelease
	end
	*/
FROM
	(	SELECT
			ShipToID
		,	CustomerPart
		,	ReleaseDT
		,	QtyRelease = SUM(QtyRelease)
		,	EEIQtyHorizon = DATEADD(wk,
			(	SELECT
					CONVERT(INT, c.custom4)
				FROM
					dbo.customer c
					JOIN dbo.destination d
						ON c.customer = d.customer
				WHERE
					d.destination = dr.ShipToID
					AND ISNUMERIC(c.custom4) = 1
					AND c.custom4 NOT LIKE '%[a-z]%'), GETDATE()
			)
		FROM
			@DistributedReleases dr
		GROUP BY
			ShipToID
		,	CustomerPart
		,	ReleaseDT
	) dr

DELETE
	od
FROM
	dbo.order_detail od
	JOIN dbo.BlanketOrderAlternates boa
		ON boa.AlternateOrderNo = od.order_no
	JOIN ##BlanketOrderDistributeReleases_Edit bodre
		ON bodre.SPID = @@SPID
		AND bodre.ActiveOrderNo = boa.ActiveOrderNo
WHERE
	od.type IN ('P', 'F','2')
--Select * into Ft2BlanketOrderDistributeReleases_Edit from ##BlanketOrderDistributeReleases_Edit
--Select * into FT2DistributedReleases from @DistributedReleases

INSERT
	order_detail
(	order_no, sequence, part_number, product_name, type, quantity,
	status, notes, unit, due_date, release_no, destination,
	customer_part, row_id, flag, ship_type, packline_qty, plant,
	week_no, std_qty, our_cum, the_cum, eeiqty, price, alternate_price,
	committed_qty )
SELECT
	order_no = dr.OrderNo,
	sequence = dr.Line + COALESCE((SELECT MAX (sequence) FROM order_detail WHERE order_no = dr.OrderNo), 0),
	part_number = dr.OrderPart,
	product_name = (SELECT name FROM dbo.part WHERE part = dr.OrderPart),
	type = COALESCE((CASE WHEN OrderType = '2' THEN 'P' ELSE 'F' END),OrderType,'P'),
	quantity = dr.QtyRelease,
	status = '',
	notes = CASE WHEN COALESCE(OrderType,'P') = 'F' THEN 'Firm distributed order.' ELSE 'Planning distributed order.' END,
	unit = (SELECT unit FROM order_header WHERE order_no = dr.OrderNo),
	due_date = dr.ReleaseDT,
	release_no = dr.ReleaseNo,
	destination = dr.ShipToID,
	customer_part = dr.CustomerPart,
	row_id = dr.Line + COALESCE((SELECT MAX (row_id) FROM order_detail WHERE order_no = dr.OrderNo), 0),
	flag = 1,
	ship_type = 'N',
	packline_qty = 0,
	plant = (SELECT plant FROM order_header WHERE order_no = dr.OrderNo),
	week_no = DATEDIFF(dd, (SELECT fiscal_year_begin FROM parameters), dr.ReleaseDT) / 7 + 1,
	std_qty = dr.QtyRelease,
	our_cum = dr.RelPost - dr.QtyRelease + COALESCE((SELECT our_cum FROM order_header WHERE order_no = dr.OrderNo), (SELECT MAX(the_cum) FROM order_detail WHERE order_no = dr.OrderNo), 0),
	the_cum = dr.RelPost + COALESCE((SELECT our_cum FROM order_header WHERE order_no = dr.OrderNo), (SELECT MAX(the_cum) FROM order_detail WHERE order_no = dr.OrderNo), 0),
	eeiqty = COALESCE
	(	(	SELECT
				EEIQty
			FROM
				@EEIQtys
			WHERE
				CustomerPart = dr.CustomerPart
				AND ShipToID = dr.ShipToID
				AND DueDT = dr.ReleaseDT
				AND dr.OrderNo =
				(	SELECT
						MIN(OrderNo)
					FROM
						@DistributedReleases dr2
					WHERE
						CustomerPart = dr.CustomerPart
						AND ShipToID = dr.ShipToID
						AND ReleaseDT = dr.ReleaseDT
				)
		)
	,	0
	),
	price = (SELECT price FROM order_header WHERE order_no = dr.OrderNo),
	alternate_price = (SELECT alternate_price FROM order_header WHERE order_no = dr.OrderNo),
	committed_qty = dr.QtyCommitted
FROM
	@DistributedReleases dr

--- </Body>

---	<Return>
IF	@TranCount = 0 BEGIN
	COMMIT TRAN @ProcName
END

SET	@Result = 0
RETURN
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_SaveBlanketOrderDistributedReleases
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/








GO

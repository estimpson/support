-- exec eeiuser.acctg_csm_sp_select_total_planner_demand 'NOR0015'

alter procedure eeiuser.acctg_csm_sp_select_sales_forecast_accuracy
@beginDT datetime = '2018-01-01'
as
declare
	@Demand table
(	BasePart char(7) not null
,	Price numeric(20,6) not null
,	OnOrderQty numeric(20,6)
,	LastOrderDT datetime
,	primary key
	(	BasePart
	,	Price
	)
)
insert
	@Demand
(	BasePart
,	Price
,	OnOrderQty
,	LastOrderDT
)
select
	BasePart = left(od.part_number,7)
,	Price = coalesce(od.alternate_price, 0)
,	OnOrderQty = sum(od.std_qty)
,	LastOrderDT = max(od.due_date)
from
	dbo.order_detail od
where
	od.due_date >= @beginDT
group by
	left(od.part_number,7)
,	coalesce(od.alternate_price, 0)

declare
	@ShipHist table
(	BasePart char(7) primary key
,	ShippedSales numeric(20,6)
)
insert
	@ShipHist
(	BasePart
,	ShippedSales
)
select
	BasePart = left(sd.part_original,7)
,	ShippedSales = sum(sd.qty_packed * sd.alternate_price)
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
where
	s.date_shipped >= @beginDT
	and coalesce(s.type,'N')!='T'
	and sd.part_original is not null
group by
	left(sd.part_original,7)

declare
	@ReleaseID varchar(30) = dbo.fn_ReturnLatestCSMRelease ('CSM')

select
	v.BasePart
,	v.CSMSales
,	v.OnOrderSales
,	v.ShippedSales
,	TotalActualSales = v.OnOrderSales + v.ShippedSales
,	Variance = v.OnOrderSales + v.ShippedSales - v.CSMSales
,	v.LastOrderDT
--,	v.OrderPrice
from
	(	select
			BasePart = CSM.BASE_PART
		,	CSMSales = sum
				(	  case when @beginDT <= '2017-01-01' and coalesce(d.LastOrderDT, getdate()) >= '2017-01-01' then (CSM.[Jan 2017] * EmpireFactor.[Jan 2017] + EmpireAdjustment.[Jan 2017]) * SellingPrice.[Jan 2017] else 0 end
					+ case when @beginDT <= '2017-02-01' and coalesce(d.LastOrderDT, getdate()) >= '2017-02-01' then (CSM.[Feb 2017] * EmpireFactor.[Feb 2017] + EmpireAdjustment.[Feb 2017]) * SellingPrice.[Feb 2017] else 0 end
					+ case when @beginDT <= '2017-03-01' and coalesce(d.LastOrderDT, getdate()) >= '2017-03-01' then (CSM.[Mar 2017] * EmpireFactor.[Mar 2017] + EmpireAdjustment.[Mar 2017]) * SellingPrice.[Mar 2017] else 0 end
					+ case when @beginDT <= '2017-04-01' and coalesce(d.LastOrderDT, getdate()) >= '2017-04-01' then (CSM.[Apr 2017] * EmpireFactor.[Apr 2017] + EmpireAdjustment.[Apr 2017]) * SellingPrice.[Apr 2017] else 0 end
					+ case when @beginDT <= '2017-05-01' and coalesce(d.LastOrderDT, getdate()) >= '2017-05-01' then (CSM.[May 2017] * EmpireFactor.[May 2017] + EmpireAdjustment.[May 2017]) * SellingPrice.[May 2017] else 0 end
					+ case when @beginDT <= '2017-06-01' and coalesce(d.LastOrderDT, getdate()) >= '2017-06-01' then (CSM.[Jun 2017] * EmpireFactor.[Jun 2017] + EmpireAdjustment.[Jun 2017]) * SellingPrice.[Jun 2017] else 0 end
					+ case when @beginDT <= '2017-07-01' and coalesce(d.LastOrderDT, getdate()) >= '2017-07-01' then (CSM.[Jul 2017] * EmpireFactor.[Jul 2017] + EmpireAdjustment.[Jul 2017]) * SellingPrice.[Jul 2017] else 0 end
					+ case when @beginDT <= '2017-08-01' and coalesce(d.LastOrderDT, getdate()) >= '2017-08-01' then (CSM.[Aug 2017] * EmpireFactor.[Aug 2017] + EmpireAdjustment.[Aug 2017]) * SellingPrice.[Aug 2017] else 0 end
					+ case when @beginDT <= '2017-09-01' and coalesce(d.LastOrderDT, getdate()) >= '2017-09-01' then (CSM.[Sep 2017] * EmpireFactor.[Sep 2017] + EmpireAdjustment.[Sep 2017]) * SellingPrice.[Sep 2017] else 0 end
					+ case when @beginDT <= '2017-10-01' and coalesce(d.LastOrderDT, getdate()) >= '2017-10-01' then (CSM.[Oct 2017] * EmpireFactor.[Oct 2017] + EmpireAdjustment.[Oct 2017]) * SellingPrice.[Oct 2017] else 0 end
					+ case when @beginDT <= '2017-11-01' and coalesce(d.LastOrderDT, getdate()) >= '2017-11-01' then (CSM.[Nov 2017] * EmpireFactor.[Nov 2017] + EmpireAdjustment.[Nov 2017]) * SellingPrice.[Nov 2017] else 0 end
					+ case when @beginDT <= '2017-12-01' and coalesce(d.LastOrderDT, getdate()) >= '2017-12-01' then (CSM.[Dec 2017] * EmpireFactor.[Dec 2017] + EmpireAdjustment.[Dec 2017]) * SellingPrice.[Dec 2017] else 0 end
					+ case when @beginDT <= '2018-01-01' and coalesce(d.LastOrderDT, getdate()) >= '2018-01-01' then (CSM.[Jan 2018] * EmpireFactor.[Jan 2018] + EmpireAdjustment.[Jan 2018]) * SellingPrice.[Jan 2018] else 0 end
					+ case when @beginDT <= '2018-02-01' and coalesce(d.LastOrderDT, getdate()) >= '2018-02-01' then (CSM.[Feb 2018] * EmpireFactor.[Feb 2018] + EmpireAdjustment.[Feb 2018]) * SellingPrice.[Feb 2018] else 0 end
					+ case when @beginDT <= '2018-03-01' and coalesce(d.LastOrderDT, getdate()) >= '2018-03-01' then (CSM.[Mar 2018] * EmpireFactor.[Mar 2018] + EmpireAdjustment.[Mar 2018]) * SellingPrice.[Mar 2018] else 0 end
					+ case when @beginDT <= '2018-04-01' and coalesce(d.LastOrderDT, getdate()) >= '2018-04-01' then (CSM.[Apr 2018] * EmpireFactor.[Apr 2018] + EmpireAdjustment.[Apr 2018]) * SellingPrice.[Apr 2018] else 0 end
					+ case when @beginDT <= '2018-05-01' and coalesce(d.LastOrderDT, getdate()) >= '2018-05-01' then (CSM.[May 2018] * EmpireFactor.[May 2018] + EmpireAdjustment.[May 2018]) * SellingPrice.[May 2018] else 0 end
					+ case when @beginDT <= '2018-06-01' and coalesce(d.LastOrderDT, getdate()) >= '2018-06-01' then (CSM.[Jun 2018] * EmpireFactor.[Jun 2018] + EmpireAdjustment.[Jun 2018]) * SellingPrice.[Jun 2018] else 0 end
					+ case when @beginDT <= '2018-07-01' and coalesce(d.LastOrderDT, getdate()) >= '2018-07-01' then (CSM.[Jul 2018] * EmpireFactor.[Jul 2018] + EmpireAdjustment.[Jul 2018]) * SellingPrice.[Jul 2018] else 0 end
					+ case when @beginDT <= '2018-08-01' and coalesce(d.LastOrderDT, getdate()) >= '2018-08-01' then (CSM.[Aug 2018] * EmpireFactor.[Aug 2018] + EmpireAdjustment.[Aug 2018]) * SellingPrice.[Aug 2018] else 0 end
					+ case when @beginDT <= '2018-09-01' and coalesce(d.LastOrderDT, getdate()) >= '2018-09-01' then (CSM.[Sep 2018] * EmpireFactor.[Sep 2018] + EmpireAdjustment.[Sep 2018]) * SellingPrice.[Sep 2018] else 0 end
					+ case when @beginDT <= '2018-10-01' and coalesce(d.LastOrderDT, getdate()) >= '2018-10-01' then (CSM.[Oct 2018] * EmpireFactor.[Oct 2018] + EmpireAdjustment.[Oct 2018]) * SellingPrice.[Oct 2018] else 0 end
					+ case when @beginDT <= '2018-11-01' and coalesce(d.LastOrderDT, getdate()) >= '2018-11-01' then (CSM.[Nov 2018] * EmpireFactor.[Nov 2018] + EmpireAdjustment.[Nov 2018]) * SellingPrice.[Nov 2018] else 0 end
					+ case when @beginDT <= '2018-12-01' and coalesce(d.LastOrderDT, getdate()) >= '2018-12-01' then (CSM.[Dec 2018] * EmpireFactor.[Dec 2018] + EmpireAdjustment.[Dec 2018]) * SellingPrice.[Dec 2018] else 0 end
					+ case when @beginDT <= '2019-01-01' and coalesce(d.LastOrderDT, getdate()) >= '2019-01-01' then (CSM.[Jan 2019] * EmpireFactor.[Jan 2019] + EmpireAdjustment.[Jan 2019]) * SellingPrice.[Jan 2019] else 0 end
					+ case when @beginDT <= '2019-02-01' and coalesce(d.LastOrderDT, getdate()) >= '2019-02-01' then (CSM.[Feb 2019] * EmpireFactor.[Feb 2019] + EmpireAdjustment.[Feb 2019]) * SellingPrice.[Feb 2019] else 0 end
					+ case when @beginDT <= '2019-03-01' and coalesce(d.LastOrderDT, getdate()) >= '2019-03-01' then (CSM.[Mar 2019] * EmpireFactor.[Mar 2019] + EmpireAdjustment.[Mar 2019]) * SellingPrice.[Mar 2019] else 0 end
					+ case when @beginDT <= '2019-04-01' and coalesce(d.LastOrderDT, getdate()) >= '2019-04-01' then (CSM.[Apr 2019] * EmpireFactor.[Apr 2019] + EmpireAdjustment.[Apr 2019]) * SellingPrice.[Apr 2019] else 0 end
					+ case when @beginDT <= '2019-05-01' and coalesce(d.LastOrderDT, getdate()) >= '2019-05-01' then (CSM.[May 2019] * EmpireFactor.[May 2019] + EmpireAdjustment.[May 2019]) * SellingPrice.[May 2019] else 0 end
					+ case when @beginDT <= '2019-06-01' and coalesce(d.LastOrderDT, getdate()) >= '2019-06-01' then (CSM.[Jun 2019] * EmpireFactor.[Jun 2019] + EmpireAdjustment.[Jun 2019]) * SellingPrice.[Jun 2019] else 0 end
					+ case when @beginDT <= '2019-07-01' and coalesce(d.LastOrderDT, getdate()) >= '2019-07-01' then (CSM.[Jul 2019] * EmpireFactor.[Jul 2019] + EmpireAdjustment.[Jul 2019]) * SellingPrice.[Jul 2019] else 0 end
					+ case when @beginDT <= '2019-08-01' and coalesce(d.LastOrderDT, getdate()) >= '2019-08-01' then (CSM.[Aug 2019] * EmpireFactor.[Aug 2019] + EmpireAdjustment.[Aug 2019]) * SellingPrice.[Aug 2019] else 0 end
					+ case when @beginDT <= '2019-09-01' and coalesce(d.LastOrderDT, getdate()) >= '2019-09-01' then (CSM.[Sep 2019] * EmpireFactor.[Sep 2019] + EmpireAdjustment.[Sep 2019]) * SellingPrice.[Sep 2019] else 0 end
					+ case when @beginDT <= '2019-10-01' and coalesce(d.LastOrderDT, getdate()) >= '2019-10-01' then (CSM.[Oct 2019] * EmpireFactor.[Oct 2019] + EmpireAdjustment.[Oct 2019]) * SellingPrice.[Oct 2019] else 0 end
					+ case when @beginDT <= '2019-11-01' and coalesce(d.LastOrderDT, getdate()) >= '2019-11-01' then (CSM.[Nov 2019] * EmpireFactor.[Nov 2019] + EmpireAdjustment.[Nov 2019]) * SellingPrice.[Nov 2019] else 0 end
					+ case when @beginDT <= '2019-12-01' and coalesce(d.LastOrderDT, getdate()) >= '2019-12-01' then (CSM.[Dec 2019] * EmpireFactor.[Dec 2019] + EmpireAdjustment.[Dec 2019]) * SellingPrice.[Dec 2019] else 0 end
				)
		,	OnOrderSales = coalesce(max(d.OnOrderSales), 0)
		,	ShippedSales = coalesce(max(sh.ShippedSales), 0)
		,	LastOrderDT = max(d.LastOrderDT)
		,	OrderPrice = max(d.OnOrderSales / d.OnOrderQty)
		from
			(	select
					acbpm.BASE_PART
				,	[Jan 2017] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jan 2017], 0))
				,	[Feb 2017] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Feb 2017], 0))
				,	[Mar 2017] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Mar 2017], 0))
				,	[Apr 2017] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Apr 2017], 0))
				,	[May 2017] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[May 2017], 0))
				,	[Jun 2017] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jun 2017], 0))
				,	[Jul 2017] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jul 2017], 0))
				,	[Aug 2017] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Aug 2017], 0))
				,	[Sep 2017] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Sep 2017], 0))
				,	[Oct 2017] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Oct 2017], 0))
				,	[Nov 2017] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Nov 2017], 0))
				,	[Dec 2017] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Dec 2017], 0))

				,	[Jan 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jan 2018], 0))
				,	[Feb 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Feb 2018], 0))
				,	[Mar 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Mar 2018], 0))
				,	[Apr 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Apr 2018], 0))
				,	[May 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[May 2018], 0))
				,	[Jun 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jun 2018], 0))
				,	[Jul 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jul 2018], 0))
				,	[Aug 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Aug 2018], 0))
				,	[Sep 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Sep 2018], 0))
				,	[Oct 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Oct 2018], 0))
				,	[Nov 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Nov 2018], 0))
				,	[Dec 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Dec 2018], 0))

				,	[Jan 2019] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jan 2019], 0))
				,	[Feb 2019] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Feb 2019], 0))
				,	[Mar 2019] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Mar 2019], 0))
				,	[Apr 2019] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Apr 2019], 0))
				,	[May 2019] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[May 2019], 0))
				,	[Jun 2019] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jun 2019], 0))
				,	[Jul 2019] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jul 2019], 0))
				,	[Aug 2019] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Aug 2019], 0))
				,	[Sep 2019] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Sep 2019], 0))
				,	[Oct 2019] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Oct 2019], 0))
				,	[Nov 2019] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Nov 2019], 0))
				,	[Dec 2019] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Dec 2019], 0))

				,	[Jan 2020] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jan 2020], 0))
				,	[Feb 2020] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Feb 2020], 0))
				,	[Mar 2020] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Mar 2020], 0))
				,	[Apr 2020] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Apr 2020], 0))
				,	[May 2020] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[May 2020], 0))
				,	[Jun 2020] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jun 2020], 0))
				,	[Jul 2020] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jul 2020], 0))
				,	[Aug 2020] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Aug 2020], 0))
				,	[Sep 2020] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Sep 2020], 0))
				,	[Oct 2020] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Oct 2020], 0))
				,	[Nov 2020] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Nov 2020], 0))
				,	[Dec 2020] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Dec 2020], 0))
				from
					EEIUser.acctg_csm_base_part_mnemonic acbpm
					join EEIUser.acctg_csm_NAIHS acn
						on acn.Release_ID = acbpm.RELEASE_ID
						and acn.[Mnemonic-Vehicle/Plant] = acbpm.MNEMONIC
				where
					acbpm.RELEASE_ID = @ReleaseID
					and acn.Version = 'CSM'
				group by
					acbpm.BASE_PART
			) CSM
			join
				(	select
						acbpm.BASE_PART
					,	[Jan 2017] = max(coalesce(acn.[Jan 2017], 0))
					,	[Feb 2017] = max(coalesce(acn.[Feb 2017], 0))
					,	[Mar 2017] = max(coalesce(acn.[Mar 2017], 0))
					,	[Apr 2017] = max(coalesce(acn.[Apr 2017], 0))
					,	[May 2017] = max(coalesce(acn.[May 2017], 0))
					,	[Jun 2017] = max(coalesce(acn.[Jun 2017], 0))
					,	[Jul 2017] = max(coalesce(acn.[Jul 2017], 0))
					,	[Aug 2017] = max(coalesce(acn.[Aug 2017], 0))
					,	[Sep 2017] = max(coalesce(acn.[Sep 2017], 0))
					,	[Oct 2017] = max(coalesce(acn.[Oct 2017], 0))
					,	[Nov 2017] = max(coalesce(acn.[Nov 2017], 0))
					,	[Dec 2017] = max(coalesce(acn.[Dec 2017], 0))

					,	[Jan 2018] = max(coalesce(acn.[Jan 2018], 0))
					,	[Feb 2018] = max(coalesce(acn.[Feb 2018], 0))
					,	[Mar 2018] = max(coalesce(acn.[Mar 2018], 0))
					,	[Apr 2018] = max(coalesce(acn.[Apr 2018], 0))
					,	[May 2018] = max(coalesce(acn.[May 2018], 0))
					,	[Jun 2018] = max(coalesce(acn.[Jun 2018], 0))
					,	[Jul 2018] = max(coalesce(acn.[Jul 2018], 0))
					,	[Aug 2018] = max(coalesce(acn.[Aug 2018], 0))
					,	[Sep 2018] = max(coalesce(acn.[Sep 2018], 0))
					,	[Oct 2018] = max(coalesce(acn.[Oct 2018], 0))
					,	[Nov 2018] = max(coalesce(acn.[Nov 2018], 0))
					,	[Dec 2018] = max(coalesce(acn.[Dec 2018], 0))

					,	[Jan 2019] = max(coalesce(acn.[Jan 2019], 0))
					,	[Feb 2019] = max(coalesce(acn.[Feb 2019], 0))
					,	[Mar 2019] = max(coalesce(acn.[Mar 2019], 0))
					,	[Apr 2019] = max(coalesce(acn.[Apr 2019], 0))
					,	[May 2019] = max(coalesce(acn.[May 2019], 0))
					,	[Jun 2019] = max(coalesce(acn.[Jun 2019], 0))
					,	[Jul 2019] = max(coalesce(acn.[Jul 2019], 0))
					,	[Aug 2019] = max(coalesce(acn.[Aug 2019], 0))
					,	[Sep 2019] = max(coalesce(acn.[Sep 2019], 0))
					,	[Oct 2019] = max(coalesce(acn.[Oct 2019], 0))
					,	[Nov 2019] = max(coalesce(acn.[Nov 2019], 0))
					,	[Dec 2019] = max(coalesce(acn.[Dec 2019], 0))

					,	[Jan 2020] = max(coalesce(acn.[Jan 2020], 0))
					,	[Feb 2020] = max(coalesce(acn.[Feb 2020], 0))
					,	[Mar 2020] = max(coalesce(acn.[Mar 2020], 0))
					,	[Apr 2020] = max(coalesce(acn.[Apr 2020], 0))
					,	[May 2020] = max(coalesce(acn.[May 2020], 0))
					,	[Jun 2020] = max(coalesce(acn.[Jun 2020], 0))
					,	[Jul 2020] = max(coalesce(acn.[Jul 2020], 0))
					,	[Aug 2020] = max(coalesce(acn.[Aug 2020], 0))
					,	[Sep 2020] = max(coalesce(acn.[Sep 2020], 0))
					,	[Oct 2020] = max(coalesce(acn.[Oct 2020], 0))
					,	[Nov 2020] = max(coalesce(acn.[Nov 2020], 0))
					,	[Dec 2020] = max(coalesce(acn.[Dec 2020], 0))
					from
						EEIUser.acctg_csm_base_part_mnemonic acbpm
						join EEIUser.acctg_csm_NAIHS acn
							on acn.Release_ID = acbpm.RELEASE_ID
							and acn.[Mnemonic-Vehicle/Plant] = acbpm.MNEMONIC
					where
						acbpm.RELEASE_ID = @ReleaseID
						and acn.Version = 'Empire Factor'
					group by
						acbpm.BASE_PART
				) EmpireFactor
				on CSM.BASE_PART = EmpireFactor.BASE_PART
			join
				(	select
						acbpm.BASE_PART
					,	[Jan 2017] = max(coalesce(acn.[Jan 2017], 0))
					,	[Feb 2017] = max(coalesce(acn.[Feb 2017], 0))
					,	[Mar 2017] = max(coalesce(acn.[Mar 2017], 0))
					,	[Apr 2017] = max(coalesce(acn.[Apr 2017], 0))
					,	[May 2017] = max(coalesce(acn.[May 2017], 0))
					,	[Jun 2017] = max(coalesce(acn.[Jun 2017], 0))
					,	[Jul 2017] = max(coalesce(acn.[Jul 2017], 0))
					,	[Aug 2017] = max(coalesce(acn.[Aug 2017], 0))
					,	[Sep 2017] = max(coalesce(acn.[Sep 2017], 0))
					,	[Oct 2017] = max(coalesce(acn.[Oct 2017], 0))
					,	[Nov 2017] = max(coalesce(acn.[Nov 2017], 0))
					,	[Dec 2017] = max(coalesce(acn.[Dec 2017], 0))

					,	[Jan 2018] = max(coalesce(acn.[Jan 2018], 0))
					,	[Feb 2018] = max(coalesce(acn.[Feb 2018], 0))
					,	[Mar 2018] = max(coalesce(acn.[Mar 2018], 0))
					,	[Apr 2018] = max(coalesce(acn.[Apr 2018], 0))
					,	[May 2018] = max(coalesce(acn.[May 2018], 0))
					,	[Jun 2018] = max(coalesce(acn.[Jun 2018], 0))
					,	[Jul 2018] = max(coalesce(acn.[Jul 2018], 0))
					,	[Aug 2018] = max(coalesce(acn.[Aug 2018], 0))
					,	[Sep 2018] = max(coalesce(acn.[Sep 2018], 0))
					,	[Oct 2018] = max(coalesce(acn.[Oct 2018], 0))
					,	[Nov 2018] = max(coalesce(acn.[Nov 2018], 0))
					,	[Dec 2018] = max(coalesce(acn.[Dec 2018], 0))

					,	[Jan 2019] = max(coalesce(acn.[Jan 2019], 0))
					,	[Feb 2019] = max(coalesce(acn.[Feb 2019], 0))
					,	[Mar 2019] = max(coalesce(acn.[Mar 2019], 0))
					,	[Apr 2019] = max(coalesce(acn.[Apr 2019], 0))
					,	[May 2019] = max(coalesce(acn.[May 2019], 0))
					,	[Jun 2019] = max(coalesce(acn.[Jun 2019], 0))
					,	[Jul 2019] = max(coalesce(acn.[Jul 2019], 0))
					,	[Aug 2019] = max(coalesce(acn.[Aug 2019], 0))
					,	[Sep 2019] = max(coalesce(acn.[Sep 2019], 0))
					,	[Oct 2019] = max(coalesce(acn.[Oct 2019], 0))
					,	[Nov 2019] = max(coalesce(acn.[Nov 2019], 0))
					,	[Dec 2019] = max(coalesce(acn.[Dec 2019], 0))

					,	[Jan 2020] = max(coalesce(acn.[Jan 2020], 0))
					,	[Feb 2020] = max(coalesce(acn.[Feb 2020], 0))
					,	[Mar 2020] = max(coalesce(acn.[Mar 2020], 0))
					,	[Apr 2020] = max(coalesce(acn.[Apr 2020], 0))
					,	[May 2020] = max(coalesce(acn.[May 2020], 0))
					,	[Jun 2020] = max(coalesce(acn.[Jun 2020], 0))
					,	[Jul 2020] = max(coalesce(acn.[Jul 2020], 0))
					,	[Aug 2020] = max(coalesce(acn.[Aug 2020], 0))
					,	[Sep 2020] = max(coalesce(acn.[Sep 2020], 0))
					,	[Oct 2020] = max(coalesce(acn.[Oct 2020], 0))
					,	[Nov 2020] = max(coalesce(acn.[Nov 2020], 0))
					,	[Dec 2020] = max(coalesce(acn.[Dec 2020], 0))
					from
						EEIUser.acctg_csm_base_part_mnemonic acbpm
						join EEIUser.acctg_csm_NAIHS acn
							on acn.Release_ID = acbpm.RELEASE_ID
							and acn.[Mnemonic-Vehicle/Plant] = acbpm.MNEMONIC
					where
						acbpm.RELEASE_ID = @ReleaseID
						and acn.Version = 'Empire Adjustment'
					group by
						acbpm.BASE_PART
				) EmpireAdjustment
				on CSM.BASE_PART = EmpireAdjustment.BASE_PART
			left join
				(	select
						acspt.BASE_PART
					,	[Jan 2017] = max(coalesce(acspt.JAN_17, 0))
					,	[Feb 2017] = max(coalesce(acspt.FEB_17, 0))
					,	[Mar 2017] = max(coalesce(acspt.MAR_17, 0))
					,	[Apr 2017] = max(coalesce(acspt.APR_17, 0))
					,	[May 2017] = max(coalesce(acspt.MAY_17, 0))
					,	[Jun 2017] = max(coalesce(acspt.JUN_17, 0))
					,	[Jul 2017] = max(coalesce(acspt.JUL_17, 0))
					,	[Aug 2017] = max(coalesce(acspt.AUG_17, 0))
					,	[Sep 2017] = max(coalesce(acspt.SEP_17, 0))
					,	[Oct 2017] = max(coalesce(acspt.OCT_17, 0))
					,	[Nov 2017] = max(coalesce(acspt.NOV_17, 0))
					,	[Dec 2017] = max(coalesce(acspt.DEC_17, 0))

					,	[Jan 2018] = max(coalesce(acspt.JAN_18, 0))
					,	[Feb 2018] = max(coalesce(acspt.FEB_18, 0))
					,	[Mar 2018] = max(coalesce(acspt.MAR_18, 0))
					,	[Apr 2018] = max(coalesce(acspt.APR_18, 0))
					,	[May 2018] = max(coalesce(acspt.MAY_18, 0))
					,	[Jun 2018] = max(coalesce(acspt.JUN_18, 0))
					,	[Jul 2018] = max(coalesce(acspt.JUL_18, 0))
					,	[Aug 2018] = max(coalesce(acspt.AUG_18, 0))
					,	[Sep 2018] = max(coalesce(acspt.SEP_18, 0))
					,	[Oct 2018] = max(coalesce(acspt.OCT_18, 0))
					,	[Nov 2018] = max(coalesce(acspt.NOV_18, 0))
					,	[Dec 2018] = max(coalesce(acspt.DEC_18, 0))

					,	[Jan 2019] = max(coalesce(acspt.JAN_19, 0))
					,	[Feb 2019] = max(coalesce(acspt.FEB_19, 0))
					,	[Mar 2019] = max(coalesce(acspt.MAR_19, 0))
					,	[Apr 2019] = max(coalesce(acspt.APR_19, 0))
					,	[May 2019] = max(coalesce(acspt.MAY_19, 0))
					,	[Jun 2019] = max(coalesce(acspt.JUN_19, 0))
					,	[Jul 2019] = max(coalesce(acspt.JUL_19, 0))
					,	[Aug 2019] = max(coalesce(acspt.AUG_19, 0))
					,	[Sep 2019] = max(coalesce(acspt.SEP_19, 0))
					,	[Oct 2019] = max(coalesce(acspt.OCT_19, 0))
					,	[Nov 2019] = max(coalesce(acspt.NOV_19, 0))
					,	[Dec 2019] = max(coalesce(acspt.DEC_19, 0))

					,	[Jan 2020] = max(coalesce(acspt.JAN_20, 0))
					,	[Feb 2020] = max(coalesce(acspt.FEB_20, 0))
					,	[Mar 2020] = max(coalesce(acspt.MAR_20, 0))
					,	[Apr 2020] = max(coalesce(acspt.APR_20, 0))
					,	[May 2020] = max(coalesce(acspt.MAY_20, 0))
					,	[Jun 2020] = max(coalesce(acspt.JUN_20, 0))
					,	[Jul 2020] = max(coalesce(acspt.JUL_20, 0))
					,	[Aug 2020] = max(coalesce(acspt.AUG_20, 0))
					,	[Sep 2020] = max(coalesce(acspt.SEP_20, 0))
					,	[Oct 2020] = max(coalesce(acspt.OCT_20, 0))
					,	[Nov 2020] = max(coalesce(acspt.NOV_20, 0))
					,	[Dec 2020] = max(coalesce(acspt.DEC_20, 0))
					from
						eeiuser.acctg_csm_selling_prices_tabular acspt
					where
						acspt.RELEASE_ID = @ReleaseID
					group by
						acspt.BASE_PART
				) SellingPrice
				on CSM.BASE_PART = SellingPrice.BASE_PART
			outer apply
				(	select
						d.BasePart
					,	OnOrderQty = sum(d.OnOrderQty)
					,	OnOrderSales = sum(d.OnOrderQty * d.OrderPrice)
					,	LastOrderDT = max(d.LastOrderDT)
					from
						(	select
								d.BasePart
							,	OrderPrice =
									case
										when d.Price > 0.01 then d.Price
										else
											case
												when d.LastOrderDT between '2017-01-01' and '2017-02-01' then SellingPrice.[Jan 2017]
												when d.LastOrderDT between '2017-02-01' and '2017-03-01' then SellingPrice.[Feb 2017]
												when d.LastOrderDT between '2017-03-01' and '2017-04-01' then SellingPrice.[Mar 2017]
												when d.LastOrderDT between '2017-04-01' and '2017-05-01' then SellingPrice.[Apr 2017]
												when d.LastOrderDT between '2017-05-01' and '2017-06-01' then SellingPrice.[May 2017]
												when d.LastOrderDT between '2017-06-01' and '2017-07-01' then SellingPrice.[Jun 2017]
												when d.LastOrderDT between '2017-07-01' and '2017-08-01' then SellingPrice.[Jul 2017]
												when d.LastOrderDT between '2017-08-01' and '2017-09-01' then SellingPrice.[Aug 2017]
												when d.LastOrderDT between '2017-09-01' and '2017-10-01' then SellingPrice.[Sep 2017]
												when d.LastOrderDT between '2017-10-01' and '2017-11-01' then SellingPrice.[Oct 2017]
												when d.LastOrderDT between '2017-11-01' and '2017-12-01' then SellingPrice.[Nov 2017]
												when d.LastOrderDT between '2017-12-01' and '2018-01-01' then SellingPrice.[Dec 2017]

												when d.LastOrderDT between '2018-01-01' and '2018-02-01' then SellingPrice.[Jan 2018]
												when d.LastOrderDT between '2018-02-01' and '2018-03-01' then SellingPrice.[Feb 2018]
												when d.LastOrderDT between '2018-03-01' and '2018-04-01' then SellingPrice.[Mar 2018]
												when d.LastOrderDT between '2018-04-01' and '2018-05-01' then SellingPrice.[Apr 2018]
												when d.LastOrderDT between '2018-05-01' and '2018-06-01' then SellingPrice.[May 2018]
												when d.LastOrderDT between '2018-06-01' and '2018-07-01' then SellingPrice.[Jun 2018]
												when d.LastOrderDT between '2018-07-01' and '2018-08-01' then SellingPrice.[Jul 2018]
												when d.LastOrderDT between '2018-08-01' and '2018-09-01' then SellingPrice.[Aug 2018]
												when d.LastOrderDT between '2018-09-01' and '2018-10-01' then SellingPrice.[Sep 2018]
												when d.LastOrderDT between '2018-10-01' and '2018-11-01' then SellingPrice.[Oct 2018]
												when d.LastOrderDT between '2018-11-01' and '2018-12-01' then SellingPrice.[Nov 2018]
												when d.LastOrderDT between '2018-12-01' and '2019-01-01' then SellingPrice.[Dec 2018]

												when d.LastOrderDT between '2019-01-01' and '2019-02-01' then SellingPrice.[Jan 2019]
												when d.LastOrderDT between '2019-02-01' and '2019-03-01' then SellingPrice.[Feb 2019]
												when d.LastOrderDT between '2019-03-01' and '2019-04-01' then SellingPrice.[Mar 2019]
												when d.LastOrderDT between '2019-04-01' and '2019-05-01' then SellingPrice.[Apr 2019]
												when d.LastOrderDT between '2019-05-01' and '2019-06-01' then SellingPrice.[May 2019]
												when d.LastOrderDT between '2019-06-01' and '2019-07-01' then SellingPrice.[Jun 2019]
												when d.LastOrderDT between '2019-07-01' and '2019-08-01' then SellingPrice.[Jul 2019]
												when d.LastOrderDT between '2019-08-01' and '2019-09-01' then SellingPrice.[Aug 2019]
												when d.LastOrderDT between '2019-09-01' and '2019-10-01' then SellingPrice.[Sep 2019]
												when d.LastOrderDT between '2019-10-01' and '2019-11-01' then SellingPrice.[Oct 2019]
												when d.LastOrderDT between '2019-11-01' and '2019-12-01' then SellingPrice.[Nov 2019]
												when d.LastOrderDT between '2019-12-01' and '2020-01-01' then SellingPrice.[Dec 2019]

												when d.LastOrderDT between '2020-01-01' and '2020-02-01' then SellingPrice.[Jan 2020]
												when d.LastOrderDT between '2020-02-01' and '2020-03-01' then SellingPrice.[Feb 2020]
												when d.LastOrderDT between '2020-03-01' and '2020-04-01' then SellingPrice.[Mar 2020]
												when d.LastOrderDT between '2020-04-01' and '2020-05-01' then SellingPrice.[Apr 2020]
												when d.LastOrderDT between '2020-05-01' and '2020-06-01' then SellingPrice.[May 2020]
												when d.LastOrderDT between '2020-06-01' and '2020-07-01' then SellingPrice.[Jun 2020]
												when d.LastOrderDT between '2020-07-01' and '2020-08-01' then SellingPrice.[Jul 2020]
												when d.LastOrderDT between '2020-08-01' and '2020-09-01' then SellingPrice.[Aug 2020]
												when d.LastOrderDT between '2020-09-01' and '2020-10-01' then SellingPrice.[Sep 2020]
												when d.LastOrderDT between '2020-10-01' and '2020-11-01' then SellingPrice.[Oct 2020]
												when d.LastOrderDT between '2020-11-01' and '2020-12-01' then SellingPrice.[Nov 2020]
												when d.LastOrderDT between '2020-12-01' and '2021-01-01' then SellingPrice.[Dec 2020]
											end
									end
							,	d.OnOrderQty
							,	d.LastOrderDT
							from
								@Demand d
							where
								d.BasePart = CSM.BASE_PART
						) d
						group by
							d.BasePart
				) d
			left join @ShipHist sh
				on CSM.BASE_PART = sh.BasePart
		group by
			CSM.BASE_PART
	) v
	join EEIUser.acctg_csm_base_part_attributes acbpa
		on acbpa.base_part = v.BasePart
		and acbpa.release_id = @ReleaseID
where
	v.CSMSales + v.OnOrderSales + v.ShippedSales > 0
	and acbpa.include_in_forecast = 1
go

exec eeiuser.acctg_csm_sp_select_sales_forecast_accuracy
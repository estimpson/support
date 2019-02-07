declare
	@partList varchar(max) = 'ADC0146,ADC0144,ADC0143,AUT0294,KSI0119,ADC0101,VAR0142,VAL0386,STK0003,ALI0149,NAL1378,TRW1041,TRW1040,AUT0286,NAL1477,AUT0283,SLA0248,TRW0959,SLA0389,HEL0236,FNG0107,AUT0339,VNA0193,VAR0129,STE0355,VPP0674,UTA0004,MAG0266,TRW0782,AUT0368'

declare
	@parts table
(	Part char(7) primary key
)

insert
	@parts
(	Part
)
select
	Part = fsstr.Value
from
	dbo.fn_SplitStringToRows(@partList, ',') fsstr

declare
	@beginDT datetime = '2018-01-01'
,	@endDT datetime = '2018-06-30 23:59:59'

declare
	@Demand table
(	BasePart char(7) not null
,	OnOrderQty numeric(20,6) not null
,	primary key
	(	BasePart
	)
)
insert
	@Demand
(	BasePart
,	OnOrderQty
)
select
	p.Part
,	OnOrderQty = coalesce(od.OnOrderQty, 0)
from
	@parts p
	left join
		(	select
				BasePart = left(od.part_number,7)
			,	OnOrderQty = sum(od.std_qty)
			,	LastOrderDT = max(od.due_date)
			from
				dbo.order_detail od
			where
				od.due_date between @beginDT and @endDT
			group by
				left(od.part_number,7)
		) od
		on p.Part = od.BasePart

declare
	@ShipHist table
(	BasePart char(7) primary key
,	ShippedQty numeric(20,6)
)
insert
	@ShipHist
(	BasePart
,	ShippedQty
)
select
	p.Part
,	ShippedQty = coalesce(sd.ShippedQty, 0)
from
	@parts p
	left join
		(	select
				BasePart = left(sd.part_original,7)
			,	ShippedQty = sum(sd.qty_packed)
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
		) sd
		on p.Part = sd.BasePart

declare
	@ReleaseID varchar(30) = dbo.fn_ReturnLatestCSMRelease ('CSM')

select
	v.BasePart
,	v.Vehicle
,	[CSM Average JAN-JUN 2018] = v.CSMQty / 6
,	[Actual Sales Average JAN-JUN 2018] = (v.OnOrderQty + v.ShippedQty) / 6
from
	(	select
			BasePart = p.Part
		,	Vehicle = coalesce(CSM.Vehicle, 'Unknown')
		,	CSMQty = coalesce
				(	CSM.[Jan 2018] * EmpireFactor.[Jan 2018] + EmpireAdjustment.[Jan 2018]
				+	CSM.[Feb 2018] * EmpireFactor.[Feb 2018] + EmpireAdjustment.[Feb 2018]
				+	CSM.[Mar 2018] * EmpireFactor.[Mar 2018] + EmpireAdjustment.[Mar 2018]
				+	CSM.[Apr 2018] * EmpireFactor.[Apr 2018] + EmpireAdjustment.[Apr 2018]
				+	CSM.[May 2018] * EmpireFactor.[May 2018] + EmpireAdjustment.[May 2018]
				+	CSM.[Jun 2018] * EmpireFactor.[Jun 2018] + EmpireAdjustment.[Jun 2018]
				,	0
				)
		,	OnOrderQty = coalesce(d.OnOrderQty, 0)
		,	ShippedQty = coalesce(sh.ShippedQty, 0)
		from
			@parts p
			left join
				(	select
						acbpm.BASE_PART
					,	Vehicle = max(acn.Brand + ' ' + acn.Nameplate)
					,	[Jan 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jan 2018], 0))
					,	[Feb 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Feb 2018], 0))
					,	[Mar 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Mar 2018], 0))
					,	[Apr 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Apr 2018], 0))
					,	[May 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[May 2018], 0))
					,	[Jun 2018] = sum(coalesce(acbpm.QTY_PER * acbpm.TAKE_RATE * acbpm.FAMILY_ALLOCATION * acn.[Jun 2018], 0))
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
						,	[Jan 2018] = max(coalesce(acn.[Jan 2018], 0))
						,	[Feb 2018] = max(coalesce(acn.[Feb 2018], 0))
						,	[Mar 2018] = max(coalesce(acn.[Mar 2018], 0))
						,	[Apr 2018] = max(coalesce(acn.[Apr 2018], 0))
						,	[May 2018] = max(coalesce(acn.[May 2018], 0))
						,	[Jun 2018] = max(coalesce(acn.[Jun 2018], 0))
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
						,	[Jan 2018] = max(coalesce(acn.[Jan 2018], 0))
						,	[Feb 2018] = max(coalesce(acn.[Feb 2018], 0))
						,	[Mar 2018] = max(coalesce(acn.[Mar 2018], 0))
						,	[Apr 2018] = max(coalesce(acn.[Apr 2018], 0))
						,	[May 2018] = max(coalesce(acn.[May 2018], 0))
						,	[Jun 2018] = max(coalesce(acn.[Jun 2018], 0))
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
				on csm.BASE_PART = p.Part
			left join @Demand d
				on d.BasePart = p.Part
			left join @ShipHist sh
				on sh.BasePart = p.Part
	) v
	left join EEIUser.acctg_csm_base_part_attributes acbpa
		on acbpa.base_part = v.BasePart
		and acbpa.release_id = @ReleaseID


/*
Create View.EEH.ACCT.SubsidiaryPartCostEffective.sql
*/

use EEH
go

--drop table ACCT.SubsidiaryPartCostEffective
if	objectproperty(object_id('ACCT.SubsidiaryPartCostEffective'), 'IsView') = 1 begin
	drop view ACCT.SubsidiaryPartCostEffective
end
go

create view ACCT.SubsidiaryPartCostEffective
as
select
	spce.Subsidiary
,	spce.Part
,	spce.EffectiveDT
,	spce.Material
,	spce.Labor
,	spce.Burden
,	spce.SalesPrice
,	spce.RowID
,	spce.RowCreateDT
,	spce.RowCreateUser
,	spce.RowModifiedDT
,	spce.RowModifiedUser
from
	(	select
			Subsidiary
		,	Part
		,	EffectiveDT
		,	Effective =
				case
					when row_number() over (partition by Subsidiary, Part order by EffectiveDT desc) = 1 then 1
					else 0
				end
		,	Material
		,	Labor
		,	Burden
		,	SalesPrice
		,	RowID
		,	RowCreateDT
		,	RowCreateUser
		,	RowModifiedDT
		,	RowModifiedUser
		from
			ACCT.SubsidiaryPartCosts
	) spce
where
	spce.Effective = 1
go

select
	*
from
	ACCT.SubsidiaryPartCostEffective spce
order by
	spce.Part
--select
--	*
--from
--	dbo.ledger_balances lb
--where
--	lb.fiscal_year = '2018'

alter view expanded_chart_of_account_items_example_with_balances
as
select
	ecoai2.fiscal_year
,	ecoai2.account
,	ecoai2.hierarchy_id
,	ecoai2.level
,	balance_total =
	(	select
 			sum(lb.period_amount)
 		from
 			dbo.ledger_balances lb
			join dbo.expanded_chart_of_account_items ecoai
				on lb.account = ecoai.account
				and lb.fiscal_year = ecoai.fiscal_year
		where
			lb.fiscal_year = ecoai2.fiscal_year
			and balance_name = 'ACTUAL'
			and ecoai.hierarchy_id like ecoai2.hierarchy_id + '%'
 	)
from
	dbo.expanded_chart_of_account_items ecoai2
go

select
	*
from
	dbo.expanded_chart_of_account_items_example_with_balances ecoaiewb
where
	ecoaiewb.fiscal_year = '2018'
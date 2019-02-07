alter view dbo.expanded_chart_of_account_items
as
with
	coa_base
		(	fiscal_year
		,	account
		)
	as
	(	select
			coai.fiscal_year
		,	coai.account
		from
			dbo.chart_of_account_items coai
		where
			coai.coa = 'EEI MASTER'
			and coai.account_level = 1
	)
,	coa_tree
		(	fiscal_year
		,	account
		,	hierarchy_id
		,	level
		)
	as
	(	select
	 		coa_base.fiscal_year
		,	coa_base.account
		,	convert (varchar(max), coa_base.account)
		,	level = 0
	 	from
	 		coa_base
		union all
		select
			coai.fiscal_year
		,	coai.account
		,	convert (varchar(max), coa_tree.hierarchy_id + '/' + coai.account)
		,	level = coa_tree.level + 1
		from
			coa_tree
			join dbo.chart_of_account_items coai
				on coa_tree.account = coai.parent_account
				and coa_tree.fiscal_year = coai.fiscal_year
				and coai.coa = 'EEI MASTER'
	)
select
	coa_tree.fiscal_year
,	coa_tree.account
,	coa_tree.hierarchy_id
,	coa_tree.level
from
	coa_tree
go

select
	*
from
	dbo.expanded_chart_of_account_items ecoai
where
	ecoai.fiscal_year = '2018'
order by
	ecoai.hierarchy_id
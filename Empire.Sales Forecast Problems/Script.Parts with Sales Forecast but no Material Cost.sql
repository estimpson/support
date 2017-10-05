select
	acvssf.base_part
from
	eeiuser.acctg_csm_vw_select_sales_forecast acvssf
where
	acvssf.Cal_17_Sales + acvssf.Cal_18_Sales + acvssf.Cal_19_Sales + acvssf.Cal_20_Sales + acvssf.Cal_21_Sales + acvssf.Cal_22_Sales + acvssf.Cal_23_Sales + acvssf.Cal_24_Sales > 0
	and acvssf.Cal_17_MC + acvssf.Cal_18_MC + acvssf.Cal_19_MC + acvssf.Cal_20_MC + acvssf.Cal_21_MC + acvssf.Cal_22_MC + acvssf.Cal_23_MC + acvssf.Cal_24_MC = 0
union all
select
	acvssf.base_part
from
	eeiuser.acctg_csm_vw_select_sales_forecast acvssf
where
	acvssf.Cal_17_Sales + acvssf.Cal_18_Sales + acvssf.Cal_19_Sales + acvssf.Cal_20_Sales + acvssf.Cal_21_Sales + acvssf.Cal_22_Sales + acvssf.Cal_23_Sales + acvssf.Cal_24_Sales > 0
	and acvssf.Cal_17_MC + acvssf.Cal_18_MC + acvssf.Cal_19_MC + acvssf.Cal_20_MC + acvssf.Cal_21_MC + acvssf.Cal_22_MC + acvssf.Cal_23_MC + acvssf.Cal_24_MC is null
order by
	1

/*
select
	*
into
	EEIUser.acctg_csm_material_cost_tabular_2017_09_bk
from
	EEIUser.acctg_csm_material_cost_tabular acmct
	join EEIUser.acctg_csm_import_quote_material_cost aciqmc
		on aciqmc.BasePart = acmct.BASE_PART
where
	acmct.RELEASE_ID = dbo.fn_ReturnLatestCSMRelease('CSM')	

update
	acmct
set PartUsedForCost = 'Quote'
,	JAN_12 = coalesce(nullif(JAN_12, 0), aciqmc.MaterialCost)
,	FEB_12 = coalesce(nullif(FEB_12, 0), aciqmc.MaterialCost)
,	MAR_12 = coalesce(nullif(MAR_12, 0), aciqmc.MaterialCost)
,	APR_12 = coalesce(nullif(APR_12, 0), aciqmc.MaterialCost)
,	MAY_12 = coalesce(nullif(MAY_12, 0), aciqmc.MaterialCost)
,	JUN_12 = coalesce(nullif(JUN_12, 0), aciqmc.MaterialCost)
,	JUL_12 = coalesce(nullif(JUL_12, 0), aciqmc.MaterialCost)
,	AUG_12 = coalesce(nullif(AUG_12, 0), aciqmc.MaterialCost)
,	SEP_12 = coalesce(nullif(SEP_12, 0), aciqmc.MaterialCost)
,	OCT_12 = coalesce(nullif(OCT_12, 0), aciqmc.MaterialCost)
,	NOV_12 = coalesce(nullif(NOV_12, 0), aciqmc.MaterialCost)
,	DEC_12 = coalesce(nullif(DEC_12, 0), aciqmc.MaterialCost)
,	JAN_13 = coalesce(nullif(JAN_13, 0), aciqmc.MaterialCost)
,	FEB_13 = coalesce(nullif(FEB_13, 0), aciqmc.MaterialCost)
,	MAR_13 = coalesce(nullif(MAR_13, 0), aciqmc.MaterialCost)
,	APR_13 = coalesce(nullif(APR_13, 0), aciqmc.MaterialCost)
,	MAY_13 = coalesce(nullif(MAY_13, 0), aciqmc.MaterialCost)
,	JUN_13 = coalesce(nullif(JUN_13, 0), aciqmc.MaterialCost)
,	JUL_13 = coalesce(nullif(JUL_13, 0), aciqmc.MaterialCost)
,	AUG_13 = coalesce(nullif(AUG_13, 0), aciqmc.MaterialCost)
,	SEP_13 = coalesce(nullif(SEP_13, 0), aciqmc.MaterialCost)
,	OCT_13 = coalesce(nullif(OCT_13, 0), aciqmc.MaterialCost)
,	NOV_13 = coalesce(nullif(NOV_13, 0), aciqmc.MaterialCost)
,	DEC_13 = coalesce(nullif(DEC_13, 0), aciqmc.MaterialCost)
,	JAN_14 = coalesce(nullif(JAN_14, 0), aciqmc.MaterialCost)
,	FEB_14 = coalesce(nullif(FEB_14, 0), aciqmc.MaterialCost)
,	MAR_14 = coalesce(nullif(MAR_14, 0), aciqmc.MaterialCost)
,	APR_14 = coalesce(nullif(APR_14, 0), aciqmc.MaterialCost)
,	MAY_14 = coalesce(nullif(MAY_14, 0), aciqmc.MaterialCost)
,	JUN_14 = coalesce(nullif(JUN_14, 0), aciqmc.MaterialCost)
,	JUL_14 = coalesce(nullif(JUL_14, 0), aciqmc.MaterialCost)
,	AUG_14 = coalesce(nullif(AUG_14, 0), aciqmc.MaterialCost)
,	SEP_14 = coalesce(nullif(SEP_14, 0), aciqmc.MaterialCost)
,	OCT_14 = coalesce(nullif(OCT_14, 0), aciqmc.MaterialCost)
,	NOV_14 = coalesce(nullif(NOV_14, 0), aciqmc.MaterialCost)
,	DEC_14 = coalesce(nullif(DEC_14, 0), aciqmc.MaterialCost)
,	JAN_15 = coalesce(nullif(JAN_15, 0), aciqmc.MaterialCost)
,	FEB_15 = coalesce(nullif(FEB_15, 0), aciqmc.MaterialCost)
,	MAR_15 = coalesce(nullif(MAR_15, 0), aciqmc.MaterialCost)
,	APR_15 = coalesce(nullif(APR_15, 0), aciqmc.MaterialCost)
,	MAY_15 = coalesce(nullif(MAY_15, 0), aciqmc.MaterialCost)
,	JUN_15 = coalesce(nullif(JUN_15, 0), aciqmc.MaterialCost)
,	JUL_15 = coalesce(nullif(JUL_15, 0), aciqmc.MaterialCost)
,	AUG_15 = coalesce(nullif(AUG_15, 0), aciqmc.MaterialCost)
,	SEP_15 = coalesce(nullif(SEP_15, 0), aciqmc.MaterialCost)
,	OCT_15 = coalesce(nullif(OCT_15, 0), aciqmc.MaterialCost)
,	NOV_15 = coalesce(nullif(NOV_15, 0), aciqmc.MaterialCost)
,	DEC_15 = coalesce(nullif(DEC_15, 0), aciqmc.MaterialCost)
,	JAN_16 = coalesce(nullif(JAN_16, 0), aciqmc.MaterialCost)
,	FEB_16 = coalesce(nullif(FEB_16, 0), aciqmc.MaterialCost)
,	MAR_16 = coalesce(nullif(MAR_16, 0), aciqmc.MaterialCost)
,	APR_16 = coalesce(nullif(APR_16, 0), aciqmc.MaterialCost)
,	MAY_16 = coalesce(nullif(MAY_16, 0), aciqmc.MaterialCost)
,	JUN_16 = coalesce(nullif(JUN_16, 0), aciqmc.MaterialCost)
,	JUL_16 = coalesce(nullif(JUL_16, 0), aciqmc.MaterialCost)
,	AUG_16 = coalesce(nullif(AUG_16, 0), aciqmc.MaterialCost)
,	SEP_16 = coalesce(nullif(SEP_16, 0), aciqmc.MaterialCost)
,	OCT_16 = coalesce(nullif(OCT_16, 0), aciqmc.MaterialCost)
,	NOV_16 = coalesce(nullif(NOV_16, 0), aciqmc.MaterialCost)
,	DEC_16 = coalesce(nullif(DEC_16, 0), aciqmc.MaterialCost)
,	JAN_17 = coalesce(nullif(JAN_17, 0), aciqmc.MaterialCost)
,	FEB_17 = coalesce(nullif(FEB_17, 0), aciqmc.MaterialCost)
,	MAR_17 = coalesce(nullif(MAR_17, 0), aciqmc.MaterialCost)
,	APR_17 = coalesce(nullif(APR_17, 0), aciqmc.MaterialCost)
,	MAY_17 = coalesce(nullif(MAY_17, 0), aciqmc.MaterialCost)
,	JUN_17 = coalesce(nullif(JUN_17, 0), aciqmc.MaterialCost)
,	JUL_17 = coalesce(nullif(JUL_17, 0), aciqmc.MaterialCost)
,	AUG_17 = coalesce(nullif(AUG_17, 0), aciqmc.MaterialCost)
,	SEP_17 = coalesce(nullif(SEP_17, 0), aciqmc.MaterialCost)
,	OCT_17 = coalesce(nullif(OCT_17, 0), aciqmc.MaterialCost)
,	NOV_17 = coalesce(nullif(NOV_17, 0), aciqmc.MaterialCost)
,	DEC_17 = coalesce(nullif(DEC_17, 0), aciqmc.MaterialCost)
,	JAN_18 = coalesce(nullif(JAN_18, 0), aciqmc.MaterialCost)
,	FEB_18 = coalesce(nullif(FEB_18, 0), aciqmc.MaterialCost)
,	MAR_18 = coalesce(nullif(MAR_18, 0), aciqmc.MaterialCost)
,	APR_18 = coalesce(nullif(APR_18, 0), aciqmc.MaterialCost)
,	MAY_18 = coalesce(nullif(MAY_18, 0), aciqmc.MaterialCost)
,	JUN_18 = coalesce(nullif(JUN_18, 0), aciqmc.MaterialCost)
,	JUL_18 = coalesce(nullif(JUL_18, 0), aciqmc.MaterialCost)
,	AUG_18 = coalesce(nullif(AUG_18, 0), aciqmc.MaterialCost)
,	SEP_18 = coalesce(nullif(SEP_18, 0), aciqmc.MaterialCost)
,	OCT_18 = coalesce(nullif(OCT_18, 0), aciqmc.MaterialCost)
,	NOV_18 = coalesce(nullif(NOV_18, 0), aciqmc.MaterialCost)
,	DEC_18 = coalesce(nullif(DEC_18, 0), aciqmc.MaterialCost)
,	JAN_19 = coalesce(nullif(JAN_19, 0), aciqmc.MaterialCost)
,	FEB_19 = coalesce(nullif(FEB_19, 0), aciqmc.MaterialCost)
,	MAR_19 = coalesce(nullif(MAR_19, 0), aciqmc.MaterialCost)
,	APR_19 = coalesce(nullif(APR_19, 0), aciqmc.MaterialCost)
,	MAY_19 = coalesce(nullif(MAY_19, 0), aciqmc.MaterialCost)
,	JUN_19 = coalesce(nullif(JUN_19, 0), aciqmc.MaterialCost)
,	JUL_19 = coalesce(nullif(JUL_19, 0), aciqmc.MaterialCost)
,	AUG_19 = coalesce(nullif(AUG_19, 0), aciqmc.MaterialCost)
,	SEP_19 = coalesce(nullif(SEP_19, 0), aciqmc.MaterialCost)
,	OCT_19 = coalesce(nullif(OCT_19, 0), aciqmc.MaterialCost)
,	NOV_19 = coalesce(nullif(NOV_19, 0), aciqmc.MaterialCost)
,	DEC_19 = coalesce(nullif(DEC_19, 0), aciqmc.MaterialCost)
,	DEC_20 = coalesce(nullif(DEC_20, 0), aciqmc.MaterialCost)
,	DEC_21 = coalesce(nullif(DEC_21, 0), aciqmc.MaterialCost)
,	DEC_22 = coalesce(nullif(DEC_22, 0), aciqmc.MaterialCost)
,	DEC_23 = coalesce(nullif(DEC_23, 0), aciqmc.MaterialCost)
,	DEC_24 = coalesce(nullif(DEC_24, 0), aciqmc.MaterialCost)
from
	EEIUser.acctg_csm_material_cost_tabular acmct
	join EEIUser.acctg_csm_import_quote_material_cost aciqmc
		on aciqmc.BasePart = acmct.BASE_PART
where
	acmct.RELEASE_ID = dbo.fn_ReturnLatestCSMRelease('CSM')
*/

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
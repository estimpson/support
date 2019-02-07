
/*
Create Procedure.EEH.ACCT.usp_SubsidiaryCostRollup_CN.sql
*/

use EEH
go

if	objectproperty(object_id('ACCT.usp_SubsidiaryCostRollup_CN'), 'IsProcedure') = 1 begin
	drop procedure ACCT.usp_SubsidiaryCostRollup_CN
end
go

create procedure ACCT.usp_SubsidiaryCostRollup_CN
	@TranDT datetime = null out
,	@Result integer = null out
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. ACCT.usp_Test
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
--- <Insert rows="*">
set	@TableName = 'dbo.PartStandard_CN'

insert
	dbo.PartStandard_CN
(	Part
)
select
	ps.part
from
	dbo.part_standard ps
where
	not exists
		(	select
				*
			from
				dbo.PartStandard_CN pss
			where
				pss.Part = ps.part
		)
order by
	ps.part

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

--- <Update rows="*">
set	@TableName = 'dbo.PartStandard_CN'

update
	pss
set pss.Material = spce.Material
,	pss.Labor = spce.Labor
,	pss.Burden = spce.Burden
,	pss.SalesPrice = spce.SalesPrice
,	pss.MaterialAccum =
		(	select
				sum(spce2.Material * xr.XQty)
			from
				FT.XRt xr
				join ACCT.SubsidiaryPartCostEffective spce2
					on xr.ChildPart = spce2.Part
					and spce2.Subsidiary = 'CN'
			where
				xr.TopPart = pss.Part
		)
,	pss.LaborAccum = 
		(	select
				sum(spce2.Labor * xr.XQty)
			from
				FT.XRt xr
				join ACCT.SubsidiaryPartCostEffective spce2
					on xr.ChildPart = spce2.Part
					and spce2.Subsidiary = 'CN'
			where
				xr.TopPart = pss.Part
		)
,	pss.BurdenAccum = 
		(	select
				sum(spce2.Burden * xr.XQty)
			from
				FT.XRt xr
				join ACCT.SubsidiaryPartCostEffective spce2
					on xr.ChildPart = spce2.Part
					and spce2.Subsidiary = 'CN'
			where
				xr.TopPart = pss.Part
		)
,	pss.SalesPriceAccum = 
		(	select
				sum(spce2.SalesPrice * xr.XQty)
			from
				FT.XRt xr
				join ACCT.SubsidiaryPartCostEffective spce2
					on xr.ChildPart = spce2.Part
					and spce2.Subsidiary = 'CN'
			where
				xr.TopPart = pss.Part
		)
from
	dbo.PartStandard_CN pss
	left join ACCT.SubsidiaryPartCostEffective spce
		on spce.Part = pss.Part
		and spce.Subsidiary = 'CN'

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>


--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
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
	@ProcReturn = ACCT.usp_SubsidiaryCostRollup_CN
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

select
	*
from
	dbo.PartStandard_CN
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
go

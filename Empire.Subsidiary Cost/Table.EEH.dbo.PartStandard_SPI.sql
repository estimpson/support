
/*
Create Table.EEH.dbo.PartStandard_SPI.sql
*/

use EEH
go

/*
exec FT.sp_DropForeignKeys

drop table dbo.PartStandard_SPI

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('dbo.PartStandard_SPI'), 'IsTable') is null begin

	create table dbo.PartStandard_SPI
	(	Part varchar(50) default ('0') not null
	,	Status int not null default(0)
	,	Type int not null default(0)
	,	Material numeric(20,6) null
	,	Labor numeric(20,6) null
	,	Burden numeric(20,6) null
	,	SalesPrice numeric(20,6) null
	,	MaterialAccum numeric(20,6) null
	,	LaborAccum numeric(20,6) null
	,	BurdenAccum numeric(20,6) null
	,	SalesPriceAccum numeric(20,6) null
	,	Quoted_Material numeric(20,6) null
	,	Quoted_Burden numeric(20,6) null
	,	Quoted_SalesPrice numeric(20,6) null
	,	Quoted_MaterialAccum numeric(20,6) null
	,	Quoted_LaborAccum numeric(20,6) null
	,	Quoted_BurdenAccum numeric(20,6) null
	,	Quoted_SalesPriceAccum numeric(20,6) null
	,	Planned_Material numeric(20,6) null
	,	Planned_Burden numeric(20,6) null
	,	Planned_SalesPrice numeric(20,6) null
	,	Planned_MaterialAccum numeric(20,6) null
	,	Planned_LaborAccum numeric(20,6) null
	,	Planned_BurdenAccum numeric(20,6) null
	,	Planned_SalesPriceAccum numeric(20,6) null
	,	Frozen_Material numeric(20,6) null
	,	Frozen_Burden numeric(20,6) null
	,	Frozen_SalesPrice numeric(20,6) null
	,	Frozen_MaterialAccum numeric(20,6) null
	,	Frozen_LaborAccum numeric(20,6) null
	,	Frozen_BurdenAccum numeric(20,6) null
	,	Frozen_SalesPriceAccum numeric(20,6) null
	,	RowID int identity(1,1) primary key clustered
	,	RowCreateDT datetime default(getdate())
	,	RowCreateUser sysname default(suser_name())
	,	RowModifiedDT datetime default(getdate())
	,	RowModifiedUser sysname default(suser_name())
	,	unique nonclustered
		(	Part
		)
	)
end
go

/*
Create trigger dbo.tr_PartStandard_SPI_uRowModified on dbo.PartStandard_SPI
*/

--use EEH
--go

if	objectproperty(object_id('dbo.tr_PartStandard_SPI_uRowModified'), 'IsTrigger') = 1 begin
	drop trigger dbo.tr_PartStandard_SPI_uRowModified
end
go

create trigger dbo.tr_PartStandard_SPI_uRowModified on dbo.PartStandard_SPI after update
as
declare
	@TranDT datetime
,	@Result int

set xact_abort off
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

begin try
	--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount
	set	@TranDT = coalesce(@TranDT, GetDate())
	save tran @ProcName
	--- </Tran>

	---	<ArgumentValidation>

	---	</ArgumentValidation>
	
	--- <Body>
	if	not update(RowModifiedDT) begin
		--- <Update rows="*">
		set	@TableName = 'dbo.PartStandard_SPI'
		
		update
			pss
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			dbo.PartStandard_SPI pss
			join inserted i
				on i.RowID = pss.RowID
		
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
	end
end try
begin catch
	declare
		@errorName int
	,	@errorSeverity int
	,	@errorState int
	,	@errorLine int
	,	@errorProcedures sysname
	,	@errorMessage nvarchar(2048)
	,	@xact_state int
	
	select
		@errorName = error_number()
	,	@errorSeverity = error_severity()
	,	@errorState = error_state ()
	,	@errorLine = error_line()
	,	@errorProcedures = error_procedure()
	,	@errorMessage = error_message()
	,	@xact_state = xact_state()

	if	xact_state() = -1 begin
		print 'Error number: ' + convert(varchar, @errorName)
		print 'Error severity: ' + convert(varchar, @errorSeverity)
		print 'Error state: ' + convert(varchar, @errorState)
		print 'Error line: ' + convert(varchar, @errorLine)
		print 'Error procedure: ' + @errorProcedures
		print 'Error message: ' + @errorMessage
		print 'xact_state: ' + convert(varchar, @xact_state)
		
		rollback transaction
	end
	else begin
		/*	Capture any errors in SP Logging. */
		rollback tran @ProcName
	end
end catch

---	<Return>
set	@Result = 0
return
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
go

insert
	dbo.PartStandard_SPI
...

update
	...
from
	dbo.PartStandard_SPI
...

delete
	...
from
	dbo.PartStandard_SPI
...
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


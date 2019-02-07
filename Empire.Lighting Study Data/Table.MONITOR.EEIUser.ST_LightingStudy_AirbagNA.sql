
/*
Create Table.MONITOR.EEIUser.ST_LightingStudy_AirbagNA.sql
*/

use MONITOR
go

/*
exec FT.sp_DropForeignKeys

drop table EEIUser.ST_LightingStudy_AirbagNA

exec FT.sp_AddForeignKeys
*/
if	objectproperty(object_id('EEIUser.ST_LightingStudy_AirbagNA'), 'IsTable') is null begin

	create table EEIUser.ST_LightingStudy_AirbagNA
	(	[Component]                                   varchar(max),
		[Service]                                     varchar(max),
		[Forecast Date]                               datetime,
		[VP: Mnemonic Vehicle/Plant]                  varchar(max),
		[VP: Mnemonic Vehicle]                        varchar(max),
		[VP: Mnemonic Platform]                       varchar(max),
		[VP: Region]                                  varchar(max),
		[VP: Country]                                 varchar(max),
		[VP: City]                                    varchar(max),
		[VP: Market]                                  varchar(max),
		[VP: Production Plant]                        varchar(max),
		[VP: Plant State/Province]                    varchar(max),
		[VP: Vehicle Plant Latitude]                  numeric(20,6),
		[VP: Vehicle Plant Longitude]                 numeric(20,6),
		[VP: Source Plant Region]                     varchar(max),
		[VP: Source Plant Country]                    varchar(max),
		[VP: Source Plant]                            varchar(max),
		[VP: Strategic Group]                         varchar(max),
		[VP: Design Parent]                           varchar(max),
		[VP: Sales Group]                             varchar(max),
		[VP: Sales Parent]                            varchar(max),
		[VP: Manufacturer Group]                      varchar(max),
		[VP: Manufacturer Parent]                     varchar(max),
		[VP: Production Brand]                        varchar(max),
		[VP: Production Nameplate]                    varchar(max),
		[VP: Platform]                                varchar(max),
		[VP: Program]                                 varchar(max),
		[VP: SOP]                                     datetime,
		[VP: EOP]                                     datetime,
		[VP: Vehicle]                                 varchar(max),
		[Global Nameplate - Airbag comp]              varchar(max),
		[VP: Global Sales Segment]                    varchar(4),
		[VP: Global Sales Sub-Segment]                varchar(max),
		[VP: Global Sales Price Class]                varchar(max),
		[VP: Global Production Segment]               varchar(max),
		[VP: Global Production Price Class]           varchar(max),
		[VP: Regional Sales Segment]                  varchar(max),
		[VP: Regional Sales Price Class]              varchar(max),
		[VP: Production Type]                         varchar(max),
		[VP: Assembly Type]                           varchar(max),
		[VP: Car/Truck]                               varchar(max),
		[VP: GVW Rating]                              varchar(max),
		[VP: GVW Class]                               varchar(max),
		[VP: Short Term Risk]                         numeric(20,6),
		[VP: Long Term Risk]                          numeric(20,6),
		[VP: Architecture]                            varchar(max),
		[VP: Engineering Group]                       varchar(max),
		[VP: Primary Design Center]                   varchar(max),
		[VP: Primary Design Country]                  varchar(max),
		[VP: Primary Design Region]                   varchar(max),
		[VP: Secondary Design Center]                 varchar(max),
		[VP: Secondary Design Country]                varchar(max),
		[VP: Secondary Design Region]                 varchar(max),
		[Airbag Position]                             varchar(max),
		[Airbag Module Supplier Group]                varchar(max),
		[Airbag Module Supplier]                      varchar(max),
		[Airbag Module Supplier Country]              varchar(max),
		[Airbag Module Supplier Region]               varchar(max),
		[Airbag Module Supplier Plant]                varchar(max),
		[Airbag Module Units]                         int,
		[Vehicle Units]                               int,
		[Component Volume 2016]                       int,
		[Component Volume 2017]                       int,
		[Component Volume 2018]                       int,
		[Component Volume 2019]                       int,
		[Component Volume 2020]                       int,
		[Component Volume 2021]                       int,
		[Component Volume 2022]                       int,
		[Component Volume 2023]                       int,
		[Vehicle Volume 2016]                         int,
		[Vehicle Volume 2017]                         int,
		[Vehicle Volume 2018]                         int,
		[Vehicle Volume 2019]                         int,
		[Vehicle Volume 2020]                         int,
		[Vehicle Volume 2021]                         int,
		[Vehicle Volume 2022]                         int,
		[Vehicle Volume 2023]                         int

	,	RowID int identity(1,1) primary key clustered
	,	RowCreateDT datetime default(getdate())
	,	RowCreateUser sysname default(suser_name())
	,	RowModifiedDT datetime default(getdate())
	,	RowModifiedUser sysname default(suser_name())
	)
end
go

/*
Create trigger EEIUser.tr_ST_LightingStudy_AirbagNA_uRowModified on EEIUser.ST_LightingStudy_AirbagNA
*/

--use MONITOR
--go

if	objectproperty(object_id('EEIUser.tr_ST_LightingStudy_AirbagNA_uRowModified'), 'IsTrigger') = 1 begin
	drop trigger EEIUser.tr_ST_LightingStudy_AirbagNA_uRowModified
end
go

create trigger EEIUser.tr_ST_LightingStudy_AirbagNA_uRowModified on EEIUser.ST_LightingStudy_AirbagNA after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EEIUser.usp_Test
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
		set	@TableName = 'EEIUser.ST_LightingStudy_AirbagNA'
		
		update
			ls
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			EEIUser.ST_LightingStudy_AirbagNA ls
			join inserted i
				on i.RowID = ls.RowID
		
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
	EEIUser.ST_LightingStudy_AirbagNA
...

update
	...
from
	EEIUser.ST_LightingStudy_AirbagNA
...

delete
	...
from
	EEIUser.ST_LightingStudy_AirbagNA
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


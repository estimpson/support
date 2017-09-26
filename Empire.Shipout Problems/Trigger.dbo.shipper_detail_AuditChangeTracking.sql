
/*
Create Trigger.dbo.shipper_detail_AuditChangeTracking.sql
*/

use MONITOR
go

if	objectproperty(object_id('dbo.shipper_detail_AuditChangeTracking'), 'IsTrigger') = 1 begin
	drop trigger dbo.shipper_detail_AuditChangeTracking
end
go

create trigger dbo.shipper_detail_AuditChangeTracking on dbo.shipper_detail after insert, update, delete
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
	declare
		@connectionID uniqueidentifier =
		(	select
				connection_id
			from
				sys.dm_exec_connections
			where
				session_id = @@spid
		)
	,	@transactionID bigint =
		(	select
				transaction_id
			from
				sys.dm_tran_current_transaction
		)
	,	@newData xml =
		(	select
				*
			from
				Inserted i
			for xml auto
		)
	,	@oldData xml =
		(	select
				*
			from
				Deleted d
			for xml auto
		)
	,	@connectionInfo xml =
		(	select
				session_id
			,	most_recent_session_id
			,	connect_time
			,	net_transport
			,	protocol_type
			,	protocol_version
			,	endpoint_id
			,	encrypt_option
			,	auth_scheme
			,	node_affinity
			,	num_reads
			,	num_writes
			,	last_read
			,	last_write
			,	net_packet_size
			,	client_net_address
			,	client_tcp_port
			,	local_net_address
			,	local_tcp_port
			,	connection_id
			,	parent_connection_id
			from
				sys.dm_exec_connections
			where
				session_id = @@spid
			for xml auto
		)
	,	@sessionInfo xml =
		(	select
				session_id
			,	login_time
			,	host_name
			,	program_name
			,	host_process_id
			,	client_version
			,	client_interface_name
			,	login_name
			,	nt_domain
			,	nt_user_name
			,	status
			,	cpu_time
			,	memory_usage
			,	total_scheduled_time
			,	total_elapsed_time
			,	endpoint_id
			,	last_request_start_time
			,	last_request_end_time
			,	reads
			,	writes
			,	logical_reads
			,	is_user_process
			,	text_size
			,	language
			,	date_format
			,	date_first
			,	quoted_identifier
			,	arithabort
			,	ansi_null_dflt_on
			,	ansi_defaults
			,	ansi_warnings
			,	ansi_padding
			,	ansi_nulls
			,	concat_null_yields_null
			,	transaction_isolation_level
			,	lock_timeout
			,	deadlock_priority
			,	row_count
			,	prev_error
			,	original_login_name
			,	last_successful_logon
			,	last_unsuccessful_logon
			,	unsuccessful_logons
			,	group_id
			from
				sys.dm_exec_sessions
			where
				session_id = @@spid
			for xml auto
		)
	,	@transactionInfo xml =
		(	select
				*
			from
				sys.dm_tran_current_transaction
			for xml auto
		)

	--- <Insert rows="*">
	set	@TableName = 'Audit.DataChanges'
	
	insert
		Audit.DataChanges
	(	ConnectionID
	,	TransactionID
	,	TableName
	,	OldData
	,	NewData
	,	ConnectionInfo
	,	SessionInfo
	,	TransactionInfo
	)
	select
		ConnectionID = @connectionID
	,	TransactionID = @transactionID
	,	TableName = 'dbo.shipper_detail'
	,	OldData = @oldData
	,	NewData = @newData
	,	ConnectionInfo = @connectionInfo
	,	SessionInfo = @sessionInfo
	,	TransactionInfo = @transactionInfo
	
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
	--- </Body>
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
	dbo.shipper_detail
...

update
	...
from
	dbo.shipper_detail
...

delete
	...
from
	dbo.shipper_detail
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


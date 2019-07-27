use FxLabelMaker_LakeOrion
go

insert
	dbo.AxPartCustomerDef
(	AxCustomer
,	AxPart
,	CustomerPart
,	PartName
,	PiecesPerBox
,	BoxesPerCarton
,	BoxesPerPallet
,	LidsPerPallet
,	QtyDunnage1
,	QtyDunnage2
,	BoxInformation
,	MasterCartonInformation
,	PalletInformation
,	PalletText
,	Notes1
,	Notes2
,	IndividualLabelFormat
,	MasterLabelFormat
,	InternalLabelFormat
,	UPC_Individual
,	UPC_Master
,	Description1
,	Description2
,	Description3
,	Other1
,	Other2
,	SizeInches
,	AdditionalInfo
,	BoxLabelFormat
,	PalletLabelFormat
,	CustomerPO
,	DockCode
,	LineFeedCode
,	ZoneCode
,	EngineeringLevel
,	SupplierCode
,	UnitWeight
,	ReturnableContainer
)
select
	apcd.AxCustomer
,	pnc.NewPart
,	apcd.CustomerPart
,	apcd.PartName
,	apcd.PiecesPerBox
,	apcd.BoxesPerCarton
,	apcd.BoxesPerPallet
,	apcd.LidsPerPallet
,	apcd.QtyDunnage1
,	apcd.QtyDunnage2
,	apcd.BoxInformation
,	apcd.MasterCartonInformation
,	apcd.PalletInformation
,	apcd.PalletText
,	apcd.Notes1
,	apcd.Notes2
,	apcd.IndividualLabelFormat
,	apcd.MasterLabelFormat
,	apcd.InternalLabelFormat
,	apcd.UPC_Individual
,	apcd.UPC_Master
,	apcd.Description1
,	apcd.Description2
,	apcd.Description3
,	apcd.Other1
,	apcd.Other2
,	apcd.SizeInches
,	apcd.AdditionalInfo
,	apcd.BoxLabelFormat
,	apcd.PalletLabelFormat
,	apcd.CustomerPO
,	apcd.DockCode
,	apcd.LineFeedCode
,	apcd.ZoneCode
,	apcd.EngineeringLevel
,	apcd.SupplierCode
,	apcd.UnitWeight
,	apcd.ReturnableContainer
from
	tempdb.dbo.PartNumberChange pnc
	join dbo.AxPartCustomerDef apcd
		on pnc.OldPart = apcd.AxPart

insert
	dbo.PartLabelDefn
(	AxCustomer
,	AxPart
,	CustomerPart
,	LabelName
,	PiecesPerLabel
,	PrinterPort
,	Copies
)
select
	pld.AxCustomer
,	pnc.NewPart
,	pld.CustomerPart
,	pld.LabelName
,	pld.PiecesPerLabel
,	pld.PrinterPort
,	pld.Copies
from
	tempdb.dbo.PartNumberChange pnc
	join dbo.PartLabelDefn pld
		on pld.AxPart = pnc.OldPart
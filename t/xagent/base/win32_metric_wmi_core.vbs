On Error Resume Next

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20

If Wscript.Arguments.Count = 0 Then
strComputer="localhost"
Else
strComputer=Wscript.Arguments(0)
End If


WScript.Echo "=========================================="
WScript.Echo "Computer= " & strComputer
WScript.Echo "=========================================="

Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")


Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_Cache", "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)

For Each objItem In colItems
WScript.Echo "<001> AsyncCopyReadsPersec= " & objItem.AsyncCopyReadsPersec
   WScript.Echo "<002> AsyncDataMapsPersec= " & objItem.AsyncDataMapsPersec
   WScript.Echo "<003> AsyncFastReadsPersec= " & objItem.AsyncFastReadsPersec
   WScript.Echo "<004> AsyncMDLReadsPersec= " & objItem.AsyncMDLReadsPersec
   WScript.Echo "<005> AsyncPinReadsPersec= " & objItem.AsyncPinReadsPersec
   WScript.Echo "<006> CopyReadHitsPercent= " & objItem.CopyReadHitsPercent
   WScript.Echo "<007> CopyReadHitsPercent_Base= " & objItem.CopyReadHitsPercent_Base
   WScript.Echo "<008> CopyReadsPersec= " & objItem.CopyReadsPersec
   WScript.Echo "<009> DataFlushesPersec= " & objItem.DataFlushesPersec
   WScript.Echo "<010> DataFlushPagesPersec= " & objItem.DataFlushPagesPersec
   WScript.Echo "<011> DataMapHitsPercent= " & objItem.DataMapHitsPercent
   WScript.Echo "<012> DataMapHitsPercent_Base= " & objItem.DataMapHitsPercent_Base
   WScript.Echo "<013> DataMapPinsPersec= " & objItem.DataMapPinsPersec
   WScript.Echo "<014> DataMapPinsPersec_Base= " & objItem.DataMapPinsPersec_Base
   WScript.Echo "<015> DataMapsPersec= " & objItem.DataMapsPersec
   WScript.Echo "<016> FastReadNotPossiblesPersec= " & objItem.FastReadNotPossiblesPersec
   WScript.Echo "<017> FastReadResourceMissesPersec= " & objItem.FastReadResourceMissesPersec
   WScript.Echo "<018> FastReadsPersec= " & objItem.FastReadsPersec
   WScript.Echo "<019> LazyWriteFlushesPersec= " & objItem.LazyWriteFlushesPersec
   WScript.Echo "<020> LazyWritePagesPersec= " & objItem.LazyWritePagesPersec
   WScript.Echo "<021> MDLReadHitsPercent= " & objItem.MDLReadHitsPercent
   WScript.Echo "<022> MDLReadHitsPercent_Base= " & objItem.MDLReadHitsPercent_Base
   WScript.Echo "<023> MDLReadsPersec= " & objItem.MDLReadsPersec
   WScript.Echo "<024> PinReadHitsPercent= " & objItem.PinReadHitsPercent
   WScript.Echo "<025> PinReadHitsPercent_Base= " & objItem.PinReadHitsPercent_Base
   WScript.Echo "<026> PinReadsPersec= " & objItem.PinReadsPersec
   WScript.Echo "<027> ReadAheadsPersec= " & objItem.ReadAheadsPersec
   WScript.Echo "<028> SyncCopyReadsPersec= " & objItem.SyncCopyReadsPersec
   WScript.Echo "<039> SyncDataMapsPersec= " & objItem.SyncDataMapsPersec
   WScript.Echo "<030> SyncFastReadsPersec= " & objItem.SyncFastReadsPersec
   WScript.Echo "<031> SyncMDLReadsPersec= " & objItem.SyncMDLReadsPersec
   WScript.Echo "<032> SyncPinReadsPersec= " & objItem.SyncPinReadsPersec
   WScript.Echo
Next


'MEMORY
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_Memory", "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)

For Each objItem In colItems
   WScript.Echo "<101> AvailableBytes= " & objItem.AvailableBytes
   WScript.Echo "<102> AvailableKBytes= " & objItem.AvailableKBytes
   WScript.Echo "<103> AvailableMBytes= " & objItem.AvailableMBytes
   WScript.Echo "<104> CacheBytes= " & objItem.CacheBytes
   WScript.Echo "<105> CacheBytesPeak= " & objItem.CacheBytesPeak
   WScript.Echo "<106> CacheFaultsPersec= " & objItem.CacheFaultsPersec
   WScript.Echo "<107> CommitLimit= " & objItem.CommitLimit
   WScript.Echo "<108> CommittedBytes= " & objItem.CommittedBytes
   WScript.Echo "<109> DemandZeroFaultsPersec= " & objItem.DemandZeroFaultsPersec
   WScript.Echo "<110> FreeSystemPageTableEntries= " & objItem.FreeSystemPageTableEntries
   WScript.Echo "<111> PageFaultsPersec= " & objItem.PageFaultsPersec
   WScript.Echo "<112> PageReadsPersec= " & objItem.PageReadsPersec
   WScript.Echo "<113> PagesInputPersec= " & objItem.PagesInputPersec
   WScript.Echo "<114> PagesOutputPersec= " & objItem.PagesOutputPersec
   WScript.Echo "<115> PagesPersec= " & objItem.PagesPersec
   WScript.Echo "<116> PageWritesPersec= " & objItem.PageWritesPersec
   WScript.Echo "<117> PercentCommittedBytesInUse= " & objItem.PercentCommittedBytesInUse
   WScript.Echo "<118> PercentCommittedBytesInUse_Base= " & objItem.PercentCommittedBytesInUse_Base
   WScript.Echo "<119> PoolNonpagedAllocs= " & objItem.PoolNonpagedAllocs
   WScript.Echo "<120> PoolNonpagedBytes= " & objItem.PoolNonpagedBytes
   WScript.Echo "<121> PoolPagedAllocs= " & objItem.PoolPagedAllocs
   WScript.Echo "<122> PoolPagedBytes= " & objItem.PoolPagedBytes
   WScript.Echo "<123> PoolPagedResidentBytes= " & objItem.PoolPagedResidentBytes
   WScript.Echo "<124> SystemCacheResidentBytes= " & objItem.SystemCacheResidentBytes
   WScript.Echo "<125> SystemCodeResidentBytes= " & objItem.SystemCodeResidentBytes
   WScript.Echo "<126> SystemCodeTotalBytes= " & objItem.SystemCodeTotalBytes
   WScript.Echo "<127> SystemDriverResidentBytes= " & objItem.SystemDriverResidentBytes
   WScript.Echo "<128> SystemDriverTotalBytes= " & objItem.SystemDriverTotalBytes
   WScript.Echo "<129> WriteCopiesPersec= " & objItem.WriteCopiesPersec
   WScript.Echo
 Next


 
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_PagingFile WHERE Name='_Total'", "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)

For Each objItem In colItems
   WScript.Echo "Name= " & objItem.Name
   WScript.Echo "<150> PercentUsage= " & objItem.PercentUsage
   WScript.Echo "<151> PercentUsagePeak= " & objItem.PercentUsagePeak
   WScript.Echo
Next


Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_Objects", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)
For Each objItem In colItems
   WScript.Echo "<180> Events= " & objItem.Events
   WScript.Echo "<181> Mutexes= " & objItem.Mutexes
   WScript.Echo "<182> Processes= " & objItem.Processes
   WScript.Echo "<183> Sections= " & objItem.Sections
   WScript.Echo "<184> Semaphores= " & objItem.Semaphores
   WScript.Echo "<185> Threads= " & objItem.Threads
   WScript.Echo
Next


'PROCESSOR
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_Processor WHERE Name='_Total'", "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)

For Each objItem In colItems
   WScript.Echo "<190> InterruptsPersec= " & objItem.InterruptsPersec
   WScript.Echo "<191> PercentIdleTime= " & objItem.PercentIdleTime
   WScript.Echo "<192> PercentInterruptTime= " & objItem.PercentInterruptTime
   WScript.Echo "<193> PercentPrivilegedTime= " & objItem.PercentPrivilegedTime
   WScript.Echo "<194> PercentProcessorTime= " & objItem.PercentProcessorTime
   WScript.Echo "<195> PercentUserTime= " & objItem.PercentUserTime
   WScript.Echo
Next

Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_System", "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)

For Each objItem In colItems
   WScript.Echo "<200> AlignmentFixupsPersec= " & objItem.AlignmentFixupsPersec
   WScript.Echo "<201> ContextSwitchesPersec= " & objItem.ContextSwitchesPersec
   WScript.Echo "<202> ExceptionDispatchesPersec= " & objItem.ExceptionDispatchesPersec
   WScript.Echo "<203> FileControlBytesPersec= " & objItem.FileControlBytesPersec
   WScript.Echo "<204> FileControlOperationsPersec= " & objItem.FileControlOperationsPersec
   WScript.Echo "<205> FileDataOperationsPersec= " & objItem.FileDataOperationsPersec
   WScript.Echo "<206> FileReadBytesPersec= " & objItem.FileReadBytesPersec
   WScript.Echo "<207> FileReadOperationsPersec= " & objItem.FileReadOperationsPersec
   WScript.Echo "<208> FileWriteBytesPersec= " & objItem.FileWriteBytesPersec
   WScript.Echo "<209> FileWriteOperationsPersec= " & objItem.FileWriteOperationsPersec
   WScript.Echo "<210> FloatingEmulationsPersec= " & objItem.FloatingEmulationsPersec
   WScript.Echo "<211> PercentRegistryQuotaInUse= " & objItem.PercentRegistryQuotaInUse
   WScript.Echo "<212> PercentRegistryQuotaInUse_Base= " & objItem.PercentRegistryQuotaInUse_Base
   WScript.Echo "<213> Processes= " & objItem.Processes
   WScript.Echo "<214> ProcessorQueueLength= " & objItem.ProcessorQueueLength
   WScript.Echo "<215> SystemCallsPersec= " & objItem.SystemCallsPersec
   WScript.Echo "<216> SystemUpTime= " & objItem.SystemUpTime
   WScript.Echo "<217> Threads= " & objItem.Threads
   WScript.Echo
Next

WScript.Quit
'where Name = '0 C:'
   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfDisk_PhysicalDisk", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
      WScript.Echo "AvgDiskBytesPerRead= " & objItem.AvgDiskBytesPerRead
      WScript.Echo "AvgDiskBytesPerTransfer= " & objItem.AvgDiskBytesPerTransfer
      WScript.Echo "AvgDiskBytesPerWrite= " & objItem.AvgDiskBytesPerWrite
      WScript.Echo "AvgDiskQueueLength= " & objItem.AvgDiskQueueLength
      WScript.Echo "AvgDiskReadQueueLength= " & objItem.AvgDiskReadQueueLength
      WScript.Echo "AvgDisksecPerRead= " & objItem.AvgDisksecPerRead
      WScript.Echo "AvgDisksecPerTransfer= " & objItem.AvgDisksecPerTransfer
      WScript.Echo "AvgDisksecPerWrite= " & objItem.AvgDisksecPerWrite
      WScript.Echo "AvgDiskWriteQueueLength= " & objItem.AvgDiskWriteQueueLength
      WScript.Echo "Caption= " & objItem.Caption
      WScript.Echo "CurrentDiskQueueLength= " & objItem.CurrentDiskQueueLength
      WScript.Echo "Description= " & objItem.Description
      WScript.Echo "DiskBytesPersec= " & objItem.DiskBytesPersec
      WScript.Echo "DiskReadBytesPersec= " & objItem.DiskReadBytesPersec
      WScript.Echo "DiskReadsPersec= " & objItem.DiskReadsPersec
      WScript.Echo "DiskTransfersPersec= " & objItem.DiskTransfersPersec
      WScript.Echo "DiskWriteBytesPersec= " & objItem.DiskWriteBytesPersec
      WScript.Echo "DiskWritesPersec= " & objItem.DiskWritesPersec
      WScript.Echo "Frequency_Object= " & objItem.Frequency_Object
      WScript.Echo "Frequency_PerfTime= " & objItem.Frequency_PerfTime
      WScript.Echo "Frequency_Sys100NS= " & objItem.Frequency_Sys100NS
      WScript.Echo "Name= " & objItem.Name
      WScript.Echo "PercentDiskReadTime= " & objItem.PercentDiskReadTime
      WScript.Echo "<*>PercentDiskTime= " & objItem.PercentDiskTime
      WScript.Echo "PercentDiskWriteTime= " & objItem.PercentDiskWriteTime
      WScript.Echo "PercentIdleTime= " & objItem.PercentIdleTime
      WScript.Echo "SplitIOPerSec= " & objItem.SplitIOPerSec
      WScript.Echo "Timestamp_Object= " & objItem.Timestamp_Object
      WScript.Echo "Timestamp_PerfTime= " & objItem.Timestamp_PerfTime
      WScript.Echo "Timestamp_Sys100NS= " & objItem.Timestamp_Sys100NS
      WScript.Echo
   Next

'where DeviceID = 'C:'
   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_LogicalDisk", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
      WScript.Echo "Access= " & objItem.Access
      WScript.Echo "Availability= " & objItem.Availability
      WScript.Echo "BlockSize= " & objItem.BlockSize
      WScript.Echo "Caption= " & objItem.Caption
      WScript.Echo "Compressed= " & objItem.Compressed
      WScript.Echo "ConfigManagerErrorCode= " & objItem.ConfigManagerErrorCode
      WScript.Echo "ConfigManagerUserConfig= " & objItem.ConfigManagerUserConfig
      WScript.Echo "CreationClassName= " & objItem.CreationClassName
      WScript.Echo "Description= " & objItem.Description
      WScript.Echo "DeviceID= " & objItem.DeviceID
      WScript.Echo "DriveType= " & objItem.DriveType
      WScript.Echo "ErrorCleared= " & objItem.ErrorCleared
      WScript.Echo "ErrorDescription= " & objItem.ErrorDescription
      WScript.Echo "ErrorMethodology= " & objItem.ErrorMethodology
      WScript.Echo "FileSystem= " & objItem.FileSystem
      WScript.Echo "<*>FreeSpace= " & objItem.FreeSpace
      WScript.Echo "InstallDate= " & WMIDateStringToDate(objItem.InstallDate)
      WScript.Echo "LastErrorCode= " & objItem.LastErrorCode
      WScript.Echo "MaximumComponentLength= " & objItem.MaximumComponentLength
      WScript.Echo "MediaType= " & objItem.MediaType
      WScript.Echo "Name= " & objItem.Name
      WScript.Echo "NumberOfBlocks= " & objItem.NumberOfBlocks
      WScript.Echo "PNPDeviceID= " & objItem.PNPDeviceID
      strPowerManagementCapabilities = Join(objItem.PowerManagementCapabilities, ",")
         WScript.Echo "PowerManagementCapabilities= " & strPowerManagementCapabilities
      WScript.Echo "PowerManagementSupported= " & objItem.PowerManagementSupported
      WScript.Echo "ProviderName= " & objItem.ProviderName
      WScript.Echo "Purpose= " & objItem.Purpose
      WScript.Echo "QuotasDisabled= " & objItem.QuotasDisabled
      WScript.Echo "QuotasIncomplete= " & objItem.QuotasIncomplete
      WScript.Echo "QuotasRebuilding= " & objItem.QuotasRebuilding
      WScript.Echo "Size= " & objItem.Size
      WScript.Echo "Status= " & objItem.Status
      WScript.Echo "StatusInfo= " & objItem.StatusInfo
      WScript.Echo "SupportsDiskQuotas= " & objItem.SupportsDiskQuotas
      WScript.Echo "SupportsFileBasedCompression= " & objItem.SupportsFileBasedCompression
      WScript.Echo "SystemCreationClassName= " & objItem.SystemCreationClassName
      WScript.Echo "SystemName= " & objItem.SystemName
      WScript.Echo "VolumeDirty= " & objItem.VolumeDirty
      WScript.Echo "VolumeName= " & objItem.VolumeName
      WScript.Echo "VolumeSerialNumber= " & objItem.VolumeSerialNumber
      WScript.Echo
   Next

   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_Tcpip_NetworkInterface", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
      WScript.Echo "BytesReceivedPersec= " & objItem.BytesReceivedPersec
      WScript.Echo "BytesSentPersec= " & objItem.BytesSentPersec
      WScript.Echo "BytesTotalPersec= " & objItem.BytesTotalPersec
      WScript.Echo "Caption= " & objItem.Caption
      WScript.Echo "CurrentBandwidth= " & objItem.CurrentBandwidth
      WScript.Echo "Description= " & objItem.Description
      WScript.Echo "Frequency_Object= " & objItem.Frequency_Object
      WScript.Echo "Frequency_PerfTime= " & objItem.Frequency_PerfTime
      WScript.Echo "Frequency_Sys100NS= " & objItem.Frequency_Sys100NS
      WScript.Echo "Name= " & objItem.Name
      WScript.Echo "OutputQueueLength= " & objItem.OutputQueueLength
      WScript.Echo "PacketsOutboundDiscarded= " & objItem.PacketsOutboundDiscarded
      WScript.Echo "PacketsOutboundErrors= " & objItem.PacketsOutboundErrors
      WScript.Echo "PacketsPersec= " & objItem.PacketsPersec
      WScript.Echo "PacketsReceivedDiscarded= " & objItem.PacketsReceivedDiscarded
      WScript.Echo "PacketsReceivedErrors= " & objItem.PacketsReceivedErrors
      WScript.Echo "PacketsReceivedNonUnicastPersec= " & objItem.PacketsReceivedNonUnicastPersec
      WScript.Echo "PacketsReceivedPersec= " & objItem.PacketsReceivedPersec
      WScript.Echo "PacketsReceivedUnicastPersec= " & objItem.PacketsReceivedUnicastPersec
      WScript.Echo "PacketsReceivedUnknown= " & objItem.PacketsReceivedUnknown
      WScript.Echo "PacketsSentNonUnicastPersec= " & objItem.PacketsSentNonUnicastPersec
      WScript.Echo "PacketsSentPersec= " & objItem.PacketsSentPersec
      WScript.Echo "PacketsSentUnicastPersec= " & objItem.PacketsSentUnicastPersec
      WScript.Echo "Timestamp_Object= " & objItem.Timestamp_Object
      WScript.Echo "Timestamp_PerfTime= " & objItem.Timestamp_PerfTime
      WScript.Echo "Timestamp_Sys100NS= " & objItem.Timestamp_Sys100NS
      WScript.Echo
   Next

   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_Tcpip_IP", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
      WScript.Echo "Caption= " & objItem.Caption
      WScript.Echo "DatagramsForwardedPersec= " & objItem.DatagramsForwardedPersec
      WScript.Echo "DatagramsOutboundDiscarded= " & objItem.DatagramsOutboundDiscarded
      WScript.Echo "DatagramsOutboundNoRoute= " & objItem.DatagramsOutboundNoRoute
      WScript.Echo "DatagramsPersec= " & objItem.DatagramsPersec
      WScript.Echo "DatagramsReceivedAddressErrors= " & objItem.DatagramsReceivedAddressErrors
      WScript.Echo "DatagramsReceivedDeliveredPersec= " & objItem.DatagramsReceivedDeliveredPersec
      WScript.Echo "DatagramsReceivedDiscarded= " & objItem.DatagramsReceivedDiscarded
      WScript.Echo "DatagramsReceivedHeaderErrors= " & objItem.DatagramsReceivedHeaderErrors
      WScript.Echo "DatagramsReceivedPersec= " & objItem.DatagramsReceivedPersec
      WScript.Echo "DatagramsReceivedUnknownProtocol= " & objItem.DatagramsReceivedUnknownProtocol
      WScript.Echo "DatagramsSentPersec= " & objItem.DatagramsSentPersec
      WScript.Echo "Description= " & objItem.Description
      WScript.Echo "FragmentationFailures= " & objItem.FragmentationFailures
      WScript.Echo "FragmentedDatagramsPersec= " & objItem.FragmentedDatagramsPersec
      WScript.Echo "FragmentReassemblyFailures= " & objItem.FragmentReassemblyFailures
      WScript.Echo "FragmentsCreatedPersec= " & objItem.FragmentsCreatedPersec
      WScript.Echo "FragmentsReassembledPersec= " & objItem.FragmentsReassembledPersec
      WScript.Echo "FragmentsReceivedPersec= " & objItem.FragmentsReceivedPersec
      WScript.Echo "Frequency_Object= " & objItem.Frequency_Object
      WScript.Echo "Frequency_PerfTime= " & objItem.Frequency_PerfTime
      WScript.Echo "Frequency_Sys100NS= " & objItem.Frequency_Sys100NS
      WScript.Echo "Name= " & objItem.Name
      WScript.Echo "Timestamp_Object= " & objItem.Timestamp_Object
      WScript.Echo "Timestamp_PerfTime= " & objItem.Timestamp_PerfTime
      WScript.Echo "Timestamp_Sys100NS= " & objItem.Timestamp_Sys100NS
      WScript.Echo
   Next

   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfNet_Server", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
      WScript.Echo "BlockingRequestsRejected= " & objItem.BlockingRequestsRejected
      WScript.Echo "BytesReceivedPersec= " & objItem.BytesReceivedPersec
      WScript.Echo "BytesTotalPersec= " & objItem.BytesTotalPersec
      WScript.Echo "BytesTransmittedPersec= " & objItem.BytesTransmittedPersec
      WScript.Echo "Caption= " & objItem.Caption
      WScript.Echo "ContextBlocksQueuedPersec= " & objItem.ContextBlocksQueuedPersec
      WScript.Echo "Description= " & objItem.Description
      WScript.Echo "ErrorsAccessPermissions= " & objItem.ErrorsAccessPermissions
      WScript.Echo "ErrorsGrantedAccess= " & objItem.ErrorsGrantedAccess
      WScript.Echo "ErrorsLogon= " & objItem.ErrorsLogon
      WScript.Echo "ErrorsSystem= " & objItem.ErrorsSystem
      WScript.Echo "FileDirectorySearches= " & objItem.FileDirectorySearches
      WScript.Echo "FilesOpen= " & objItem.FilesOpen
      WScript.Echo "FilesOpenedTotal= " & objItem.FilesOpenedTotal
      WScript.Echo "Frequency_Object= " & objItem.Frequency_Object
      WScript.Echo "Frequency_PerfTime= " & objItem.Frequency_PerfTime
      WScript.Echo "Frequency_Sys100NS= " & objItem.Frequency_Sys100NS
      WScript.Echo "LogonPersec= " & objItem.LogonPersec
      WScript.Echo "LogonTotal= " & objItem.LogonTotal
      WScript.Echo "Name= " & objItem.Name
      WScript.Echo "PoolNonpagedBytes= " & objItem.PoolNonpagedBytes
      WScript.Echo "PoolNonpagedFailures= " & objItem.PoolNonpagedFailures
      WScript.Echo "PoolNonpagedPeak= " & objItem.PoolNonpagedPeak
      WScript.Echo "PoolPagedBytes= " & objItem.PoolPagedBytes
      WScript.Echo "PoolPagedFailures= " & objItem.PoolPagedFailures
      WScript.Echo "PoolPagedPeak= " & objItem.PoolPagedPeak
      WScript.Echo "ServerSessions= " & objItem.ServerSessions
      WScript.Echo "SessionsErroredOut= " & objItem.SessionsErroredOut
      WScript.Echo "SessionsForcedOff= " & objItem.SessionsForcedOff
      WScript.Echo "SessionsLoggedOff= " & objItem.SessionsLoggedOff
      WScript.Echo "SessionsTimedOut= " & objItem.SessionsTimedOut
      WScript.Echo "Timestamp_Object= " & objItem.Timestamp_Object
      WScript.Echo "Timestamp_PerfTime= " & objItem.Timestamp_PerfTime
      WScript.Echo "Timestamp_Sys100NS= " & objItem.Timestamp_Sys100NS
      WScript.Echo "WorkItemShortages= " & objItem.WorkItemShortages
      WScript.Echo
   Next

'MEMORY
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_Memory", "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)

For Each objItem In colItems
   WScript.Echo "<101> AvailableBytes= " & objItem.AvailableBytes
   WScript.Echo "<102> AvailableKBytes= " & objItem.AvailableKBytes
   WScript.Echo "<103> AvailableMBytes= " & objItem.AvailableMBytes
   WScript.Echo "<104> CacheBytes= " & objItem.CacheBytes
   WScript.Echo "<105> CacheBytesPeak= " & objItem.CacheBytesPeak
   WScript.Echo "<106> CacheFaultsPersec= " & objItem.CacheFaultsPersec
   WScript.Echo "<107> CommitLimit= " & objItem.CommitLimit
   WScript.Echo "<108> CommittedBytes= " & objItem.CommittedBytes
   WScript.Echo "<109> DemandZeroFaultsPersec= " & objItem.DemandZeroFaultsPersec
   WScript.Echo "<110> FreeSystemPageTableEntries= " & objItem.FreeSystemPageTableEntries
   WScript.Echo "<111> PageFaultsPersec= " & objItem.PageFaultsPersec
   WScript.Echo "<112> PageReadsPersec= " & objItem.PageReadsPersec
   WScript.Echo "<113> PagesInputPersec= " & objItem.PagesInputPersec
   WScript.Echo "<114> PagesOutputPersec= " & objItem.PagesOutputPersec
   WScript.Echo "<115> PagesPersec= " & objItem.PagesPersec
   WScript.Echo "<116> PageWritesPersec= " & objItem.PageWritesPersec
   WScript.Echo "<117> PercentCommittedBytesInUse= " & objItem.PercentCommittedBytesInUse
   WScript.Echo "<118> PercentCommittedBytesInUse_Base= " & objItem.PercentCommittedBytesInUse_Base
   WScript.Echo "<119> PoolNonpagedAllocs= " & objItem.PoolNonpagedAllocs
   WScript.Echo "<120> PoolNonpagedBytes= " & objItem.PoolNonpagedBytes
   WScript.Echo "<121> PoolPagedAllocs= " & objItem.PoolPagedAllocs
   WScript.Echo "<122> PoolPagedBytes= " & objItem.PoolPagedBytes
   WScript.Echo "<123> PoolPagedResidentBytes= " & objItem.PoolPagedResidentBytes
   WScript.Echo "<124> SystemCacheResidentBytes= " & objItem.SystemCacheResidentBytes
   WScript.Echo "<125> SystemCodeResidentBytes= " & objItem.SystemCodeResidentBytes
   WScript.Echo "<126> SystemCodeTotalBytes= " & objItem.SystemCodeTotalBytes
   WScript.Echo "<127> SystemDriverResidentBytes= " & objItem.SystemDriverResidentBytes
   WScript.Echo "<128> SystemDriverTotalBytes= " & objItem.SystemDriverTotalBytes
   WScript.Echo "<129> WriteCopiesPersec= " & objItem.WriteCopiesPersec
   WScript.Echo
 Next


 
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_PagingFile WHERE Name='_Total'", "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)

For Each objItem In colItems
   WScript.Echo "Name= " & objItem.Name
   WScript.Echo "<150> PercentUsage= " & objItem.PercentUsage
   WScript.Echo "<151> PercentUsagePeak= " & objItem.PercentUsagePeak
   WScript.Echo
Next


Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_Objects", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)
For Each objItem In colItems
   WScript.Echo "<180> Events= " & objItem.Events
   WScript.Echo "<181> Mutexes= " & objItem.Mutexes
   WScript.Echo "<182> Processes= " & objItem.Processes
   WScript.Echo "<183> Sections= " & objItem.Sections
   WScript.Echo "<184> Semaphores= " & objItem.Semaphores
   WScript.Echo "<185> Threads= " & objItem.Threads
   WScript.Echo
Next


'PROCESSOR
Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_Processor WHERE Name='_Total'", "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)

For Each objItem In colItems
   WScript.Echo "<190> InterruptsPersec= " & objItem.InterruptsPersec
   WScript.Echo "<191> PercentIdleTime= " & objItem.PercentIdleTime
   WScript.Echo "<192> PercentInterruptTime= " & objItem.PercentInterruptTime
   WScript.Echo "<193> PercentPrivilegedTime= " & objItem.PercentPrivilegedTime
   WScript.Echo "<194> PercentProcessorTime= " & objItem.PercentProcessorTime
   WScript.Echo "<195> PercentUserTime= " & objItem.PercentUserTime
   WScript.Echo
Next

Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_System", "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)

For Each objItem In colItems
   WScript.Echo "<200> AlignmentFixupsPersec= " & objItem.AlignmentFixupsPersec
   WScript.Echo "<201> ContextSwitchesPersec= " & objItem.ContextSwitchesPersec
   WScript.Echo "<202> ExceptionDispatchesPersec= " & objItem.ExceptionDispatchesPersec
   WScript.Echo "<203> FileControlBytesPersec= " & objItem.FileControlBytesPersec
   WScript.Echo "<204> FileControlOperationsPersec= " & objItem.FileControlOperationsPersec
   WScript.Echo "<205> FileDataOperationsPersec= " & objItem.FileDataOperationsPersec
   WScript.Echo "<206> FileReadBytesPersec= " & objItem.FileReadBytesPersec
   WScript.Echo "<207> FileReadOperationsPersec= " & objItem.FileReadOperationsPersec
   WScript.Echo "<208> FileWriteBytesPersec= " & objItem.FileWriteBytesPersec
   WScript.Echo "<209> FileWriteOperationsPersec= " & objItem.FileWriteOperationsPersec
   WScript.Echo "<210> FloatingEmulationsPersec= " & objItem.FloatingEmulationsPersec
   WScript.Echo "<211> PercentRegistryQuotaInUse= " & objItem.PercentRegistryQuotaInUse
   WScript.Echo "<212> PercentRegistryQuotaInUse_Base= " & objItem.PercentRegistryQuotaInUse_Base
   WScript.Echo "<213> Processes= " & objItem.Processes
   WScript.Echo "<214> ProcessorQueueLength= " & objItem.ProcessorQueueLength
   WScript.Echo "<215> SystemCallsPersec= " & objItem.SystemCallsPersec
   WScript.Echo "<216> SystemUpTime= " & objItem.SystemUpTime
   WScript.Echo "<217> Threads= " & objItem.Threads
   WScript.Echo
Next

WScript.Quit
'where Name = '0 C:'
   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfDisk_PhysicalDisk", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
      WScript.Echo "AvgDiskBytesPerRead= " & objItem.AvgDiskBytesPerRead
      WScript.Echo "AvgDiskBytesPerTransfer= " & objItem.AvgDiskBytesPerTransfer
      WScript.Echo "AvgDiskBytesPerWrite= " & objItem.AvgDiskBytesPerWrite
      WScript.Echo "AvgDiskQueueLength= " & objItem.AvgDiskQueueLength
      WScript.Echo "AvgDiskReadQueueLength= " & objItem.AvgDiskReadQueueLength
      WScript.Echo "AvgDisksecPerRead= " & objItem.AvgDisksecPerRead
      WScript.Echo "AvgDisksecPerTransfer= " & objItem.AvgDisksecPerTransfer
      WScript.Echo "AvgDisksecPerWrite= " & objItem.AvgDisksecPerWrite
      WScript.Echo "AvgDiskWriteQueueLength= " & objItem.AvgDiskWriteQueueLength
      WScript.Echo "Caption= " & objItem.Caption
      WScript.Echo "CurrentDiskQueueLength= " & objItem.CurrentDiskQueueLength
      WScript.Echo "Description= " & objItem.Description
      WScript.Echo "DiskBytesPersec= " & objItem.DiskBytesPersec
      WScript.Echo "DiskReadBytesPersec= " & objItem.DiskReadBytesPersec
      WScript.Echo "DiskReadsPersec= " & objItem.DiskReadsPersec
      WScript.Echo "DiskTransfersPersec= " & objItem.DiskTransfersPersec
      WScript.Echo "DiskWriteBytesPersec= " & objItem.DiskWriteBytesPersec
      WScript.Echo "DiskWritesPersec= " & objItem.DiskWritesPersec
      WScript.Echo "Frequency_Object= " & objItem.Frequency_Object
      WScript.Echo "Frequency_PerfTime= " & objItem.Frequency_PerfTime
      WScript.Echo "Frequency_Sys100NS= " & objItem.Frequency_Sys100NS
      WScript.Echo "Name= " & objItem.Name
      WScript.Echo "PercentDiskReadTime= " & objItem.PercentDiskReadTime
      WScript.Echo "<*>PercentDiskTime= " & objItem.PercentDiskTime
      WScript.Echo "PercentDiskWriteTime= " & objItem.PercentDiskWriteTime
      WScript.Echo "PercentIdleTime= " & objItem.PercentIdleTime
      WScript.Echo "SplitIOPerSec= " & objItem.SplitIOPerSec
      WScript.Echo "Timestamp_Object= " & objItem.Timestamp_Object
      WScript.Echo "Timestamp_PerfTime= " & objItem.Timestamp_PerfTime
      WScript.Echo "Timestamp_Sys100NS= " & objItem.Timestamp_Sys100NS
      WScript.Echo
   Next

'where DeviceID = 'C:'
   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_LogicalDisk", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
      WScript.Echo "Access= " & objItem.Access
      WScript.Echo "Availability= " & objItem.Availability
      WScript.Echo "BlockSize= " & objItem.BlockSize
      WScript.Echo "Caption= " & objItem.Caption
      WScript.Echo "Compressed= " & objItem.Compressed
      WScript.Echo "ConfigManagerErrorCode= " & objItem.ConfigManagerErrorCode
      WScript.Echo "ConfigManagerUserConfig= " & objItem.ConfigManagerUserConfig
      WScript.Echo "CreationClassName= " & objItem.CreationClassName
      WScript.Echo "Description= " & objItem.Description
      WScript.Echo "DeviceID= " & objItem.DeviceID
      WScript.Echo "DriveType= " & objItem.DriveType
      WScript.Echo "ErrorCleared= " & objItem.ErrorCleared
      WScript.Echo "ErrorDescription= " & objItem.ErrorDescription
      WScript.Echo "ErrorMethodology= " & objItem.ErrorMethodology
      WScript.Echo "FileSystem= " & objItem.FileSystem
      WScript.Echo "<*>FreeSpace= " & objItem.FreeSpace
      WScript.Echo "InstallDate= " & WMIDateStringToDate(objItem.InstallDate)
      WScript.Echo "LastErrorCode= " & objItem.LastErrorCode
      WScript.Echo "MaximumComponentLength= " & objItem.MaximumComponentLength
      WScript.Echo "MediaType= " & objItem.MediaType
      WScript.Echo "Name= " & objItem.Name
      WScript.Echo "NumberOfBlocks= " & objItem.NumberOfBlocks
      WScript.Echo "PNPDeviceID= " & objItem.PNPDeviceID
      strPowerManagementCapabilities = Join(objItem.PowerManagementCapabilities, ",")
         WScript.Echo "PowerManagementCapabilities= " & strPowerManagementCapabilities
      WScript.Echo "PowerManagementSupported= " & objItem.PowerManagementSupported
      WScript.Echo "ProviderName= " & objItem.ProviderName
      WScript.Echo "Purpose= " & objItem.Purpose
      WScript.Echo "QuotasDisabled= " & objItem.QuotasDisabled
      WScript.Echo "QuotasIncomplete= " & objItem.QuotasIncomplete
      WScript.Echo "QuotasRebuilding= " & objItem.QuotasRebuilding
      WScript.Echo "Size= " & objItem.Size
      WScript.Echo "Status= " & objItem.Status
      WScript.Echo "StatusInfo= " & objItem.StatusInfo
      WScript.Echo "SupportsDiskQuotas= " & objItem.SupportsDiskQuotas
      WScript.Echo "SupportsFileBasedCompression= " & objItem.SupportsFileBasedCompression
      WScript.Echo "SystemCreationClassName= " & objItem.SystemCreationClassName
      WScript.Echo "SystemName= " & objItem.SystemName
      WScript.Echo "VolumeDirty= " & objItem.VolumeDirty
      WScript.Echo "VolumeName= " & objItem.VolumeName
      WScript.Echo "VolumeSerialNumber= " & objItem.VolumeSerialNumber
      WScript.Echo
   Next

   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_Tcpip_NetworkInterface", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
      WScript.Echo "BytesReceivedPersec= " & objItem.BytesReceivedPersec
      WScript.Echo "BytesSentPersec= " & objItem.BytesSentPersec
      WScript.Echo "BytesTotalPersec= " & objItem.BytesTotalPersec
      WScript.Echo "Caption= " & objItem.Caption
      WScript.Echo "CurrentBandwidth= " & objItem.CurrentBandwidth
      WScript.Echo "Description= " & objItem.Description
      WScript.Echo "Frequency_Object= " & objItem.Frequency_Object
      WScript.Echo "Frequency_PerfTime= " & objItem.Frequency_PerfTime
      WScript.Echo "Frequency_Sys100NS= " & objItem.Frequency_Sys100NS
      WScript.Echo "Name= " & objItem.Name
      WScript.Echo "OutputQueueLength= " & objItem.OutputQueueLength
      WScript.Echo "PacketsOutboundDiscarded= " & objItem.PacketsOutboundDiscarded
      WScript.Echo "PacketsOutboundErrors= " & objItem.PacketsOutboundErrors
      WScript.Echo "PacketsPersec= " & objItem.PacketsPersec
      WScript.Echo "PacketsReceivedDiscarded= " & objItem.PacketsReceivedDiscarded
      WScript.Echo "PacketsReceivedErrors= " & objItem.PacketsReceivedErrors
      WScript.Echo "PacketsReceivedNonUnicastPersec= " & objItem.PacketsReceivedNonUnicastPersec
      WScript.Echo "PacketsReceivedPersec= " & objItem.PacketsReceivedPersec
      WScript.Echo "PacketsReceivedUnicastPersec= " & objItem.PacketsReceivedUnicastPersec
      WScript.Echo "PacketsReceivedUnknown= " & objItem.PacketsReceivedUnknown
      WScript.Echo "PacketsSentNonUnicastPersec= " & objItem.PacketsSentNonUnicastPersec
      WScript.Echo "PacketsSentPersec= " & objItem.PacketsSentPersec
      WScript.Echo "PacketsSentUnicastPersec= " & objItem.PacketsSentUnicastPersec
      WScript.Echo "Timestamp_Object= " & objItem.Timestamp_Object
      WScript.Echo "Timestamp_PerfTime= " & objItem.Timestamp_PerfTime
      WScript.Echo "Timestamp_Sys100NS= " & objItem.Timestamp_Sys100NS
      WScript.Echo
   Next

   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_Tcpip_IP", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
      WScript.Echo "Caption= " & objItem.Caption
      WScript.Echo "DatagramsForwardedPersec= " & objItem.DatagramsForwardedPersec
      WScript.Echo "DatagramsOutboundDiscarded= " & objItem.DatagramsOutboundDiscarded
      WScript.Echo "DatagramsOutboundNoRoute= " & objItem.DatagramsOutboundNoRoute
      WScript.Echo "DatagramsPersec= " & objItem.DatagramsPersec
      WScript.Echo "DatagramsReceivedAddressErrors= " & objItem.DatagramsReceivedAddressErrors
      WScript.Echo "DatagramsReceivedDeliveredPersec= " & objItem.DatagramsReceivedDeliveredPersec
      WScript.Echo "DatagramsReceivedDiscarded= " & objItem.DatagramsReceivedDiscarded
      WScript.Echo "DatagramsReceivedHeaderErrors= " & objItem.DatagramsReceivedHeaderErrors
      WScript.Echo "DatagramsReceivedPersec= " & objItem.DatagramsReceivedPersec
      WScript.Echo "DatagramsReceivedUnknownProtocol= " & objItem.DatagramsReceivedUnknownProtocol
      WScript.Echo "DatagramsSentPersec= " & objItem.DatagramsSentPersec
      WScript.Echo "Description= " & objItem.Description
      WScript.Echo "FragmentationFailures= " & objItem.FragmentationFailures
      WScript.Echo "FragmentedDatagramsPersec= " & objItem.FragmentedDatagramsPersec
      WScript.Echo "FragmentReassemblyFailures= " & objItem.FragmentReassemblyFailures
      WScript.Echo "FragmentsCreatedPersec= " & objItem.FragmentsCreatedPersec
      WScript.Echo "FragmentsReassembledPersec= " & objItem.FragmentsReassembledPersec
      WScript.Echo "FragmentsReceivedPersec= " & objItem.FragmentsReceivedPersec
      WScript.Echo "Frequency_Object= " & objItem.Frequency_Object
      WScript.Echo "Frequency_PerfTime= " & objItem.Frequency_PerfTime
      WScript.Echo "Frequency_Sys100NS= " & objItem.Frequency_Sys100NS
      WScript.Echo "Name= " & objItem.Name
      WScript.Echo "Timestamp_Object= " & objItem.Timestamp_Object
      WScript.Echo "Timestamp_PerfTime= " & objItem.Timestamp_PerfTime
      WScript.Echo "Timestamp_Sys100NS= " & objItem.Timestamp_Sys100NS
      WScript.Echo
   Next

   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfNet_Server", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems
      WScript.Echo "BlockingRequestsRejected= " & objItem.BlockingRequestsRejected
      WScript.Echo "BytesReceivedPersec= " & objItem.BytesReceivedPersec
      WScript.Echo "BytesTotalPersec= " & objItem.BytesTotalPersec
      WScript.Echo "BytesTransmittedPersec= " & objItem.BytesTransmittedPersec
      WScript.Echo "Caption= " & objItem.Caption
      WScript.Echo "ContextBlocksQueuedPersec= " & objItem.ContextBlocksQueuedPersec
      WScript.Echo "Description= " & objItem.Description
      WScript.Echo "ErrorsAccessPermissions= " & objItem.ErrorsAccessPermissions
      WScript.Echo "ErrorsGrantedAccess= " & objItem.ErrorsGrantedAccess
      WScript.Echo "ErrorsLogon= " & objItem.ErrorsLogon
      WScript.Echo "ErrorsSystem= " & objItem.ErrorsSystem
      WScript.Echo "FileDirectorySearches= " & objItem.FileDirectorySearches
      WScript.Echo "FilesOpen= " & objItem.FilesOpen
      WScript.Echo "FilesOpenedTotal= " & objItem.FilesOpenedTotal
      WScript.Echo "Frequency_Object= " & objItem.Frequency_Object
      WScript.Echo "Frequency_PerfTime= " & objItem.Frequency_PerfTime
      WScript.Echo "Frequency_Sys100NS= " & objItem.Frequency_Sys100NS
      WScript.Echo "LogonPersec= " & objItem.LogonPersec
      WScript.Echo "LogonTotal= " & objItem.LogonTotal
      WScript.Echo "Name= " & objItem.Name
      WScript.Echo "PoolNonpagedBytes= " & objItem.PoolNonpagedBytes
      WScript.Echo "PoolNonpagedFailures= " & objItem.PoolNonpagedFailures
      WScript.Echo "PoolNonpagedPeak= " & objItem.PoolNonpagedPeak
      WScript.Echo "PoolPagedBytes= " & objItem.PoolPagedBytes
      WScript.Echo "PoolPagedFailures= " & objItem.PoolPagedFailures
      WScript.Echo "PoolPagedPeak= " & objItem.PoolPagedPeak
      WScript.Echo "ServerSessions= " & objItem.ServerSessions
      WScript.Echo "SessionsErroredOut= " & objItem.SessionsErroredOut
      WScript.Echo "SessionsForcedOff= " & objItem.SessionsForcedOff
      WScript.Echo "SessionsLoggedOff= " & objItem.SessionsLoggedOff
      WScript.Echo "SessionsTimedOut= " & objItem.SessionsTimedOut
      WScript.Echo "Timestamp_Object= " & objItem.Timestamp_Object
      WScript.Echo "Timestamp_PerfTime= " & objItem.Timestamp_PerfTime
      WScript.Echo "Timestamp_Sys100NS= " & objItem.Timestamp_Sys100NS
      WScript.Echo "WorkItemShortages= " & objItem.WorkItemShortages
      WScript.Echo
   Next


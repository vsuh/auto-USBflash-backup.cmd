# Define a WMI event query, that looks for new instances of Win32_LogicalDisk where DriveType is "2"
# http://msdn.microsoft.com/en-us/library/aa394173(v=vs.85).aspx
$Query = "select * from __InstanceCreationEvent within 5 where TargetInstance ISA 'Win32_LogicalDisk' and TargetInstance.DriveType = 2";

# Define a PowerShell ScriptBlock that will be executed when an event occurs
$Action = { & D:\IRIS\bin\back_me.ps1;  };
$Action = { & ('d:\IRIS\bin\back_me.ps1' -f $event.SourceEventArgs.NewEvent.TargetInstance.Name);  };
# Create the event registration
Register-WmiEvent -Query $Query -Action $Action -SourceIdentifier USBFlashDrive;

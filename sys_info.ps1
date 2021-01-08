$PowerShellVersion=$psversiontable.PSVersion.ToString()

$OS = Get-WmiObject -Class Win32_OperatingSystem
$OSCaption = $OS.Caption
$OSVersion = $OS.Version
$OSSerialNumber = $OS.SerialNumber
$OSInstallDate = $OS.InstallDate
$Network = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true
$DefaultIPGateway = $Network.DefaultIPGateway
$NetworkAdapter = $Network.Description
$IPAddress = $Network.IPAddress[0]
$IPV6Address = $Network.IPAddress[1]
$IPSubnet = $Network.IPSubnet[0]
$MACAddress = $Network.MACAddress
$Computer = Get-WmiObject -Class Win32_ComputerSystem
$ComputerName = $Computer.Name
$CPUInfo = Get-WmiObject -Class Win32_Processor
$LogicalProcessorCount = (Get-WmiObject -class Win32_processor -Property NumberOfLogicalProcessors).NumberOfLogicalProcessors
$PhysicalProcessorCount = @($CPUInfo).Count
$PhysicalDiskInfo = Get-WmiObject -Class Win32_DiskDrive
$LogicalDiskInfo = Get-WmiObject -Class Win32_LogicalDisk -filter "DriveType=3"
$LogicalDiskCount = $LogicalDiskInfo.Count
$PhysicalDiskCount = ($PhysicalDiskInfo.Caption).Count
$MemTotal = "{0:0.0} GB" -f ($OS.TotalVisibleMemorySize / 1MB)

$RESULT="{""result"":{""powershellVersion"":""$PowerShellVersion"",""startTime"":""$(Get-Date)"",
    ""os"":{""osCaption"":""$OSCaption"",""osVersion"":""$OSVersion"",""serialNumber"":""$OSSerialNumber"",""osInstallTime"":""$OSInstallDate""},
    ""ip"":{""defaultIPGateway"":""$DefaultIPGateway"",""networkAdapter"":""$NetworkAdapter"",""ipAddress"":""$IPAddress"",""ipV6Address"":""$IPV6Address"",""subnetMask"":""$IPSubnet"",""macAddress"":""$MACAddress""},
    ""system"":{""computerName"":""$ComputerName"",""physicalCPUNum"":""$PhysicalProcessorCount"",""logicalCPUNum"":""$LogicalProcessorCount"",""memorySizeTotal"":""$MemTotal""},""cpu"":["
$count=0
foreach ($CPU in $CPUInfo)
{
    $CPUName = $CPU.Name
    $DeviceID = $CPU.DeviceID
    $RESULT=$RESULT+"{""cpuName"":""$CPUName"",""deviceID"":""$DeviceID""}"
    $count++
    if($count -lt $PhysicalProcessorCount)
    {
        $RESULT=$RESULT+","
    }
    elseif($count -eq $PhysicalProcessorCount)
    {
        $RESULT=$RESULT+"],""physicalDisk"":["
    }
}
$count=0
foreach ($Disk in $PhysicalDiskInfo)
{
    $SerialNumber = $Disk.SerialNumber
    $DeviceID = $Disk.DeviceID.Remove(0,4)
    $DiskSize = "{0:N2}GB" -f ($Disk.Size/1GB)
    $RESULT=$RESULT+"{""serialNumber"":""$SerialNumber"",""deviceID"":""$DeviceID"",""diskSize"":""$DiskSize""}"
    $count++
    if($count -lt $PhysicalDiskCount)
    {
        $RESULT=$RESULT+","
    }
    elseif($count -eq $PhysicalDiskCount)
    {
        $RESULT=$RESULT+"],""logicalDisk"":["
    }
}
$count=0
foreach ($Disk in $LogicalDiskInfo)
{
    $SerialNumber = $Disk.VolumeSerialNumber
    $DeviceID = $Disk.DeviceID
    $DiskSize = "{0:N2}GB" -f ($Disk.Size/1GB)
    $DiskFreeSpace = "{0:N2}GB" -f ($Disk.FreeSpace/1GB)
    $RESULT=$RESULT+"{""deviceID"":""$DeviceID"",""volumeSerialNumber"":""$SerialNumber"",""diskSize"":""$DiskSize"",""diskFreeSpace"":""$DiskFreeSpace""}"
    $count++
    if($count -lt $LogicalDiskCount)
    {
        $RESULT=$RESULT+","
    }
    elseif($count -eq $LogicalDiskCount)
    {
        $RESULT=$RESULT+"]}}"
    }
}
echo $RESULT
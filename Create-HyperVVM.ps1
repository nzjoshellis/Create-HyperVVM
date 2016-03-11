################################################################
# SCRIPT: Create-HyperVVM
# AUTHOR: Josh Ellis - Josh@JoshEllis.NZ
# Website: JoshEllis.NZ
# VERSION: 1.0
# DATE: 12/03/2016
# DESCRIPTION: Creates a new Hyper-V VM and sets the Boot DVD
################################################################

[CmdletBinding()]
Param(
[Parameter(Mandatory=$True,Position=1)]
[string]$VMName
     )

$CPU = 2
$RAM = 4GB
$VHDSize = 40GB
$VHDPath = ("C:\HyperV\Disks\"+"$VMName"+"\$VMName-OS.vhdx")
$VMPath = "C:\HyperV\Config\"
$Switch = "Private-LAN"
$VMGeneration = 2
$AutomaticStartAction = "Nothing" #Nothing,StartifRunning,Start
$AutomaticStopAction = "ShutDown" #TurnOff,Save,Shutdown
$BootISO = "E:\Microsoft Images\Windows Server 2016\en_windows_server_2016_technical_preview_3_x64_dvd_6942082.iso"

#Create VM
New-VM -ComputerName $Env:Computername -Name $VMName -MemoryStartupBytes $Ram -SwitchName $Switch -NewVHDPath $VHDPath -NewVHDSizeBytes $VHDSize -Path $VMPath -Generation $VMGeneration

#Set CPU and Memory
Set-VM -Name $VMName -ProcessorCount $CPU -DynamicMemory -MemoryMaximumBytes $Ram -MemoryMinimumBytes 1GB

#Set Start and Stop Action
Set-VM -Name $VMName -AutomaticStartAction $AutomaticStartAction -AutomaticStopAction $AutomaticStopAction

#Set Boot ISO
Add-VMDvdDrive -VMName $VMName -Path $BootISO

#Set Boot Order
$BootDVD = Get-VMDvdDrive -VMName $VMName
$BootVHD = Get-VMHardDiskDrive -VMName $VMName
Set-VMFirmware -VMName $VMName -BootOrder $BootVHD,$BootDVD 

#Start VM
Start-VM $VMName
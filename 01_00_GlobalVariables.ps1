$AzureSub = "43434f70-04343-43432-807d-4343ewrwer34"
$RG = 'RG-STRETCH'
$Region = 'eastus'  # works only on eastus 
$sqlservername = 'stretchserver'
$sqladminusername = 'stretchadmin'
$sqladminpassword = 'StrongPassword123@'
$firewallName = "HopeFW"
$OnPremServer = 'localhost'
$SQLServerservice = 'SQL Server (MSSQLSERVER)'
$MyLocalDesktop = $env:COMPUTERNAME
set-location C:\Ravi\Languages\Demo\StretchDB\

Function Get-PublicIP { 
 (Invoke-WebRequest http://ifconfig.me/ip ).Content
}
$StartIP = (Get-PublicIP).split('.')
$StartIP[-1] = 0
$StartIP = $StartIP -join '.'

$EndIP = (Get-PublicIP).split('.')
$EndIP[-1] = 255
$EndIP = $EndIP -join '.'

function Test-Administrator {  
 $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

clear-host 

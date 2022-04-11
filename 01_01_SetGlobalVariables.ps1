# ensure global variables have been set 
#region 
set-location C:\Ravi\Languages\Demo\StretchDB\
. C:\Ravi\Languages\Demo\StretchDB\01_00_GlobalVariables.ps1
clear-host 
if ($sqlservername.length -gt 0) {    
    Write-Host 'Global variables have been set.' -ForegroundColor Green
}
#endregion 

# ensure ADS is in admin mode 
#region 
# usually placing '#Requires -RunAsAdministrator' at the top of the script should suffice 
# however in my case F5 doesn't work in ADS 
# '#Requires -RunAsAdministrator' is only for F5, not for F8! 

if (!(Test-Administrator)){
  Write-warning "You need admin mode to run these scripts!" 
  return 0 
}

#endregion 

# start local SQL Server service 
#region 
$status = (get-service -Name $SQLServerservice).status 
if ($status -ne 'Running') {
    (get-service -Name $SQLServerservice).Start()
    Write-Host "Starting service [$SQLServerservice]..." -ForegroundColor Green
    Start-Sleep -Seconds 5 
    $status = (get-service -Name $SQLServerservice).status 
    if ($status -eq 'Running') {
      Write-Host "Successfully started local SQL Server service" -ForegroundColor Green
    } else {
      Write-warning "Failed to start local SQL Server service!"
    }
} else {
  Write-Host "No need to start the local SQL Server service. It is already running!" -ForegroundColor Green
}
#endregion 





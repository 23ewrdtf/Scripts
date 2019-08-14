#Retrieve list of computer names from a text file
$computers = Get-Content C:\computers.txt

#Loop through list to start the agent on each
foreach ($comp in $computers) {
    #Retrieve the service and its properties for each computer
    try { $service = Get-Service -ComputerName $comp -Name <servicename> -ErrorAction Stop }
    catch { Write-Host "Service does not appear to be installed in this device $comp" -ForegroundColor Red; }
    Write-Host "Service status is $($service.status) on $comp"

    #If status is Stopped, just start it.
    if ($service.Status -eq 'Stopped') {
        Set-Service -Name <servicename> -ComputerName $comp -Status Running
        Write-Host "Service started from Stopped state on $comp" -ForegroundColor Green
    } 
 
    #If status is StopPending, stop the service then start service
    elseif ($service.Status -eq 'StopPending') {
        Get-Process -Name <servicename> -ComputerName $comp | Stop-Process -Force
        Start-Sleep 5
        Set-Service -Name <servicename> -ComputerName $comp -Status Running
        Write-Host "Service started from Stopping state on $comp" -ForegroundColor Green
    }
    #Otherwise service is either Running or Starting
    else { Write-Host "Service is not in a Stopped state on $comp" -ForegroundColor Yellow }
}

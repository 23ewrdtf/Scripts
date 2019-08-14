$Computers = Get-Content "C:\computerlist.txt"
$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
$Property = "FeatureSettingsOverride"
$Value = "0"

$results = foreach ($computer in $Computers)
{
    If (test-connection -ComputerName $computer -Count 1 -Quiet)
    {
        Try {
            Invoke-Command -ComputerName $Computers -ScriptBlock {Set-ItemProperty -Path $path -Name $Property -Value $Value -ErrorAction 'Stop'}
            $status = "Success"
        } Catch {
            $status = "Failed"
        }
    }
    else
    {   
        $status = "Unreachable"
    }
    
    New-Object -TypeName PSObject -Property @{
        'Computer'=$computer
        'Status'=$status
    }
}

$results |
Export-Csv -NoTypeInformation -Path "./out.csv"

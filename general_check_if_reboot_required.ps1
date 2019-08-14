# Check if Reboot is required
# First way

$systemInfo = New-Object -ComObject "Microsoft.Update.SystemInfo"

if ( $systemInfo.RebootRequired ) {
    #Device requires reboot
    return $true
} else {
    #Device does not require reboot
    return $false
}

$systemInfo


# Another Way

(New-Object -ComObject "Microsoft.Update.SystemInfo")


# Another way

Function Test-WUARebootRequired {
    try {
        (New-Object -ComObject "Microsoft.Update.SystemInfo").RebootRequired
    } catch {
        Write-Warning -Message "Failed to query COM object because $($_.Exception.Message)"
    }
}
Test-WUARebootRequired

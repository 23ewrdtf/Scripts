$systemInfo = New-Object -ComObject "Microsoft.Update.SystemInfo"

if ( $systemInfo.RebootRequired ) {
    #Device requires reboot
    return $true
} else {
    #Device does not require reboot
    return $false
}

$systemInfo

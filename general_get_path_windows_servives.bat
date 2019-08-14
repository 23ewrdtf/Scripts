gwmi win32_service | % { if ($_.pathname -match 'system32|c:\\windows\\system32\\TrustedInstaller|SysWow64') { Write-Output "$($_.Name) : $($_.pathname)" } }

$filename = "\windows\system32\ntoskrnl.exe" 
 
$obj = New-Object System.Collections.ArrayList 
 
$computernames = Get-Content C:\Users\<USER>\list_of_computers.txt
foreach ($server in $computernames) 
{ 
$filepath = Test-Path "\\$server\c$\$filename" 
 
if ($filepath -eq "True") { 
$file = Get-Item "\\$server\c$\$filename" 
 
     
        $obj += New-Object psObject -Property @{'Computer'=$server;'FileVersion'=$file.VersionInfo|Select FileVersion;'LastAccessTime'=$file.LastWriteTime} 
        } 
     } 
     
$obj | select computer, FileVersion, lastaccesstime | Export-Csv -Path 'C:\Users\<USER>\results.txt' -NoTypeInformation 

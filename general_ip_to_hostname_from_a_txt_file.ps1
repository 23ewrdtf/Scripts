Get-Content C:\Users\admin\Downloads\computers.txt | ForEach-Object {([system.net.dns]::GetHostByAddress($_)).hostname >> C:\Users\admin\Downloads\results.txt}

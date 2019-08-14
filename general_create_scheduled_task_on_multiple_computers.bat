PsExec.exe @computers.txt schtasks.exe /create /RU <USERNAME> /RP <PASSWORD> /TN Reboot /SD 19/09/2018 /ST 03:00 /SC ONCE /TR "shutdown -r -f -t 5"

# Scripts
Good or Bad scripts, they help me to achieve some bits.

Originally from: https://github.com/tretos53/notes/tree/master/Scripting


### bitbucket_backup.py

Python Script - bitbucket_backup.py. This script downlaods list of repos from bitbucket and git clone them or pull them.
It needs a lot of improvments especially when handling username and apppassword and logs and at some point move to functions.

### compare_tag_string.sh

Nagios Plugin Bash Script. This script checks if two strings from two different files in two different repos are the same. Helps to check if prod and dev yaml tag files are the same, especially if deployed by helm. It needs a lot of improvments especially when handling username and apppassword

### k8_monitor_nodes.sh

Monitor overall Kubernetes cluster utilization and capacity.

It displays: node name, %CPU, %RAM, Taints, Created Date/Time, Kubelet Version, No of running pods.

Average %CPU, %RAM, No of NOT running pods.

### automox_get_servers.ps1

Download info about servers from Automox and save to csv

### general_start_service.ps1

Loop through list of computers to start a specified servicename on each.

### general_check_file_version.ps1

Remotely check the file version for multiple servers from a file and send to a file.
Source: https://gallery.technet.microsoft.com/scriptcenter/Get-file-version-on-Remote-8835bfe8

### general_check_os_version.ps1

Remotely check the OS version and other details. Run in PowerShell ISE. It's slow.
Source: https://gallery.technet.microsoft.com/scriptcenter/PowerShell-System-571521d1

### general_set_registry_key.ps1

Set registry keys remotely. It might not work due to Trusted Hosts. Try general_set_registry_key.bat
Source https://community.spiceworks.com/topic/614948-script-to-modify-registry-value-on-multiple-computers

### general_ip_to_hostname_from_a_txt_file.ps1

IP to Hostname from a txt file

### general_ip_to_hostname_from_a_txt_file.ps1

Another way from https://blogs.technet.microsoft.com/gary/2009/08/28/resolve-ip-addresses-to-hostname-using-powershell/

### general_create_scheduled_task_on_multiple_computers.bat

Create a scheduled task on multiple servers using PsExec. Specify a user to run the task as that user.

### general_check_if_reboot_required.ps1

Check if Reboot is required. A few ways.

### general_get_path_windows_servives.ps1

Get path for all windows services

### generate_changelog.sh and generate_changelog2.sh

Generates changelog from commits


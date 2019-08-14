# Python Script - bitbucket_backup.py
# This script downlaods list of repos from bitbucket and git clone them or pull them.
# It needs a lot of improvments especially when handling username and apppassword and logs.
###################
# Replace ALL <> !#
###################


import os
import datetime
import tarfile
import time
from datetime import datetime
import shutil
import pdb

print("")
print("******************************************")
print("* Downloading list of repos...")
print("******************************************")
print("")
#pdb.set_trace()


result1 = os.popen("curl -s -S --user <app_username>:<app_password> https://bitbucket.org/api/2.0/user/permissions/repositories?pagelen=100 | jq '.values[].repository.name' | sed 's/\"//g'").read()
result2 = os.popen("curl -s -S --user <app_username>:<app_password> https://bitbucket.org/api/2.0/user/permissions/repositories?pagelen=100\&page=2 | jq '.values[].repository.name' | sed 's/\"//g'").read()
result3 = os.popen("curl -s -S --user <app_username>:<app_password> https://bitbucket.org/api/2.0/user/permissions/repositories?pagelen=100\&page=3 | jq '.values[].repository.name' | sed 's/\"//g'").read()
result4 = os.popen("curl -s -S --user <app_username>:<app_password> https://bitbucket.org/api/2.0/user/permissions/repositories?pagelen=100\&page=4 | jq '.values[].repository.name' | sed 's/\"//g'").read()

result = result1+result2+result3+result4

backupdir = "/backups/bitbucket/"
repo_url = "https://bitbucket.org/<organisation>/temp.git" #set var to something, it will be changed later.
now = datetime.now() # current date and time
date_time = now.strftime("%m_%d_%Y_%H_%M_%S")
date_only = now.strftime("%m_%d_%Y")

logfile = open("/backups/bitbucket/{}.txt".format(date_time), "a")

os.system("export GIT_MERGE_AUTOEDIT=no")
os.system("git config --global core.mergeoptions --no-edit")

print("")
print("******************************************")
print("Current date and time")
print(date_time)
print("******************************************")
print("")

for repo in result.split('\n'):
    repo = repo.strip('\r')
    backupdir = "/backups/bitbucket/{}".format(repo)
#    print(date_time)
#    pdb.set_trace()
    if not os.path.isdir(backupdir):

        repo_url = "https://<app_username>:<app_password>@bitbucket.org/<organisation>/{}.git".format(repo) 
        backupdir = "/backups/bitbucket/{}".format(repo)

        logfile.write("{} {} cloning started.\n".format(date_time,repo))

        print("")
        print("******************************************")
        print("* Cloning {}...".format(repo))
        print("******************************************")
        print("")
        os.system("git clone --progress {} {}".format(repo_url,backupdir))

        logfile.write("{} {} cloned.\n".format(date_time,repo))

        print("")
        print("******************************************")
        print("* Waiting 5s to give BitBucket a break...")
        print("******************************************")
        print("")
        time.sleep(5)

    else:

        repo_url = "https://<app_username>:<app_password>@bitbucket.org/<organisation>/{}.git".format(repo) 
        backupdir = "/backups/bitbucket/{}".format(repo)

        print("")
        print("******************************************")
        print("* {} already cloned, pulling.".format(repo))
        print("******************************************")
        print("")

        logfile.write("{} {} already cloned, pulling.\n".format(date_time,repo))

        os.system("git -C {} pull".format(backupdir))
        logfile.write("{} {} pulled.\n".format(date_time,repo))

        print("")
        print("******************************************")
        print("* Waiting 5s to give BitBucket a break...")
        print("******************************************")
        print("")
        time.sleep(5)

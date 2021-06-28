# This script assumes /backups/gitlab/groupname folder for backups and jq installed using snap. Adjust for other systems. Adjust --git-dir too.

# Create an app token in Gitlab with read only access to API and Repos.

# Create a file called /backups/gitlab_secret.txt with below code:

#!/bin/bash

GITLAB_TOKEN=<created earlier token>

# Create a file called /backup/gitlab_backup.sh with below code

#!/bin/bash

source /backups/gitlab_secret.txt

now=$(date "+%m-%d-%Y-%T")

echo "┌─────────────────────────────────────────"
echo "│Current date $now"
echo "└─────────────────────────────────────────"

# Adjust that part. It depends how many repos in a group you have as API is limited to 100 per page. Replace <GROUP ID> with the ID of your group.
curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://gitlab.com/api/v4/groups/<GROUP ID>/projects?include_subgroups=true&per_page=100&page=1" | /snap/bin/jq --compact-output --raw-output '.[] | {"name":.path,"url":.ssh_url_to_repo}' >> repos.json
curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "https://gitlab.com/api/v4/groups/<GROUP ID>/projects?include_subgroups=true&per_page=100&page=2" | /snap/bin/jq --compact-output --raw-output '.[] | {"name":.path,"url":.ssh_url_to_repo}' >> repos.json

# This one shows how many repos.
wc -l repos.json

# If you want to remove some repos, like personal ones, use this and replace XXX with lines you want to remove:
# sed -i '/XXXX/d' repos.json

        echo "┌─────────────────────────────────────────"
        echo "│Cloning repo group"
        echo "└─────────────────────────────────────────"

while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    name=$(echo "${LINE}" | /snap/bin/jq -r '.name')
    url=$(echo "${LINE}" | /snap/bin/jq -r '.url')
        echo "┌─────────────────────────────────────────"
        echo "│Repo name $name ($url)"
    if [[ -d "/backups/gitlab/groupname/${name}" ]]; then
        echo "│Repo already cloned, pulling..."
        echo "└─────────────────────────────────────────"
        git --git-dir="/backups/gitlab/groupname/${name}/.git" pull ${url}
    else
        echo "│Repo not cloned, cloning..."
        echo "└─────────────────────────────────────────"
        git clone ${url} /backups/gitlab/groupname/${name}
    fi
    echo ""
done <  repos.json

rm repos.json

# Adjust below
curl -s -X POST --data-urlencode "payload={\"channel\": \"#gitlab_backup\", \"username\": \"Gitlab Backup\", \"text\": \"Gitlab Group Backup Complete.\", \"icon_emoji\": \":female-technologist:\",}" https://hooks.slack.com/services/xxx/xxx/xxx

# Add below to crontab -e

# At 01:00 on Sunday.
0 1 * * 0 bash /backups/gitlab_backup.sh >> /backups/log_gitlab_cron_`date +\%Y-\%m-\%d_\%H:\%M:\%S`.log 2>&1

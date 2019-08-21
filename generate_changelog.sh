#!/usr/bin/env bash
# Generate a new changelog from commits.
# Copied from https://github.com/helm/charts/pull/16444 might be useful for future.

git log --abbrev-commit --pretty=oneline stable/jenkins/ | while read line ;
do
  read -r commit message <<< "$line"
  version=$(git show $commit:stable/jenkins/Chart.yaml|grep "version:"|sed 's/version: //')
  printf "| %6s | %s | %s |\n" $version $commit "$message"
done

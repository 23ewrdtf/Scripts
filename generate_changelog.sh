#!/usr/bin/env bash
# Generate a new changelog from commits.
# Copied from https://github.com/helm/charts/pull/16444 might be useful for future.

git log --abbrev-commit --pretty=oneline stable/sumologic-fluentd/ | while read line ;
do
  read -r commit message <<< "$line"
  version=$(git show $commit:stable/sumologic-fluentd/Chart.yaml|grep "version:"|sed 's/version: //')
  printf "##  %6s\n\n%s\ncommit: %s \n\n" $version "$message" $commit
done

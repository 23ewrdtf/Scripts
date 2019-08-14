#!/bin/bash
#
# Monitor overall Kubernetes cluster utilization and capacity.
#
# Original source:
# https://github.com/kubernetes/kubernetes/issues/17512#issuecomment-367212930
#
# Tested with:
#   - AWS EKS v1.11.5
#
# Does not require any other dependencies to be installed in the cluster.

set -e

KUBECTL="kubectl"
NODES=$($KUBECTL get nodes --no-headers -o custom-columns=NAME:.metadata.name)

function usage() {
  local node_count=0
  local total_percent_cpu=0
  local total_percent_mem=0
  local readonly nodes=$@
  local CreationTimestamp=0
  local Taint=0
  local kubelet_version=0
  local number_of_pods=0
  local number_of_non_running_pods=0

  for n in $nodes; do
    local requests=$($KUBECTL describe node $n | grep -A3 -E "\\s\sRequests" | tail -n2)
    local percent_cpu=$(echo $requests | awk -F "[()%]" '{print $2}')
    local percent_mem=$(echo $requests | awk -F "[()%]" '{print $8}')
    local CreationTimestamp=$(KUBECTL describe node $n | grep CreationTimestamp | tr -s [:space:] | sed -e 's/CreationTimestamp/Created/')
    local Taint=$(KUBECTL describe node $n | grep Taint | tr -s [:space:] | cut -f1 -d"=")
    local kubelet_version=$(KUBECTL describe node $n | grep "Kubelet Version" | tr -s [:space:])
    local number_of_pods=$(KUBECTL get pods --all-namespaces -o wide | grep $n -c)
    local number_of_non_running_pods=$(KUBECTL get pods --all-namespaces | grep -v Run -c)
    local number_of_non_running_pods=$((number_of_non_running_pods - 1))
    echo "$n: | ${percent_cpu}% CPU | ${percent_mem}% memory | ${Taint} | ${CreationTimestamp} | ${kubelet_version} | No of Pods:${number_of_pods}"

    node_count=$((node_count + 1))
    total_percent_cpu=$((total_percent_cpu + percent_cpu))
    total_percent_mem=$((total_percent_mem + percent_mem))
    
  done

  local readonly avg_percent_cpu=$((total_percent_cpu / node_count))
  local readonly avg_percent_mem=$((total_percent_mem / node_count))

  echo "Average usage: ${avg_percent_cpu}% CPU, ${avg_percent_mem}% memory, Pods NOT Running:${number_of_non_running_pods}"
}

usage $NODES

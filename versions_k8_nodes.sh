#!/bin/bash
#
# Show versions of k8, addons and worker nodes.
#
# Original source:
# https://github.com/kubernetes/kubernetes/issues/17512#issuecomment-367212930
#
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
    local CreationTimestamp=$(KUBECTL describe node $n | grep CreationTimestamp | tr -s [:space:] | sed -e 's/CreationTimestamp/Created/')
    local kubeproxyversion=$(KUBECTL describe node $n | grep Kube-Proxy | tr -s [:space:])
    local Taint=$(KUBECTL describe node $n | grep Taint | tr -s [:space:] | cut -f1 -d"=")
    local kubelet_version=$(KUBECTL describe node $n | grep "Kubelet Version" | tr -s [:space:])

    echo "$n: | ${Taint} | ${CreationTimestamp} | ${kubelet_version} | ${kubeproxyversion}"
    
  done
  
  # Versions
  local k8_version=$(KUBECTL version --short | grep "Server Version" | tr -s [:space:])
  local coredns_version=$(KUBECTL describe deployment coredns --namespace kube-system | grep Image | cut -d "/" -f 3)
  local CNI_version=$(KUBECTL describe daemonset aws-node --namespace kube-system | grep Image | cut -d "/" -f 2)

  echo ""
  echo "k8:${k8_version}"
  echo "${coredns_version}"
  echo "CNI:${CNI_version}"
}

usage $NODES

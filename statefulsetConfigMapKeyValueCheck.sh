#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: bash script_name deployment_or_statefulset_name search_key namespace"
    exit 1
fi

# Get the StatefulSet Name
statefulset_name="$1"
echo "StatefulSet Name: $statefulset_name"

# Key that needs to be searched
key="$2"
echo "ConfigMap Key: $key"

# Namespace
namespace="$3"
echo "Namespace: $namespace"

# Extract the name of the Pods from the Workload
pods_name=$(kubectl get pods -n $namespace -o custom-columns="Name:.metadata.name,OwnerReferenceKind:.metadata.ownerReferences[0].kind" | grep $statefulset_name | cut -f1 -d ' ' )

if [ -z "$pods_name" ]; then
    echo "No pods found for $statefulset_name in namespace $namespace."
    exit 1
fi

echo "----------------------- Fetching ConfigMap Key Value from Pods -----------------------"

for pod in $pods_name
do
    value=$(kubectl exec -it "$pod" -n "$namespace" -- env | grep "$key")
    echo "$pod - $value"
done

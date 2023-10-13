#!/bin/bash

# Check if the number of arguments is less than 3
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <deployment_name> <key> <namespace>"
    exit 1
fi

# Get the Deployment Name
deployment_name="$1"
echo "Deployment Name: $deployment_name"

# Key that needs to be searched
key="$2"
echo "ConfigMap Key: $key"

# Namespace
namespace=$3
echo "Namespace: $namespace"

# Container Name
container_name=$deployment_name
echo "Container Name: $container_name"

# Extract Latest ReplicaSet Name
replicaSet_name=$(kubectl get deploy $deployment_name -o jsonpath='{.status.conditions[*].message}' -n $namespace | grep -o '".*"' | sed 's/"//g')
echo "ReplicaSet Name: $replicaSet_name"

# Extract all Pods Name of Latest ReplicaSet
pods_name=$(kubectl get pods -o=custom-columns="Name":".metadata.name","OwnerReferenceKind":".metadata.ownerReferences[0].kind","OwnerReferenceName":".metadata.ownerReferences[0].name" -n $namespace | grep $replicaSet_name | cut -f1 -d ' ')
# echo -e "Pods Name:\n$pods_name"

echo "----------------------- Fetching ConfigMap Key Value from Pods -----------------------"

for pod in $pods_name
do 
    value=$(kubectl exec -it $pod -c $container_name -n $namespace -- env | grep $key)
    echo "$pod - $value"
done

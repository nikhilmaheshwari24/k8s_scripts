#!/bin/bash

# Create or clear the CSV file
`> deploymentPodRunningOnSameNode.csv`

# Add header to the CSV file
echo "Namespace,DeploymentName,NodeName" >> deploymentPodRunningOnSameNode.csv

# Declare an array
declare -a namespaces

# Assign output to the array
read -a namespaces < <(kubectl get namespaces -o=jsonpath='{.items[*].metadata.name}{" "}') # The "< <()" construction is used in Bash to redirect the output of a command into a loop or read it line by line and then assign it to a variable or an array.

# # Custom List of namespaces
# namespaces=(ABC DEF GHI JKL MNO PQRS TUV WXYZ)

# Loop through each namespace
for namespace in "${namespaces[@]}"
do
    echo "Namespace: $namespace"

    # Get all deployment names
    deployments=$(kubectl get deployment -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' -n "$namespace")

    # Loop through each deployment
    for deployment_name in $deployments
    do
        node_list=()

        # echo "Deployment: ${deployment_name}"

        # Extract Latest ReplicaSet Name
        replicaSet_name=$(kubectl get deploy "$deployment_name" -o jsonpath='{.status.conditions[*].message}' -n "$namespace" | grep -o '".*"' | sed 's/"//g')

        # Extract the number of replicas of the deployment
        replicas=$(kubectl get deployment "$deployment_name" -o jsonpath='{.spec.replicas}' -n "$namespace")

        # Extract all Pods Name of Latest ReplicaSet
        pods=$(kubectl get pods -o=custom-columns="Name":".metadata.name","OwnerReferenceKind":".metadata.ownerReferences[0].kind","OwnerReferenceName":".metadata.ownerReferences[0].name" -n "$namespace" | grep "$replicaSet_name" | cut -f1 -d ' ')

        # Check if the deployment has more than one replica and process pods accordingly
        if [ "$replicas" -gt 0 ]
        then
            if [ "$replicas" -gt 1 ]
            then
                # Loop through each pod
                for pod in $pods
                do 
                    nodeName=$(kubectl get pod "$pod" -o jsonpath='{.spec.nodeName}' -n "$namespace")

                    # Check if a node has more than one pod scheduled
                    if [[ " ${node_list[@]} " =~ " ${nodeName} " ]]
                    then
                        echo "$namespace,$deployment_name" >> deploymentPodRunningOnSameNode.csv
                        break
                    else 
                        node_list+=("$nodeName")
                    fi
                done
            else
                continue # If the replica is 1, move to the next deployment
            fi
        fi
    done
done

#!/bin/bash

# Create or clear the CSV file
`> deploymentContainerCommandOutput.csv`

# Add header to the CSV file
echo "Namespace,DeploymentName,CurrentReplicaSet,PodName,AllContainers,ContainerName,Command Output - env | grep OTEL_JAR_FILE" >> deploymentContainerCommandOutput.csv

# Declare an array
declare -a namespaces

# Assign output to the array
read -a namespaces < <(kubectl get namespaces -o=jsonpath='{.items[*].metadata.name}{" "}') # The "< <()" construction is used in Bash to redirect the output of a command into a loop or read it line by line and then assign it to a variable or an array.

# Custom List of namespaces
# namespaces=(ABC DEF GHI JKL MNO PQRS TUV WXYZ) # Add your desired namespaces here

for namespace in ${namespaces[@]}
do

    echo "Namespace: $namespace"

    # Get all deployment names
    deployments=$(kubectl get deployments -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' -n $namespace)

    # Loop through each deployment
    for deployment_name in $deployments
    do
        # echo -en "\nDeployment Name: $deployment_name\n"
        
        # Extract Latest ReplicaSet Name
        replicaSet_name=$(kubectl get deploy $deployment_name -o jsonpath='{.status.conditions[*].message}' -n $namespace | grep -o '".*"' | sed 's/"//g')

        # echo -en "ReplicaSet Name: $replicaSet_name\n"

        # Get the number of replicas
        replicas=$(kubectl get deployment $deployment_name -o=jsonpath='{.spec.replicas}' -n $namespace)

        # Extract all Pods Name of Latest ReplicaSet
        pods=$(kubectl get pods -o=custom-columns="Name":".metadata.name","OwnerReferenceKind":".metadata.ownerReferences[0].kind","OwnerReferenceName":".metadata.ownerReferences[0].name" -n $namespace | grep $replicaSet_name | cut -f1 -d ' ')

        # echo -en "Pods:\n$pods"

        # If at least one replica exists
        if [ "$replicas" -gt 0 ]; then
            # Get the list of containers in the pod, handling the error if no pods are found

            for pod in $pods
            do 
                containers=$(kubectl get pod $pod -o=custom-columns="Name":".metadata.name","OwnerReferenceKind":".metadata.ownerReferences[0].kind","OwnerReferenceName":".metadata.ownerReferences[0].name,ContainerName:.spec.containers[*].name" -n $namespace | grep $replicaSet_name | awk '{print $4}' | tr ',' ' ')
                
                # echo -en "\nContainers: $containers"

                # Check if containers are found
                if [ -n "$containers" ]; then
                    # Loop through each container
                    for container in $containers
                    do

                        # Skip specific sidecar containers
                        if [[ "$container" != "A" && "$container" != "B" && "$container" != "C" ]]; 
                        then
                            # echo -en "\nFor container: $container"=
                            # Replace the following command with the desired command to execute
                            echo -e " -- kubectl exec $pod -c $container -n $namespace -- env | grep OTEL_JAR_FILE | cut -f2 -d '='"

                            cmd_output=$(kubectl exec $pod -c $container -n $namespace -- env | grep OTEL_JAR_FILE | cut -f2 -d '=')

                            echo -e "$namespace,$deployment_name,$replicaSet_name,$pod,$container,$cmd_output\n"

                            echo -en "$namespace,$deployment_name,$replicaSet_name,$pod,$containers,$container,$cmd_output\n" >> deploymentContainerCommandOutput.csv


                        fi
                    done
                else
                    echo -en "\nNo containers found"
                fi
            done
        else
            echo -en "\nNo replicas found"
        fi
    done
done

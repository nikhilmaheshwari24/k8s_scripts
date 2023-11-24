#!/bin/bash

# Empty file
`> pod_container_op.csv`

# List of namespaces
namespaces=(acropolis aether aphrodite-centre-module argo-rollouts aries athena aura auraapps auth-centre-module cipher control-centre-module eod-center-webapp extensions finance-center-webapp garnet gwathena-resources kubecost luminosrewards notification oms-canary operations-center-app-module operations-management orchestra perseus photonorcus product-centre-module rhea ruby sentor statement support-centre-module tenxp-test-module tethys-resources uszsrecommons weavetest zeus) # Add your desired namespaces here

for namespace in ${namespaces[@]}
do

    # echo -n "Namespace: $namespace"

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
                            echo -e "-- kubectl exec $pod -c $container -n $namespace -- env | grep OTEL_JAR_FILE | cut -f2 -d '='"

                            cmd_output=$(kubectl exec $pod -c $container -n $namespace -- env | grep OTEL_JAR_FILE | cut -f2 -d '=')

                            echo -e "$namespace,$deployment_name,$replicaSet_name,$pod,$container,$cmd_output"

                            echo -en "$namespace,$deployment_name,$replicaSet_name,$pod,$container,$cmd_output\n" >> pod_container_op.csv

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

#!/bin/bash

# Get all deployment names
deployments=$(kubectl get deployments -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

# Loop through each deployment
for deployment in $deployments
do
    # Get the number of replicas
    replicas=$(kubectl get deployment "$deployment" -o=jsonpath='{.spec.replicas}')

    # If at least one replica exists
    if [ "$replicas" -gt 0 ]; then
        echo -n "$deployment -- "
        # Replace the following command with the desired command to execute
        kubectl exec $(kubectl get pods -l app=$deployment -o=jsonpath='{.items[0].metadata.name}') -- YOUR_COMMAND_HERE
    fi
done

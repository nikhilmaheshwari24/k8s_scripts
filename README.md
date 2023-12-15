# k8s_scripts
Scripts related to Kubernetes

## deploymentPodRunningOnSameNode.sh

 *[deploymentPodRunningOnSameNode]* iterates through all deployments in specified namespaces and identifies situations where multiple pods from the same deployment are scheduled on the same node. When the number of replicas for a deployment is greater than 1, it checks if any of the pods within that deployment share a node. If so, it logs the Namespace and DeploymentName into a CSV file named **deploymentPodRunningOnSameNode.csv**.


[deploymentPodRunningOnSameNode]: https://github.com/nikhilmaheshwari24/k8s_scripts/blob/master/deploymentPodRunningOnSameNode.sh
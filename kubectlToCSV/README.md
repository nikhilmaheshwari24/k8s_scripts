# Kubectl To CSV

### To get the list of all pods with all the images that are being used

```bash
kubectl get pod -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,Images:.spec.containers[*].image" -A | tr -s ' ' | sed 's/,/;/g' | tr ' ' ',' > pod_images.csv 
```

### To get the list of apiVersion of all resources for the kubernetes object

```bash
kubectl get <object> -o custom-columns="Namespace:.metadata.namespace,ApiVersion:.apiVersion,Kind:.kind,Name:.metadata.name" -A | tr -s ' ' | tr ' ' ',' > apiVersion.csv
```

### To get the list of nodes for all pods
```bash
kubectl get pods -o=custom-columns="Namespace":".metadata.namespace","Name":".metadata.name","Node":".spec.nodeName" -A | tr -s ' ' | tr ' ' ',' > pod_node.csv
```

### To get the list of the ingress with associated services and ingressClassName

```bash
kubectl get ingress -o custom-columns="Namespace:.metadata.namespace,IngressName:.metadata.name,IngressClassName:.spec.ingressClassName,Associated Services:.spec.rules[*].http.paths[*].backend.service.name" | tr -s ' ' | sed 's/,/;/g' | tr ' ' ',' > ingress_svc.csv
```

### To get the list of container names associated with a pod

```bash
kubectl get pods -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,ContainersName:.spec.containers[*].name" -A | tr -s ' ' | tr ',' ';' | tr ' ' ',' | tr ';' ' ' > pod_containers.csv
```

### To get the list of all containers and images for a pod with their owner

```bash
kubectl get po -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,OwnerReferenceKind:.metadata.ownerReferences[0].kind,ContainersNames:.spec.containers[*].name,ContainersImages:.spec.containers[*].image" -A | tr -s ' ' | tr ',' ';' | tr ' ' ',' | tr ';' ' ' > pod_owner_container_images.csv
```

### To get the requiredDuringSchedulingIgnoredDuringExecution affinity for deployment
```bash
kubectl get deployment -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,requiredDuringSchedulingIgnoredDuringExecutionKeys:.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].key,requiredDuringSchedulingIgnoredDuringExecutionOperator:.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].operator,requiredDuringSchedulingIgnoredDuringExecutionValues:.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].values" -A | tr -s ' ' | tr ',' ';' | tr ' ' ',' | tr ';' ' ' > deployment_affinity.csv
```

### To get the preferredDuringSchedulingIgnoredDuringExecution affinity for deployment
```bash
kubectl get deployment -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,preferredDuringSchedulingIgnoredDuringExecutionKeys:.spec.template.spec.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].key,preferredDuringSchedulingIgnoredDuringExecutionOperator:.spec.template.spec.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].operator,preferredDuringSchedulingIgnoredDuringExecutionValues:.spec.template.spec.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].values" -A | tr -s ' ' | tr ',' ';' | tr ' ' ',' | tr ';' ' ' > deployment_affinity.csv
```

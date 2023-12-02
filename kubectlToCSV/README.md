# Kubectl To CSV

### images associated with pods
```bash
kubectl get pod -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,Images:.spec.containers[*].image" -A | tr -s ' ' | sed 's/,/;/g' | tr ' ' ',' > pod_images.csv 
```

### apiVersions of all resources for a kubernetes object

```bash
kubectl get <object> -o custom-columns="Namespace:.metadata.namespace,ApiVersion:.apiVersion,Kind:.kind,Name:.metadata.name" -A | tr -s ' ' | tr ' ' ',' > apiVersion.csv
```

### pods with the scheduled nodeName
```bash
kubectl get pods -o=custom-columns="Namespace":.metadata.namespace,Name:.metadata.name,Node:.spec.nodeName -A | tr -s ' ' | tr ' ' ',' > pod_node.csv
```

### ingresses with associated services and ingressClassName

```bash
kubectl get ingress -o custom-columns="Namespace:.metadata.namespace,IngressName:.metadata.name,IngressClassName:.spec.ingressClassName,Associated Services:.spec.rules[*].http.paths[*].backend.service.name" | tr -s ' ' | sed 's/,/;/g' | tr ' ' ',' > ingress_svc.csv
```

### containers for all pods

```bash
kubectl get pod -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,ContainersName:.spec.containers[*].name" -A | tr -s ' ' | tr ',' ';' | tr ' ' ',' | tr ';' ' ' > pod_containers.csv
```

### containers and images for all pods with their owner

```bash
kubectl get pod -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,OwnerReferenceKind:.metadata.ownerReferences[0].kind,ContainersNames:.spec.containers[*].name,ContainersImages:.spec.containers[*].image" -A | tr -s ' ' | tr ',' ';' | tr ' ' ',' | tr ';' ' ' > pod_owner_container_images.csv
```

### requiredDuringSchedulingIgnoredDuringExecution affinity for all deployments
```bash
kubectl get deployment -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,requiredDuringSchedulingIgnoredDuringExecutionKeys:.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].key,requiredDuringSchedulingIgnoredDuringExecutionOperator:.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].operator,requiredDuringSchedulingIgnoredDuringExecutionValues:.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].values" -A | tr -s ' ' | tr ',' ';' | tr ' ' ',' | tr ';' ' ' > deployment_affinity.csv
```

### preferredDuringSchedulingIgnoredDuringExecution affinity for all deployments
```bash
kubectl get deployment -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,preferredDuringSchedulingIgnoredDuringExecutionKeys:.spec.template.spec.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].key,preferredDuringSchedulingIgnoredDuringExecutionOperator:.spec.template.spec.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].operator,preferredDuringSchedulingIgnoredDuringExecutionValues:.spec.template.spec.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].values" -A | tr -s ' ' | tr ',' ';' | tr ' ' ',' | tr ';' ' ' > deployment_affinity.csv
```

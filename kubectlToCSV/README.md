# Kubectl To CSV

## Common

#### to get the associated apiVersions

```bash
kubectl get <object> -o custom-columns="Namespace:.metadata.namespace,ApiVersion:.apiVersion,Kind:.kind,Name:.metadata.name" -A | tr -s ' ' | tr ' ' ',' > apiVersion.csv
```

## Pod

#### to get the associated images

```bash
kubectl get pod -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,Images:.spec.containers[*].image" -A | tr -s ' ' | sed 's/,/;/g' | tr ' ' ',' > pod_images.csv 
```

#### to get the associated nodeName
```bash
kubectl get pods -o=custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,Node:.spec.nodeName" -A | tr -s ' ' | tr ' ' ',' > pod_node.csv
```

#### to get the associated container names

```bash
kubectl get pod -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,ContainersName:.spec.containers[*].name" -A | tr -s ' ' | tr ',' ';' | tr ' ' ',' | tr ';' ' ' > pod_containers.csv
```

#### to get the associated containers and images with their owner-kind

```bash
kubectl get pod -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,OwnerReferenceKind:.metadata.ownerReferences[0].kind,ContainersNames:.spec.containers[*].name,ContainersImages:.spec.containers[*].image" -A | tr -s ' ' | tr ',' ';' | tr ' ' ',' | tr ';' ' ' > pod_owner_container_images.csv
```

## Deployment

#### to get the associated requiredDuringSchedulingIgnoredDuringExecution affinity
```bash
kubectl get deployment -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,requiredDuringSchedulingIgnoredDuringExecutionKeys:.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].key,requiredDuringSchedulingIgnoredDuringExecutionOperator:.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].operator,requiredDuringSchedulingIgnoredDuringExecutionValues:.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].values" -A | tr -s ' ' | tr ',' ';' | tr ' ' ',' | tr ';' ' ' > deployment_affinity.csv
```

#### to get the associated preferredDuringSchedulingIgnoredDuringExecution affinity
```bash
kubectl get deployment -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,preferredDuringSchedulingIgnoredDuringExecutionKeys:.spec.template.spec.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].key,preferredDuringSchedulingIgnoredDuringExecutionOperator:.spec.template.spec.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].operator,preferredDuringSchedulingIgnoredDuringExecutionValues:.spec.template.spec.affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[*].matchExpressions[*].values" -A | tr -s ' ' | tr ',' ';' | tr ' ' ',' | tr ';' ' ' > deployment_affinity.csv
```

#### to get the associated container requests and limits
```bash
kubectl get deployment -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,ContainersName:.spec.template.spec.containers[*].name,ContainerRequests:.spec.template.spec.containers[*].resources.requests,ContainerLimits:.spec.template.spec.containers[*].resources.limits -A"
```

## Ingress

#### to get associated services and ingressClass names

```bash
kubectl get ingress -o custom-columns="Namespace:.metadata.namespace,IngressName:.metadata.name,IngressClassName:.spec.ingressClassName,Associated Services:.spec.rules[*].http.paths[*].backend.service.name" | tr -s ' ' | sed 's/,/;/g' | tr ' ' ',' > ingress_svc.csv
```

## Services

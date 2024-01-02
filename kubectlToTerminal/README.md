# Kubectl To Terminal

### containers for all pods

```bash
kubectl get pod -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,ContainersName:.spec.containers[*].name" -A
```

### containers for all pods with images

```bash
kubectl get pod -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,ContainersName:.spec.containers[*].name,Image:.spec.containers[*].image" -A
```

# Kubectl To Terminal

### containers for all pods

```bash
kubectl get pod -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,ContainersName:.spec.containers[*].name" -A
```
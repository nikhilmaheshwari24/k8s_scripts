# Kubectl To CSV

### To get the list all pods with all the images which are being used

```bash
kubectl get pod -o custom-columns="Namespace:.metadata.namespace,Name:.metadata.name,Images:.spec.containers[*].image" -A | tr -s ' ' | sed 's/,/;/g' | tr ' ' ',' > pod_images.csv 
```

### To get the list of apiVersion of all resources for kubernetes object

```bash
kubectl get <object> -o custom-columns="Namespace:.metadata.namespace,ApiVersion:.apiVersion,Kind:.kind,Name:.metadata.name" -A | tr -s ' ' | tr ' ' ',' > apiVersion.csv
```
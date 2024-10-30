kubectl get all
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm install crossplane crossplane-stable/crossplane --dry-run --debug --namespace crossplane-system --create-namespace
helm install crossplane crossplane-stable/crossplane --namespace crossplane-system --create-namespace

kubectl get pods -n crossplane-system
kubectl api-resources  | grep crossplane


kubectl create secret generic azure-secret -n crossplane-system --from-file=creds=./azure-credentials.json
kubectl describe secret azure-secret -n crossplane-system
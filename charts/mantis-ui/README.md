# Helm chart for mantis ui app

## How to use
```bash
helm repo add regelcloud https://helm.regelcloud.com
helm repo update
helm search repo regelcloud 
helm install -n mantis-system mantis-ui  regelcloud/mantis-ui 
```
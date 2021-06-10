# ECR Token Updater

## Automatically updates ECR token

To use ECR with a remote Kubernetes (i.e., without the benefit of IAM or IRSA)
requires fetching a 12-hour short term token from AWS. This repository describes a
method to instruct the Kubernetes scheduler to periodically request a new token and
set it as a secret in your Kubernetes cluster.

# Usage
## Prerequisites
To use this repo, you'll need a few things in addition to a working Kubernetes
cluster:

- A valid AWS user account
- If RBAC is in use, a service account with tthe ability to create and delete secrets
in your cluster shoule be attached to the container in the cronjob.

## Procedure
### Set AWS keys as a Kubernetes secret
#### Caveats
>If a secret manager such as Vault is in use, consider storing this secret there as
Kubernetes secrets are not meant to be secure. The following example is meant for
demonstration only.
In addition, if some sort of instance profile or other login to AWS is available,
it is preferred to use that to gain initial permissions.

1. Use `aws configure` or similar to create a `/home/$USER/.aws/` folder
1. Store the resulting files into a Kubernetes secret:
    ```bash
    kubectl create secret generic aws-credentials \
    --from-file /home/$USER/.aws/config --from-file /home/$USER/.aws/credentials
    ```
1. Edit `ecr-configmap.yaml` as appropriate for your environment with account number and default region.
    ```yaml
    apiVersion: v1
    kind: ConfigMap
    metadata:
        name: ecr-config
    data:
        account: <account-number>
        region: <region-name>
    ```
1. Send the completed configmap and cronjob documents to the API server.
    ```bash
    kubectl apply -f ecr-configmap.yaml -f ecr-updater.yaml
    ```

## Installation

### Pre-requisites

#### Argocd

Install ArgoCD from OperatorHub. We use Red Hat's version of ArgoCD - OpenShift GitOps. Search for `Red Hat OpenShift GitOps` in OperatorHub and install the operator by following the instructions.

#### MTO

Install MTO from OperatorHub. Search for `Multi Tenant Operator` in OperatorHub and install the operator by following the instructions.

Once MTO is installed, search for the CR `IntegrationConfig` and enable the Console and Showback to true:

```yaml
components:
    console: true
    showback: true
```

Once both the operators are installed, you need to apply the following role to the `openshift-gitops-argocd-application-controller` service account to allow ArgoCD to create multi-tenant operator's custom resources.

```bash
oc apply -f config/argocd/clusterrole.yaml

oc apply -f config/argocd/clusterrolebinding.yaml
```

### Quick Start

Once the pre-requisites are installed, follow these steps to install the ArgoCD Application for MTO Hands-on.

```bash
oc apply -f argocd/mto-hands-on.yaml
```

### Accessing GitOps Console

Once the ArgoCD Application is installed, you can access the GitOps Console by following these steps:

```bash
oc get route openshift-gitops-server -n openshift-gitops
```

To get the password, run the following command:

```bash
oc get secret openshift-gitops-cluster -n openshift-gitops -o jsonpath='{.data.admin\.password}' | base64 -d
```

Then open the browser and login to the above URL with the following credentials:

```bash
Username: admin
Password: <password>
```
Monitor the progress of the ArgoCD Application installation by navigating to the `Applications` tab in the ArgoCD Console. Make sure all the tenants, quotas and namespaces are created successfully.

### Accessing MTO Console

You can access the MTO Console by following these steps:

```bash
oc get ingress -n multi-tenant-operator tenant-operator-console
```

Then open the browser and navigate to the above URL. By default, you can login with the following credentials:

```bash
Username: mto
Password: mto
```

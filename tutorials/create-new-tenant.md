## Adding a New Tenant the GitOps Way

Managing Day 2 operations in a multi-tenant environment can be challenging. Adopting GitOps, which uses Git as a single source of truth for declarative infrastructure and applications, streamlines cluster management and application delivery. With GitOps, changes to infrastructure and applications are made through pull requests, offering control for admins as well as a clear audit trail of modifications.

This tutorial demonstrates how to add a new tenant to an existing MTO setup using GitOps principles.

### Pre-requisites

Ensure you've completed the setup as described in the [installation guide](../INSTALL.md)

#### Step 1: Structure your Git Repository

The repository's structure is pivotal for managing GitOps operations effectively. Our repository is organized as follows:

*Kindly note that we will use this structure for all the tutorials in this repo.*

```bash
mto-hands-on/
├── argocd/
│   └── mto-hands-on.yaml
├── config/
│   └── tenants/
│       ├── apollo.yaml
│       ├── hermes.yaml
│       └── zeus.yaml
│   ├── quotas
│       ├── large.yaml
│       ├── medium.yaml
│       └── small.yaml
└── gitops/
    ├── quota-application.yaml
    └── tenant-application.yaml
```

- `config/tenants` directory contains the tenant resources.  
- `config/quotas` directory contains the quota resources.  
- `gitops` directory contains the ArgoCD application resources.  
- `argocd` directory contains the parent ArgoCD application for MTO Hands-on.

#### Step 2: Define your New Tenant

To add a new tenant named `poseidon`, create `config/tenants/poseidon.yaml` with the following configuration:

```yaml
apiVersion: tenantoperator.stakater.com/v1beta2
kind: Tenant
metadata:
  name: poseidon
spec:
  editors:
    users:
      - diana-waters@nordmart.com
  namespaces:
    withTenantPrefix:
      - sea-ops
      - atlantis-gov
  onDelete:
    cleanAppProject: true
    cleanNamespaces: false
  owners:
    users:
      - neptune@nordmart.com
      - mto@stakater.com
  quota: medium
  viewers:
    users:
      - marina-coast@nordmart.com
```

#### Step 3: Define a new Quota / Use an existing Quota

You could either create a new Quota or use an existing one. For this tutorial, we will use an existing quota named [`medium`](../config/quotas/medium.yaml).

#### Step 4: Create a Pull Request

Branch off, commit your new tenant configuration, and push the changes:

```bash
git checkout -b add-poseidon-tenant
git add config/tenants/poseidon.yaml
git commit -m "Add new tenant poseidon"
git push origin add-poseidon-tenant
```
Finally, create a pull request against the `main` branch for review.

#### Step 5: Merge the Pull Request

This step provides control to the maintainers to review the changes before they are applied on the cluster. Once the pull request is merged, ArgoCD application will automatically pick up the changes and apply them to the cluster.

#### Step 6: Verify the Changes

You can verify the changes by navigating to the `Applications` tab in the ArgoCD Console. Make sure the new tenant (& quota) are created successfully.

You can also verify the creation of the new tenant on your OpenShift cluster by running the following command:

```bash
oc get tenant poseidon -n multi-tenant-operator -o yaml
```

### Conclusion

In this tutorial, we added a new tenant to the existing MTO setup using GitOps. 

This approach not only simplifies the Day 2 operations but also emphasizes operational efficiency, auditability, and control over changes.

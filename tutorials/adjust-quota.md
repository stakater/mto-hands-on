## Modifying an Existing Quota: Enhancing the `Small` Quota

In the world of multi-tenant Kubernetes clusters, resource allocation and management are crucial for the smooth operation of tenant applications. As tenants evolve, their resource requirements might change, leading to a need for adjustments in the quotas assigned to them.  

In this tutorial, we respond to a scenario where tenants using the `small` quota are experiencing resource shortages, leading to a need for more resources to support their applications. We will walk through the process of modifying the existing "small" quota to increase its resource allocations, using GitOps principles for change management.

### Requirement

Tenants currently using the "small" quota have reported that the allocated resources are insufficient for their growing needs. They require an increase in resources to ensure their applications can operate efficiently without resource contention.

### Pre-requisites

Ensure you've completed the setup as described in the [installation guide](../INSTALL.md)

#### Step 1: Evaluate the Current `Small` and `Medium` Quotas

Before making any changes, it's essential to understand the current resource allocations for the `small` and `medium` quotas. This will help us determine the appropriate resource increments for the `small` quota.

The `small` quota is defined in `config/quotas/small.yaml` and the `medium` quota is defined in `config/quotas/medium.yaml`. Let us review the resource allocations on both these quotas.

The original `small` quota is as follows:

*CPU Requests*: **3 cores**  
*Memory Requests*: **3Gi**  
*ConfigMaps, Secrets, Services*: **50 each**  
*Services Load Balancers*: **2**

The `medium` quota provides more resources:

*CPU Requests*: **5 cores**  
*Memory Requests*: **5Gi**  
*ConfigMaps, Secrets, Services*: **100 each**  
*Services Load Balancers*: **2**


#### Step 2: Modify the `Small` Quota

Given the requirement, we will increase the `small` quota slightly but ensure it remains below the `medium` quota levels. Here's the revised `small` quota definition:

```yaml
apiVersion: tenantoperator.stakater.com/v1beta1
kind: Quota
metadata:
  name: small
spec:
  limitrange:
    limits:
      - max:
          cpu: '3' # Increased from 2
          memory: 350Mi # Increased from 250Mi
        min:
          cpu: 100m
          memory: 50Mi
  resourcequota:
    hard:
      configmaps: '75' # Increased from 50
      requests.cpu: '4' # Increased from 3
      requests.memory: 4Gi # Increased from 3Gi
      secrets: '75' # Increased from 50
      services: '75' # Increased from 50
      services.loadbalancers: '2'
```

#### Step 3: Commit and Push the Changes

Branch off, commit your new tenant configuration, and push the changes:

```bash
git checkout -b update-small-quota
git add config/quotas/small.yaml
git commit -m "Enhance small quota"
git push origin update-small-quota
```

Finally, create a pull request against the `main` branch for review.

#### Step 5: Merge the Pull Request

This step provides control to the maintainers to review the changes before they are applied on the cluster. Once the pull request is merged, ArgoCD application will automatically pick up the changes and apply them to the cluster.

#### Step 6: Verify the Changes

You can verify the changes by navigating to the `Applications` tab in the ArgoCD Console. Make sure the updated quota `small` has been modified successfully.

You can also verify the `small` quota on your OpenShift cluster by running the following command:

```bash
oc get quota small -n multi-tenant-operator -o yaml
```

### Conclusion

By following this tutorial, we've successfully modified the `small` quota to better meet the needs of our tenants while adhering to GitOps principles for transparent and auditable infrastructure changes. This approach not only ensures operational efficiency but also maintains the integrity and security of our multi-tenant environment.

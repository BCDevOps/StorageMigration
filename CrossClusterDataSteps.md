# Migrate PV Contents Between Clusters

**Use case:** Migrate/Copy contents of a PV in one cluster to a PV in a separate cluster.

![](./assets/Intra-Cluster-PV-Copy.png)

> This process creates several temporary objects in your openshift namespaces.

## Assumptions

`Edit` Access to a pre-existing OpenShift namespace on *Cluster A*
  - Existing PVC (source)
  - pvc-migrator successfully built in cluster

`Edit` Access to a namespace within *Cluster B*
  - Pre-Created PVC suited for the destination (size/storageClass/etc)
  - pvc-migrator successfully built in cluster

[Step Overview](#Step-Overview)

[Walkthrough](#Sample-Walkthrough)

[Database data](#Database-data)

## Step Overview

- Confirm pre-requisites (assumptions) have been met.
- initialize project
- deploy each profile
- clean up clusters


## Sample Walkthrough

For this sample, the source/target clusters have been reversed to accomodate pending firewall changes for the lab environments.  Specifically, outgoing traffic from pathfinder lab to klab is pending approval.  This traffic has been confirmed for Pathfinder Production to Silver production environments.

### Detailed Steps:

#### 1. Copy login commands from clusters.  

It is important that you have logged in recently to both clusters from the command line. Go to the web console of each cluster and copy and paste each login command into your terminal.


#### 2. Initialization  
~~~
./x-cluster-migrate init -p default
~~~
Follow the prompts on the screen and it should successfully initialize the project.  
You will have to navigate to `./cross-cluster/openshift/templates/source-pvc-migrator/source-pvc-migrator-deploy.source.local.param` and `./cross-cluster/openshift/templates/target-pvc-migrator/target-pvc-migrator-deploy.target.local.param` and comment out the line that says `SRC_IMAGE_NAMESPACE` or `DST_IMAGE_NAMESPACE` and change it to the namespace of your `pvc-migrator` build.  
eg:
~~~
SRC_IMAGE_NAMESPACE=devex-von-tools
~~~
~~~
DST_IMAGE_NAMESPACE=4a9599-tools
~~~

#### 3. Migration
Now that the param files have been tweaked, we can start the deployment
~~~
./x-cluster-migrate migrate -p target
~~~
~~~
./x-cluster-migrate migrate -p source
~~~
#### 4. Cleanup
After the deployment completes, clean up the namespaces
~~~
./x-cluster-migrate clean -p target
~~~
~~~
./x-cluster-migrate clean -p source
~~~


## Database data

Specific callout for database data.  A reliable approach for DB data migration could be:

1. backup your source DB on the source cluster
2. copy the DB backup PVC to the remote cluster (using [Step Overview](#Step-Overview) )
3. perform a DB restore to a target DB service on the remote cluster.

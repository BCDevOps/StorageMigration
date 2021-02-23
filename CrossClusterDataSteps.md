# Migrate PV Contents Between Clusters

**Use case:** Migrate/Copy contents of a PV in one cluster to a PV in a separate cluster.

![](./assets/Intra-Cluster-PV-Copy.png)

> This process creates several temporary objects in your openshift namespaces.

## Assumptions

`Edit` Access to a pre-existing OpenShift namespace on *Cluster A*

  - deploymentConfig or other application deployment (to be scaled down)
  - Existing PVC (source)

`Edit` Access to a namespace within *Cluster B*

  - Service account and token with `deployer` access.
  - Pre-Created PVC suited for the destination (size/storageClass/etc)

[Step Overview](#Step-Overview)

[Walkthrough](#Sample-Walkthrough)

[Database data](#Database-data)

## Step Overview

- Confirm pre-requisites (assumptions) have been met.
- Edit source.env and dest.env files
- Edit settings.sh file 
- Run ./x-cluster-migrate
- After migration, run ./x-cluster-migrate clean


## Sample Walkthrough

For this sample, the source/target clusters have been reversed to accomodate pending firewall changes for the lab environments.  Specifically, outgoing traffic from pathfinder lab to klab is pending approval.  This traffic has been confirmed for Pathfinder Production to Silver production environments.

### Detailed Steps:

1. modify variables file (settings.sh)

**settings.sh:**
``` bash
export DST_OCP4=true #whether or not your destination on source cluster is on OCP4
export SRC_OCP4=false
export DST_CONTEXT=4a9599-prod/api-silver-devops-gov-bc-ca:6443/wadeking98@github # the full context of dest and source clusters
export SRC_CONTEXT=devex-von-prod/console-pathfinder-gov-bc-ca:8443/wadeking98
export DST_PVC=backup-mariadb # name of the source and destination pvcs
export SRC_PVC=backup
```
To find the `DST_CONTEXT` and `SRC_CONTEXT` you have to login to both clusters from the command line. (just copy an paste both login commands into the terminal). Next run `oc config get-contexts` find the contexts with your username and source/destination cluster.


2. Navigate to the openshift folder and run `./x-cluster-migrate`

Follow the prompts on the screen and it should successfully copy the source pvc to the target

3. After you've verified that the migration completed successfully, run `./x-cluster-migrate clean` to remove the builds, deployments, nsps, etc. that were created during the migration 


## Database data

Specific callout for database data.  A reliable approach for DB data migration could be:

1. backup your source DB on the source cluster
2. copy the DB backup PVC to the remote cluster (using [Step Overview](#Step-Overview) )
3. perform a DB restore to a target DB service on the remote cluster.

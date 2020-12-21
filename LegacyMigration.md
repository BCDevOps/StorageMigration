# Legacy Gluster Storage Migration


### (Also Known As: Gluster Classic)

Almost 3 years ago, the DevOps Platform Service began with Gluster Persistent Volumes and manual PV Provisioning. This work was done before the auto-provisioning storage classes were implemented (gluster-block, gluster-file, etc) and have been deprecated by Container Native Storage (CNS).

Creation of new Gluster Classic PVs has been discontinued for some time and the next step to complete the discontinuation by migrating the remaining PVs to auto-provisioned CNS or alternative storage options that will be supported going forward.  The goal is to avoid having to allocate budget in the next fiscal year for this legacy storage (Targeting *March 31, 2019* for all migrations completed)

For most of the projects this is a straightforward migration to a freshly provisioned PVC. An update, and redeploy of a deployment configuration, and removal of the old PVC is all that is required.  The following documentation will walk through the manual steps you will need to perform for a basic storage migration.  There are also community contributions to this repository that support automatically migrating to a new volume of the same name (through a 2 step process).

# Gluster Classic -> CNS


## Project Space

If you're reading this, you have hopefully received an email about the need to migrate off of any legacy storage.  This project space contains "How to" documentation and will be tracking the progress of the migration using GitHub Issues.

The [issues](https://github.com/BCDevOps/StorageMigration/issues) in this repository will also be monitored and updated by the BCGov DevOps Support teams for tracking and assistance.  While there is a Rocket.Chat channel [#devops-storage-migration](https://chat.pathfinder.gov.bc.ca/channel/devops-storage-migration) that will be a communication and help request resource.  Historical detail and information for individual Project migrations should be added to the Issue to avoid loss of information during the project.

## Where to find more

Github project: [BCDevOps/StorageMigration](https://github.com/BCDevOps/StorageMigration)

Rocket.Chat channel: [#devops-storage-migration](https://chat.pathfinder.gov.bc.ca/channel/devops-storage-migration)

Migration Walkthrough: [MigrationSteps](./MigrationSteps.md)
Cross Cluster Migration: [CrossClusterDataSteps](./CrossClusterDataSteps.md)

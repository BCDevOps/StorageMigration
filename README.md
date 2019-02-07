# Legacy Gluster Storage Migration

Legacy Gluster Persistent Volumes refers to the manual PV Provisioning done before the auto-provisioning storage classes were implemented (gluster-block, gluster-file, etc)

Creation of the manual PVs has been discontinued for some time and the next step to complete the discontinuation by migrating the remaining PVs to auto-provisioned or alternative storage options that will be supported going forward.

For most of the projects, a straightforward migration to a freshly provisioned PVC, update and redeploy of a deployment configuration, and removal of the old PVC will be all that is required.  The following documentation will walk through the manual steps you will need to perform for a basic storage migration.

## Project Space

If you've reading this, you have hopefully received an email about the need to migrate off of any legacy storage.  This project space contains "How to" documentation and will be tracking the progress of the migration using GitHub Issues.

The issues will also be monitored and updated by the BCGov DevOps Support teams for tracking and assistance.  While there is a Slack channel (#StorageMigration) that will be used for most communication, historical detail and information for individual Project migrations should be added to the Issue to avoid loss of information during the project.

## Where to find more

Github project: [BCDevOps/StorageMigration](https://github.com/BCDevOps/StorageMigration)

Migration Walkthrough: [MigrationSteps](./MigrationSteps.md)
# Storage Migration

Migrating state data from 1 Persistent Volume to another has gotten quite a bit of use.  Originally created to help with the [Legacy storage migration](./LegacyMigration.md), the uses have multiplied as teams have more and more stateful applications.

Automation now exists to migrate stateful data within the same cluster, and a walkthrough for an approach to migrate data between clusters has been developed too (only waiting for community support to automate!)

### Links

Github project: [BCDevOps/StorageMigration](https://github.com/BCDevOps/StorageMigration)

Automation Migration Walkthrough: [MigrationSteps](https://github.com/BCDevOps/StorageMigration/MigrationSteps.md)

Cross Cluster Migration: [CrossClusterDataSteps](https://github.com/BCDevOps/StorageMigration/CrossClusterDataSteps.md)

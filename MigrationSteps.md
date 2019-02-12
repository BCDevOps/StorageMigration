# Basic Storage Migration Steps

## Preparation

Before you begin, you will need to have the following information handy:

- NameSpace/Project name:
- Legacy PVC Name (SOURCE):
- Deployment Config Name: [deployment configurations that reference the source PVC by name]
- Additional references: [any additional objects or locations that reference the PVC by name]
- New PVC Name (TARGET):

## Prepare migration environment

### Prepare target PVC

Create a new PVC that matches the size of the source PVC using the appropriate gluster-file or other auto-provisioning storage class.

### Create Migration DeploymentConfig

Use the included template to create a basic DC that will start a generic pod with appropriate project permissions.  This pod will include oc cli, rsync and can be used to migrate PVs.  The template will also create a project service account with the project admin role to be used by the migration DC.

## Migration

- Scale down deployment of application using the SOURCE volume.  (remember current running pod # to be able to scale back to same #)

  `oc scale dc/<apps> --replicas=0`

- Spin up migration pod with environment variable options set
  - *PAUSE*: Duration to pause (eg: "1d") so that the migration pod sits in a paused state to allow oc rsh in and a manual migration or check to take place.
  - *AUTORUN_CMD*: (sample from pod log: "cd /source; rsync . /target") contains the migration command to run for an automated migration.  This is an unverified feature, test before using.
- Verify Data - Complete/Confirm rsync of data from SOURCE to TARGET.  (possible from within the active migration pod via oc rsh, or via examining the pod logs, or other data validation?)
- Modify application deployment configuration(s) to replace *SOURCE* PVC with *TARGET* PVC.
- Scale down migration pod to 0 (if not already done)

  `oc scale dc/<migration-DC> --replicas=0`

- Scale up deployment of application and confirm deployment and application status.
- Update any other configuration that references original *SOURCE* PVC to reference the new *TARGET* PVC instead. (pipelines? Git template sources? other?)

## Cleanup

- decommission/cleanup old pvc  (`oc delete pvc <SOURCE-claim-name>`)
- decommission migration deploymentConfig (`oc delete dc/<migration-dc>`)
- Update Project specific github issue with completion status.

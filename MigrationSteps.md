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

Use the included template to create a basic DC with a generic pod with appropriate project permissions.  This pod will include oc cli, rsync and can be used to migrate PVs.  By default, the pod will launch, echo a simple log, sleep for 1d and then exit.  With the base image, 2 environment variables exist to modify the behavior of the pod:

- SLEEP: Nothing fancy, accepts sleep command parameters to modify the sleep time.  (eg: 1d)
- AUTORUN_CMD: more dangerous, but if you know the command you would like to have auto-run on launch (rather than using oc rsh to manually migrate your data), this environment variable will run it with an "exec".

## Migration

- Scale down deployment of application using the SOURCE volume.  (remember current running pod # to be able to scale back to same #)

  `oc scale dc/<apps> --replicas=0`

- Spin up migration pod with environment variable options set.
- Migrate data either within an oc rsh session (ensure you set your SLEEP long enough to complete your migration), or via the AUTORUN_CMD environment variable.
- Verify Data - Complete/Confirm rsync of data from SOURCE to TARGET.  (possible from within the active migration pod via oc rsh, or via examining the pod logs, or other data validation?)
- Scale down migration pod to 0 (if not already done)

  `oc scale dc/<migration-DC> --replicas=0`

- Modify application deployment configuration(s) to replace *SOURCE* PVC with *TARGET* PVC.
- Scale up deployment of application and confirm deployment and application status.
- Update any other configuration that references original *SOURCE* PVC to reference the new *TARGET* PVC instead. (pipelines? Git template sources? other?)

## Cleanup

- decommission/cleanup old pvc  (`oc delete pvc <SOURCE-claim-name>`)
- decommission migration deploymentConfig (`oc delete dc/<migration-dc>`)
- Update Project specific github issue with completion status.

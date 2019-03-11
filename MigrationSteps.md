# Automated Storage Migration Steps

The automated storage migration steps build on the [openshift-developer-tools](https://github.com/BCDevOps/openshift-developer-tools/tree/master/bin) scripts.  Make sure you have them installed and working on your machine.

The PVC created by the scripts will match the name of the original PVC, therefore there will be no impact to existing references.  If you have decided to change the storage class or size of your PVC, you will need to update any templates and/or parameter files (infrastructure as code files) to match.

**It's always a good idea to make sure you have recent and validated backups of all of your data before you continue.**

**Tip:** The `scaleDown` and `scaleUp` commands provided by the `manage` script can be used to scale other application pods.  For example; if you are migrating the PVC for a PostgreSQL instance, you may want to scale the application pods that depend on the database service before and after you perform the migration.

1. Initialize the PVC migrator environment using the 'init' command; for example:
    ```
    ./manage -n devex-von-image init
    ```
1. Deploy the build configuration using the 'build' command; for example:
    ```
    ./manage build
    ```
1. Migrate your PVC(s) using the 'migrate' command; for example:
    ```
    ./manage -e tools migrate jenkins jenkins-data gluster-block 5Gi
    ```
1. Remove the PVC migrator components from your environment(s) using the 'clean' command; for example:
    ```
    ./manage -e tools clean
    ./manage -e dev clean
    ...
    ```
For complete documentation refer to the `manage` script's documentation.
```
./manage -h
```

# Manual Storage Migration Steps

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

# Basic Storage Migration Steps

## Preparation

Before you begin, you will need to have the following information handy:

- NameSpace/Project name:
- Legacy PVC Name (SOURCE):
- Deployment Config Name: [deployment configurations that reference the source PVC by name]
- Additional references: [any additional objects or locations that reference the PVC by name]
- New PVC Name (TARGET):

## Prepare migration environment

### Create Migration DeploymentConfig

Use the included template to create a basic DC that will start a generic pod with appropriate project permissions.  This pod will include oc cli, rsync and can be used to migrate PVs.  The template will also create a project service account with the project admin role to be used by the migration DC.

### Prepare target PVC

Create a new PVC that matches the size of the source PVC using the appropriate gluster-file or other auto-provisioning storage class.

## Migration

- Spin  up migration pod

- Migration (in migration pod):
   1. Collect pod info (running pods, #instances for each) 
   2. Scale down running pods to 0 (remember current running pod # to be able to scale back to same #)
      `oc scale dc/<apps> --replicas=0`
   3. collect dc config info
      - find all dc with pvc's attached
      - for each dc  with pvc's attached
        - for each pvc do
          - collect pvc config info
          - connect to old pvc 
            `oc volume dc/<migration-pod> --add --overwrite --name=<pvc-name> --type=persistentVolumeClaim --claim-name=<pvc-claim-name>`
          - create new storage on cns (same size ?, type block?) (if not created already)
            `oc create -f pvc-cns.json`
            `oc volume dc/<migration-pod> --add --claim-size <pvc-size> --mount-path <pvc-mount-path> --name <pvc-vol-name>`
          - mount both PVC (old and new)
          - copy data 
             `tar cf - . | oc rsh <pod> tar xofC - <mount-point>`
          - verify data ?
        - for each pvc, do
          - update dc (to mount new pvc) (doing this at end because config update will trigger deploy)
   4. spin up applicatiomn pods in project (oc scale dc/<apps> --replicas=x) Note: need to remember what it was before
   5. validate application.
   6. decommission/cleanup old pvc  (oc delete pvc <claim-name>
      - for each dc  with pvc's attached
        - delete& reclaim old pvc
           oc delete pvc <claim-name>
           oc volume dc/<dc-config-name --remove --name <pvc-claim-name>

F) decommission migration pod

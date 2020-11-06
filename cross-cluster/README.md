[TOC]

[Files PV Migrate Model](#Migrate-or-Backup-a-path)

[Database Migrate Model](#Migrate-or-backup-a-PostgreSQL-DB)

---------

## Migrate or backup a Path

Use case: You have aan application pod in a namespace/project that needs a config path backup occasionally for restoration. 
This solution does a file/oc native rsync to another PV, allowing for the files to be restored from the rsync at a later time.
Optionall, as a CronJob object it can be set to run and generate backups at any interval, as long as you've storage space for it.

~This OpenShift template creates several pieces within a project where your app might live.~

#### It expects several things already in place.

1. a vanilla OpenShift application deployment with a pvc & pv that has been bound before
2. the serviceAccount if need be or labels associated for access to the pv's
3. access to the oc-cli tools container image

#### This template/yaml intends to create:

~- a template of env vars~
- a pvc for storage (provided as part of manifests)
- a pvc that it expects to move (manifests include a testing item)

### Making it Happen

Pick a project where you have a deployment that you need migrated..

You must leverage the existing serviceAccount or labels in the project for the existing app, to allow access to it.
Swap out any appropriate variables in the resulting YAML.

```bash
oc project your-app-project
oc create -f pvc-yamls.yaml
oc create -f depl1-oc.yaml
```

Now check to see that the deployment's pod exists..

```bash
oc get pods
```

Note that the script within does not manage storage consumption. Please plan according to your migrate requirements.


### The Process


1. Go into the project on your old cluster where your persistent app lives
   ```bash
   oc project <your-project>
   oc get dc && oc get deployment
   ```
2. capture the pvc from your app, usually by label
   ```bash
   oc get pvc -l <app=thingy>
   #sample output:
   ```
3. Your app should have it's pods (that mount storage) scaled down to zero (0) (shut-down), to ensure no data corruption. 
   
4. Edit the migrator deployment/ template to have all necessary variables:

   * target cluster API URL
   * target cluster API port
   * target namespace/project
   * target cluster authentication token (from your own login menu)
   * and the relevant labels that associate the pvc to your app deployment.

   Don't forget to save the config

### the following steps cover how the migrator pod will setup the same pvc on the target cluster and then
### it will oc rsync the contents of the pvc selected, to the pv on the target cluster.
### It will do this by spawning a migrator pod on the target cluster and receiving the rsync.

   `rsync -IOrlzhv --no-times --no-perms --safe-links <source path from PV mount> <target path in target PV mount>`
   
   - Optionally add the `-q` flag if you don't care for the output of each file handled.
   
   - Be aware of the placement of slashes in the paths to ensure file and directories aren't mis-handled. 
   
8. Once the rsync completes, (re)start your target cluster's app or redeploy it and verify the migrated data

----------------------------------------------------------------------------------------------

Note: Still iterating on this process, but the concept for getting PV content there is sound.

Note: Still to add: handling databases (becomes a db native process, to ensure quiesced data)    

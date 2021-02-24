export GIT_URI=${GIT_URI:-"https://github.com/BCDevOps/StorageMigration.git"}
export GIT_REF=${GIT_REF:-"master"}
export DST_OCP4=true #whether or not your destination on source cluster is on OCP4
export SRC_OCP4=false
export DST_CONTEXT=4a9599-prod/api-silver-devops-gov-bc-ca:6443/wadeking98@github # the full context of dest and source clusters
export SRC_CONTEXT=devex-von-prod/console-pathfinder-gov-bc-ca:8443/wadeking98
export DST_PVC=backup-mariadb # name of the source and destination pvcs
export SRC_PVC=backup

export DST_CLUSTER=$(echo ${DST_CONTEXT} | awk 'BEGIN { FS = "/" } ; { print $1 }' )
export SRC_CLUSTER=$(echo ${SRC_CONTEXT} | awk 'BEGIN { FS = "/" } ; { print $1 }' )
export REMOTE_CLUSTER=$(echo ${DST_CONTEXT} | awk 'BEGIN { FS = "/" } ; { print $2 }' )
export REMOTE_PROJECT=$DST_CLUSTER
export DST_IMAGE_NAMESPACE=$DST_CLUSTER
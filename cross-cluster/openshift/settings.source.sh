export PROJECT_NAMESPACE=${PROJECT_NAMESPACE:-"devex-von"}
export include_templates="source-pvc-deploy"

export REMOTE_CLUSTER=$(echo ${DST_CONTEXT} | awk 'BEGIN { FS = "/" } ; { print $2 }' )
export REMOTE_PROJECT=$DST_CLUSTER
export DST_CLUSTER=$(echo ${DST_CONTEXT} | awk 'BEGIN { FS = "/" } ; { print $1 }' )
export SRC_CLUSTER=$(echo ${SRC_CONTEXT} | awk 'BEGIN { FS = "/" } ; { print $1 }' )
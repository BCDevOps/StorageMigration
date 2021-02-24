export PROJECT_NAMESPACE=${PROJECT_NAMESPACE:-"4a9599"}
export include_templates="target-pvc-deploy"
export DST_OCP4=true #whether or not your destination on source cluster is on OCP4
export SRC_OCP4=false
export DST_CONTEXT=4a9599-prod/api-silver-devops-gov-bc-ca:6443/wadeking98@github # the full context of dest and source clusters
export SRC_CONTEXT=devex-von-prod/console-pathfinder-gov-bc-ca:8443/wadeking98
export DST_PVC=backup-mariadb # name of the source and destination pvcs
export SRC_PVC=backup

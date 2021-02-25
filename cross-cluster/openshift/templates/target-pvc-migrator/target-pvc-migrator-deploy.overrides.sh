export DST_CLUSTER=$(echo ${DST_CONTEXT} | awk 'BEGIN { FS = "/" } ; { print $1 }' )
export SRC_CLUSTER=$(echo ${SRC_CONTEXT} | awk 'BEGIN { FS = "/" } ; { print $1 }' )
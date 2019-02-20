#!/bin/bash

# =================================================================================================================
# Usage:
# -----------------------------------------------------------------------------------------------------------------
usage () {
  cat <<-EOF

  ======================================================================================
  This container and script allow you to easily migrate files from one
  PVC to another.  By default when the container is deployed the source and 
  destination PVCs are mounted to /source/ and /target/ respectively.

  When run in container mode the script will sleep for ${SLEEP} to keep
  the conatiner alive while you run the script in it's default sync mode
  to copy all of the files from one PVC to another.
  --------------------------------------------------------------------------------------
  
  Usage:
  ======

    $0 [options]

  Standard Options:
  =================

    -h prints this usage documentation.
    
    -r run in container mode
    
    -s source directory
      Defaults to /source/, typically you will not need to override the default value.

    -t target directory
      Defaults to /target/, typically you will not need to override the default value.
  ======================================================================================

EOF
}
# =================================================================================================================

# =================================================================================================================
# Funtions:
# -----------------------------------------------------------------------------------------------------------------
echoRed(){
  _msg=${1}
  _red='\e[31m'
  _nc='\e[0m' # No Color
  echo -e "${_red}${_msg}${_nc}"
}

waitForAnyKey() {
  read -n1 -s -r -p $'\e[33mWould you like to continue?\e[0m  Press Ctrl-C to exit, or any other key to continue ...' key
  echo -e \\n

  # If we get here the user did NOT press Ctrl-C ...
  return 0
}

autoRun() {
  if [ ! -z "${AUTORUN_CMD}" ]; then
    return 0
  else
    return 1
  fi
}

runContainer() {
  if [ ! -z "${RUN_CONTAINER}" ]; then
    return 0
  else
    return 1
  fi
}

sync(){
  (
    source=${1}
    target=${2}
    if [ -z "${source}" ] || [ -z "${target}" ]; then
      echo -e \\n"sync; Missing parameter!"\\n
      exit 1
    fi

    rsync -rlv ${source} ${target}
  )
}
# ======================================================================================

# ======================================================================================
# Set Defaults
# --------------------------------------------------------------------------------------
SLEEP=${SLEEP:-"1m"}
SOURCE_DIR=${SOURCE_DIR:-"/source/"}
TARGET_DIR=${TARGET_DIR:-"/target/"}
# ======================================================================================

# =================================================================================================================
# Initialization:
# -----------------------------------------------------------------------------------------------------------------
while getopts s:t:rh FLAG; do
  case $FLAG in
    s)
      SOURCE_DIR=${OPTARG}
      ;;
    t)
      TARGET_DIR=${OPTARG}
      ;;
    r)
      RUN_CONTAINER=1
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      echo -e \\n"Invalid option: -${OPTARG}"\\n
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))
# =================================================================================================================

# =================================================================================================================
# Main Script
# -----------------------------------------------------------------------------------------------------------------
if runContainer; then
  usage

  if autoRun; then
    echoRed "Auto run mode, running the following command:"
    echo "${AUTORUN_CMD}"
    exec ${AUTORUN_CMD}
  fi

  echoRed "Sleeping for ${SLEEP} ..."
  sleep ${SLEEP}
else
  echo
  echo "Ready to sync files:"
  echo "  Source Directory: ${SOURCE_DIR}"
  echo "  Target Directory: ${TARGET_DIR}"
  echo
  waitForAnyKey
  sync "SOURCE_DIR" "TARGET_DIR"
fi
# =================================================================================================================


#!/bin/bash


usage () {
  cat <<-EOF
#------------------------------------------------------------------------
# Holding for ${SLEEP} while a manual storage migration is run.
#
#------------------------------------------------------------------------

 Run the following command to copy your data:
   cd /source; rsync -r . /target

EOF
}

echoRed (){
  _msg=${1}
  _red='\e[31m'
  _nc='\e[0m' # No Color
  echo -e "${_red}${_msg}${_nc}"
}

# Show usage and then sleep

usage

if [ -z "${SLEEP}" ]; then
  SLEEP="1m"
fi

if [ ! -z "${AUTORUN_CMD}" ]; then
  echoRed "Running the following:"
  echo "${AUTORUN_CMD}"
  exec ${AUTORUN_CMD}
fi

echoRed "Sleeping for ${SLEEP} ..."
/usr/bin/sleep ${SLEEP}

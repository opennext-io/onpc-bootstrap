#!/usr/bin/env bash

## Shell Opts ----------------------------------------------------------------
set -e -u -x
  
## Variables -----------------------------------------------------------------
# Extra options to pass to the ONPC bootstrap process
export BOOTSTRAP_OPTS=${BOOTSTRAP_OPTS:-''}
  
# Store the clone repo root location
export ONPC_CLONE_DIR="${ONPC_CLONE_DIR:-$(readlink -f $(dirname $0)/..)}"

## Main ----------------------------------------------------------------------
    
# Ensure that some of the wrapper options are overridden
# to prevent interference with the OSA bootstrap.
export ANSIBLE_INVENTORY="/etc/ansible/maas.py"
export ANSIBLE_REMOTE_USER="ubuntu"
export ANSIBLE_ROLE_FETCH_MODE=git-clone
export MAAS_INI_PATH="/etc/ansible/maas.ini"
export ANSIBLE_VARS_PLUGINS="/dev/null"
export HOST_VARS_PATH="/dev/null"
export GROUP_VARS_PATH="/dev/null"
        
# Run ONPC bootstrap playbook
pushd playbooks 
  if [ -z "${BOOTSTRAP_OPTS}" ]; then
    /usr/bin/ansible-playbook playbook-osa-environment.yml
  else  
    export BOOTSTRAP_OPTS_ITEMS=''
    for BOOTSTRAP_OPT in ${BOOTSTRAP_OPTS}; do
      BOOTSTRAP_OPTS_ITEMS=${BOOTSTRAP_OPTS_ITEMS}"-e "${BOOTSTRAP_OPT}" "
    done
    /usr/bin/ansible-playbook playbook-osa-environment.yml ${BOOTSTRAP_OPTS_ITEMS}
  fi    
popd  
      
# Now unset the env var overrides so that the defaults work again
unset ANSIBLE_INVENTORY
unset ANSIBLE_REMOTE_USER
unset ANSIBLE_VARS_PLUGINS
unset ANSIBLE_ROLE_FETCH_MODE
unset HOST_VARS_PATH
unset GROUP_VARS_PATH
unset MAAS_INI_PATH

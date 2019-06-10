#!/bin/bash

# Exits on errors
set -ex
# Trace everything into specific log file
exec > >(tee -i /var/log/"$(basename "$0" .sh)"_"$(date '+%Y-%m-%d_%H-%M-%S')".log) 2>&1

if [ ! -r ../ansible-role-requirements.yml ]; then
	echo "Missing or unreadable file -e role_file=../ansible-role-requirements.yml"
	exit 1
fi
# Import the ansible role dependencies
/usr/bin/ansible-playbook /opt/openstack-ansible/scripts/get-ansible-role-requirements.yml -e role_file=../ansible-role-requirements.yml
# All done
touch /opt/.onpc-get-roles-done
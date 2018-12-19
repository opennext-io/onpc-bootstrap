#!/bin/bash

# Exits on errors
set -ex
# Trace everything into specific log file
exec > >(tee -i /var/log/"$(basename "$0" .sh)"_"$(date '+%Y-%m-%d_%H-%M-%S')".log) 2>&1

# Move to proper dir
pushd /opt/onpc-logging
# Create the monitoring container(s)
openstack-ansible /opt/openstack-ansible/playbooks/lxc-containers-create.yml -e 'container_group=influx_containers:collectd_containers:grafana_containers'
openstack-ansible setup-everything.yml
popd
# All done
touch /opt/.setup-logging-done

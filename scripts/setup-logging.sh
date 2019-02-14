#!/bin/bash 
# Copyright 2018, OpenNext SAS.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

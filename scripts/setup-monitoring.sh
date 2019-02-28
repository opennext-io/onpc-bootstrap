#!/usr/bin/env bash
# 
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

## Variables -----------------------------------------------------------------
# If you're proxy'ing grafana you will need to provide the full root_path when you run
# the playbook add the following -e grafana_url='https://cloud.something/grafana/'
# Note: Specifying the Grafana external URL won't work with http_proxy settings in the playbook.
export grafana_url=${grafana_url:-''}

# Move to proper dir
pushd /opt/onpc-monitoring/playbooks
# Create the monitoring container(s)
#openstack-ansible /opt/openstack-ansible/playbooks/lxc-containers-create.yml -e #'container_group=influx_containers:collectd_containers:grafana_containers'
openstack-ansible setup_everything.yml
popd

# Now unset the env var overrides so that the defaults work again
unset grafana_url
# All done
touch /opt/.setup-monitoring-done
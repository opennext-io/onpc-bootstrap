OpenNext Private Cloud Basic Model
##################################
:date: 2018-01-13
:tags: openstack, ansible, opennext
:category: \*openstack, \*nix, \*opennext


About this repository
=====================
This repository contains the OpenNext environment setup for
OpenStack-Ansible deployment.

Master node setup process
=========================

Install the EPEL repo
---------------------
.. code-block:: bash

    yum install epel-release -y
    yum update

Install git
-----------
.. code-block:: bash

    yum install git -y

Install python >= 2.7.5
-----------------------
  .. code-block:: bash

    yum install python -y

Install ansible >= 2.7.5
------------------------
  .. code-block:: bash

    yum install python -y

Generate RSA key pair for root
------------------------------
  Use defaults with no password
  .. code-block:: bash

    sudo ssh-keygen -t rsa

Clone the onpc-bootstrap repo
-----------------------------
.. code-block:: bash
    cd /opt
    git clone https://github.com/opennext-io/onpc-bootstrap.git

Install master node
-------------------
.. code-block:: bash
    sudo bash
    cd /opt/onpc-bootstrap/playbooks
    ansible-playbook playbook-install-master.yml

Install Cobbler on master node
------------------------------
Prior to installing and configuring Cobbler, you may need to customise
your deployement profile in onpc-site-config.yml file

.. code-block:: bash
    sudo bash
    cd /opt/onpc-bootstrap/playbooks
    ansible-playbook playbook-install-cobbler.yml -e "@../onpc-site-config.yml"

Cobbler web UI is avalaible at https://<master-node>/cobbler_web

Cobbler user name and password are defined in vars/cobbler.yml

If the Web UI doesn't come up or returns an error, you may need to restart
the service.

.. code-block:: bash
     systemctl restart httpd 

Configure Cobbler inventory
---------------------------

Build the inventroy in this order:

* Distributions
* Profiles
* Systems

.. code-block:: bash
    sudo bash
    cd /opt/onpc-bootstrap/playbooks
    ansible-playbook playbook-register-distros.yml -e "@../onpc-site-config.yml"
    ansible-playbook playbook-register-profiles.yml -e "@../onpc-site-config.yml"
    ansible-playbook playbook-register-systems.yml -e "@../onpc-site-config.yml"

Verify the Cobbler inventory is correctly defined
-------------------------------------------------

.. code-block:: bash
     /etc/ansible/cobbler.py --list

This should return something like this:

.. code-block:: yaml

    {
     "_meta": {
       "hostvars": {
       [ snip....]
        "infra-01.opennext.local": {
            "cobbler": {
            "boot_files": {},
            "comment": "This is an infra node",
            "ctime": 1568194592.450351,
            "depth": 2,
            "enable_gpxe": "<<inherit>>",
            "fetchable_files": {},
            "gateway": "172.29.236.1",
            "hostname": "infra-01.opennext.local",
            "image": "",
            "interfaces": {
                "bond0": {
                "bonding_opts": "miimon=100 mode=1",
                "bridge_opts": "",
                "cnames": [],
                "connected_mode": false,
                "dhcp_tag": "",
                "dns_name": "",
                "if_gateway": "",
                "interface_master": "",
                "interface_type": "bond",
                "ip_address": "172.31.0.56",
                "ipv6_address": "",
                "ipv6_default_gateway": "",
                "ipv6_mtu": "",
                "ipv6_prefix": "",
                "ipv6_secondaries": [],
                "ipv6_static_routes": [],
                "mac_address": "",
                "management": false,
                "mtu": "",
                "netmask": "255.255.255.0",
                "static": true,
                "static_routes": [],
                "virt_bridge": ""
                },
                "bond1": {
                "bonding_opts": "miimon=100 mode=1",
                "bridge_opts": "",
                "cnames": [],
                "connected_mode": false,
                "dhcp_tag": "",
                "dns_name": "",
                "if_gateway": "",
                "interface_master": "br-vlan",
                "interface_type": "bonded_bridge_slave",
                "ip_address": "",
                "ipv6_address": "",
                "ipv6_default_gateway": "",
                "ipv6_mtu": "",
                "ipv6_prefix": "",
                "ipv6_secondaries": [],
                "ipv6_static_routes": [],
                "mac_address": "",
                "management": false,
                "mtu": "",
                "netmask": "",
                "static": false,
                "static_routes": [],
                "virt_bridge": ""
                },
                "bond1.10": {
                "bonding_opts": "",
                "bridge_opts": "",
                "cnames": [],
                "connected_mode": false,
                "dhcp_tag": "",
                "dns_name": "",
                "if_gateway": "",
                "interface_master": "br-mgmt",
                "interface_type": "bridge_slave",
                "ip_address": "",
                "ipv6_address": "",
                "ipv6_default_gateway": "",
                "ipv6_mtu": "",
                "ipv6_prefix": "",
                "ipv6_secondaries": [],
                "ipv6_static_routes": [],
                "mac_address": "",
                "management": false,
                "mtu": "",
                "netmask": "",
                "static": false,
                "static_routes": [],
                "virt_bridge": ""
                },
                "bond1.20": {
                "bonding_opts": "",
                "bridge_opts": "",
                "cnames": [],
                "connected_mode": false,
                "dhcp_tag": "",
                "dns_name": "",
                "if_gateway": "",
                "interface_master": "br-vxlan",
                "interface_type": "bridge_slave",
                "ip_address": "",
                "ipv6_address": "",
                "ipv6_default_gateway": "",
                "ipv6_mtu": "",
                "ipv6_prefix": "",
                "ipv6_secondaries": [],
                "ipv6_static_routes": [],
                "mac_address": "",
                "management": false,
                "mtu": "1500",
                "netmask": "",
                "static": false,
                "static_routes": [],
                "virt_bridge": ""
                },
                "bond1.30": {
                "bonding_opts": "",
                "bridge_opts": "",
                "cnames": [],
                "connected_mode": false,
                "dhcp_tag": "",
                "dns_name": "",
                "if_gateway": "",
                "interface_master": "br-storage",
                "interface_type": "bridge_slave",
                "ip_address": "",
                "ipv6_address": "",
                "ipv6_default_gateway": "",
                "ipv6_mtu": "",
                "ipv6_prefix": "",
                "ipv6_secondaries": [],
                "ipv6_static_routes": [],
                "mac_address": "",
                "management": false,
                "mtu": "",
                "netmask": "",
                "static": false,
                "static_routes": [],
                "virt_bridge": ""
                },
                "br-mgmt": {
                "bonding_opts": "",
                "bridge_opts": "STP=no",
                "cnames": [],
                "connected_mode": false,
                "dhcp_tag": "",
                "dns_name": "infra-01.opennext.local",
                "if_gateway": "172.29.236.1",
                "interface_master": "",
                "interface_type": "bridge",
                "ip_address": "172.29.236.56",
                "ipv6_address": "",
                "ipv6_default_gateway": "",
                "ipv6_mtu": "",
                "ipv6_prefix": "",
                "ipv6_secondaries": [],
                "ipv6_static_routes": [],
                "mac_address": "",
                "management": false,
                "mtu": "",
                "netmask": "255.255.252.0",
                "static": true,
                "static_routes": [],
                "virt_bridge": ""
                },
                "br-storage": {
                "bonding_opts": "",
                "bridge_opts": "STP=no",
                "cnames": [],
                "connected_mode": false,
                "dhcp_tag": "",
                "dns_name": "",
                "if_gateway": "",
                "interface_master": "",
                "interface_type": "bridge",
                "ip_address": "172.29.244.56",
                "ipv6_address": "",
                "ipv6_default_gateway": "",
                "ipv6_mtu": "",
                "ipv6_prefix": "",
                "ipv6_secondaries": [],
                "ipv6_static_routes": [],
                "mac_address": "",
                "management": false,
                "mtu": "",
                "netmask": "255.255.252.0",
                "static": true,
                "static_routes": [],
                "virt_bridge": ""
                },
                "br-vlan": {
                "bonding_opts": "",
                "bridge_opts": "STP=no",
                "cnames": [],
                "connected_mode": false,
                "dhcp_tag": "",
                "dns_name": "",
                "if_gateway": "",
                "interface_master": "",
                "interface_type": "bridge",
                "ip_address": "",
                "ipv6_address": "",
                "ipv6_default_gateway": "",
                "ipv6_mtu": "",
                "ipv6_prefix": "",
                "ipv6_secondaries": [],
                "ipv6_static_routes": [],
                "mac_address": "",
                "management": false,
                "mtu": "",
                "netmask": "",
                "static": true,
                "static_routes": [],
                "virt_bridge": ""
                },
                "br-vxlan": {
                "bonding_opts": "",
                "bridge_opts": "STP=no",
                "cnames": [],
                "connected_mode": false,
                "dhcp_tag": "",
                "dns_name": "",
                "if_gateway": "",
                "interface_master": "",
                "interface_type": "bridge",
                "ip_address": "172.29.240.56",
                "ipv6_address": "",
                "ipv6_default_gateway": "",
                "ipv6_mtu": "",
                "ipv6_prefix": "",
                "ipv6_secondaries": [],
                "ipv6_static_routes": [],
                "mac_address": "",
                "management": false,
                "mtu": "1500",
                "netmask": "255.255.252.0",
                "static": true,
                "static_routes": [],
                "virt_bridge": ""
                },
                "eno1": {
                "bonding_opts": "",
                "bridge_opts": "",
                "cnames": [],
                "connected_mode": false,
                "dhcp_tag": "",
                "dns_name": "",
                "if_gateway": "",
                "interface_master": "bond0",
                "interface_type": "bond_slave",
                "ip_address": "",
                "ipv6_address": "",
                "ipv6_default_gateway": "",
                "ipv6_mtu": "",
                "ipv6_prefix": "",
                "ipv6_secondaries": [],
                "ipv6_static_routes": [],
                "mac_address": "ac:1f:6b:47:3f:c8",
                "management": true,
                "mtu": "",
                "netmask": "",
                "static": false,
                "static_routes": [],
                "virt_bridge": ""
                },
                "eno2": {
                "bonding_opts": "",
                "bridge_opts": "",
                "cnames": [],
                "connected_mode": false,
                "dhcp_tag": "",
                "dns_name": "",
                "if_gateway": "",
                "interface_master": "bond1",
                "interface_type": "bond_slave",
                "ip_address": "",
                "ipv6_address": "",
                "ipv6_default_gateway": "",
                "ipv6_mtu": "",
                "ipv6_prefix": "",
                "ipv6_secondaries": [],
                "ipv6_static_routes": [],
                "mac_address": "ac:1f:6b:47:3f:c9",
                "management": false,
                "mtu": "",
                "netmask": "",
                "static": false,
                "static_routes": [],
                "virt_bridge": ""
                }
            },
            "ipv6_autoconfiguration": false,
            "ipv6_default_device": "",
            "kernel_options": {},
            "kernel_options_post": {},
            "kickstart": "<<inherit>>",
            "ks_meta": {},
            "ldap_enabled": false,
            "ldap_type": "authconfig",
            "mgmt_classes": [
                "controller",
                "network",
                "haproxy",
                "image",
                "infra"
            ],
            "mgmt_parameters": "<<inherit>>",
            "monit_enabled": false,
            "mtime": 1568194603.026112,
            "name": "infra-01",
            "name_servers": [
                "172.31.0.55",
                "172.29.236.1"
            ],
            "name_servers_search": [
                "opennext.local"
            ],
            "netboot_enabled": true,
            "owners": "<<inherit>>",
            "power_address": "",
            "power_id": "",
            "power_pass": "",
            "power_type": "ipmitool",
            "power_user": "",
            "profile": "infra",
            "proxy": "<<inherit>>",
            "redhat_management_key": "<<inherit>>",
            "redhat_management_server": "<<inherit>>",
            "repos_enabled": false,
            "server": "<<inherit>>",
            "status": "production",
            "template_files": {},
            "template_remote_kickstarts": 0,
            "uid": "MTU2ODE5NDU5Mi40NTk5OTEwODcuMzk2MzM",
            "virt_auto_boot": "<<inherit>>",
            "virt_cpus": "<<inherit>>",
            "virt_disk_driver": "<<inherit>>",
            "virt_file_size": "<<inherit>>",
            "virt_path": "<<inherit>>",
            "virt_pxe_boot": 0,
            "virt_ram": "<<inherit>>",
            "virt_type": "<<inherit>>"
            }
        }
        }
    },
    "ceph": [
        "ceph-01.opennext.local",
        "ceph-01.opennext.local"
    ],
    "compute": [
        "compute-01.opennext.local",
        "compute-01.opennext.local"
    ],
    "controller": [
        "infra-01.opennext.local"
    ],
    "haproxy": [
        "infra-01.opennext.local"
    ],
    "image": [
        "infra-01.opennext.local"
    ],
    "infra": [
        "infra-01.opennext.local",
        "infra-01.opennext.local"
    ],
    "network": [
        "infra-01.opennext.local"
    ],
    "production": [
        "infra-01.opennext.local",
        "ceph-01.opennext.local",
        "compute-01.opennext.local"
    ]
    }

Setup the OSA / ONPC environment
--------------------------------
.. code-block:: bash
    sudo bash
    cd /opt/onpc-bootstrap/playbooks
    ansible-playbook playbook-install-osa-env.yml  -i /etc/ansible/cobbler.py

Provision the target via PXE netboot
------------------------------------
The target hosts should provision automatically according to their
assigned roles and profiles defined in 'onpc-site-config.yml'.
It's critically important that the primary network interface is assigned
a correct MAC address for Cobbler to be able to pick the correct and profile
and system configuration at time of netboot. 

Setup the target hosts once they are provisionned
-------------------------------------------------
.. code-block:: bash
    sudo bash
    cd /opt/onpc-bootstrap/playbooks
    ansible-playbook playbook-setup-hosts.yml  -i /etc/ansible/cobbler.py

Finally install OpenStack on the target nodes using the OpenStack-Ansible
documentation 





OpenNext Private Cloud Basic Model
##################################
:date: 2018-01-13
:tags: openstack, ansible, opennext
:category: \*openstack, \*nix, \*opennext


About this repository
---------------------
This repository defines the OpenNext deployment model for a basic (a.k.a Starter Kit)
OpenStack infrastructure. Supports all-in-one or multi-node deployment in virtual or
physical machines.

Process
-------

You have to become root to execute the following steps.

Clone the onpc-basic-model repo

.. code-block:: bash

    cd /opt
    git clone git@github.com:opennext-io/onpc-basic-model.git

Copy everything under ./etc/openstack_deploy into /etc/openstack_deploy

.. code-block:: bash

    cd /opt/onpc-basic-model
    sudo cp -R ./etc/openstack_deploy/* /etc/openstack_deploy/

Generate the password values

.. code-block:: bash

    sudo /opt/openstack-ansible/scripts/pw-token-gen.py --file /etc/openstack_deploy/user_onpc_secrets.yml

Import the ansible role dependencies

.. code-block:: bash

    cd /opt/openstack-ansible
    openstack-ansible ./tests/get-ansible-role-requirements.yml \
        -e role_file=/opt/onpc-basic-model/ansible_role_requirements.yml

Regenerate the inventory

.. code-block:: bash

    export ANSIBLE_INVENTORY=/opt/openstack-ansible/playbooks/inventory/dynamic_inventory.py
    /opt/openstack-ansible/playbooks/inventory/dynamic_inventory.py --config /etc/openstack_deploy

Then proceed with:

   * The installation of openstack-ansible
   * The install of the monitoring stack (onpc-monitoring)
   * The install of the logging stack (onpc-logging)


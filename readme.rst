OpenNext Private Cloud Basic Model
##################################
:date: 2018-01-13
:tags: openstack, ansible, opennext
:category: \*openstack, \*nix, \*opennext


About this repository
---------------------
This repository contains the OpenNext environment setup for
OpenStack-Ansible deployment.

Master node setup process
-------------------------

* Install the EPEL repo

.. code-block:: bash

    yum install epel-release -y
    yum update

* Install git

.. code-block:: bash

    yum install git -y

* Install python >= 2.7

  .. code-block:: bash

    yum install python -y

* Generate RSA key pair for root
  Use defaults with no password

  .. code-block:: bash

    sudo ssh-keygen -t rsa

* Clone the onpc-bootstrap repo

.. code-block:: bash
    cd /opt
    git clone https://github.com/opennext-io/onpc-bootstrap.git

   * The installation of openstack-ansible
   * The install of the monitoring stack (onpc-monitoring)
   * The install of the logging stack (onpc-logging)


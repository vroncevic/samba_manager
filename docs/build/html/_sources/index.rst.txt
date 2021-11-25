samba_manager
--------------

**samba_manager** is shell tool for controlling/operating Samba Server.

Developed in `bash <https://en.wikipedia.org/wiki/Bash_(Unix_shell)>`_ code: **100%**.

|GitHub shell checker|

.. |GitHub shell checker| image:: https://github.com/vroncevic/samba_manager/workflows/samba_manager%20shell%20checker/badge.svg
   :target: https://github.com/vroncevic/samba_manager/actions?query=workflow%3A%22samba_manager+shell+checker%22

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

|GitHub issues| |Documentation Status| |GitHub contributors|

.. |GitHub issues| image:: https://img.shields.io/github/issues/vroncevic/samba_manager.svg
   :target: https://github.com/vroncevic/samba_manager/issues

.. |GitHub contributors| image:: https://img.shields.io/github/contributors/vroncevic/samba_manager.svg
   :target: https://github.com/vroncevic/samba_manager/graphs/contributors

.. |Documentation Status| image:: https://readthedocs.org/projects/samba_manager/badge/?version=latest
   :target: https://samba_manager.readthedocs.io/projects/samba_manager/en/latest/?badge=latest

.. toctree::
    :hidden:

    self

Installation
-------------

|Debian Linux OS|

.. |Debian Linux OS| image:: https://raw.githubusercontent.com/vroncevic/samba_manager/dev/docs/debtux.png
   :target: https://www.debian.org

Navigate to release `page`_ download and extract release archive.

.. _page: https://github.com/vroncevic/samba_manager/releases

To install **samba_manager** type the following

.. code-block:: bash

   tar xvzf samba_manager-x.y.tar.gz
   cd samba_manager-x.y
   cp -R ~/sh_tool/bin/   /root/scripts/samba_manager/ver.x.y/
   cp -R ~/sh_tool/conf/  /root/scripts/samba_manager/ver.x.y/
   cp -R ~/sh_tool/log/   /root/scripts/samba_manager/ver.x.y/

Or You can use Docker to create image/container.

|GitHub docker checker|

.. |GitHub docker checker| image:: https://github.com/vroncevic/samba_manager/workflows/samba_manager%20docker%20checker/badge.svg
   :target: https://github.com/vroncevic/samba_manager/actions?query=workflow%3A%22samba_manager+docker+checker%22

Dependencies
-------------

**samba_manager** requires next modules and libraries

* sh_util `https://github.com/vroncevic/sh_util <https://github.com/vroncevic/sh_util>`_

Shell tool structure
---------------------

**samba_manager** is based on MOP.

Shell tool structure

.. code-block:: bash

   sh_tool/
   ├── bin/
   │   ├── center.sh
   │   ├── display_logo.sh
   │   ├── nmb_operation.sh
   │   ├── samba_manager.sh
   │   ├── smb_info.sh
   │   ├── smb_list.sh
   │   ├── smb_operation.sh
   │   ├── smb_version.sh
   │   └── winbind_operation.sh
   ├── conf/
   │   ├── samba_manager.cfg
   │   ├── samba_manager.logo
   │   └── samba_manager_util.cfg
   └── log/
       └── samba_manager.log

Copyright and licence
----------------------

|License: GPL v3| |License: Apache 2.0|

.. |License: GPL v3| image:: https://img.shields.io/badge/License-GPLv3-blue.svg
   :target: https://www.gnu.org/licenses/gpl-3.0

.. |License: Apache 2.0| image:: https://img.shields.io/badge/License-Apache%202.0-blue.svg
   :target: https://opensource.org/licenses/Apache-2.0

Copyright (C) 2016 by `vroncevic.github.io/samba_manager <https://vroncevic.github.io/samba_manager>`_

**samba_manager** is free software; you can redistribute it and/or modify it
under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

Lets help and support FSF.

|Free Software Foundation|

.. |Free Software Foundation| image:: https://raw.githubusercontent.com/vroncevic/samba_manager/dev/docs/fsf-logo_1.png
   :target: https://my.fsf.org/

|Donate|

.. |Donate| image:: https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif
   :target: https://my.fsf.org/donate/

Indices and tables
------------------

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

# Samba server management.

samba_manager is shell tool for control/operating Samba Server.

Developed in bash code: 100%.

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/samba_manager.svg)](https://github.com/vroncevic/samba_manager/issues)
 [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/samba_manager.svg)](https://github.com/vroncevic/samba_manager/graphs/contributors)

### INSTALLATION

Navigate to release [page](https://github.com/vroncevic/samba_manager/releases) download and extract release archive.

To install modules type the following:

```
tar xvzf samba_manager-x.y.z.tar.gz
cd samba_manager-x.y.z
cp -R ~/sh_tool/bin/   /root/scripts/samba_manager/ver.1.0/
cp -R ~/sh_tool/conf/  /root/scripts/samba_manager/ver.1.0/
cp -R ~/sh_tool/log/   /root/scripts/samba_manager/ver.1.0/
```

Or You can use docker to create image/container.

:sparkles:

### USAGE

```
# Create symlink for shell tool
ln -s /root/scripts/samba_manager/ver.1.0/bin/samba_manager.sh /root/bin/samba_manager

# Setting PATH
export PATH=${PATH}:/root/bin/

# Control/operating Samba Server
samba_manager version
```

### DEPENDENCIES

This tool requires these other modules and libraries:

* sh_util https://github.com/vroncevic/sh_util

### SHELL TOOL STRUCTURE

samba_manager is based on MOP.

Shell tool structure:
```
.
├── bin/
│   ├── nmb_operation.sh
│   ├── samba_manager.sh
│   ├── smb_info.sh
│   ├── smb_list.sh
│   ├── smb_operation.sh
│   ├── smb_version.sh
│   └── winbind_operation.sh
├── conf/
│   ├── samba_manager.cfg
│   └── samba_manager_util.cfg
└── log/
    └── samba_manager.log
```

### DOCS

[![Documentation Status](https://readthedocs.org/projects/samba_manager/badge/?version=latest)](https://samba_manager.readthedocs.io/projects/samba_manager/en/latest/?badge=latest)

More documentation and info at:

* https://samba_manager.readthedocs.io/en/latest/

:sparkles:

### COPYRIGHT AND LICENCE

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2018 by https://vroncevic.github.io/samba_manager

This tool is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

:sparkles:


<img align="right" src="https://raw.githubusercontent.com/vroncevic/samba_manager/dev/docs/samba_manager_logo.png" width="25%">

# Samba server management

**samba_manager** is shell tool for control/operating Samba Server.

Developed in **[bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))** code: **100%**.

[![samba_manager shell checker](https://github.com/vroncevic/samba_manager/workflows/samba_manager%20shell%20checker/badge.svg)](https://github.com/vroncevic/samba_manager/actions?query=workflow%3A%22samba_manager+shell+checker%22)

The README is used to introduce the tool and provide instructions on
how to install the tool, any machine dependencies it may have and any
other information that should be provided before the tool is installed.

[![GitHub issues open](https://img.shields.io/github/issues/vroncevic/samba_manager.svg)](https://github.com/vroncevic/samba_manager/issues) [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/samba_manager.svg)](https://github.com/vroncevic/samba_manager/graphs/contributors)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Installation](#installation)
- [Usage](#usage)
- [Dependencies](#dependencies)
- [Shell tool structure](#shell-tool-structure)
- [Docs](#docs)
- [Copyright and licence](#copyright-and-licence)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Installation

![Debian Linux OS](https://raw.githubusercontent.com/vroncevic/samba_manager/dev/docs/debtux.png)

Navigate to release **[page](https://github.com/vroncevic/samba_manager/releases)** download and extract release archive.

To install **samba_manager** type the following

```
tar xvzf samba_manager-x.y.tar.gz
cd samba_manager-x.y
cp -R ~/sh_tool/bin/   /root/scripts/samba_manager/ver.x.y/
cp -R ~/sh_tool/conf/  /root/scripts/samba_manager/ver.x.y/
cp -R ~/sh_tool/log/   /root/scripts/samba_manager/ver.x.y/
```

Self generated setup script and execution
```
./samba_manager_setup.sh

[setup] installing App/Tool/Script samba_manager
	Thu 25 Nov 2021 08:49:54 PM CET
[setup] clean up App/Tool/Script structure
[setup] copy App/Tool/Script structure
[setup] remove github editor configuration files
[setup] set App/Tool/Script permission
[setup] create symbolic link of App/Tool/Script
[setup] done

/root/scripts/samba_manager/ver.2.0/
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

3 directories, 13 files
lrwxrwxrwx 1 root root 56 Nov 25 20:49 /root/bin/samba_manager -> /root/scripts/samba_manager/ver.2.0/bin/samba_manager.sh
```

Or You can use docker to create image/container.

[![samba_manager docker checker](https://github.com/vroncevic/samba_manager/workflows/samba_manager%20docker%20checker/badge.svg)](https://github.com/vroncevic/samba_manager/actions?query=workflow%3A%22samba_manager+docker+checker%22)

### Usage

```
# Create symlink for shell tool
ln -s /root/scripts/samba_manager/ver.x.y/bin/samba_manager.sh /root/bin/samba_manager

# Setting PATH
export PATH=${PATH}:/root/bin/

# Available options
samba_manager

samba_manager ver.2.0
Thu Nov 25 20:51:21 UTC 2021

[check_root] Check permission for current session? [ok]
[check_root] Done

	                                                                               
	                     _                                                         
	 ___  __ _ _ __ ___ | |__   __ _   _ __ ___   __ _ _ __   __ _  __ _  ___ _ __ 
	/ __|/ _` | '_ ` _ \| '_ \ / _` | | '_ ` _ \ / _` | '_ \ / _` |/ _` |/ _ \ '__|
	\__ \ (_| | | | | | | |_) | (_| | | | | | | | (_| | | | | (_| | (_| |  __/ |   
	|___/\__,_|_| |_| |_|_.__/ \__,_| |_| |_| |_|\__,_|_| |_|\__,_|\__, |\___|_|   
	                                                               |___/           
	                                                                               
			Info   github.io/samba_manager ver.2.0 
			Issue  github.io/issue
			Author vroncevic.github.io

  [USAGE] samba_manager [OPTIONS]
  [OPTIONS]
  [PR] smb | nmb | winbind | all
  [OP] start | stop | restart | status | version
  # Restart smb service
  samba_manager smb restart
  [help | h] print this option
```

### Dependencies

**samba_manager** requires next modules and libraries
* samba_manager [https://github.com/vroncevic/samba_manager](https://github.com/vroncevic/samba_manager)

### Shell tool structure

**samba_manager** is based on MOP.

Shell tool structure
```
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
```

### Docs

[![Documentation Status](https://readthedocs.org/projects/samba_manager/badge/?version=latest)](https://samba_manager.readthedocs.io/projects/samba_manager/en/latest/?badge=latest)

More documentation and info at
* [https://samba_manager.readthedocs.io/en/latest/](https://samba_manager.readthedocs.io/en/latest/)
* [https://www.gnu.org/software/bash/manual/](https://www.gnu.org/software/bash/manual/)

### Copyright and licence

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2016 by [vroncevic.github.io/samba_manager](https://vroncevic.github.io/samba_manager)

**samba_manager** is free software; you can redistribute it and/or modify
it under the same terms as Bash itself, either Bash version 4.2.47 or,
at your option, any later version of Bash 4 you may have available.

Lets help and support FSF.

[![Free Software Foundation](https://raw.githubusercontent.com/vroncevic/samba_manager/dev/docs/fsf-logo_1.png)](https://my.fsf.org/)

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://my.fsf.org/donate/)

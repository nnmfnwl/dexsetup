### 1. Operating system dependencies setup and dexsetup files download

**Update system and install git and proxychains for privacy:**
  * estimated time on very slow machine few minutes
  * system upgrade will be prompted for root password
```
su - -c "apt update; apt full-upgrade; apt install git proxychains4 tor torsocks; exit"
```

**Update user permissions for ability to use tor**
  * user permissions must be updated for ability to use tor network anonymity layer
  * user logout and login is needed after this step
```
groups | grep debian-tor || su - -c "usermod -a -G debian-tor ${USER}; exit"
```

**Create root directory(~/dexsetup) and download all dexsetup files**
  * estimated time on very slow machine 1 minute, depending on connection speed
```
mkdir -p ~/dexsetup/dexsetup \
&& cd ~/dexsetup/dexsetup \
&& proxychains4 git clone https://github.com/nnmfnwl/dexsetup.git ./
```

**Software dependencies installation**
  * installation script is using native repository system
  * packages are divided into 4 categories:
  *  clibuild - install mandatory console interface build dependencies and main console interface tools
  *  clitools - install console interface tools
  *  guibuild - install graphical interface build dependencies and main graphical tools
  *  guitools - install graphical user interface tools
  * for console interface only is recommended to install both cli categories
  * for graphical interface is recommended to install all categories
```
./setup.dependencies.sh clibuild clitools guibuild guitools
```
  * to get more details about usage and packages please use help
```
./setup.dependencies.sh help
```

**Proxychains configuration file update**
  * update file ~/proxychains/proxychains.conf
  * to allow localhost access
  * to update SOCKS version 4 to 5
  * it is recommended step
```
./setup.cfg.proxychains.sh install
```

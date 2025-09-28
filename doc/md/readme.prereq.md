### 1. Operating system dependencies setup and dexsetup files download

**Update system, install software dependencies and configure user ability to use tor**
  * for effectivity we create list of what we want to install and then execute all root(administrator) commands at once
  * **1.** set to install base mandatory privacy tools packages
```
pkg_base="proxychains4 tor torsocks"
```
  * **2.** set to install mandatory console interface build dependencies and main console interface tools packages
```
pkg_cli_build="curl wget git make cmake clang clang-tools clang-format libclang1 libboost-all-dev basez libprotobuf-dev protobuf-compiler libssl-dev openssl gcc g++ python3-pip python3-dateutil cargo pkg-config libseccomp-dev libcap-dev libsecp256k1-dev firejail firejail-profiles seccomp proxychains4 tor libsodium-dev libgmp-dev screen libfmt-dev libdb-dev libdb5.3++-dev"
```
  * **3.** set to install install useful console interface tools. For example tool clamav anti virus tool is used by dexsetup after every packages compilation or download to verify it.
```
pkg_cli_tools="clamav htop joe mc lm-sensors apt-file net-tools sshfs linux-cpupower"
```
  * **4.** set to install install graphical interface build dependencies and main graphical tools
```
pkg_gui_build="qt5-qmake-bin qt5-qmake qttools5-dev-tools qttools5-dev qtbase5-dev-tools qtbase5-dev libqt5charts5-dev python3-gst-1.0 libqrencode-dev"
```
  * **5.** set to install install graphical user interface tools. If you want to manage dexsetup environments like wallets, BlockDX and other apps remotely there is VNC package. Keepassx is tool to securely store your keys, passwords, seeds etc..., xsensors to monitor temperatures.
```
pkg_gui_tools="gitg keepassx geany xsensors tigervnc-standalone-server"
```
  * **6.** set to configure user to have ability to use tor network anonymity layer
```
groups | grep debian-tor > /dev/null && cfg_user_tor="echo 'tor for ${USER} already configured'" || cfg_user_tor="usermod -a -G debian-tor ${USER}"
```
  * **7.Debian** Start system configuration for `Debian` or `Ubuntu` based systems which are using `apt` package manager and `su` or `sudo` system configuration access.
```
sudo -v; (test $? != 0) && su_cmd="echo \"Please enter ROOT password\"; su -c" || su_cmd="echo \"Please enter ${USER} sudo password\"; sudo -sh -c"; eval "${su_cmd} \"apt update; apt full-upgrade; apt install ${pkg_base} ${pkg_cli_build} ${pkg_cli_tools} ${pkg_gui_build} ${pkg_gui_tools}; ${cfg_user_tor}; exit\""
```

**Create root directory(~/dexsetup) and download all dexsetup files**
  * estimated time on very slow machine 1 minute, depending on connection speed
```
mkdir -p ~/dexsetup/dexsetup \
&& cd ~/dexsetup/dexsetup \
&& proxychains4 git clone https://github.com/nnmfnwl/dexsetup.git ./ \
&& git checkout merge.2025.02.06 \
&& chmod 755 setup* \
&& chmod 755 ./src/setup*.sh
```

**Proxychains configuration file update**
  * update file ~/proxychains/proxychains.conf
  * to allow localhost access
  * to update SOCKS version 4 to 5
  * it is recommended step
```
./setup.cfg.proxychains.sh install
```

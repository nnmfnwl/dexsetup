### full wallets/nodes setup compiled from source example

**full wallets/nodes setup compiled from source example:**
  * This example works even from freshly installed Debian operating system
  * At the end of tutorial you would be able to run fully by firejail security sandbox isolated crypto wallets/nodes.

**How to Step by step setup DEX with DEXSETUP**
  * open terminal on target server or just SSH connect to target server for setup
  * please replace `username` and `hostname` with real values.
```
ssh username@hostname
```
  * make system uptodate, install base privacy tool and git to download dexsetup privately.
```
su - -c "apt update; apt full-upgrade; apt install git proxychains4 tor torsocks; exit"
```
  * Update user permissions for ability to use tor
```
groups | grep debian-tor || su - -c "usermod -a -G debian-tor ${USER}; exit"
```
  * for previous command changes to be applied
  * disconnect and SSH connect to remote server again
```
exit
```
```
ssh username@hostname
```
  * download DEXSETUP installation files privately over tor
  * for sure try also git pull to upgrade if repository already exist
```
mkdir -p ~/dexsetup/dexsetup
cd ~/dexsetup/dexsetup
proxychains4 git clone https://github.com/nnmfnwl/dexsetup.git ./
proxychains4 git pull
```
  * Using dexsetup to install complete GUI(graphical user interface)+CLI(command line interface) Debian package dependencies
  * `guibuild` and `guitools` parameter could be skip and Graphical user interfaces for wallets will not be build.
```
./setup.dependencies.sh clibuild clitools guibuild guitools
```
  * proxychains user file reconfiguration
```
./setup.cfg.proxychains.sh install
```
  * Choose which one wallets to be build securely from official sources.
  * Because PIVX using not enough tested rustc unstable buggy library and Debian using 1.63 stable version, the PIVX wallet must be temporary downloaded as precompiled binary package.
```
./setup.cc.wallet.sh ./src/cfg.cc.blocknet.sh install build
```
```
./setup.cc.wallet.sh ./src/cfg.cc.bitcoin.sh install build
```
```
./setup.cc.wallet.sh ./src/cfg.cc.dash.sh install build
```
```
./setup.cc.wallet.sh ./src/cfg.cc.dogecoin.sh install build
```
```
./setup.cc.wallet.sh ./src/cfg.cc.lbrycrd.sqlite.sh install build
```
```
./setup.cc.wallet.sh ./src/cfg.cc.litecoin.sh install build
```
```
./setup.cc.wallet.sh ./src/cfg.cc.particl.sh install build
```
```
./setup.cc.wallet.sh ./src/cfg.cc.pivx.sh install download
```
```
./setup.cc.wallet.sh ./src/cfg.cc.pocketcoin.sh install download
```
  * generate wallets start scripts with default wallet.dat names and default chain directories
  * generate firejail security sandbox configuration file(rules)
  * check, merge and generate/add needed wallet configuration variables for ability to be everything working properly and ready for DEX and CLI management
  * generate CLI(command line interface) wallet management predefined commands for autocomplete
```
./setup.cc.wallet.profile.sh ./src/cfg.cc.blocknet.sh
```
```
./setup.cc.wallet.profile.sh ./src/cfg.cc.bitcoin.sh
```
```
./setup.cc.wallet.profile.sh ./src/cfg.cc.dash.sh
```
```
./setup.cc.wallet.profile.sh ./src/cfg.cc.dogecoin.sh
```
```
./setup.cc.wallet.profile.sh ./src/cfg.cc.lbrycrd.sqlite.sh
```
```
./setup.cc.wallet.profile.sh ./src/cfg.cc.litecoin.sh
```
```
./setup.cc.wallet.profile.sh ./src/cfg.cc.particl.sh
```
```
./setup.cc.wallet.profile.sh ./src/cfg.cc.pivx.sh
```
```
./setup.cc.wallet.profile.sh ./src/cfg.cc.pocketcoin.sh
```

**How to VNC remote desktop connection - server side config**
  * for ability to manage wallets in graphical user interface mode, there is optional manual how to setup remote Desktop management by VNC.
  * set password used for VNC remote desktop management login
```
tigervncpasswd
```
  * configure server to start VNC server automatically after every computer restart
  * VNC listening TCP port set by 2 as 5902
  * don't worry listening port is for security reasons accessible by localhost only.
```
port=2
grep "^:${port}=${USER}$" /etc/tigervnc/vncserver.users || su - -c "echo \":${port}=${USER}\" >> /etc/tigervnc/vncserver.users; systemctl start tigervncserver@:${port}.service; systemctl enable tigervncserver@:${port}.service"
```
**How to VNC remote desktop connection - client side config**
  * Before VNC remote desktop connection to server, it is always needed to make secured SSH tunnel to server first.
```
ssh -L 5922:127.0.0.1:5902 username@server_hostname -N -f
```
  * Now run VNC client remmina or any other VNC client as you wish to.
```
remmina
```
  * Inside VNC client create remote connection to VNC server over localhost tunnel which been created by previous command
```
127.0.0.1:5922
```
  * click connect button and enter VNC password set in `tigervncpasswd` step
  * So every time you want to connect your server by VNC you need to open secure SSH tunnel to server first, but many VNC clients support SSH tunnel inside profile, so it could do automatically, it highly depends which VNC client is used.

**How to start wallets**
  * Every wallet profile has own 3 start scripts:
  * `qt` to start wallet in graphical user interface mode
  * `d` to start wallet in command line interface daemon mode
  * `cli` to start command line interface for wallet management
  
  * to start blocknet wallet in graphical user interface `qt` mode
```
cd ~/dexsetup/dexsetup/blocknet && ./firejail.blocknet.wallet_block.qt.bin.sh
```
  * to start blocknet wallet in command line interface `d` mode
```
cd ~/dexsetup/dexsetup/blocknet && ./firejail.blocknet.wallet_block.d.bin.sh
```
  * to start blocknet command line interface wallet management
```
cd ~/dexsetup/dexsetup/blocknet && ./firejail.blocknet.wallet_block.cli.bin.sh
```

**Recommended Wallet steps**
  * Fresh new `wallets supposed to be encrypted` by password first to system become more secure.
  * Wallet could be encrypted easy by entering `./encrypt` command inside `CLI wallet management`
```
./encrypt
```
  * Once wallets are encrypted, `wallets supposed to have backup`.
  * Wallet could make backup easy by entering `./backup` command inside `CLI wallet management`
```
./backup
```
  * Once wallet backups are done, immediately make hard copy of whole `/home/username/dexsetup/dexsetup/backup/` directory to safe external offline drive.
  * you can do it manually by graphical user interface or do like hacker by calling recursive copy command.
```
cp -r ~/dexsetup/dexsetup/backup /media/${USER}/usb/mount/point/
```
  * maybe if your server is remote running VPS, you can run scp command on your local machine to download backups to your local machine.
```
scp -r username@hostname:~/dexsetup/dexsetup/backup ~/backup_dex_wallets
```
  * Please remember that encrypted wallets must be unlocked before doing any wallet active operations.
  * Encrypted wallet could be unlocked easy by entering `./unlock.full` command inside `CLI wallet management`
```
./unlock.full
```
  * Just little CLI(command line interface) HINT:
  * To easy list and use many DEXSETUP predefined wallet CLI commands, just type `./` and push `TAB` button twice to see auto-complete advices.
```
./
```

**How to update just one specific wallet, for example Litecoin wallet**
  * Before upgrading for example litecoin wallet, all litecoin wallet instances must be stop first.
  * Wallet process could by entering `./stop` command inside `CLI wallet management` or just closing qt wallet with close button.
```
./stop
```
  * switch terminal to `dexsetup` main directory and upgrade dexsetup
```
cd ~/dexsetup/dexsetup/ && proxychains4 git pull
```
  * rebuild `ltc` wallet from source into new version by
```
./setup.cc.wallet.sh ./src/cfg.cc.ltc.sh update build
```
  * Unfortunately there are many cases when developer forget to update correctly build rules, so wallet would not update or is not able to be rebuild from previously downloaded and updated source code correctly. For this cases there is ability to force wallet files to be removed and rebuild again from scratch.
```
./setup.cc.wallet.sh ./src/cfg.cc.ltc.sh purge
./setup.cc.wallet.sh ./src/cfg.cc.ltc.sh update build
```
  * optionally `ltc` wallet could be updated by directly downloading pre-compiled binary files
```
./setup.cc.wallet.sh ./src/cfg.cc.ltc.sh update download
```
  * Once build/download update process successfully finish, check new wallet version in `CLI wallet management` by command `./cli -version`
```
./cli -version
```
  * And finally start ltc wallet again
```
./firejail.ltc.wallet_ltc.qt.bin.sh
```

**FAQ - Frequently asked questions**
  * Where could find all files used and generated by DEXSETUIP?
    * DEXSETUP is by default using standard directory paths for chain data used like `~/.pivx`, `~/.litecoin`, `./blocknet`, `~/.bitcoin`
    * DEXSETUP is by default using one main installation path/directory where source code, profiles, build and all stuff stored `cd ~/dexsetup/`
    * DEXSETUP also using standard proxychains config file `~/.proxychains/proxychains.conf`
    
  * DEXSETUP is failing to download a source code with commands like `./setup.cc.wallet.sh ./src/cfg.cc.blocknet.sh install`.
    * DEXSETUP is by default using `tor onion privacy routing` to download and communicate with other internet entities.
    * This high quality privacy technology could sometimes go wrong.
    * `Solution 1`: Just run command again and replace argument `install` with `update` like: `./setup.cc.wallet.sh ./src/cfg.cc.blocknet.sh update`.
    * `Solution 2`: Before calling command again, just force tor to switch into new routing path by `su - -c "systemctl restart tor@default.service; exit"` or `su - -c "service tor@default restart; exit"`.
    * `Solution 3` NOT recommended solution because loosing privacy: DEXSETUP setup command could be called without tor sanboxing by `noproxychains` argument.

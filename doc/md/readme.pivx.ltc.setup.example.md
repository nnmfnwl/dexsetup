### 12. full PIVX/LTC setup example

**full PIVX/LTC setup example:**
  * this example works even from freshly installed debian operating system
  * it setup PIVX/LTC trading with DEXBOT
  * at first we need to check system is up to date and install git first.
```
su - -c "apt update; apt full-upgrade; apt install git proxychains4 tor torsocks; exit"
```
  * Update user permissions for ability to use tor and logout and login again after command execution
```
su - -c "usermod -a -G debian-tor ${USER}; exit"
```
  * main directory create and copy installation files
```
mkdir -p ~/Downloads/ccwallets/dexsetup
cd ~/Downloads/ccwallets/dexsetup
&& proxychains4 git clone https://github.com/nnmfnwl/dexsetup.git ./
```
  * switch to experimental branch
```
git checkout experimental
```
  * need to update executables
```
chmod 755 setup.cc.dexbot.sh setup.cc.firejail.sh setup.cc.wallet.sh setup.cfg.proxychains.sh setup.dependencies.sh setup.screen.sh setup.update.sh src/setup.cc.make.sh
```
  * install all GUI+CLI debian dependencies
```
./setup.dependencies.sh clibuild clitools guibuild guitools
```
  * proxychains user file reconfigure
```
./setup.cfg.proxychains.sh install
```
  * download and build blocknet, litecoin and pivx wallets securely from official sources
  * using QA version of blocknet to support also partial orders
```
cd ~/Downloads/ccwallets/dexsetup
./setup.cc.wallet.sh ./src/cfg.cc.blocknet.qa.sh install
./setup.cc.wallet.sh ./src/cfg.cc.litecoin.sh install
./setup.cc.wallet.sh ./src/cfg.cc.pivx.sh install
```
  * generate sandboxing start scripts with default wallet names and default chain directories
```
./setup.cc.firejail.sh ./src/cfg.cc.blocknet.qa.sh
./setup.cc.firejail.sh ./src/cfg.cc.litecoin.sh
./setup.cc.firejail.sh ./src/cfg.cc.pivx.sh
```
  * generate PIVX/LTC trading strategy scripts
  * command could be repeated later with `yourpivxaddress` and `yourlitecoinaddress` replaced with real wallet addresses
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.qa.sh ./src/cfg.cc.pivx.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.pivx.ltc.sh strategy1 yourpivxaddress1 yourlitecoinaddress1
```
  * could be also another PIVX/LTC strategy running at same time, lets name it `strategy2` and using another addresses for funds `yourpivxaddress2` and `yourlitecoinaddress2`
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.qa.sh ./src/cfg.cc.pivx.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.pivx.ltc.sh strategy2 yourpivxaddress2 yourlitecoinaddress2
```
  * now we need to generate whole ecosystem startup script
```
./setup.screen.sh
```
  * everything is ready to be started
```
cd ~/Downloads/ccwallets/dexsetup/ && ./run.instance_default.qt.sh/`
```
  * now wallets should be loading for the first time
  * we could enter into GNU screen environment
```
screen -x
```
  * now we could look around and list screen tabs by shortcut: `CTRL + a + "`
  * use narrows to switch between tabs and choose for example `blocknet.wallet_block.cli` and push `ENTER` key
  * now we are in `Blocknet wallet cli` we could try list all predefined commands by writing `./` and push `TAB` button twice like in terminal )
```
```
  * finally you can detach from screen environment and let it all running
```
CTRL + a + d
```
  * time to time check for update. this command should be done out of screen environment
```
cd ~/Downloads/ccwallets/dexsetup/ && ./setup.update.sh system dexsetup walletauto firejail dexbot screen once
```
  * or updater could be running in separated special screen as daemon as automatic updater
```
cd ~/Downloads/ccwallets/dexsetup/ && ./setup.update.sh system dexsetup walletauto firejail dexbot screen daemon yes
```

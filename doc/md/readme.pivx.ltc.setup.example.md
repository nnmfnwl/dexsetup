### 11. full PIVX/LTC setup example

**full PIVX/LTC DEXSETUP setup example:**
  * This example works even from freshly installed Debian operating system
  * At the end of tutorial you would be able to PIVX/LTC trading automatically by DEXBOT or ,manually by BlockDX

**How to Step by step setup DEX with DEXSETUP**
  * open terminal and SSH connect to remote server for setup
  * please replace username with real login username and server_hostname with your real server hostname or ip address
```
ssh username@server_hostname
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
ssh username@server_hostname
```
  * set user password used for VNC remote desktop management
  * please remember that password it will be need later.
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
  * download DEXSETUP installation files privately over tor
```
mkdir -p ~/Downloads/ccwallets/dexsetup
cd ~/Downloads/ccwallets/dexsetup
proxychains4 git clone https://github.com/nnmfnwl/dexsetup.git ./
```
  * Using dexsetup to install complete GUI(graphical user interface)+CLI(command line interface) Debian package dependencies
```
./setup.dependencies.sh clibuild clitools guibuild guitools
```
  * proxychains user file reconfiguration
```
./setup.cfg.proxychains.sh install
```
  * download and build blocknet, litecoin wallets securely from official sources
  * Because PIVX using not enough tested rustc unstable buggy library and Debian using 1.63 stable version, the PIVX wallet must be temporary downloaded as precompiled binary package.
```
./setup.cc.wallet.sh ./src/cfg.cc.blocknet.sh install
./setup.cc.wallet.sh ./src/cfg.cc.litecoin.sh install build
./setup.cc.wallet.sh ./src/cfg.cc.pivx.sh install download
```
  * generate wallets start scripts with default wallet.dat names and default chain directories
  * generate firejail security sandbox configuration file(rules)
  * check, merge and generate/add needed wallet configuration variables for ability to be everything working properly and ready for DEX and CLI management
  * generate CLI(command line interface) wallet management predefined commands for autocomplete
```
./setup.cc.firejail.sh ./src/cfg.cc.blocknet.sh
./setup.cc.firejail.sh ./src/cfg.cc.litecoin.sh
./setup.cc.firejail.sh ./src/cfg.cc.pivx.sh
```
  * generate PIVX/LTC trading strategy start scripts
  * generate firejail security isolation configuration files(rules) for scripts
  * check, merge and generate/add all needed Blocknet-Decentralized-exchange configuration variables(Xbridge config)
  * Bellow command using:
    * default blocknet wallet `./src/cfg.cc.blocknet.sh` as DEX provider
    * default pivx wallet `./src/cfg.cc.pivx.sh` as maker for trading pair PIVX/LTC
    * default litecoin wallet `./src/cfg.cc.litecoin.sh` as taker for trading pair PIVX/LTC
    * default dexbot version `./src/cfg.dexbot.alfa.sh` as automatic trading bot order manager
    * default startegy configuration `./src/cfg.strategy.pivx.ltc.sh` used to generate final working strategy
    * generated strategy with suffix name `strategy1`
  * command will be run again later with `yourpivxaddress` and `yourlitecoinaddress` replaced with real wallet addresses.
  * Specific generated strategy is using funds sitting on specified addresses only. Because you can run many strategies with pivx at same time, for example `PIVX/LTC conservative 1`, `PIVX/LTC aggressive 1`, `PIVX/BTC aggressive 1`... and you do not want funds to be mixed.
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.pivx.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.pivx.ltc.sh strategy1 yourpivxaddress1 yourlitecoinaddress1
```
  * Another PIVX/LTC trading strategy could be generated very easy, lets say, name it `strategy2` and using another addresses for funds `yourpivxaddress2` and `yourlitecoinaddress2` and choose not default but aggressive price movement behavior to try earn more profits `./src/cfg.strategy.pivx.ltc.aggressive1.sh` 
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.pivx.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.pivx.ltc.aggressive1.sh strategy2 yourpivxaddress2 yourlitecoinaddress2
```
  * download or build blocknet BlockDX GUI(Graphical user interface) app from official sources
  * setup BlockDX by compilation from source code would take hours, so we choose `download` instead of `build` argument
```
./setup.cc.blockdx.sh download install
```
  * following command is to setup/configure default installed `blockdx` with default installed `blocknet` and create start script to run blockdx inside security sandbox and generate firejail security sandbox configuration file(rules).
  * Firejail isolation makes ability to also run multiple BlockDX instances connected to two different running Blocknet instances.
```
./setup.cc.blockdx.firejail.sh
```
  * As all DEXSETUP processes and also running components are by default protected by tor sanboxing, the part of project is also tor browser setup and sandboxed profiling.
  * To download TorBrowser privacy web browser from official sources
```
./setup.torbrowser.sh download install
```
  * To setup firejail sandbox profile for tor browser named default
```
./setup.torbrowser.firejail.sh default
```
  * Starting up, stopping or updating manually all wallets and trading scripts could take some time...and effort...and mistakes could be done...
  * DEXSETUP setup.screen.sh script automatically generate screen start/stop/update scripts based on previously used DEXSETUP commands(not from bash history file)
  * As we setup with DEXSETUP everything we want, it is time to generate whole ecosystem startup script.
  * DEXSETUP start script could be regenerated later when needed, for example when user adds more wallets and trading strategies and pairs.
```
./setup.screen.sh install
```
  * Now we are almost ready and it is time to logout/close from terminal/SSH server connection.
```
exit
```

**How to VNC remote desktop connection**
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
  * click connect button and enter VNC password set in previous steps
  * So every time you want to connect your server by VNC you need to open secure SSH tunnel to server first, but many VNC clients support SSH tunnel inside profile, so it could do automatically, it highly depends which VNC client is used.

**How to start DEX system and attach into and detach from screen DEX CLI interface**
  * To spin up whole DEX system up: enter directory and click on script or use command
```
cd ~/Downloads/ccwallets/dexsetup/ && ./start.screen.instance_default.gui.sh
```
  * To attach to DEX system CLI interface command
```
screen -x
```
  * To list all DEX system components use keyboard shortcut `CTRL + a + "`, navigate by `narrows` and switch to component by `Enter`
```
CTRL + a + "
```
  * To detach from DEX CLI
```
CTRL + a + d
```

**How to start DEX wallet components**
  * screen start script will start or not start loading wallets automatically depending how DEXSETUP `./setup.screen.sh` was setup.
  * For now it is not recommended to let it all start automatically because huge pressure and slowdown on server could happen.
  * It is recommended to connect DEX system CLI interface and start components manually one by one:
    * use `CTRL + a + "` to switch to `block` DEX system component and start `blocknet wallet component` by `enter` on already predefined command.
    * Use same steps to start also `litecoin wallet` and `pivx wallet` by switching into `ltc` and `pivx` components.
  * Below commands are not needed just represents whats been done.

<strike>

```
cd ~/Downloads/ccwallets/blocknet
./firejail.blocknet.wallet_block.qt.bin.sh
```
```
cd ~/Downloads/ccwallets/litecoin
./firejail.litecoin.wallet_ltc.qt.bin.sh
```
```
cd ~/Downloads/ccwallets/pivx
./firejail.pivx.wallet_pivx.qt.bin.sh
```

</strike>

**DEXSETUP configured system finalization**
  * Fresh new `wallets supposed to be encrypted` by password first to system become more secure.
  * use `CTRL + a + "` to switch to `block_cli` CLI(console user interface) component and use command `./encrypt` to encrypt Blocknet wallet.
  * Or you can just use boring wallet GUI(Graphical user interface) and click on menu to encrypt wallet.
  * Apply wallet encryption procedure also on all other wallets `litecoin_cli` and `pivx_cli`
```
./encrypt
```
  * Once wallets are encrypted, `wallets supposed to have backup`.
  * Use `CTRL + a + "` to switch to `block_cli`, `litecoin_cli` and also `pivx_cli` components and use command `./backup`
```
./backup
```
  * Once wallet backups are done, immediately make hard copy of whole `/home/username/Downloads/ccwallets/dexsetup/backup/` directory on safe external offline drive.
  * you can do it manually by graphical user interface or do like hacker by calling recursive copy command.
```
cp -r ~/Downloads/ccwallets/dexsetup/backup /media/${USER}/usb/mount/point/
```
  * maybe if your server is remote running VPS, you can run scp command on your local machine to download backups to your local machine.
```
scp -r username@server_hostname:~/Downloads/ccwallets/dexsetup/backup ~/backup_dex_wallets
```
  * Please remember that encrypted wallets must be unlocked before starting any dexbot trading bot strategy or doing any funds send operations.
  * Use `CTRL + a + "` to switch to `block_cli`, `litecoin_cli` and also `pivx_cli` and use command `./unlock.full` and enter password used to encrypt wallet.
```
./unlock.full
```
  * Just little CLI(command line interface) HINT:
  * To easy list and use many DEXSETUP predefined wallet CLI commands, just type `./` and push `TAB` button twice for autocomplete.
```
./
```
  * Every trading strategy must specify wallet address where funds are stored to be working with.
  * To generate needed wallet addresses, navigate again to `litecoin_cli`, and `pivx_cli` and use command `./getnewaddress.default`
  * There will be one address needed per every bot trading strategy.
  * Addresses could be also easy-boring generated by GUI wallet interface.
```
./getnewaddress.default
```
  * Now set our addresses to be used by generated PIVX/LTC trading strategies `startegy1` and `strategy2`.
  * Most easy way is to navigate by `CTRL + a + "` to `dexsetup` component and call dexbot setup command again with real addresses and `update_strategy`
  * or manually edit file `~/Downloads/ccwallets/dexbot/git.src/strategy_PIVX_LTC_strategy1.py` and `~/Downloads/ccwallets/dexbot/git.src/strategy_PIVX_LTC_strategy2.py` lines ~41 and ~42 where `--makeraddress` and `--takeraddress` is specified.
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.pivx.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.pivx.ltc.sh strategy1 PIVX_ADDRESS_1 LITECOIN_ADDRESS_1 update_strategy
```
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.pivx.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.pivx.ltc.aggressive1.sh strategy2 PIVX_ADDRESS_2 LITECOIN_ADDRESS_2 update_strategy
```
  * Now wallet addresses used buy DEXBOT trading strategies needs FUNDS(you know what to do)
  * Best would be to send funds to trading addresses as many times as open orders you are willing to keep active by bot at same time, because atomic swap technology can process just one swaps per UTXO. Split functionality is already part of Blocknet's XBrige API and Automatic split functionality will be part of DEXBOT configuration later, anyway expensive transaction coins like Bitcoin should be using strategy with this feature very carefully and by default must be disabled.
  
<strike>

```
#no command needed
```

</strike>

  * Use `CTRL + a + "` navigate to `block_cli` component
  * PIVX/LTC `strategy1` and `startegy2` using open `order size of 10 PIVX`, so we would split `PIVX_ADDRESS_1` and `PIVX_ADDRESS_2` funds into pieces of `12` to cover also TXfee and not left unusable dust after trade. But we need also consider bot configuration to keep maximum just `2 orders open`, so if we have 500 PIVX in wallet, we could split funds into pieces of `250 PIVX`, it would be most effective, most cheap and not wasting blockchain space.
  * Same logic needs to be applied with `LITECOIN_ADDRESS_1` and `LITECOIN_ADDRESS_2`, for example having 10 Litecoins would be split into pieces of `5 LTC`.
```
./cli dxSplitAddress PIVX 250 PIVX_ADDRESS_1 true false true
./cli dxSplitAddress PIVX 250 PIVX_ADDRESS_2 true false true
./cli dxSplitAddress LTC 5 LITECOIN_ADDRESS_1 true false true
./cli dxSplitAddress LTC 5 LITECOIN_ADDRESS_2 true false true
```
  * more trading strategy parameter updates by file edit `~/Downloads/ccwallets/dexbot/git.src/strategy_PIVX_LTC_strategy1.py`, for example:
    * maximum open orders count update is `"--maxopen 2"`
    * first placed order size and minimal first placed order size `"--sellstart 10 --sellstartmin 5"`
    * first placed order price slide `"--slidestart 2.01"` (2.01 * price == slide is +101%)
    * last order size and minimal last order size `"--sellend 10 --sellendmin 5"`
    * last placed order price slide `"--slideend 1.05""`(1.05 * price == slide is +5%)
  * there is also ability for CLI interactive strategy edit mode and also ability to define own configs to generate strategies, but those later when advance user.

**DEXSETUP configured starting strategies**
  * For using DEXBOT most effective way there is pricing proxy/cache
  * Use `CTRL + a + "` to switch to `DEXBOT pricing proxy` component
  * And push `enter` key to start dexbot pricing proxy process by predefined command.
  * Below command is not needed just represents whats supposed to be done.

<strike>

```
cd ~/Downloads/ccwallets/dexbot/ && ./run.firejail.proxy.sh
```

</strike>

  * Use `CTRL + a + "` to switch to `PIVX LTC strategy1` component
  * And push `enter` key to start PIVX DEXBOT order maker of `PIVX/LTC` trading pair.
  * Below command is not needed just represents whats supposed to be done.

<strike>

```
cd ~/Downloads/ccwallets/dexbot/ && ./run.firejail.PIVX.LTC.strategy1.sh
```

</strike>

  * Use `CTRL + a + "` to switch to `LTC PIVX strategy1` component
  * And push `enter` key to start LTC DEXBOT order maker of `PIVX/LTC` trading pair.
  * Below command is not needed just represents whats supposed to be done.

<strike>

```
cd ~/Downloads/ccwallets/dexbot/ && ./run.firejail.LTC.PIVX.strategy1.sh
```

</strike>

  * Yes you are now one of DEX system liquidity providers.
```
echo "I am happy DEX Liquidity provider"
```
  * To correctly stop trading strategy:
    * Switch to running strategy component
    * push `CTRL + c` few times to quit process
    * and call again run strategy script with `--canceladdress` addition ie like `./run.firejail.LTC.PIVX.strategy1.sh --canceladdress`
    * this way, the BOT is stop and orders which belong just to this one specific running strategy are canceled.
```
./run.firejail.LTC.PIVX.strategy1.sh --canceladdress
```

**DEXSETUP viewing open orders by BlockDX GUI and Blocknet monitor web page**
  * to run BlockDX GUI just push `Enter` key when switched to `blockdx` component.
  * Check out Graphical user interface to see you running as Liquidity provider into DEX.
  * You can also try to manage orders manually like a BOSS )
  * Below command is not needed just represents whats supposed to be done or mouse click manually.

<strike>

```
cd ~/Downloads/ccwallets/blockdx/blockdx.1.9.5/ && ./firejail.blockdx.default.sh
```

</strike>

  * to run TorBrowser GUI just push `Enter` key when switched to `torbrowser` component.
  * Once tor browser starts, just visit `https://www.blocknetmonitor.com/?p=openorders` to check see you running as Liquidity provider into DEX.
  * Below command is not needed just represents whats supposed to be done or mouse click manually.

<strike>

```
cd ~/Downloads/ccwallets/tor_browser/latest/ && ./firejail.torbrowser.default.sh
```

</strike>

```
https://www.blocknetmonitor.com/?p=openorders
```

**How to stop whole DEX system**
  * To stop all DEX system components: enter directory and click on script or use command
```
cd ~/Downloads/ccwallets/dexsetup/ && ./stop.screen.instance_default.sh
```

**How to update just one specific wallet, for example Litecoin wallet**
  * switch to wallet cli which is going to be updated, for example `ltc_cli` and stop wallet by command `./stop`
```
./stop
```
  * switch to wallet `ltc` component and wait until wallet completely stop.
  * If wallet experience stuck at quit as actual version of PIVX is causing, try use `CTRL + c` some few times.
```
# `CTRL + c`
```
  * switch to `dexsetup` component and for sure switch directory to `dexsetup` and use proxychains and git pull to update components
```
cd ~/Downloads/ccwallets/dexsetup/ && proxychains4 git pull
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
  * optionally `ltc` wallet could be updated by download
```
./setup.cc.wallet.sh ./src/cfg.cc.ltc.sh update download
```
  * Once build/download update process successfully finish, check new wallet version in `ltc_cli` component by command `./cli -version`
```
./cli -version
```
  * And finally start ltc wallet again switched in `ltc` component
```
./firejail.ltc.wallet_ltc.qt.bin.sh
```

**How to update whole DEX system**
  * To update all DEX system components: enter directory and click on script or use command on fresh open terminal.
  * all wallets and components will stop automatically.
  * this is experimental branch functionality and needs more development and testing.
```
cd ~/Downloads/ccwallets/dexsetup/ && ./update.screen.instance_default.sh all`
```

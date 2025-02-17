### 9. Environment usage

**Basic Files Structure navigation**
  * By default of this tutorial root directory where all files are stored is `~/dexsetup/`
    * wallet directory `./<crypto name>` ie `~/dexsetup/blocknet/`
      * wallet source code `./git.src/` ie `~/dexsetup/blocknet/git.src/`
      * wallet build binary files `./bin/` ie `~/dexsetup/blocknet/bin/`
      * wallet firejail custom development environment script `./firejail.<crypto name>.dev.env.sh` ie `./firejail.blocknet.dev.env.sh`
      * wallet firejail CLI run script `./firejail.<cc>.<wallet name>.cli.bin.sh` ie `./firejail.blocknet.wallet_block.cli.bin.sh`
      * wallet firejail Daemon run script `./firejail.<cc>.<wallet name>.d.bin.sh` ie `./firejail.blocknet.wallet_block.d.bin.sh`
      * wallet firejail QT run script `./firejail.<cc>.<wallet name>.qt.bin.sh` ie `./firejail.blocknet.wallet_block.cli.qt.sh`
    * custom wallet build directories `./<crypto name>/<crypto name.version>` ie `~/dexsetup/blocknet/blocknet.qa`
    * DEXSETUP directory`./dexsetup/` ie `~/dexsetup/dexsetup`
      * generated ecosystem management screen scripts
        * `./start.screen.instance_default.cli.sh/`
        * `./start.screen.instance_default.gui.sh/`
        * `./stop.screen.instance_default.sh/`
        * `./update.screen.instance_default.sh/`
    * DEXBOT files `./dexbot/` ie `~/dexsetup/dexbot`
      * generated DEXBOT strategies `./git.src/strategy_<cc ticker>_<cc ticker>_<strategy name>.py` ie `./git.src/strategy_BLOCK_LTC_strategy1.py` and `./git.src/strategy_LTC_BLOCK_strategy1.py`
      * generated DEXBOT strategies run scripts `./run.firejail.<cc ticker>.<cc ticker>.<strategy name>.sh` ie `./run.firejail.BLOCK.LTC.strategy1.sh` and `run.firejail.LTC.BLOCK.strategy1.sh`

**Environment usage with screen script**
  * best way to start whole ecosystem in Graphical desktop environment or over ssh is by generated screen script
  * In case we want to screen script just to open all screen tabs and type commands in, but everything to be manually started by ENTER button, for this case there is `norun` argument when generating screen script.
```
cd ~/dexsetup/dexsetup && `./run.instance_default.qt.sh`
cd ~/dexsetup/dexsetup && `./run.instance_default.d.sh`
```
  * before entering screen, please read at least basics about navigation in GNU screen [2. Remote console management tips with Gnu Screen](./readme.remote.console.md)
  * to enter running ecosystem screen environment 
  * ssh/login to machine, open terminal and
```
screen -x
```
  * to see and navigate everything running in this instance as named screen TABS
  * while holding CTRL, push `a` key, release all buttons than push `"` key (it could be SHIFT+' to write ")
```
CTRL + a + "
```

**Manual Environment usage without screen script**
  * to start ie: blocknet wallet daemon securely sandboxed:
```
cd ~/dexsetup/blocknet && ./firejail.blocknet.wallet_block.d.bin.sh
```
  * to start ie: blocknet cli sandbox:
```
cd ~/dexsetup/blocknet && ./firejail.blocknet.wallet_block.cli.bin.sh
```
  * to start previously generated BLOCK.LTC trading strategy anmed strategy1 in bidirectorial way
```
cd ~/Downloads/dexbot/ && ./run.firejail.BLOCK.LTC.strategy1.sh
cd ~/Downloads/dexbot/ && ./run.firejail.LTC.BLOCK.strategy1.sh
```
  * once you stop trading strategy by CTRL+C, you need to clean up orders manually by
```
cd ~/Downloads/dexbot/ && ./run.firejail.BLOCK.LTC.strategy1.sh --canceladdress
```
  * for more details about usage you can also type
```
./run.firejail.BLOCK.LTC.strategy1.sh --help
```

**Predefined CLI commands for even more user friendly usage**
   * For every firejail generated CLI script for combination of wallet.version+blockchain.dir+wallet.dat there is always generated list of specific predefined CLI RPC commands like:
   * to show and easy use predefined cli commands for actual cli sandbox type ./ and autocomplete by TAB TAB key
```
./ TAB TAB
```

   * to execute CLI RPC call in actual cli sandxbox by predefined command:
```
./cli <rpc command... like help>
```

   * list all commands(Q to exit, / to search, n find next):
   * `help | less`:
```
./help
```
   * unlock wallet fully /unlock for staking only /lock wallet:
   * `walletpassphrase "$(read -sp "pwd: " undo; echo $undo;undo=)" 9999999999`
```
./unlock.full
./unlock.staking
./lock
```
   * unlock wallet fully and most secure way(supported only by NEW RPC CLIENTS LIKE BITCOIN)
   * `-stdinwalletpassphrase walletpassphrase`
```
./unlock.full
```
   * show basic info about wallet
   * `getwalletinfo | grep -e balance -e txcount -e unlocked`
```
./getwalletinfo.basic
```
   * show staking information
   * `getstakingstatus`
```
./getstakingstatus
```
   * show basic blockchain information
   * `getblockchaininfo | grep -e blocks -e headers -e bestblockhash`
```
./getblockchaininfo.basic
```
   * show UPLOAD / DOWNLOAD data information
   * `getnettotals | grep -e totalbytes`
```
./getnettotals.basics
```
   * show number of active connections
   * `getconnectioncount`
```
./getconnectioncount
```
   * disable or enable network
   * `setnetworkactive true/false`
```
./setnetworkactive.true
./setnetworkactive.false
```
   * show connected nodes:
   * `getpeerinfo | grep "\"addr\"" | grep "\."`
```
./getpeerinfo.basic
```
   * show list of all wallet UTXOs:
   * `listunspent 0 | grep -e address -e label -e amount -e confirmations`
```
./listunspent.basic
```
   * list all generated addresses and all time received balances:
   * `listreceivedbyaddress 0 true | grep -e address -e label -e amount`
```
./listreceivedbyaddress.basic
```
   * list addresses and actual balances:
   * `listaddressgroupings | grep -v -e "\[" -e "\]"`
```
./listaddressgroupings.basic
```
   * stop wallet:
   * `stop`
```
./stop
```

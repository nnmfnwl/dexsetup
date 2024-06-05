### 6. DEXBOT trading strategies setup

**To setup dexbot strategy for custom trading pair:**
  * estimated time on very slow machine 1 minute
  * blocknet/maker/taker wallet configuration will be automatically updated if needed
  * blocknet xbridge configuration will be automatically updated if needed
  * dexbot will be automatically downloaded if needed
  * dependencies for running dexbot will be automatically installed if needed
  * finally dexbot custom strategy and run scripts will be created
  
  * following first command: is to setup `blocknet` with `litecoin` trading pair on top of `Blocknet.QA` and `dexbot alfa` version with predefined strategy for `block.ltc` named as `strategy1` strategy set up on addresses `blocknet01` and `litecoin01`
  * `./setup.cc.dexbot.sh` is script itself
  * `./src/cfg.cc.blocknet.qa.sh` is Blocknet wallet used as API provider
  * `./src/cfg.cc.blocknet.sh ./src/cfg.cc.litecoin.sh` are trading pairs
  * `./src/cfg.dexbot.alfa.sh` is dexbot version
  * `./src/cfg.strategy.block.ltc.sh` is predefined strategy file containing parameters
  * `strategy1` is name of strategy. file naming is important because you can be running multiple strategies at same time with different addresses and UTXOs
  * `blocknet01` is blocknet wallet address where funds are stored.
  * `litecoin01` is litecoin wallet address where funds are stored.
  * ***Funds for different trading pairs must be stored separately on different addresses!***
  * `blocknet01` and `litecoin01` needs to be replaced by real wallet addresses (It could be done later by manually editing generated strategy file with text editor)

**Predefined setup commands for many DEXBOT trading pairs**
  * Blocknet / Litecoin
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.block.ltc.sh strategy1      blocknet01   litecoin01
```
  * Bitcoin / Litecoin
  * Because of very high Bitcoin Transaction Fees, it is we use Litecoin as base trading token
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.bitcoin.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.btc.ltc.sh strategy1         bitcoin01    litecoin02
```
  * Verge / Litecoin
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.verge.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.xvg.ltc.sh strategy1           verge01      litecoin03
```
  * Dogecoin / Litecoin
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.dogecoin.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.doge.ltc.sh strategy1       dogecoin01   litecoin04
```
  * Pivx / Litecoin
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.pivx.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.pivx.ltc.sh strategy1           pivx01       litecoin05
```
  * Dash / Litecoin
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.dash.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.dash.ltc.sh strategy1           dash01       litecoin06
```
  * Lbry credits(Odysee token) / Litecoin
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.lbrycrd.leveldb.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.lbc.ltc.sh strategy1 lbrycrd01    litecoin07
```
  * Pocketcoin(Bastyon social network token) / Litecoin
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.pocketcoin.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.pkoin.ltc.sh strategy1    pocketcoin01 litecoin08
```
  * Particl / Litecoin
```
./setup.cc.dexbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.particl.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.part.ltc.sh strategy1    particl01 litecoin09
```
  * for more information about dexbot script and how to use optional arguments, please read help
```
./setup.cc.dexbot.sh ... help | less
```

  * successful result of every above command are generated trading strategies and corresponding firejail run scripts:
    * all files stored in DEXBOT root directory at `/<DEXBOT root>/`
    * trading strategies as `./git.src/strategy_<maker ticker>_<taker ticker>_<strategy name>.py`
    * trading run script 1 `run.firejail.<maker ticker>.<taker ticker>.<strategy name>.sh`
    * trading run script 2 `run.firejail.<maker ticker as taker>.<taker ticker ad maker>.<strategy name>.sh`
    * for example `run.firejail.BLOCK.LTC.strategy1.sh` and `run.firejail.LTC.BLOCK.strategy1.sh`
  * **it is recommended to not execute generated scripts directly, rather using them with screen setup of this tutorial**
    * screen setup is used to generate user friendly whole ecosystem startup script

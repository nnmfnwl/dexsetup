### 6. DXBOT trading strategies setup

**To setup dxbot strategy for custom trading pair:**
  * estimated time on very slow machine 1 minute
  * blocknet/maker/taker wallet configuration will be automatically updated if needed
  * blocknet xbridge configuration will be automatically updated if needed
  * dxmakerbot will be automatically downloaded if needed
  * dependencies for running dxmakerbot will be automatically installed if needed
  * finally dxmakerbot custom strategy and run scripts will be created
  
  * following first command: is to setup `blocknet` with `litecoin` trading pair on top of `Blocknet.QA` and `dxbot alfa` version with predefined strategy for `block.ltc` named as `test1` strategy set up on addresses `blocknet01` and `litecoin01`
  * `./setup.cc.dxbot.sh` is script itself
  * `./src/cfg.cc.blocknet.qa.sh` is Blocknet wallet used as API provider
  * `./src/cfg.cc.blocknet.sh ./src/cfg.cc.litecoin.sh` are trading pairs
  * `./src/cfg.dxbot.alfa.sh` is dexbot version
  * `./src/cfg.strategy.block.ltc.sh` is predefined strategy file containing parameters
  * `test1` is name of strategy. file naming is important because you can be running multiple strategies at same time with different addresses and UTXOs
  * `blocknet01` is blocknet wallet address where funds are stored.
  * `litecoin01` is litecoin wallet address where funds are stored.
  * ***Funds for different trading pairs must be stored separately on different addresses!***
  * `blocknet01` and `litecoin01` needs to be replaced by real wallet addresses (It could be done later by manually editing generated strategy file with text editor)
```
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.qa.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.block.ltc.sh test1      blocknet01   litecoin01
```
  * Bitcoin / Litecoin
  * Because of very high Bitcoin Transaction Fees, it is we use Litecoin as base trading token
```
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.bitcoin.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.btc.ltc.sh test1         bitcoin01    litecoin02
```
  * Verge / Litecoin
```
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.verge.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.xvg.ltc.sh test1           verge01      litecoin03
```
  * Dogecoin / Litecoin
```
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.dogecoin.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.doge.ltc.sh test1       dogecoin01   litecoin04
```
  * Pivx / Litecoin
```
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.pivx.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.pivx.ltc.sh test1           pivx01       litecoin05
```
  * Dash / Litecoin
```
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.dash.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.dash.ltc.sh test1           dash01       litecoin06
```
  * Lbry credits(Odysee token) / Litecoin
```
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.lbrycrd.leveldb.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.lbc.ltc.sh test1 lbrycrd01    litecoin07
```
  * Pocketcoin(Bastyon social network token) / Litecoin
```
./setup.cc.dxbot.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.pocketcoin.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dxbot.alfa.sh ./src/cfg.strategy.pkoin.ltc.sh test1    pocketcoin01 litecoin08
```
  * for more information about dxbot script and how to use optional arguments, please read help
```
./setup.cc.dxbot.sh ... help | less
```

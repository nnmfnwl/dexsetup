### 5. Wallets firejail sandbox setup

**To generate or update firejail sandboxing run scripts:**
  * estimated time on very slow machine 1 minute
  * basic usage:
```
./setup.cc.firejail.sh ./src/cfg.cc.blocknet.sh
./setup.cc.firejail.sh ./src/cfg.cc.litecoin.sh
./setup.cc.firejail.sh ./src/cfg.cc.bitcoin.sh
./setup.cc.firejail.sh ./src/cfg.cc.verge.sh
./setup.cc.firejail.sh ./src/cfg.cc.dogecoin.sh
./setup.cc.firejail.sh ./src/cfg.cc.pivx.sh
./setup.cc.firejail.sh ./src/cfg.cc.dash.sh
./setup.cc.firejail.sh ./src/cfg.cc.lbrycrd.leveldb.sh
./setup.cc.firejail.sh ./src/cfg.cc.lbrycrd.sqlite.sh
./setup.cc.firejail.sh ./src/cfg.cc.pocketcoin.sh
```
***Advanced usage, like setting up multiple firejail wallet instances***
  * below example will setup 2 pivx wallet instances with separated chain data directories
  * both wallets using same default version of PIVX wallet `./src/cfg.cc.pivx.sh`
  * first wallet dedicated for blockdx and dexbot, with chain directory at `~/.pivx/` and wallet dat file as `wallet_pivx_blockdx`
  * second wallet dedicated for staking only, with chain directory at `~/.pivx_staking/` and wallet dat file as  `wallet_pivx_staking`
  * to prevent mess wallet dat files, for example at backup process are using different file names
```
./setup.cc.firejail.sh ./src/cfg.cc.pivx.sh ~/Downloads/ccwallets/pivx/ ~/.pivx/ wallet_pivx_blockdx
./setup.cc.firejail.sh ./src/cfg.cc.pivx.sh ~/Downloads/ccwallets/pivx/ ~/.pivx_staking/ wallet_pivx_staking
```
  * for more information about firejail script and how to use optional arguments, please read help
```
./setup.cc.firejail.sh ... help | less
```
   

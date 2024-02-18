### 5. Wallets firejail sandbox setup
  * it is recommended to not execute build binary files directly, rather using them with this firejail setup
  * firejail setup is used to generate security profile and script which isolate wallet from other user files and also from other wallets because of security reasons
  
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
./setup.cc.firejail.sh ./src/cfg.cc.particl.sh
```
  * successful result of every above command are generated firejail profiles and run scripts:
    * all files stored in wallet root directories at `/<DEXSETUP root>/../<coin name>/`
    * development environment run script `firejail.<coin name>.dev.env.sh/`
    * wallet run script for daemon `firejail.<coin name>.wallet_<coin name>.d.bin.sh`
    * wallet run script for qt `firejail.<coin name>.wallet_<coin name>.qt.bin.sh`
    * wallet run script for cli `firejail.<coin name>.wallet_<coin name>.cli.bin.sh`
    * for example `~/Downloads/ccwallets/blocknet/firejail.blocknet.wallet_block.d.bin.sh`
  * **it is recommended to not execute generated scripts directly, rather using them with screen setup of this tutorial**
    * screen setup is used to generate user friendly whole ecosystem startup script
    
***Advanced usage, like setting up multiple firejail wallet instances***
  * below example will setup 2 pivx wallet instances with separated chain data directories
  * both wallets using same default version of PIVX wallet `./src/cfg.cc.pivx.sh`
  * first wallet dedicated for blockdx and dexbot, with chain directory at `~/.pivx/` and wallet dat file as `wallet_pivx_blockdx`
  * second wallet dedicated for staking only, with chain directory at `~/.pivx_staking/` and wallet dat file as  `wallet_pivx_staking`
  * to prevent mess wallet dat files, for example at backup process are using different file names
```
./setup.cc.firejail.sh ./src/cfg.cc.pivx.sh ~/.pivx/ wallet_pivx_blockdx
./setup.cc.firejail.sh ./src/cfg.cc.pivx.sh ~/.pivx_staking/ wallet_pivx_staking
```
  * for more information about firejail script and how to use optional arguments, please read help
```
./setup.cc.firejail.sh ... help | less
```
   

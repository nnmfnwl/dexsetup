### 4. Build/Update wallets from official repositories

**To download and build wallets from official repositories:**
  * estimated time on very slow machine ~30 minutes per one wallet
  * build process is securely sandboxed and privacy protected by proxychains(tor)
  * no wallet is mandatory, it depends what you want to use.
```
./setup.cc.wallet.sh ./src/cfg.cc.blocknet.sh install
./setup.cc.wallet.sh ./src/cfg.cc.litecoin.sh install
./setup.cc.wallet.sh ./src/cfg.cc.bitcoin.sh install
./setup.cc.wallet.sh ./src/cfg.cc.verge.sh install
./setup.cc.wallet.sh ./src/cfg.cc.dogecoin.sh install
./setup.cc.wallet.sh ./src/cfg.cc.pivx.sh download install
./setup.cc.wallet.sh ./src/cfg.cc.dash.sh install
./setup.cc.wallet.sh ./src/cfg.cc.lbrycrd.leveldb.sh install
./setup.cc.wallet.sh ./src/cfg.cc.lbrycrd.sqlite.sh install
./setup.cc.wallet.sh ./src/cfg.cc.pocketcoin.sh install
./setup.cc.wallet.sh ./src/cfg.cc.particl.sh install
```

  * successful result of every above command is
    * downloaded source code at `/<DEXSETUP root>/../<coin name>/git.src/`
    * build binary files at `/<DEXSETUP root>/../<coin name>/bin/`
    * for example `~/dexsetup/blocknet/`
  * **it is recommended to not execute build binary files directly, rather using it with firejail and screen setup of this tutorial**
    * firejail setup is used to generate security profile and script which isolate wallet from other user files and also from other wallets because of security reasons
    * screen setup is used to generate user friendly whole ecosystem startup script

**Help tips**
  * in certain cases download error could happen, because of used proxychains
  * for this case try again by replacing "install" with "continue"
```
./setup.cc.wallet.sh ./src/cfg.cc.<wallet name>.sh continue
```
  * if download problem persist try to add "noproxychains" option to try to download over clear-net
```
./setup.cc.wallet.sh ./src/cfg.cc.<wallet name>.sh continue noproxychains
```
  * for more information about build script and how to use optional arguments, please read help
```
./setup.cc.wallet.sh help | less
```

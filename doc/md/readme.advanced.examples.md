### 10. Advanced examples

**Example to generate 2 pivx wallet by firejail protected run scripts**

  * `first pivx wallet for staking` will be using custom blockchain directory "~/.pivx_staking" and wallet dat file "wallet_pivx_staking" and firejail run script named with suffix "_staking"
  * `second pivx wallet for blockdx` liquidity will be using default blockchain directory "~/.pivx/" and wallet.dat file as "wallet_pivx_blockdx" and firejail run script named with suffix "_blockdx"
```
cd ~/Downloads/ccwallets/dexsetup/
./setup.cc.firejail.sh ./src/cfg.cc.pivx.sh ~/.pivx/ wallet_pivx_blockdx
./setup.cc.firejail.sh ./src/cfg.cc.pivx.sh ~/.pivx_staking/ wallet_pivx_staking
```

  * after generating run script, to run GUI/DAEMON/CLI for staking wallet:
```
cd ~/Downloads/ccwallets/pivx/
./firejail.pivx.wallet_pivx_staking.qt.bin.sh
./firejail.pivx.wallet_pivx_staking.d.bin.sh
./firejail.pivx.wallet_pivx_staking.cli.bin.sh
```

  * after generating run script, to run GUI/DAEMON/CLI for blockdx liquidity wallet:
```
cd ~/Downloads/ccwallets/pivx/
./firejail.pivx.wallet_pivx_blockdx.qt.bin.sh
./firejail.pivx.wallet_pivx_blockdx.d.bin.sh
./firejail.pivx.wallet_pivx_blockdx.cli.bin.sh
```

  * so fast so simple, cheers.

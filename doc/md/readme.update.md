### 8. System update script as onetime or daemon

**ABOUT**
  * Whole ecosystem update script
  * updating manually all os/sources/wallets/... could take some time and effort...
  * `setup.update.sh` is tool used to update running DEXSETUP ecosystem instance

**Default Usage**
  * estimated time depends on update size
  * `system` try to update operating system packages
  * `dexsetup` try to update dexsetup itself
  * `walletauto |walletforce` update wallet versions automatically by comparing commit ids or force to update all wallets
  * `firejail` regenerate firejail scripts
  * `dexbot` regenerate dexbot strategies
  * `screen` regenerate screen start script
  * `yes` don't ask, just say yes to all questions
  * `once|daemon` run only once or in loop as daemon
```
./setup.update.sh system dexsetup walletauto firejail dexbot screen once
```

**Output**
  * successful result of above command is updated DEXSETUP
    
**More Help**
  * for all information about update script and how to use optional arguments, please read help
```
./setup.update.sh help | less
```

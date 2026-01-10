### 8. Start/stop/update scripts with GNU Screen terminal multiplexer setup

**ABOUT**
  * Whole ecosystem start/stop/update screen script setup
  * Starting up, stopping or updating manually all wallets and trading scripts could take some time...and effort...and mistakes could be done...
  * `setup.screen.sh` script automatically generate screen start/stop/update scripts based on previously used DEXSETUP commands(not from bash history file)
  * It also support custom instances, so you could have two or more ecosystem instances at once.

**Default Usage**
  * estimated time on very slow machine 1 minute
  * setup generates multiple scripts, one for GUI(graphical user interface) another one for CLI(console user interface)
  * arguments:
    * `install` to create scripts for the first time
    * `update` to overwrite existing scripts
    * `clean` to cleanup existing dexsetup history
  * default usage is:
```
./setup.screen.sh install
```

**Output**
  * successful result of above command is
    * generated ecosystem management scripts `/<DEXSETUP root>/<start|stop|update>.screen.instance_<instance name>.<|qt|d>.sh`
    * for example:
      * `~/dexsetup/dexsetup/start.screen.instance_default.cli.sh/` to start in graphical user interface mode
      * `~/dexsetup/dexsetup/start.screen.instance_default.gui.sh/` to start in console user interface mode
      * `~/dexsetup/dexsetup/stop.screen.instance_default.sh/` to stop
      * `~/dexsetup/dexsetup/update.screen.instance_default.sh/` to update
  * QT(GUI) script needs to be run from inside running GRAPHICAL USER INTERFACE SESSION OR INSIDE ie VNC SESSION. So should not be called within classic SSH session because that not having exported GUI environment variables so will not be able to detect display used for GUI apps.
  
  * generated screen start instance with default options contains:
    * screen tab named `uptime` used as for machine/operating system/storage/temp/network status overview.
    * screen tab named `htop` used as htop command real-time system analysis
    * screen tab named `dexsetup` reserved for later management
    * screen tabs named by `wallet names` used for running wallet daemon or QT instances
    * screen tabs named by `wallet names.cli` used for running wallet CLI
    * screen tabs named by `tradingpair.strategyname` used for running DEXBOT strategies
  
  * generated update script has optional arguments:
    * `system` try to update operating system packages
      * it could fix many OS/Libs bugs, but also could make your wallet needed to be rebuild again
    * `dexsetup` try to update dexsetup itself
      * it could load new version of wallets, new strategies, etc...
    * `wallet` try to update wallets
      * in case of wallet update process failing, wallets could be updated manually and update script restarted
    * `firejail` regenerate firejail scripts
    * `dexbot` regenerate dexbot strategies
       * any manual edits on strategy options would be removed
    * `screen` regenerate screen start script
    * `yes` don't ask, just say yes to all questions
    * `daemon` run only once or in loop as daemon
  
**More Help**
  * for all details about screen setup script and generated start/stop/update scripts usage please read help
```
./setup.screen.sh help | less
```

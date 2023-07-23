### 7. Start script with GNU Screen terminal multiplexer setup

**ABOUT**
  * Whole ecosystem startup screen script setup
  * Starting up manually all wallets and trading scripts could take some time...and effort...
  * `setup.cc.screen.sh` script automatically generate screen startup script based on previously used DEXSETUP commands
  * It also support custom instances, so you could have two or more ecosystem instances at once.

**Default Usage**
  * estimated time on very slow machine 1 minute
  * setup generates two startup scripts, one for QT another one for CLI
  * default usage is
```
./setup.cc.screen.sh
```

**Output**
  * successful result of above command is
    * generated ecosystem start scripts `/<DEXSETUP root>/run.instance_<instance name>.<qt/d>.sh`
    * for example `~/Downloads/ccwallets/dexsetup/run.instance_default.d.sh/` and `~/Downloads/ccwallets/dexsetup/run.instance_default.qt.sh/`
  * QT(GUI) script needs to be run from inside running GRAPHICAL USER INTERFACE SESSION OR INSIDE ie VNC SESSION. So should not be called within classic SSH session because that not having exported GUI environment variables so will not be able to detect display used for GUI apps.
  apps.
  
  * screen startup instance with default options contains:
    * screen tab named `uptime` used as for machine/operating system/storage/temp/network status overview.
    * screen tab named `htop` used as htop command real-time system analysis
    * screen tab named `dexsetup` reserved for later management
    * screen tabs named by `wallet names` used for running wallet daemon or QT instances
    * screen tabs named by `wallet names.cli` used for running wallet CLI
    * screen tabs named by `tradingpair.strategyname` used for running DEXBOT strategies 

**More Help**
  * for all information about screen setup script and how to use optional arguments, please read help
```
./setup.cc.screen.sh help | less
```

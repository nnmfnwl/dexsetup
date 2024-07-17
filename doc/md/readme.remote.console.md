###  2. Basic Step By Step Management With Remote Console with GNU Screen

**Reasons why GNU-Screen short manual included in tutorial:**
  * Management of running multiple CLI(command line interface) services by single terminal is user-friendly when used good tool for.
  * Dexsetup using standard tool called GNU-Screen which allows to attach, detach and manage multiple CLI services by single local/SSH terminal window.
  * So GNU-Screen in DEXSETUP is used to automatize and manage multiple wallets/wallet-cli/bots/tasks by just one local/remote ssh terminal connection, same like multiple web pages by Web Browser Tabs.

**How to manage remote/local services with GNU-Screen**
  * at first we need to open terminal or also connect to remote machine by ssh(please replace "user" and "hostname" with real values)
```
ssh user@hostname
```
  * to reconnect already running GNU screen session or create new screen session
```
screen -R
```
  * to connect to already running GNU screen session from multiple machines
```
screen -x
```
  * Basic GNU-screen shortcuts and navigation between tabs to manage multiple console apps at same time:
  * while holding CTRL, push `a` key, release both buttons than push `custom` key
```
* to detach from screen session(apps will keep running in background)    CTRL + a + d
* to create new screen "tab"    CTRL + a + c
* to list and select screen "tab"    CTRL + a + "
* to go next tab    CTRL + a + n
* to go previous tab    CTRL + a + p
* to cycle last 2 tabs    CTRL + a + a
* to show screen help    CTRL + a + ?
* to rename screen tab    CTRL + a + A
* to move screen tab to position 1    CTRL + a + :number 1 + ENTER
```
  * Maybe now it looks boring, but once will server need remote management even with slow internet connection, this short manual let manage running bots and wallets so easy like a boss.

**More extensive manual could be found also at man page**
```
man screen
```

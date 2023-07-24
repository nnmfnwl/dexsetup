###  2. Basic Step By Step Management With Remote Console with GNU Screen

  * With GNU Screen you can easy manage multiple wallets/wallet-cli/bots/tasks in open terminals, same like in multiple Web Browser Tabs
```
man screen
```
  * at first we need to connect to remote machine by ssh(please replace "user" and "hostname" with real values)
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
  * while holding CTRL, push `a` key, release all buttons than push `custom` key
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

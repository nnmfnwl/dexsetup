### 3. Basic Step By Step Management With Remote Desktop

#### Initial VNC server startup

  * At first we need use SSH to connect to server
```
ssh user@hostname
```

  * generate VNC password
  * (one time only)
```
tigervncpasswd
```

  * to start tigervnc on server(one time only)
  * after executing below command and waiting few seconds it is safe to exit ssh connection
```
tigervncserver -localhost yes -geometry 1024x768 -depth 16 :1
```

  * to configure tigervnc server to start automatically with computer
  * first part of below command is to detect `su vs sudo` system
  * second part of below command add user into tigervnc vncserver.users config and enable and start vnc service
  * :1 means 5901 vnc port, :2 would be 5902 vnc port.

```
port=1
sudo -v; (test $? != 0) && su_cmd="echo \"Please enter ROOT password\"; su -c" || su_cmd="echo \"Please enter ${USER} sudo password\"; sudo -sh -c"; 
(grep "^:[0-9]=${USER}$" /etc/tigervnc/vncserver.users && echo "TigerVNC is already configured to start automatically with ${USER}") || (grep "^:${port}=" /etc/tigervnc/vncserver.users && echo "TigerVNC is already configured at port ${port} for another user, please choose another port=${port} value and repeat command again") || eval "${su_cmd} \"echo ':${port}=${USER}' >> /etc/tigervnc/vncserver.users; systemctl start tigervncserver@:${port}.service; systemctl enable tigervncserver@:${port}.service\""
```

#### VNC client connect option 1 with xtigervncviewer

  * to connect tigervnc client to server over secured and encrypted SSH tunnel
  * to enter or exit full screen mode push "F8" to show menu and "f" or click "full screen"
  * you will be asked for VNC password from previous step
  * (please replace "user" and "hostname" with real values)
```
ssh -L 5901:127.0.0.1:5901 -N -f user@hostname && xtigervncviewer -FullscreenSystemKeys=1 -MenuKey=F8 -RemoteResize=1 -FullScreen=0 localhost:5901 ; exit
```

#### VNC client connect option 2 with remmina

  * remmina could be also used as VNC remote desktop client
  * ssh tunnel enable first
  * finally start Remmina VNC remote desktop client
```
ssh -L 5901:127.0.0.1:5901 user@hostname -N -f
remmina
```

#### Sound Over SSH

  * optionally enable sound over ssh by aplay
```
ssh user@hostname "arecord -f cd" | aplay
```
  * in case of sound over ssh is crashing you can use automatic recovery command instead
```
while :; do ssh user@hostname "arecord -f cd" | aplay; done
```

#### Recommendations

  * it is recommended to start also GUI wallets inside GNU Screen because:
    * if remote network connection slows down, it could be still managed by CLI
    * All logs are easy to read with GNU screen
    * It is more easy to automatize CLI commands with GNU screen
    * [see 2. Remote console management tips with Gnu Screen](./readme.remote.console.md)
    * [see 7. Start script with GNU Screen terminal multiplexer setup](./readme.screen.md)
    
#### Remote desktop effectivity with Mate Desktop

  * The more effects Graphical Desktop Environment using, the slower and less effective VNC connection could be, same navigation all the time with mouse without keyboard shortcuts cause same negative effect.
  * For most effective user experience with VNC, the below configuration for mate desktop minimize network bandwidth and maximize effectivity by many build in desktop shortcuts.
  * Included changes and shortcuts:
    * `WIN + Q` - Show main menu (Just because **Q** key is on good position)
    * `WIN + E` - ***S***earch and Run application
    * `WIN + G` - ***G***o go home folder
    * `WIN + S` - ***S***earch for files
    * `WIN + D` - Minimize all applications and show `d`esktop
    * `WIN + L` - ***L***ock screen
    * `WIN + T` - Run ***T***erminal
    * `CTRL + ALT + Narrows` - Navigate different desktops
    * `WIN + ALT + Narrows` - Move applications between desktops
    * `WIN + F` - Toggle window ***f***ull-screen mode
    * `WIN + X` - Toggle window ma***x***imize mode
    * `WIN + N` - Mi***n***imize window
    * `WIN + M` - ***M***aximize window
    * `WIN + R` - ***R***esize window
    * `WIN + W` - Toggle window visible on all ***W***orkspaces or just one
    * `WIN + V` - Toggle maximize window ***V***ertically
    * `WIN + H` - Toggle maximize window ***H***orizontally
    * `WIN + Narrows` - Move window to borders of the screen
    * `WIN + C` - Move windows to the ***C***enter of the screen
    * `WIN + A` - Make screenshot on specific ***A***rea of the screen
    * Minimized desktop effects for less remote desktop video traffic
  * Before applying configuration, would be good practice to backup current Mate-desktop configuration first
```
test -f ~/dconf.dump.org.mate.backup.txt || dconf dump /org/mate/ > ~/dconf.dump.org.mate.backup.txt
```
  * To apply new configuration on Mate-desktop provided by dexsetup
```
dconf load /org/mate/ < ~/dexsetup/dexsetup/src/dconf.dump.org.mate.txt
```
  * To restore previous configuration on Mate-desktop from backup
```
dconf load /org/mate/ > ~/dconf.dump.org.mate.backup.txt
```
  * Optionally to reset all Mate-desktop configuration to system defaults
```
dconf reset -f /org/mate/
```
  

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
(grep "^:[0-9]=${USER}$" /etc/tigervnc/vncserver.users && echo "TigerVNC is already configured to start automatically with ${USER}") || (grep "^:${port}=" /etc/tigervnc/vncserver.users && echo "TigerVNC is already configured at port ${port} for another user, please choose another port=${port} value and repeat command again") || eval "${su_cmd} \"echo ':${port}=${USER}' >> /etc/tigervnc/vncserver.users; systemctl start tigervncserver@:1.service; systemctl enable tigervncserver@:1.service\""
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

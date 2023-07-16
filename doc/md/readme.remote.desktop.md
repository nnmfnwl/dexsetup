### 3. Basic Step By Step Management With Remote Desktop

#### Initial VNC server startup

  * Hints how to remote desktop management with VNC:
  
  * SSH to connect to server
```
ssh user@hostname
```

  * to generate VNC password
  * (one time only)
```
tigervncpasswd
```

  * to start tigervnc on server(do not worry, tiger vnc client resolution auto resize is supported :))
  * (one time only)
```
tigervncserver -localhost yes -geometry 1024x768 -depth 16 :1
```
  * after executing above command wait a few seconds and exit ssh connection

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

  * anyway it is recommended to start also GUI wallets inside GNU Screen because:
  *  if remote network connection slows down, it could be still managed by CLI
  *  All logs are easy to read with GNU screen
  *  It is more easy to automatize CLI commands with GNU screen
  *    [see Remote console management tips with Gnu Screen](./readme.remote.console.md)
  *    [see Semi/automatization startup](./readme.auto.md)

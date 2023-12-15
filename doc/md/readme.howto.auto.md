### 9. How start it all up automatically right after restart

  * once you are having screen start script generated, like
```
~/Downloads/ccwallets/dexsetup/start.screen.instance_default.cli.sh
```

  * if you want to be automatically started right after computer restart
  * Run command
```
crontab -e
```

  * And add line, but replace `username` with real user login name
```
@reboot bash /home/username/Downloads/ccwallets/dexsetup/start.screen.instance_default.cli.sh
```

  * automatic startup script with graphical user interface or inside VNC is not done
  * TODO

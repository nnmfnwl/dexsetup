### 13. Cool Free-Speech Privacy Apps setup and profile management from official repositories

**TOR BROWSER download or build from official repositories:**
  * setup by downloading precompiled packages takes on slow machine ~4 minutes
  * setup by compilation from source code takes on slow machine a hours...
  * setup process is securely sandboxed and network privacy protected by firejail and proxychains(tor)
  
  * to setup latest default `tor browser` by `downloading` and `installing` to default `directory`
```
./setup.torbrowser.sh download install
```
  * it is not recommended to use `tor browser` app directly but by below privacy security sandbox profile
  * to create `default` `tor browser` sandbox profile start script `firejail.torbrowser.default.sh`
```
./setup.torbrowser.firejail.sh default
```
  * successful result of both above commands is
    * downloaded torbrowser at `<DEXSETUP root>/tor_browser/latest/data/download/pkg/`
    * torbrowser default profile files at `<DEXSETUP root>/tor_browser/latest/data/profile/default/`
    * torbrowser default profile start script at `<DEXSETUP root>/tor_browser/latest/firejail.torbrowser.default.sh`
  * for more information about script usage read full help
```
./setup.torbrowser.sh help | less
./setup.torbrowser.firejail.sh help | less
```

**Session Ultimate Privacy Messenger download or build from official repositories:**
  * setup by downloading precompiled packages takes on slow machine ~4 minutes
  * setup by compilation from source code takes on slow machine a hours...
  * setup process is securely sandboxed and network privacy protected by firejail and proxychains(tor)
  
  * to setup latest default `Session messenger` by `downloading` and `installing` to default `directory`
```
./setup.session.sh download install
```
  * it is not recommended to use `session` app directly but by below privacy security sandbox profile
  * to create `default` `session` sandbox profile start script `firejail.session.default.sh`
```
./setup.session.firejail.sh default
```
  * successful result of both above commands is
    * downloaded session at `<DEXSETUP root>/session/latest/data/download/pkg/`
    * session default profile files at `<DEXSETUP root>/session/latest/data/profile/default/`
    * session default profile start script at `<DEXSETUP root>/session/latest/firejail.session.default.sh`
  * for more information about script usage read full help
```
./setup.session.sh help | less
./setup.session.firejail.sh help | less
```

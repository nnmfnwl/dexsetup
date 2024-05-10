### 7. BlockDX - The graphical user interface for BLOCKNET DEX setup from official repositories

**To download or build BlockDX from official repositories:**
  * setup by downloading precompiled packages takes on slow machine ~4 minutes
  * setup by compilation from source code takes on slow machine a hours...
  * build process is securely sandboxed and privacy protected by proxychains(tor)
  * all needed configuration is updated automatically
  
  * following command is to setup latest default `blockdx` by `downloading` and `installing` to default `directory`
```
./setup.cc.blockdx.sh download install
```
  
  * it is not recommended to use blockdx app directly but below privacy security sandbox profile
  * following command is to setup default installed `blockdx` with default installed `blocknet` and create blockdx firejail sandbox profile start script `firejail.blockdx.default.sh`
```
./setup.cc.blockdx.firejail.sh
```
  
  * successful result of both above commands is
    * downloaded blockdx at `<DEXSETUP root>/blockdx/latest/data/download/pkg/`
    * binary files extracted at `<DEXSETUP root>/blockdx/latest/data/download/bin/`
    * blockdx default profile start script at `<DEXSETUP root>/blockdx/latest/firejail.blockdx.default.sh`
    * blockdx default profile files at `<DEXSETUP root>/blockdx/latest/data/profile/default/`

**Help tips**
  * in certain cases download error could happen, because of used proxychains
  * for this case try again by replacing "install" with "update"
```
./setup.cc.blockdx.sh download update
```
  * if download problem persist try to add "noproxychains" option to try to download over clear-net
```
./setup.cc.blockdx.sh download update noproxychains
```
  * for more information about dowload/build scripts and how to use optional arguments, please read help
```
./setup.cc.blockdx.sh help | less
./setup.cc.blockdx.firejail.sh help | less
```

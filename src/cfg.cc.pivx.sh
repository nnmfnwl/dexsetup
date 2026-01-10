cc_setup_helper_version="20210827"

# include defaults
source "$(dirname "${BASH_SOURCE[0]}")/cfg.cc.defaults.sh" || exit 1

cc_ticker="PIVX"
cc_bin_file_name_prefix="pivx"
cc_gui_cfg_dir_name="PIVX"

cc_install_dir_path_default="pivx"
cc_chain_dir_path_default="~/.pivx"
cc_wallet_name_default="wallet_pivx_dex"
cc_conf_name_default="pivx.conf"

cc_download_url_x86_64="https://github.com/PIVX-Project/PIVX/releases/download/v5.6.1/pivx-5.6.1-x86_64-linux-gnu.tar.gz"
cc_download_sha512sum_x86_64="6b1c83bd60d2930d012abfddf309a2aa45ee5c3ee634170eea6f7b6d57847b51e4915e6609b21aef0d5ecedade20387c49bf79b9627964b8ea4c180ea3c24024"

cc_download_url_i686="https://github.com/PIVX-Project/PIVX/releases/download/v5.6.1/pivx-5.6.1-i686-pc-linux-gnu.tar.gz"
cc_download_sha512sum_i686="4ff0057d27d4006a534632c6b37cfbf2ae7cfb91c51b4856d31ba5f9a09c24c1df3d76d3b5132861b8c35abe7beec759efd466eda43649ed56683842adac75ba"

cc_download_url_arm="https://github.com/PIVX-Project/PIVX/releases/download/v5.6.1/pivx-5.6.1-arm-linux-gnueabihf.tar.gz"
cc_download_sha512sum_arm="c7c079efd8daf6edc10654a3390edfd752353469a6791b4415a00c9f0d723d132acbc4e37b5735e0061296816a7844653da982b6d0651fcaa79f71112fba7597"

cc_download_url_aarch64="https://github.com/PIVX-Project/PIVX/releases/download/v5.6.1/pivx-5.6.1-aarch64-linux-gnu.tar.gz"
cc_download_sha512sum_aarch64="2a2544782a381e706a823fba6288a9d51cb555ab98881ec6b1d356c9cd23f1b56248dd94527c78552c54c458d7373d279f08bf732fa814bf03d219e226b249b2"

cc_download_extracted_bin_files_dir="pivx-5.6.1/bin"

export CC=clang
export CXX=clang++

cc_command_post_git='
mkdir -p ${cc_git_src_path}/cargo_ln_to_home &&
ln -s ${cc_git_src_path}/cargo_ln_to_home ~/.cargo
'

#~ cc_firejail_make_args='
#~ --mkdir=$HOME/.cargo 
#~ --noblacklist=$HOME/.cargo 
#~ --whitelist=$HOME/.cargo 
#~ --read-write=$HOME/.cargo 
#~ --mkdir=$HOME/.pivx-params 
#~ --noblacklist=$HOME/.pivx-params 
#~ --whitelist=$HOME/.pivx-params 
#~ '

cc_firejail_make_args='
--mkdir=$HOME/.pivx-params 
--noblacklist=$HOME/.pivx-params 
--whitelist=$HOME/.pivx-params 
'

cc_firejail_profile_add='
mkdir ${HOME}/.pivx-params
noblacklist ${HOME}/.pivx-params
whitelist ${HOME}/.pivx-params
'

cc_git_src_url="https://github.com/PIVX-Project/PIVX.git"
cc_git_src_branch="v5.6.1"
cc_git_src_branch="2e9ce171d00ece29a73a75d037a0867c3b2fc83d"
cc_git_commit_id="2e9ce171d00ece29a73a75d037a0867c3b2fc83d"

cc_make_depends="bdb"
cc_make_depends_debian12="${cc_make_depends}"
cc_make_depends_debian13="${cc_make_depends}"

cc_make_depends_ubuntu="bdb boost"
cc_make_depends_ubuntu24="${cc_make_depends_ubuntu}"
cc_make_depends_ubuntu25="${cc_make_depends_ubuntu}"

cc_command_configure='
./configure --quiet
LDFLAGS="-L`pwd`/depends/${cc_archdir}/lib/"
CPPFLAGS="-I`pwd`/depends/${cc_archdir}/include/"
CXXFLAGS="-O3 -march=native"
--disable-bench --disable-gui-tests --disable-tests
--enable-reduce-exports --without-miniupnpc --without-zmq
--with-gui=auto
'
cc_command_configure_debian12="${cc_command_configure}"
cc_command_configure_debian13="${cc_command_configure}"

cc_command_configure_ubuntu='
./configure --quiet
LDFLAGS="-L`pwd`/depends/${cc_archdir}/lib/"
CPPFLAGS="-I`pwd`/depends/${cc_archdir}/include/"
CXXFLAGS="-O3 -march=native"
--with-boost-libdir=`pwd`/depends/${cc_archdir}/lib/
--disable-bench --disable-gui-tests --disable-tests
--enable-reduce-exports --without-miniupnpc --without-zmq
--with-gui=auto
'
cc_command_configure_ubuntu24="${cc_command_configure_ubuntu}"
cc_command_configure_ubuntu25="${cc_command_configure_ubuntu}"


# HINT >> add to above configure parameter to compile with debug symbols >>
# --enable-debug

cc_command_pre_make='
filepath="src/chiabls/src/threshold.cpp" &&
strnext="schemes.hpp" &&
stradd="#include <memory>" &&
((cat ${filepath} | grep "${stradd}") || sed -i -e "/${strnext}/ a ${stradd}" ${filepath})
'

cc_command_post_make='
./params/install-params.sh
'

cc_command_post_extract='
cd ./pivx-5.6.1/ && ./install-params.sh
'

# conf file will scanned and comment existing conflist lines
# config to add be be line by line evaluated and added

cc_port=52472
cc_rpcport=52473
cc_rpcuser="BlockDXPIVX"
#~ cc_rpcpassword=`cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 32 | head -n 1`
cc_rpcpassword=`tr -dc A-Za-z0-9 </dev/urandom | head -c 32`

# lines will eval before add
cc_main_cfg_add='
server=1
listen=1
port=${cc_port}

rpcbind=127.0.0.1
rpcallowip=127.0.0.1
rpcport=${cc_rpcport}
rpcuser=${cc_rpcuser}
rpcpassword=${cc_rpcpassword}

listenonion=0
onlynet=ipv6
onlynet=ipv4=multi
onlynet=onion=multi
onion=127.0.0.1:9050
bind=127.0.0.1
bantime=180

maxconnections=7
maxuploadtarget=777

txindex=1

staking=0
'

cc_xbridge_cfg_add='
Title=PIVX
Address=
Ip=127.0.0.1
Port=${cc_rpcport}
Username=${cc_rpcuser}
Password=${cc_rpcpassword}
AddressPrefix=30
ScriptPrefix=13
SecretPrefix=212
COIN=100000000
MinimumAmount=0
TxVersion=1
DustAmount=0
CreateTxMethod=BTC
GetNewKeySupported=false
ImportWithNoScanSupported=true
MinTxFee=10000
BlockTime=60
FeePerByte=20
Confirmations=0
'

# list of incompatible CLI commands surrounded with spaces
cc_cli_not_compatible='
 unlock.new 
 getstakinginfo 
 getstakereport 
'

cc_setup_helper_version="20210827"

# include defaults
source "$(dirname "${BASH_SOURCE[0]}")/cfg.cc.defaults.sh" || exit 1

cc_ticker="PKOIN"
cc_bin_file_name_prefix="pocketcoin"
cc_gui_cfg_dir_name="Pocketcoin"

cc_install_dir_path_default="pocketcoin"
cc_chain_dir_path_default="~/.pocketcoin"
cc_wallet_name_default="wallet_pkoin_dex"
cc_conf_name_default="pocketcoin.conf"


export CC=clang
export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add=''

cc_git_src_url="https://github.com/pocketnetteam/pocketnet.core.git"
cc_git_src_branch_master="0.22"
#~ cc_git_src_branch="feature/sqlite"
#~ cc_git_commit_id="cb78e60beef40e0293b1ed1b5b70a8782c0ee5ec"
cc_git_src_branch="0.22.19"
cc_git_commit_id="802b7cef8112c380538119f667f09646a871a47e"
#~ cc_git_src_branch="fix/stake_worker_wallet_access"
#~ cc_git_commit_id="1530f7e3cfdcde83790284d0cadf1111ad143a63"

cc_make_depends="bdb"
cc_make_depends_ubuntu="bdb boost"

cc_command_configure='
./configure
LDFLAGS="-L`pwd`/depends/${cc_archdir}/lib/"
CPPFLAGS="-I`pwd`/depends/${cc_archdir}/include/"
CXXFLAGS="-O3 -march=native"
--disable-bench --disable-gui-tests --disable-tests
--enable-reduce-exports --without-miniupnpc --without-zmq
--with-gui=auto
'

cc_command_configure_ubuntu='
./configure
LDFLAGS="-L`pwd`/depends/${cc_archdir}/lib/"
CPPFLAGS="-I`pwd`/depends/${cc_archdir}/include/"
CXXFLAGS="-O3 -march=native"
--with-boost-libdir=`pwd`/depends/${cc_archdir}/lib/
--disable-bench --disable-gui-tests --disable-tests
--enable-reduce-exports --without-miniupnpc --without-zmq
--with-gui=auto
'

# HINT >> add to above configure parameter to compile with debug symbols >>
# --enable-debug

cc_command_pre_make=''

cc_command_post_make=''

# conf file will scanned and comment existing conflist lines
# config to add be be line by line evaluated and added

cc_port=37070
cc_rpcport=37071
cc_rpcuser="BlockDXpocketcoin"
#~ cc_rpcpassword=`cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 32 | head -n 1`
cc_rpcpassword=`tr -dc A-Za-z0-9 </dev/urandom | head -c 32`

# lines will eval before add
cc_main_cfg_add='
listen=1
server=1
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

maxconnections=17
maxuploadtarget=1777

txindex=1

blocksonly=1

staking=0

walletbroadcast=1

api=0

disconnectold=1
'

cc_xbridge_cfg_add='
Title=PocketCoin
Ip=127.0.0.1
Port=${cc_rpcport}
AddressPrefix=55
ScriptPrefix=80
SecretPrefix=33
COIN=100000000
MinimumAmount=0
TxVersion=1
DustAmount=0
CreateTxMethod=BTC
GetNewKeySupported=true
ImportWithNoScanSupported=true
MinTxFee=10000
BlockTime=60
FeePerByte=20
Confirmations=0
Username=${cc_rpcuser}
Password=${cc_rpcpassword}
Address=
TxWithTimeField=false
LockCoinsSupported=false
JSONVersion=
ContentType=
CashAddrPrefix=
'

# list of incompatible CLI commands surrounded with spaces
cc_cli_not_compatible='
 unlock.new 
 unlock.staking.only 
 getstakingstatus 
 dxcmdall 
'

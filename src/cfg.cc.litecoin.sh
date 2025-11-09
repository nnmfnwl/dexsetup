cc_setup_helper_version="20210827"

# include defaults
source "$(dirname "${BASH_SOURCE[0]}")/cfg.cc.defaults.sh" || exit 1

cc_ticker="LTC"
cc_bin_file_name_prefix="litecoin"
cc_gui_cfg_dir_name="Litecoin"

cc_install_dir_path_default="litecoin"
cc_chain_dir_path_default="~/.litecoin"
cc_wallet_name_default="wallet_ltc_dex"
cc_conf_name_default="litecoin.conf"

export CC=clang
export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add=''

cc_git_src_url="https://github.com/litecoin-project/litecoin.git"
cc_git_src_branch="v0.21.4"
cc_git_commit_id="beae01d62292a0aab363b7a4d3f606708cea7260"

cc_make_depends="bdb"
cc_make_depends_ubuntu="bdb boost"

cc_command_configure='
./configure --quiet
LDFLAGS="-L`pwd`/depends/${cc_archdir}/lib/"
CPPFLAGS="-I`pwd`/depends/${cc_archdir}/include/"
CXXFLAGS="-O3 -march=native"
--disable-bench --disable-gui-tests --disable-tests
--enable-reduce-exports --without-miniupnpc --without-zmq
--with-gui=auto
'

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

# HINT >> add to above configure parameter to compile with debug symbols >>
# --enable-debug

cc_command_pre_make='
'

# conf file will scanned and comment existing conflist lines
# config to add be be line by line evaluated and added

cc_port=9333
cc_rpcport=9332
cc_rpcuser="BlockDXLitecoin"
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

addresstype=legacy
changetype=legacy

deprecatedrpc=signrawtransaction
'

cc_xbridge_cfg_add='
Title=Litecoin
Ip=127.0.0.1
Port=${cc_rpcport}
AddressPrefix=48
ScriptPrefix=50
SecretPrefix=176
COIN=100000000
MinimumAmount=0
DustAmount=0
CreateTxMethod=BTC
GetNewKeySupported=true
ImportWithNoScanSupported=true
FeePerByte=10
MinTxFee=5000
TxVersion=2
BlockTime=150
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
 getstakingstatus 
 getstakinginfo 
 getstakereport 
'

cc_cli_add=(
'addnode.onetry.auto'
'./cli addnode "95.216.39.190:9333" onetry'
)

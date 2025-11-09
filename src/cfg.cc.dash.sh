cc_setup_helper_version="20210827"

# include defaults
source "$(dirname "${BASH_SOURCE[0]}")/cfg.cc.defaults.sh" || exit 1

cc_ticker="DASH"
cc_bin_file_name_prefix="dash"
cc_gui_cfg_dir_name="Dash"

cc_install_dir_path_default="dash"
cc_chain_dir_path_default="~/.dashcore"
cc_wallet_name_default="wallet_dash_dex"
cc_conf_name_default="dash.conf"


export CC=clang
export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add='
#~ mkdir ${cc_chain_dir_path}/${cc_wallet_name}
'

cc_git_src_url="https://github.com/dashpay/dash.git"
#~ cc_git_src_branch="v19.2.0"
#~ cc_git_commit_id="549e347b742cb4dc63807a292729e658218d7d0f"
cc_git_src_branch="v20.1.1"
cc_git_commit_id="19512988c6e6e8641245bd9c5fab21dd737561f0"

cc_make_depends="bdb backtrace"
cc_make_depends_debian12="bdb boost backtrace"
cc_make_depends_ubuntu="${cc_make_depends_debian12}"

cc_command_configure='
./configure --quiet
LDFLAGS="-L`pwd`/depends/${cc_archdir}/lib/"
CPPFLAGS="-I`pwd`/depends/${cc_archdir}/include/"
CXXFLAGS="-O3 -march=native"
--disable-bench --disable-gui-tests --disable-tests
--enable-reduce-exports --without-miniupnpc --without-zmq
--with-gui=auto
'

cc_command_configure_debian12='
./configure --quiet
LDFLAGS="-L`pwd`/depends/${cc_archdir}/lib/"
CPPFLAGS="-I`pwd`/depends/${cc_archdir}/include/"
CXXFLAGS="-O3 -march=native"
--with-boost-libdir=`pwd`/depends/${cc_archdir}/lib/
--disable-bench --disable-gui-tests --disable-tests
--enable-reduce-exports --without-miniupnpc --without-zmq
--with-gui=auto
'
cc_command_configure_ubuntu="${cc_command_configure_debian12}"

# HINT >> add to above configure parameter to compile with debug symbols >>
# --enable-debug

cc_command_pre_make='
filepath="src/qt/trafficgraphwidget.cpp" &&
((cat ${filepath} | grep "#include <QPainterPath>") || sed -i -e "/#include <QPainter>/ a #include <QPainterPath>" ${filepath})
'

cc_command_post_make=''

# conf file will scanned and comment existing conflist lines
# config to add be be line by line evaluated and added

cc_port=9999
cc_rpcport=9998
cc_rpcuser="BlockDXDash"
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

maxconnections=7
maxuploadtarget=777

txindex=1
'

cc_xbridge_cfg_add='
Title=Dash
Address=
Ip=127.0.0.1
Port=${cc_rpcport}
Username=${cc_rpcuser}
Password=${cc_rpcpassword}
AddressPrefix=76
ScriptPrefix=16
SecretPrefix=204
COIN=100000000
MinimumAmount=0
TxVersion=1
DustAmount=0
CreateTxMethod=BTC
GetNewKeySupported=false
ImportWithNoScanSupported=true
MinTxFee=2500
BlockTime=150
FeePerByte=5
Confirmations=0
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
'./cli addnode "gbg2wd4uwc5k7w5j3w46zre6r5ioezulgjriketxv4qekybzg2zwdnid.onion:9999" onetry
./cli addnode "k6bzqtkhtzyziethin3kkys342rlzcmqkrs5ibashqclcu23ehuz6oqd.onion:9999" onetry
./cli addnode "46.4.217.251:9999" onetry
./cli addnode "149.248.0.248:9999" onetry
'
)

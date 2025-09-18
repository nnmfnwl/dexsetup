cc_setup_helper_version="20210827"

cc_ticker="XVG"
cc_bin_file_name_prefix="verge"
cc_gui_cfg_dir_name="VERGE"

cc_install_dir_path_default="verge"
cc_chain_dir_path_default="~/.VERGE"
cc_wallet_name_default="wallet_xvg_dex"
cc_conf_name_default="VERGE.conf"


#~ export CC=clang
#~ export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add=''

cc_git_src_url="https://github.com/vergecurrency/verge.git"
cc_git_src_branch="v7.12.0"
cc_git_commit_id="aae9d147c9bf0e5c8cadbc0e7ba41bdc9ac522ff"

cc_make_cpu_threads=3

cc_make_depends="bdb boost"

cc_command_configure='
./configure
LDFLAGS="-L`pwd`/depends/${cc_archdir}/lib/"
CPPFLAGS="-I`pwd`/depends/${cc_archdir}/include/"
CXXFLAGS="-O3 -march=native"
--with-boost-libdir=`pwd`/depends/${cc_archdir}/lib/
--disable-bench --disable-gui-tests --disable-tests --without-tests
--enable-reduce-exports --without-miniupnpc
--with-gui=auto
'

# HINT >> add to above configure parameter to compile with debug symbols >>
# --enable-debug

cc_command_pre_make='
filepath="src/qt/trafficgraphwidget.cpp" &&
((cat ${filepath} | grep "#include <QPainterPath>") || sed -i -e "/#include <QPainter>/ a #include <QPainterPath>" ${filepath})
'

# conf file will scanned and comment existing conflist lines
# config to add be be line by line evaluated and added

cc_port=21102
cc_rpcport=20102
cc_rpcuser="BlockDXVerge"
cc_rpcpassword=`cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 32 | head -n 1`

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
onlynet=onion
onlynet=ipv6
onlynet=ipv4
#~ proxy=127.0.0.1:9050
onion=127.0.0.1:9050
bind=127.0.0.1
bantime=180

maxconnections=7
maxuploadtarget=777

txindex=1

dynamic-network=true
without-tor=true
'

cc_xbridge_cfg_add='
Title=Verge
Ip=127.0.0.1
Port=${cc_rpcport}
AddressPrefix=30
ScriptPrefix=33
SecretPrefix=158
COIN=1000000
MinimumAmount=0
TxVersion=1
DustAmount=0
CreateTxMethod=BTC
GetNewKeySupported=true
ImportWithNoScanSupported=true
MinTxFee=400000
BlockTime=30
FeePerByte=200
Confirmations=0
TxWithTimeField=true
LockCoinsSupported=false
Username=${cc_rpcuser}
Password=${cc_rpcpassword}
Address=
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

cc_setup_helper_version="20210827"

cc_ticker="DOGE"
cc_bin_file_name_prefix="dogecoin"
cc_gui_cfg_dir_name="Dogecoin"

cc_install_dir_path_default="dogecoin"
cc_chain_dir_path_default="~/.dogecoin"
cc_wallet_name_default="wallet_doge.dat"
cc_conf_name_default="dogecoin.conf"


export CC=clang
export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add=''

cc_git_src_url="https://github.com/dogecoin/dogecoin.git"
cc_git_src_branch="v1.14.7"
cc_git_commit_id="a6d12201363b0eb4ccf854b609fc6e98958b1443"

cc_make_cpu_threads=4

cc_make_depends="bdb"

cc_command_configure='
./configure --quiet
LDFLAGS="-L`pwd`/depends/${cc_archdir}/lib/"
CPPFLAGS="-I`pwd`/depends/${cc_archdir}/include/"
CXXFLAGS="-O3 -march=native"
--disable-bench --disable-gui-tests --disable-tests
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

cc_port=22556
cc_rpcport=22555
cc_rpcuser="BlockDXDogecoin"
cc_rpcpassword=`cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 32 | head -n 1`

# lines will eval before add
cc_main_cfg_add='
listen=1
server=1

rpcbind=127.0.0.1
rpcallowip=127.0.0.1
port=${cc_port}
rpcport=${cc_rpcport}
rpcuser=${cc_rpcuser}
rpcpassword=${cc_rpcpassword}
txindex=1

bantime=180

maxuploadtarget=1500
'

cc_xbridge_cfg_add='
Title=Dogecoin
Ip=127.0.0.1
Port=${cc_rpcport}
AddressPrefix=30
ScriptPrefix=22
SecretPrefix=158
COIN=100000000
MinimumAmount=0
TxVersion=1
DustAmount=0
CreateTxMethod=BTC
GetNewKeySupported=false
ImportWithNoScanSupported=true
MinTxFee=2000000
BlockTime=60
FeePerByte=2000
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

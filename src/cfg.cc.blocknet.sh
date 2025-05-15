cc_setup_helper_version="20210827"

cc_ticker="BLOCK"
cc_bin_file_name_prefix="blocknet"
cc_gui_cfg_dir_name="Blocknet"

cc_install_dir_path_default="blocknet"
cc_chain_dir_path_default="~/.blocknet"
cc_wallet_name_default="wallet_block"
cc_conf_name_default="blocknet.conf"
cc_xbridge_cfg_name_default="xbridge.conf"

export CC=clang
export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add=''

cc_git_src_url="https://github.com/blocknetdx/blocknet.git"
cc_git_src_branch="v4.4.1"
cc_git_commit_id="ac930b7f80c1773688a24f7519e2df2effa795d4"

cc_make_cpu_threads=4

cc_make_depends="bdb boost"

cc_command_configure='
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
filepath="src/qt/trafficgraphwidget.cpp" &&
((cat ${filepath} | grep "#include <QPainterPath>") || sed -i -e "/#include <QPainter>/ a #include <QPainterPath>" ${filepath}) &&

filepath="src/qt/blocknetaddresseditor.cpp" &&
((cat ${filepath} | grep "#include <QPainterPath>") || sed -i -e "/#include <QPainter>/ a #include <QPainterPath>" ${filepath}) &&

filepath="src/qt/blocknetavatar.cpp" &&
((cat ${filepath} | grep "#include <QPainterPath>") || sed -i -e "/#include <QPainter>/ a #include <QPainterPath>" ${filepath}) &&

filepath="src/qt/blocknetbreadcrumb.cpp" &&
((cat ${filepath} | grep "#include <QPainterPath>") || sed -i -e "/#include <QPainter>/ a #include <QPainterPath>" ${filepath}) &&

filepath="src/qt/blocknetavatar.cpp" &&
((cat ${filepath} | grep "#include <QPainterPath>") || sed -i -e "/#include <QPainter>/ a #include <QPainterPath>" ${filepath}) &&

filepath="src/qt/blocknetcircle.cpp" &&
((cat ${filepath} | grep "#include <QPainterPath>") || sed -i -e "/#include <QPainter>/ a #include <QPainterPath>" ${filepath}) &&

filepath="src/qt/blockneticonbtn.cpp" &&
((cat ${filepath} | grep "#include <QPainterPath>") || sed -i -e "/#include <QPainter>/ a #include <QPainterPath>" ${filepath})
'

cc_command_post_make=''

# conf file will scanned and comment existing conflist lines
# config to add be be line by line evaluated and added

cc_port=41412
cc_rpcport=41414
cc_rpcuser="BlockDXBlocknet"
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

dxnowallets=1

classic=1
staking=1

rpcworkqueue=256

bantime=180

maxuploadtarget=1500
'

cc_xbridge_cfg_add='
Title=Blocknet
Ip=127.0.0.1
Port=${cc_rpcport}
AddressPrefix=26
ScriptPrefix=28
SecretPrefix=154
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
 getstakinginfo 
 getstakereport
'

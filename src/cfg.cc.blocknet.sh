cc_setup_helper_version="20210827"

cc_ticker="BLOCK"
cc_bin_file_name_prefix="blocknet"
cc_gui_cfg_dir_name="Blocknet"

cc_install_dir_path_default="blocknet"
cc_chain_dir_path_default="~/.blocknet"
cc_wallet_name_default="wallet_block_dex"
cc_conf_name_default="blocknet.conf"
cc_xbridge_cfg_name_default="xbridge.conf"

cc_download_url_x86_64="https://github.com/blocknetdx/blocknet/releases/download/v4.4.1/blocknet-4.4.1-x86_64-linux-gnu.tar.gz"
cc_download_sha512sum_x86_64="e6104098856c3e51d0fef9b933d383af89737210e5974a6f494bc0235a888b9efbdd3715132531af5554cabcfe18ab76f7b54ebfda1cc8d793a3fead175bd539"
cc_download_sha256sum_aarch64="f6e89043e54560415f657b6c9b1c3932512e2fbc3ff109119798b1d71ecc1041"

cc_download_url_i686=""
cc_download_sha512sum_i686=""

cc_download_url_arm=""
cc_download_sha512sum_arm=""

cc_download_url_aarch64="https://github.com/blocknetdx/blocknet/releases/download/v4.4.1/blocknet-4.4.1-aarch64-linux-gnu.tar.gz"
cc_download_sha512sum_aarch64="4dfe0b4859909e4f4a802323230a708adf5f3c7596b2d00e10f70d6581379dd83cf2c5c1930b31b53befb921bb3ec143f6faf1054d4d3b37e170191ba2e504c2"
cc_download_sha256sum_aarch64="be0b81dd7100afacac57f34f33e90e96ae90a5c84d2075350330ba5918e1604e"

cc_download_url_riscv64="https://github.com/blocknetdx/blocknet/releases/download/v4.4.1/blocknet-4.4.1-riscv64-linux-gnu.tar.gz"
cc_download_sha512sum_riscv64="9f447d90e048c1d1d92f8d76428b9595c9688148ecaea162e2f638442a6ca5a88273cbe40bc5edc7901123e5f58edabe285b0615e2b4272a1e23fac5470fde33"
cc_download_sha256sum_aarch64="ccd1be2cad8de46ecb9d15184fc77d827b637d93fac768c8de444d9f7bccd6e1"

cc_download_extracted_bin_files_dir="blocknet-4.4.1/bin"

export CC=clang
export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add=''

cc_git_src_url="https://github.com/blocknetdx/blocknet.git"
cc_git_src_branch="v4.4.1"
cc_git_commit_id="ac930b7f80c1773688a24f7519e2df2effa795d4"

cc_make_cpu_threads=3

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
#Accept connections from outside (default: 1 if no -proxy or -connect)
listen=1
server=1
port=${cc_port}

rpcbind=127.0.0.1
rpcallowip=127.0.0.1
rpcport=${cc_rpcport}
rpcuser=${cc_rpcuser}
rpcpassword=${cc_rpcpassword}

#Automatically create Tor hidden service (default: 1)
listenonion=0
#~ onlynet=<net>
# Make outgoing connections only through network <net> (ipv4, ipv6 or
# onion). Incoming connections are not affected by this option.
# This option can be specified multiple times to allow multiple networks.
onlynet=ipv6
onlynet=ipv4
onlynet=onion
#proxy=127.0.0.1:9050
onion=127.0.0.1:9050
bind=127.0.0.1
bantime=180

maxconnections=7
maxuploadtarget=777

txindex=1

dxnowallets=1

classic=1
staking=0

rpcworkqueue=256

#rpcxbridgetimeout - Timeout for internal XBridge RPC calls (default: 120 seconds)
rpcxbridgetimeout=210
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

cc_cli_add=(
'addnode.onetry.auto'
'./cli addnode "185.231.155.27:41412" onetry'

'dxSplitAddress'
'./cli dxSplitAddress \$@'
)

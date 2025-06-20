cc_setup_helper_version="20210827"

cc_ticker="LBC"
cc_bin_file_name_prefix="lbrycrd"
cc_gui_cfg_dir_name="LBRY"

cc_install_dir_path_default="lbrycrd/sqlite"
cc_chain_dir_path_default="~/.lbrycrd.sqlite"
cc_wallet_name_default="wallet_lbc"
cc_conf_name_default="lbrycrd.conf"


export CC=gcc
export CXX=g++

cc_firejail_make_args=''

cc_firejail_profile_add=''

cc_git_src_url="https://github.com/lbryio/lbrycrd.git"
cc_git_src_branch="v0.17.4.6"
cc_git_commit_id="c9637f8e1c1a9a440d280d75777f3bc961edbf92"

cc_make_cpu_threads=3

cc_command_pre_depends='
filepath="depends/packages/boost.mk" &&
strsearch="_download_path" &&
stradd="\$(package)_download_path=https://boostorg.jfrog.io/artifactory/main/release/1.69.0/source/" &&
((cat ${filepath} | grep "${stradd}") || sed -i -e "s#.*${strsearch}.*#${stradd}#" ${filepath})
'

cc_make_depends="bdb boost"

cc_command_configure='
./configure --quiet
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
((cat ${filepath} | grep "#include <QPainterPath>") || sed -i -e "/#include <QPainter>/ a #include <QPainterPath>" ${filepath}) &&

filepath="src/bitcoind.cpp" &&
((cat ${filepath} | grep "#include <limits>") || sed -i -e "/#include <chainparams.h>/ i #include <limits>" ${filepath}) &&

filepath="src/primitives/robin_hood.h" &&
((cat ${filepath} | grep "#include <limits>") || sed -i -e "/#include <algorithm>/ i #include <limits>" ${filepath}) &&

filepath="src/httprpc.cpp" &&
((cat ${filepath} | grep "#include <limits>") || sed -i -e "/#include <httprpc.h>/ i #include <limits>" ${filepath})
'

# conf file will scanned and comment existing conflist lines
# config to add be be line by line evaluated and added

cc_port=9248
cc_rpcport=9247
cc_rpcuser="BlockDXLBRYCredits"
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
onlynet=ipv6
onlynet=ipv4
onlynet=onion
onion=127.0.0.1:9050
bind=127.0.0.1
bantime=180

maxconnections=7

txindex=1

addresstype=legacy
changetype=legacy
deprecatedrpc=signrawtransaction

blocksonly=1

#claimtriecache=150
# sett claim trie cache size in megabytes (4 to 16384, default: 560)

#dbcache=150
# Set database cache size in megabytes (4 to 16384, default: 560)

#maxmempool=200
# Keep the transaction memory pool below <n> megabytes (default: 300)

#maxorphantx=100
# Keep at most <n> unconnectable transactions in memory (default: 100)

#memfile=2
# Use a memory mapped file for the claimtrie allocations (default: use RAM instead)

#persistmempool=0
# Whether to save the mempool on shutdown and load on restart (default: 1)

maxuploadtarget=777
# Tries to keep outbound traffic under the given target (in MiB per 24h),
# 0 = no limit (default: 0)

#uacomment=Blocknet.Blockdx

maxtxfee=0.5
dustrelayfee=0.00000001
'

cc_xbridge_cfg_add='
Title=LBRYCredits
Address=
Ip=127.0.0.1
Port=${cc_rpcport}
Username=${cc_rpcuser}
Password=${cc_rpcpassword}
AddressPrefix=85
ScriptPrefix=122
SecretPrefix=28
COIN=100000000
MinimumAmount=0
TxVersion=1
DustAmount=0
CreateTxMethod=BTC
GetNewKeySupported=false
ImportWithNoScanSupported=true
MinTxFee=20000
BlockTime=150
FeePerByte=40
Confirmations=0
'

# list of incompatible CLI commands surrounded with spaces
cc_cli_not_compatible='
 unlock.new 
 getstakingstatus 
 getstakinginfo 
 getstakereport 
'

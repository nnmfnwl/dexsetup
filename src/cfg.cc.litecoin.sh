cc_setup_helper_version="20210827"

cc_ticker="LTC"
cc_bin_file_name_prefix="litecoin"
cc_gui_cfg_dir_name="Litecoin"

cc_install_dir_path_default="litecoin"
cc_chain_dir_path_default="~/.litecoin"
cc_wallet_name_default="wallet_ltc"
cc_conf_name_default="litecoin.conf"

export CC=clang
export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add=''

cc_git_src_url="https://github.com/litecoin-project/litecoin.git"
cc_git_src_branch="0.18"
cc_git_commit_id="2eabb3a5ebdcd58252d244aa7b106c84c65cbabf"

cc_make_cpu_threads=4

cc_make_depends="bdb"

cc_command_configure='
./configure --quiet
LDFLAGS="-L`pwd`/depends/${cc_archdir}/lib/"
CPPFLAGS="-I`pwd`/depends/${cc_archdir}/include/"
CXXFLAGS="-O3 -march=native"

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
cc_rpcpassword=`cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 32 | head -n 1`

# lines will eval before add
cc_main_cfg_add='
server=1
listen=1

rpcbind=127.0.0.1
rpcallowip=127.0.0.1
port=${cc_port}
rpcport=${cc_rpcport}
rpcuser=${cc_rpcuser}
rpcpassword=${cc_rpcpassword}
txindex=1
addresstype=legacy
changetype=legacy
deprecatedrpc=signrawtransaction

bantime=180

maxuploadtarget=1500
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

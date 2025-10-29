cc_setup_helper_version="20210827"

cc_ticker="BTC"
cc_bin_file_name_prefix="bitcoin"
cc_gui_cfg_dir_name="Bitcoin"

cc_install_dir_path_default="bitcoin"
cc_chain_dir_path_default="~/.bitcoin"
cc_wallet_name_default="wallet_btc_dex"
cc_conf_name_default="bitcoin.conf"


export CC=clang
export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add=''

cc_git_src_url="https://github.com/bitcoin/bitcoin.git"
cc_git_src_branch="v23.2"
cc_git_commit_id="4d2f2fae9782a4736c2e271f5d6107b677f2e14d"

cc_make_cpu_threads=3

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

cc_command_post_make=''

# conf file will scanned and comment existing conflist lines
# config to add be be line by line evaluated and added

cc_port=8333
cc_rpcport=8332
cc_rpcuser="BlockDXBitcoin"
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
onlynet=ipv4
onlynet=onion
onion=127.0.0.1:9050
bind=127.0.0.1
bantime=180

maxconnections=7
maxuploadtarget=777

txindex=1

addresstype=legacy
changetype=legacy
'

cc_xbridge_cfg_add='
Title=Bitcoin
Ip=127.0.0.1
Port=${cc_rpcport}
AddressPrefix=0
ScriptPrefix=5
SecretPrefix=128
COIN=100000000
MinimumAmount=0
TxVersion=2
DustAmount=0
CreateTxMethod=BTC
MinTxFee=12000
BlockTime=600
GetNewKeySupported=false
ImportWithNoScanSupported=false
FeePerByte=60
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
 unlock.old 
 getstakingstatus 
 getstakinginfo 
 getstakereport 
'

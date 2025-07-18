cc_setup_helper_version="20210827"

cc_ticker="BCH"
cc_bin_file_name_prefix="bitcoincash"
cc_gui_cfg_dir_name="Bitcoincash"

cc_install_dir_path_default="bitcoincash"
cc_chain_dir_path_default="~/.bitcoincash"
cc_wallet_name_default="wallet_bch"
cc_conf_name_default="bitcoin.conf"


export CC=clang
export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add=''

cc_git_src_url="https://gitlab.com/bitcoin-cash-node/bitcoin-cash-node.git"
cc_git_src_branch="v27.1.0"
cc_git_commit_id="9f9aa5a6e128a1c8b58b573ba44dcd0427fb8bf3"

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

cc_port=10333
cc_rpcport=10332
cc_rpcuser="BlockDXBitcoincash"
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

bantime=180

maxuploadtarget=1500
'

cc_xbridge_cfg_add='
Title=BitcoinCash
Address=
Ip=127.0.0.1
Port=${cc_rpcport}
Username=${cc_rpcuser}
Password=${cc_rpcpassword}
AddressPrefix=0
ScriptPrefix=5
SecretPrefix=128
COIN=100000000
MinimumAmount=0
TxVersion=2
DustAmount=0
CreateTxMethod=BCH
GetNewKeySupported=true
ImportWithNoScanSupported=true
MinTxFee=500
BlockTime=600
FeePerByte=2
Confirmations=0
'

# list of incompatible CLI commands surrounded with spaces
cc_cli_not_compatible='
 unlock.old 
 getstakingstatus 
 getstakinginfo 
 getstakereport 
'

cc_setup_helper_version="20210827"

cc_ticker="PART"
cc_bin_file_name_prefix="particl"
cc_gui_cfg_dir_name="Particl"

cc_install_dir_path_default="particl"
cc_chain_dir_path_default="~/.particl"
cc_wallet_name_default="wallet_part"
cc_conf_name_default="particl.conf"


export CC=clang
export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add=''

cc_git_src_url="https://github.com/particl/particl-core.git"
cc_git_src_branch="v0.19.2.23"
cc_git_commit_id="79ac84858bc33717ec572807f566acbc43dccd0e"

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

cc_port=51738
cc_rpcport=51735
cc_rpcuser="BlockDXParticl"
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
Title=Particl
Address=
Ip=127.0.0.1
Port=${cc_rpcport}
Username=${cc_rpcuser}
Password=${cc_rpcpassword}
AddressPrefix=56
ScriptPrefix=60
SecretPrefix=108
COIN=100000000
MinimumAmount=0
TxVersion=160
DustAmount=0
CreateTxMethod=PART
GetNewKeySupported=true
ImportWithNoScanSupported=true
MinTxFee=10000
BlockTime=120
FeePerByte=500
Confirmations=0
'

# list of incompatible CLI commands surrounded with spaces
cc_cli_not_compatible='
 unlock.new 
 getstakingstatus 
 getstakereport 
'

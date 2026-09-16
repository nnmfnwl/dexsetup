cc_setup_helper_version="20210827"

# include defaults
source "$(dirname "${BASH_SOURCE[0]}")/cfg.cc.defaults.sh" || exit 1

cc_ticker="SCC"
cc_bin_file_name_prefix="scc"
cc_gui_cfg_dir_name="StakeCubeCoin"

cc_install_dir_path_default="stakecubecoin"
cc_chain_dir_path_default="~/.stakecubecoin"
cc_wallet_name_default="wallet_scc_dex"
cc_conf_name_default="stakecubecoin.conf"


export CC=clang
export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add='
#mkdir ${cc_chain_dir_path}/${cc_wallet_name}
'

cc_git_src_url="https://github.com/stakecube/StakeCubeCoin.git"
cc_git_src_branch_master="develop"
cc_git_src_branch="v3.5.1.0"
cc_git_commit_id="1542625b0b3b56b8eb2ad8846bd66aa2507d7379"

cc_make_depends="bdb backtrace"
cc_make_depends_debian12="${cc_make_depends}"
cc_make_depends_debian13="${cc_make_depends}"
cc_make_depends_ubuntu24="${cc_make_depends}"
cc_make_depends_ubuntu25="${cc_make_depends}"

cc_command_configure='
./configure --quiet
LDFLAGS="-L`pwd`/depends/${cc_archdir}/lib/"
CPPFLAGS="-I`pwd`/depends/${cc_archdir}/include/"
CXXFLAGS="-O3 -march=native"
--disable-bench --disable-gui-tests --disable-tests
--enable-reduce-exports --without-miniupnpc --without-zmq
--with-gui=auto
'

cc_command_configure_debian12="${cc_command_configure}"
cc_command_configure_debian13="${cc_command_configure}"
cc_command_configure_ubuntu24="${cc_command_configure}"
cc_command_configure_ubuntu25="${cc_command_configure}"


# HINT >> add to above configure parameter to compile with debug symbols >>
# --enable-debug

cc_command_pre_make=''

cc_command_post_make=''

# conf file will scanned and comment existing conflist lines
# config to add be be line by line evaluated and added

cc_port=40000
cc_rpcport=39999
cc_rpcuser="BlockDXSCC"
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
Title=StakeCubeCoin
Address=
Ip=127.0.0.1
Port=${cc_rpcport}
Username=${cc_rpcuser}
Password=${cc_rpcpassword}
AddressPrefix=125
ScriptPrefix=117
SecretPrefix=253
COIN=100000000
MinimumAmount=0
TxVersion=2
DustAmount=0
CreateTxMethod=BTC
GetNewKeySupported=true
ImportWithNoScanSupported=true
MinTxFee=1000
BlockTime=120
FeePerByte=3
Confirmations=0
'

# list of incompatible CLI commands surrounded with spaces
cc_cli_not_compatible='
 unlock.old 
 getstakingstatus 
 getstakinginfo 
 getstakereport 
'

cc_cli_add=(
'unlock.mixingonly.only'
'./cli -stdinwalletpassphrase walletpassphrase 9999999999 true'

'addnode.onetry.auto'
'./cli addnode "[2001:470:7c:c2::4962]:40000" onetry
./cli addnode "[2001:470:7c:c2::7191]:40000" onetry
./cli addnode "[2a02:c207:2140:2630::55]:40000" onetry
./cli addnode "[2001:470:6d:47f::870]:40000" onetry
./cli addnode "[2001:470:7c:c2::49a0]:40000" onetry
./cli addnode "84.247.129.43:40000" onetry
./cli addnode "123.253.61.161:40000" onetry
'
)

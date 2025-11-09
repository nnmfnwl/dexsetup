cc_setup_helper_version="20210827"

# include defaults
source "$(dirname "${BASH_SOURCE[0]}")/cfg.cc.defaults.sh" || exit 1

cc_ticker="BCH"
cc_bin_file_name_prefix="bitcoin"
cc_gui_cfg_dir_name="Bitcoincash"

cc_install_dir_path_default="bitcoincash_node"
cc_chain_dir_path_default="~/.bitcoincash"
cc_wallet_name_default="wallet_bch_dex"
cc_conf_name_default="bitcoin.conf"

cc_git_src_url="https://github.com/bitcoin-cash-node/bitcoin-cash-node.git"
cc_git_src_branch_master="master"
cc_git_src_branch="v28.0.1"
cc_git_commit_id="631badbf64766fa8c2d38f099e937f8c6cb19014"

cc_download_url_x86_64="https://github.com/bitcoin-cash-node/bitcoin-cash-node/releases/download/v28.0.1/bitcoin-cash-node-28.0.1-x86_64-linux-gnu.tar.gz"
cc_download_sha512sum_x86_64="fad15a4f6352715a9dbbb0e288f8a1e96c6a24e3389d49975dc0663e20b9048437f2f0532f50b808526b061ebe68849d9d032e698541f2c53c3e4dc02eeca32c"
cc_download_sha256sum_x86_64="d69ee632147f886ca540cecdff5b1b85512612b4c005e86b09083a63c35b64fa"

cc_download_url_i686=""
cc_download_sha512sum_i686=""
cc_download_sha256sum_i686=""

cc_download_url_arm=""
cc_download_sha512sum_arm=""
cc_download_sha256sum_arm=""

cc_download_url_aarch64="https://github.com/bitcoin-cash-node/bitcoin-cash-node/releases/download/v28.0.1/bitcoin-cash-node-28.0.1-aarch64-linux-gnu.tar.gz"
cc_download_sha512sum_aarch64="pleaseupdatesha512"
cc_download_sha256sum_aarch64="pleaseupdatesha256"

cc_download_extracted_bin_files_dir="bitcoin-cash-node-28.0.1/bin" 

export CC=clang
export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add=''

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

#~ addresstype=legacy
#~ changetype=legacy
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

cc_setup_helper_version="20210827"

# include defaults
source "$(dirname "${BASH_SOURCE[0]}")/cfg.cc.defaults.sh" || exit 1

cc_ticker="BTX"
cc_bin_file_name_prefix="bitcore"
cc_gui_cfg_dir_name="Bitcore"

cc_install_dir_path_default="bitcore"
cc_chain_dir_path_default="~/.bitcore"
cc_wallet_name_default="wallet_btx_dex"
cc_conf_name_default="bitcore.conf"

cc_download_url_x86_64="https://github.com/bitcore-btx/BitCore/releases/download/0.90.9.10/bitcore-x86_64-linux-gnu_qt5-dev.tar.gz"
cc_download_sha512sum_x86_64="00685c12c0507c56df52f00cb2e6248ddec34367e926f4aff6b94069725a29a4e1e6c5752aff8e77efb775dd8749ba0f9be737deea9e23b7a73e6c77a680dbf1"
cc_download_sha256sum_aarch64="f6a92d07f1d760af28fba2ac127c4d18bedb62ca8d4f032801040fbd9fa80314"

cc_download_url_i686="https://github.com/bitcore-btx/BitCore/releases/download/0.90.9.10/bitcore-i686-pc-linux-gnu.tar.gz"
cc_download_sha512sum_i686="becad5398a6bab89ba9a400b799fa98bc9e825a53b3e11c1d8c35d2266a8b7a6312a9ea297ae064eb64ab50932698747c906c859dfef1b7ea237c991fcc126f5"
cc_download_sha256sum_i686="498bc46c6230a309d50c8fcae48ec3c841d407a436fdbf419b1440dc465de343"

cc_download_url_arm="https://github.com/bitcore-btx/BitCore/releases/download/0.90.9.10/bitcore-arm-linux-gnueabihf.tar.gz"
cc_download_sha512sum_arm="13bfdd950974b104064186b7d9ef52852d4faa7d330d51aff1396d857b0fa9e5703f4cd1b85435cb5c4be0a7fc0e1d77e1b8773b2a313c52a4da268c333b46f0"
cc_download_sha256sum_arm="0f5e7f4ea510e4cf416c09536def4e008330234d61a054ba6817b0c3ab30ebf4"

cc_download_url_aarch64=""
cc_download_sha512sum_aarch64=""
cc_download_sha256sum_aarch64=""

cc_download_url_riscv64=""
cc_download_sha512sum_riscv64=""
cc_download_sha256sum_aarch64=""

cc_download_extracted_bin_files_dir="bitcore/bin"

export CC=clang
export CXX=clang++
#~ export CXXFLAGS="-std=c++11 -O3 -march=native"
#~ export CFLAGS="-std=c++11 -O3 -march=native"

cc_firejail_make_args=''

cc_firejail_profile_add=''

cc_git_src_url="https://github.com/bitcore-btx/BitCore.git"
cc_git_src_branch="0.90.9.10"
cc_git_commit_id="4e66aaf6757b16092ab516b85eca14a5b70432f8"

cc_command_pre_depends='
filepath="depends/packages/bdb.mk" &&
strsearch="_config_opts_linux" &&
stradd="\$(package)_cflags+=-Wno-error=implicit-function-declaration" &&
((cat ${filepath} | grep "${stradd}") || sed -i -e "/${strsearch}/ a ${stradd}" ${filepath})
'

cc_make_depends="bdb"
cc_make_depends_debian12="bdb boost"
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
cc_command_configure_debian13="${cc_command_configure}"
cc_command_configure_ubuntu24="${cc_command_configure}"
cc_command_configure_ubuntu25="${cc_command_configure}"

cc_command_configure_debian12='
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
'

cc_command_post_make=''

# conf file will scanned and comment existing conflist lines
# config to add be be line by line evaluated and added

cc_port=8555
cc_rpcport=8556
cc_rpcuser="BlockDXBitcore"
#~ cc_rpcpassword=`cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 32 | head -n 1`
cc_rpcpassword=`tr -dc A-Za-z0-9 </dev/urandom | head -c 32`

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

listenonion=0
onlynet=ipv6
onlynet=ipv4=multi
onlynet=onion=multi
#proxy=127.0.0.1:9050
onion=127.0.0.1:9050
bind=127.0.0.1
bantime=180

maxconnections=7
maxuploadtarget=777

txindex=1

# staking=0

# Legacy addresses must be used
addresstype=legacy
changetype=legacy
'

cc_xbridge_cfg_add='
Title=BitCore
Ip=127.0.0.1
Port=${cc_rpcport}
AddressPrefix=3
ScriptPrefix=125
SecretPrefix=128
COIN=100000000
MinimumAmount=0
TxVersion=2
DustAmount=0
CreateTxMethod=BTC
GetNewKeySupported=true
ImportWithNoScanSupported=true
MinTxFee=2000000
BlockTime=150
FeePerByte=4000
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

# commands will be executed line by line to first fail which means return non 0
cc_command_list_post_profile=(
'chance directory to same directory'
'cd .'
)

# list of incompatible CLI commands surrounded with spaces
cc_cli_not_compatible='
 unlock.new 
'

cc_cli_add=(
'unlock.full'
'./cli walletpassphrase \"\$(read -sp pwd:\  undo; echo \$undo;undo=)\" 9999999999'

'unlock.staking.only'
'./cli walletpassphrase \"\$(read -sp pwd:\  undo; echo \$undo;undo=)\" 9999999999 true'

'addnode.onetry.auto'
'./cli addnode "5.175.184.193:8555" onetry
./cli addnode "31.25.241.224:8555" onetry
./cli addnode "49.228.40.58:8555" onetry
./cli addnode "66.151.242.154:8555" onetry
./cli addnode "83.221.211.116:8555" onetry
./cli addnode "83.221.211.116:8555" onetry
./cli addnode "93.130.169.16:8555" onetry
./cli addnode "88.214.58.224:8555" onetry
./cli addnode "194.62.1.213:8555" onetry
'
)

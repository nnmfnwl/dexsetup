cc_setup_helper_version="20210827"

# include defaults
source "$(dirname "${BASH_SOURCE[0]}")/cfg.cc.defaults.sh" || exit 1

cc_ticker="XVG"
cc_bin_file_name_prefix="verge"
cc_gui_cfg_dir_name="VERGE"

cc_install_dir_path_default="verge"
cc_chain_dir_path_default="~/.VERGE"
cc_wallet_name_default="wallet_xvg_dex"
cc_conf_name_default="VERGE.conf"


export CC=clang
export CXX=clang++

cc_firejail_make_args=''

cc_firejail_profile_add=''

cc_git_src_url="https://github.com/vergecurrency/verge.git"
cc_git_src_branch="v8.0.0"
cc_git_commit_id="b572bed7181fb72c41d4d717407d5eec8c7aaf97"

cc_command_pre_depends='
filepath="depends/packages/bdb.mk" &&
strsearch="_config_opts_linux" &&
stradd="\$(package)_cflags+=-Wno-error=implicit-function-declaration" &&
((cat ${filepath} | grep "${stradd}") || sed -i -e "/${strsearch}/ a ${stradd}" ${filepath})
'

cc_make_depends="bdb"

cc_command_configure='
./configure
LDFLAGS="-L`pwd`/depends/${cc_archdir}/lib/"
CPPFLAGS="-I`pwd`/depends/${cc_archdir}/include/"
CXXFLAGS="-O3 -march=native"
--disable-bench --disable-gui-tests --disable-tests --without-tests
--enable-reduce-exports --without-miniupnpc
--with-gui=auto
'

# HINT >> add to above configure parameter to compile with debug symbols >>
# --enable-debug

cc_command_pre_make='
filepath="src/net_processing.cpp" &&
strsearch="#include <memory>" &&
stradd="#include <array>" &&
((cat ${filepath} | grep "${stradd}") || sed -i -e "/${strsearch}/ a ${stradd}" ${filepath}) &&

filepath="src/qt/sendcoinsdialog.cpp" &&
strsearch="#include <QFontMetrics>" &&
stradd="#include <array>" &&
((cat ${filepath} | grep "${stradd}") || sed -i -e "/${strsearch}/ a ${stradd}" ${filepath}) &&

filepath="src/qt/trafficgraphwidget.cpp" &&
((cat ${filepath} | grep "#include <QPainterPath>") || sed -i -e "/#include <QPainter>/ a #include <QPainterPath>" ${filepath})
'

# conf file will scanned and comment existing conflist lines
# config to add be be line by line evaluated and added

cc_port=21102
cc_rpcport=20102
cc_rpcuser="BlockDXVerge"
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
onlynet=onion
onlynet=ipv6=multi
onlynet=ipv4=multi
#~ proxy=127.0.0.1:9050
onion=127.0.0.1:9050
bind=127.0.0.1
bantime=180

maxconnections=7
maxuploadtarget=777

txindex=1

dynamic-network=true
without-tor=true
'

cc_xbridge_cfg_add='
Title=Verge
Ip=127.0.0.1
Port=${cc_rpcport}
AddressPrefix=30
ScriptPrefix=33
SecretPrefix=158
COIN=1000000
MinimumAmount=0
TxVersion=1
DustAmount=0
CreateTxMethod=BTC
GetNewKeySupported=true
ImportWithNoScanSupported=true
MinTxFee=400000
BlockTime=30
FeePerByte=200
Confirmations=0
TxWithTimeField=true
LockCoinsSupported=false
Username=${cc_rpcuser}
Password=${cc_rpcpassword}
Address=
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

cc_cli_add=(
'addnode.onetry.auto'
'./cli addnode "p4vjqpnqslrc2gniopxgu75t2hwdjrhr56unzxyjmlvxh7l6dk33tlqd.onion:21102" onetry
./cli addnode "5ia5cridzvmrfn6jrc7yegxdiqsn23yr3gf2b3ru54zopbv5crwt7nad.onion:21102" onetry
./cli addnode "me42s2jffdmv2j5lq74y5dfrhjwvnh27cc7k4uleccbojcfmwfsxqzad.onion:21102" onetry
./cli addnode "kdaa6uvi7thwcf4wylydy4i723t6cvoib6wpl6pikekqmea4wm2b7did.onion:21102" onetry
./cli addnode "fs6zqnig2st24grcjdeqdvgjisohdj6itwxwqyymv7m6lku2itotczid.onion:21102" onetry
./cli addnode "gaw7kjhgsfjlt4hxvxxoqlewjj7e43spzuubgcfrndglr3rmqb7kebqd.onion:21102" onetry
./cli addnode "cydj7pocjyvdvl3nkrb5kxow6wga24oyzfik7ycpe5xlphvlastfhqyd.onion:21102" onetry
'
)

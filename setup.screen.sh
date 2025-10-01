#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1
source "./src/tools.screen.sh" || exit 1

# show help
tool_screen_show_help

# handle arguments
cc_instance_default="instance_default"
cc_instance=${cc_instance_default}
cc_action_screen=""
cc_nohtop=""
cc_nodexsetup=""
cc_noedit=""
cc_noblockdx=""
cc_notorbrowser=""
cc_nobravebrowser=""
cc_nosession=""
cc_nowalletautorun=""
cc_nodexbotautorun=""
cc_sleepnum_default=10
cc_sleepnum=${cc_sleepnum_default}
cc_proxychains_default="proxychains4 -q"
cc_proxychains=${cc_proxychains_default}

argc=$#
argv=("$@")
tool_screen_process_arguments ${argc} ${argv}

# ecosystem instance script
echo "INFO >> ecosystem instance name >> ${cc_instance}"

# ecosystem instance run scripts paths
start_ecosystem_script_cli_path="./start.screen."${cc_instance}".cli.sh"
start_ecosystem_script_gui_path="./start.screen."${cc_instance}".gui.sh"

# ecosystem instance stop script paths
stop_ecosystem_script_path="./stop.screen."${cc_instance}".sh"

# ecosystem instance update script paths
update_ecosystem_script_path="./update.screen."${cc_instance}".sh"

echo "INFO >> using ecosystem instance script >> ${start_ecosystem_script_cli_path}"
echo "INFO >> using ecosystem instance script >> ${start_ecosystem_script_gui_path}"
echo "INFO >> using ecosystem instance script >> ${stop_ecosystem_script_path}"
echo "INFO >> using ecosystem instance script >> ${update_ecosystem_script_path}"

# check run script exit if update not enabled
tool_variable_check_load_default cc_action_screen "" "argument install|update|clean"
if [ "${cc_action_screen}" = "install" ]; then
    tool_file_if_exist_exit ${start_ecosystem_script_cli_path} "dexsetup ecosostem instance cli start script"
    tool_file_if_exist_exit ${start_ecosystem_script_gui_path} "dexsetup ecosostem instance gui start script"
    tool_file_if_exist_exit ${stop_ecosystem_script_path} "dexsetup ecosostem instance stop script"
    tool_file_if_exist_exit ${update_ecosystem_script_path} "dexsetup ecosostem instance update script"
elif [ "${cc_action_screen}" = "update" ]; then
    tool_file_if_notexist_exit ${start_ecosystem_script_cli_path} "dexsetup ecosostem instance cli run script"
    tool_file_if_notexist_exit ${start_ecosystem_script_gui_path} "dexsetup ecosostem instance gui run script"
    tool_file_if_notexist_exit ${stop_ecosystem_script_path} "dexsetup ecosostem instance stop script"
    tool_file_if_notexist_exit ${update_ecosystem_script_path} "dexsetup ecosostem instance update script"
elif [ "${cc_action_screen}" = "clean" ]; then
    tool_rmfile start_ecosystem_script_cli_path
    tool_rmfile start_ecosystem_script_gui_path
    tool_rmfile stop_ecosystem_script_path
    tool_rmfile update_ecosystem_script_path
    # TODO clean up history
    exit 0
else
    echo "ERROR >> argument missing >> install|update|clean"
    exit 1
fi

# prepare run scripts data
gssn=${cc_instance}
cli_script_data="
echo 'working on it...'

screen -list | grep '${gssn}' > /dev/null
if [ \$? == 0 ]; then
  echo 'Screen ${gssn} is already running.
Please stop it first or attach.
REMEMBER!
> Following command to attach to dexsetup system:
screen -x
> Following keyboard shortcut to detach from dexsetup system:
ctrl + a + d
> Following keyboard shortcut to navigate on dexsetup system:
ctrl + a + \"
> Following command to stop dexsetup system:
./stop.screen.instance_default.sh
'
  exit 1
fi

screen -dmS \"${gssn}\" -t \"uptime\"
"
gui_script_data="
echo 'working on it...'

screen -list | grep '${gssn}' > /dev/null
if [ \$? == 0 ]; then
  echo 'Screen ${gssn} is already running.
Please stop it first or attach.
REMEMBER!
> Following command to attach to dexsetup system:
screen -x
> Following keyboard shortcut to detach from dexsetup system:
ctrl + a + d
> Following keyboard shortcut to navigate on dexsetup system:
ctrl + a + \"
> Following command to stop dexsetup system:
./stop.screen.instance_default.sh
'
  exit 1
fi

screen -dmS \"${gssn}\" -t \"uptime\"
"

stop_script_data="echo 'WARNING >> Stopping all the crypto screen=\"${gssn}\" stuff'
"

update_script_data="echo 'WARNING >> Updating all the crypto screen=\"${gssn}\" stuff'

echo 'Not implemented or tested well.'
exit 1

echo 'INFO >> updating operating system packages'
su - -c \"apt update; apt full-upgrade; apt install git proxychains4 tor torsocks; exit\"

echo 'INFO >> checking user group'
groups | grep debian-tor || su - -c \"usermod -a -G debian-tor ${USER}; exit\"

echo 'INFO >> checking dexsetup directory'
cd ~/dexsetup/dexsetup

echo 'INFO >> stash current changes'
git stash

echo 'INFO >> updating dexsetup source code'
proxychains4 git pull

echo 'INFO >> installing dependencies'
./setup.dependencies.sh clibuild clitools guibuild guitools

echo 'INFO >> reconfiguring proxychains user configuration'
./setup.cfg.proxychains.sh update

echo 'INFO >> updating wallets'
./setup.cc.wallet.sh ./src/cfg.cc.blocknet.sh update
./setup.cc.wallet.sh ./src/cfg.cc.litecoin.sh update
./setup.cc.wallet.sh ./src/cfg.cc.bitcoin.sh update
./setup.cc.wallet.sh ./src/cfg.cc.verge.sh update
./setup.cc.wallet.sh ./src/cfg.cc.dogecoin.sh update
./setup.cc.wallet.sh ./src/cfg.cc.pivx.sh download update
./setup.cc.wallet.sh ./src/cfg.cc.dash.sh update
./setup.cc.wallet.sh ./src/cfg.cc.lbrycrd.sqlite.sh update
./setup.cc.wallet.sh ./src/cfg.cc.pocketcoin.sh update
./setup.cc.wallet.sh ./src/cfg.cc.particl.sh update

echo 'INFO >> updating firejail scripts'
./setup.cc.wallet.profile.sh ./src/cfg.cc.blocknet.sh ~/.blocknet_staking/ wallet_block_staking
./setup.cc.wallet.profile.sh ./src/cfg.cc.pocketcoin.sh ~/.pocketcoin_staking/ wallet_pkoin_staking
./setup.cc.wallet.profile.sh ./src/cfg.cc.pivx.sh ~/.pivx_staking/ wallet_pivx_staking

./setup.cc.wallet.profile.sh ./src/cfg.cc.blocknet.sh wallet_block_dex
./setup.cc.wallet.profile.sh ./src/cfg.cc.litecoin.sh wallet_ltc_dex
./setup.cc.wallet.profile.sh ./src/cfg.cc.bitcoin.sh wallet_btc_dex
./setup.cc.wallet.profile.sh ./src/cfg.cc.verge.sh wallet_xvg_dex
./setup.cc.wallet.profile.sh ./src/cfg.cc.dogecoin.sh wallet_doge_dex.dat
./setup.cc.wallet.profile.sh ./src/cfg.cc.pivx.sh wallet_pivx_dex
./setup.cc.wallet.profile.sh ./src/cfg.cc.dash.sh wallet_dash_dex
./setup.cc.wallet.profile.sh ./src/cfg.cc.lbrycrd.sqlite.sh wallet_lbc_dex
./setup.cc.wallet.profile.sh ./src/cfg.cc.pocketcoin.sh wallet_pkoin_dex

echo 'INFO >> updating dexbot strategies'
./setup.cc.dexbot.profile.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.block.ltc.sh update_xb_config strategy1 replace_with_block_address replace_with_litecoin_address1 update_strategy

./setup.cc.dexbot.profile.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.bitcoin.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.btc.ltc.sh update_xb_config strategy1 replace_with_bitcoin_address replace_with_litecoin_address2 update_strategy

./setup.cc.dexbot.profile.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.verge.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.xvg.ltc.sh update_xb_config strategy1 replace_with_verge_address replace_with_litecoin_address3 update_strategy

./setup.cc.dexbot.profile.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.pivx.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.pivx.ltc.sh update_xb_config strategy1 replace_with_pivx_address replace_with_litecoin_address4 update_strategy
 
./setup.cc.dexbot.profile.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.dash.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.dash.ltc.sh update_xb_config strategy1 replace_with_dash_address replace_with_litecoin_address5 update_strategy

./setup.cc.dexbot.profile.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.lbrycrd.sqlite.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.lbc.ltc.sh update_xb_config strategy1 replace_with_lbry_address replace_with_litecoin_address6 update_strategy

./setup.cc.dexbot.profile.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.pocketcoin.sh ./src/cfg.cc.litecoin.sh ./src/cfg.dexbot.alfa.sh ./src/cfg.strategy.pkoin.ltc.sh update_xb_config strategy1 replace_with_pocketcoin_address replace_with_litecoin_address7 update_strategy

exit 0
"

gswt='uptime'
cli_script_data=${cli_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff 'uptime; free -mh; df -h | grep -e \"Size\" -e \" /$\" -e \"boot\" -e \"home\"; sensors | grep -e temp -e Core -e Composite; /sbin/ifconfig | grep packets\n'
"
gui_script_data=${gui_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff 'uptime; free -mh; df -h | grep -e \"Size\" -e \" /$\" -e \"boot\" -e \"home\"; sensors | grep -e temp -e Core -e Composite; /sbin/ifconfig | grep packets\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

if [[ "${cc_nohtop}" == "" ]] ;then
   echo "I >> HTOP >> Enabled"
gswt='htop'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'htop\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'htop\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"
else
    echo "I >> HTOP >> Disabled"
fi

if [[ "${cc_nodexsetup}" == "" ]] ;then
    echo "I >> DEXSETUP >> Enabled"
gswt='dexsetup'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/dexsetup/dexsetup/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'ls -la\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/dexsetup/dexsetup/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'ls -la\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"
else
    echo "I >> DEXSETUP >> Disabled"
fi

if [[ "${cc_noedit}" == "" ]] ;then
    echo "I >> EDIT >> Enabled"
gswt='edit'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/dexsetup/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.blocknet_staking/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.pocketcoin_staking/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.pivx_staking/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.blocknet/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.bitcoin/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.litecoin/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.dogecoin/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'ls -la\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/dexsetup/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.blocknet_staking/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.pocketcoin_staking/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.pivx_staking/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.blocknet/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.bitcoin/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.litecoin/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/.dogecoin/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'ls -la\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"
else
    echo "I >> EDIT >> Disabled"
fi

if [[ "${cc_noblockdx}" == "" ]] ;then
    echo "I >> BlockDX >> Enabled"
gswt='blockdx'
cli_script_data=${cli_script_data}""
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/dexsetup/blockdx/blockdx.1.9.5/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'ls -la\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './firejail.blockdx.default.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"
else
    echo "I >> BlockDX >> Disabled"
fi

if [[ "${cc_notorbrowser}" == "" ]] ;then
    echo "I >> TorBrowser >> Enabled"
gswt='torbrowser'
cli_script_data=${cli_script_data}""
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/dexsetup/tor_browser/latest/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'ls -la\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './firejail.torbrowser.default.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"
else
    echo "I >> TorBrowser >> Disabled"
fi

if [[ "${cc_nobravebrowser}" == "" ]] ;then
    echo "I >> BraveBrowser >> Enabled"
gswt='bravebrowser'
cli_script_data=${cli_script_data}""
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/dexsetup/brave_browser/latest/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'ls -la\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './firejail.bravebrowser.default.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"
else
    echo "I >> BraveBrowser >> Disabled"
fi

if [[ "${cc_nosession}" == "" ]] ;then
    echo "I >> Session >> Enabled"
gswt='session'
cli_script_data=${cli_script_data}""
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/dexsetup/session/latest/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'ls -la\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './firejail.session.default.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"
else
    echo "I >> Session >> Disabled"
fi

if [[ "${cc_nowalletautorun}" == "" ]] ;then
    echo "I >> WALLETAUTORUN >> Enabled"
else
    echo "I >> WALLETAUTORUN >> Disabled"
fi

if [[ "${cc_nodexbotautorun}" == "" ]] ;then
    echo "I >> DEXBOTAUTORUN >> Enabled"
else
    echo "I >> DEXBOTAUTORUN >> Disabled"
fi


wallet="block_dao"
gswt=${wallet}
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/dexsetup/blocknet/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './firejail.blocknet.wallet_${wallet}.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/dexsetup/blocknet/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './firejail.blocknet.wallet_${wallet}.qt.bin.sh'
"

gswt=${wallet}'_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/blocknet/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.blocknet.wallet_${wallet}.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/blocknet/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.blocknet.wallet_${wallet}.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"




gswt='block_staking'
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/dexsetup/blocknet/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './firejail.blocknet.wallet_block_staking.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t \"${gswt}\"
sleep 0.1
screen -S ${gssn} -p \"${gswt}\" -X stuff 'cd ~/dexsetup/blocknet/\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './firejail.blocknet.wallet_block_staking.qt.bin.sh'
"

gswt='block_staking_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/blocknet/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.blocknet.wallet_block_staking.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/blocknet/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.blocknet.wallet_block_staking.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"

gswt='pkoin_staking'
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pocketcoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pocketcoin.wallet_pkoin_staking.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pocketcoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pocketcoin.wallet_pkoin_staking.qt.bin.sh'
"

gswt='pkoin_staking_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pocketcoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pocketcoin.wallet_pkoin_staking.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pocketcoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pocketcoin.wallet_pkoin_staking.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"

gswt='pivx_staking'
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pivx/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pivx.wallet_pivx_staking.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pivx/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pivx.wallet_pivx_staking.qt.bin.sh'
"

gswt='pivx_staking_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pivx/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pivx.wallet_pivx_staking.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pivx/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pivx.wallet_pivx_staking.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"

gswt='block_dex'
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/blocknet/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.blocknet.wallet_block_dex.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/blocknet/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.blocknet.wallet_block_dex.qt.bin.sh'
"

gswt='block_dex_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/blocknet/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.blocknet.wallet_block_dex.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/blocknet/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.blocknet.wallet_block_dex.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"

gswt='btc_dex'
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/bitcoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.bitcoin.wallet_btc_dex.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/bitcoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.bitcoin.wallet_btc_dex.qt.bin.sh'
"

gswt='btc_dex_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/bitcoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.bitcoin.wallet_btc_dex.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/bitcoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.bitcoin.wallet_btc_dex.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"

gswt='ltc_dex'
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/litecoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.litecoin.wallet_ltc_dex.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/litecoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.litecoin.wallet_ltc_dex.qt.bin.sh'
"

gswt='ltc_dex_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/litecoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.litecoin.wallet_ltc_dex.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/litecoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.litecoin.wallet_ltc_dex.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"

gswt='doge_dex_dat'
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dogecoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.dogecoin.wallet_doge_dex.dat.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dogecoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.dogecoin.wallet_doge_dex.dat.qt.bin.sh'
"

gswt='doge_dex_dat_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dogecoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.dogecoin.wallet_doge_dex.dat.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dogecoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.dogecoin.wallet_doge_dex.dat.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff $'\003'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"

gswt='dash_dex'
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dash/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.dash.wallet_dash_dex.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dash/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.dash.wallet_dash_dex.qt.bin.sh'
"

gswt='dash_dex_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dash/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.dash.wallet_dash_dex.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dash/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.dash.wallet_dash_dex.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff ';^C'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"

gswt='pivx_dex'
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pivx/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pivx.wallet_pivx_dex.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pivx/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pivx.wallet_pivx_dex.qt.bin.sh'
"

gswt='pivx_dex_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pivx/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pivx.wallet_pivx_dex.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pivx/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pivx.wallet_pivx_dex.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff ';^C'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"

gswt='xvg_dex'
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/verge/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.verge.wallet_xvg_dex.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/verge/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.verge.wallet_xvg_dex.qt.bin.sh'
"

gswt='xvg_dex_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/verge/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.verge.wallet_xvg_dex.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/verge/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.verge.wallet_xvg_dex.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff ';^C'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"

gswt='lbc_dex'
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/lbrycrd/sqlite/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.lbrycrd.wallet_lbc_dex.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/lbrycrd/sqlite/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.lbrycrd.wallet_lbc_dex.qt.bin.sh'
"

gswt='lbc_dex_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/lbrycrd/sqlite/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.lbrycrd.wallet_lbc_dex.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/lbrycrd/sqlite/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.lbrycrd.wallet_lbc_dex.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff ';^C'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"

gswt='pkoin_dex'
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pocketcoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pocketcoin.wallet_pkoin_dex.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pocketcoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pocketcoin.wallet_pkoin_dex.qt.bin.sh'
"

gswt='pkoin_dex_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pocketcoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pocketcoin.wallet_pkoin_dex.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/pocketcoin/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.pocketcoin.wallet_pkoin_dex.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff ';^C'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"

gswt='part_dex'
gswt_tmp=${gswt}
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/particl/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.particl.wallet_part_dex.d.bin.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/particl/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.particl.wallet_part_dex.qt.bin.sh'
"

gswt='part_dex_cli'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/particl/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.particl.wallet_part_dex.cli.bin.sh\n'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/particl/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './firejail.particl.wallet_part_dex.cli.bin.sh\n'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff './lock\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff './stop\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff 'exit\n'
while :; do ps aux | grep -v grep | grep ^${USER}\  | grep ${gswt_tmp} && (echo waiting && sleep 1) || break; done
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff ';^C'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt_tmp}\" -X stuff 'exit\n'
"

gswt='DEXBOT pricing proxy'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.proxy.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.proxy.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='BLOCK LTC strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.BLOCK.LTC.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.BLOCK.LTC.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.BLOCK.LTC.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='LTC BLOCK strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.BLOCK.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.BLOCK.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.LTC.BLOCK.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='BTC LTC strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.BTC.LTC.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.BTC.LTC.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.BTC.LTC.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='LTC BTC strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.BTC.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.BTC.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.LTC.BTC.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='DOGE LTC strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '{gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.DOGE.LTC.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '{gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.DOGE.LTC.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.DOGE.LTC.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='LTC DOGE strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.DOGE.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.DOGE.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.LTC.DOGE.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='DASH LTC strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.DASH.LTC.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.DASH.LTC.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.DASH.LTC.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='LTC DASH strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.DASH.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.DASH.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.LTC.DASH.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='PIVX LTC strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.PIVX.LTC.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.PIVX.LTC.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.PIVX.LTC.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='LTC PIVX strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.PIVX.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.PIVX.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.LTC.PIVX.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
sleep 1.5
screen -S ${gssn} -X quit
"

gswt='XVG LTC strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.XVG.LTC.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.XVG.LTC.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.XVG.LTC.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='LTC XVG strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.XVG.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.XVG.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.LTC.XVG.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='LBC LTC strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LBC.LTC.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LBC.LTC.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.LBC.LTC.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='LTC LBC strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.LBC.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.LBC.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.LTC.LBC.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='PART LTC strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.PART.LTC.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.PART.LTC.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.PART.LTC.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

gswt='LTC PART strategy1'
cli_script_data=${cli_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.PART.strategy1.sh'
"
gui_script_data=${gui_script_data}"
screen -drS ${gssn} -X screen -t '${gswt}'
sleep 0.1
screen -S ${gssn} -p '${gswt}' -X stuff 'cd ~/dexsetup/dexbot/\n'
screen -S ${gssn} -p '${gswt}' -X stuff './run.firejail.LTC.PART.strategy1.sh'
"
stop_script_data=${stop_script_data}"
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^C'
#screen -S ${gssn} -p \"${gswt}\" -X stuff './run.firejail.LTC.PART.strategy1.sh --canceladdress --exitonerror 1\n'
screen -S ${gssn} -p \"${gswt}\" -X stuff '^D'
"

cli_script_data=${cli_script_data}"
echo 'All done.
REMEMBER!
> Following command to attach to dexsetup system:
screen -x
> Following keyboard shortcut to detach from dexsetup system:
ctrl + a + d
> Following keyboard shortcut to navigate on dexsetup system:
ctrl + a + \"'
"
gui_script_data=${gui_script_data}"
echo 'All done.
REMEMBER!
> Following command to attach to dexsetup system:
screen -x
> Following keyboard shortcut to detach from dexsetup system:
ctrl + a + d
> Following keyboard shortcut to navigate on dexsetup system:
ctrl + a + \"'
"
stop_script_data=${stop_script_data}"
echo done
"

# write run ecosystem instance scripts
tool_make_and_chmod_script_or_exit start_ecosystem_script_cli_path cli_script_data "create start ecosystem cli script"

tool_make_and_chmod_script_or_exit start_ecosystem_script_gui_path gui_script_data "create start ecosystem gui script"

tool_make_and_chmod_script_or_exit stop_ecosystem_script_path stop_script_data "create stop ecosystem script"

tool_make_and_chmod_script_or_exit update_ecosystem_script_path update_script_data "create update ecosystem script"

# setup.dependencies cmd history add

# go over setup.history directory and try to update wallets
    
    # TODO setup.cc.main.sh must generate setup.history directory after success compilation
        # and generate update scripts that check commit ID
            # and check if process is not running
    
    # check if wallet have not commit ID

# check if we are in right directory

# github self update

# open directory history

#~ ## Autostart Right After Pc Restart With Crontab

   #~ * At first choose lines from above GNU Screen startup automatization
   #~ * and save it all in file:
#~ ```
#~ ~/dexsetup/dexsetup/ccwallets.autostart.sh
#~ ```

  #~ * if you want to be automatically started right after computer restart
  #~ * Run command
#~ ```
#~ crontab -e
#~ ```

   #~ * And add line, but replace `username` with real user login name
#~ ```
#~ @reboot bash /home/username/dexsetup/dexsetup/ccwallets.autostart.sh
#~ ```

exit 0

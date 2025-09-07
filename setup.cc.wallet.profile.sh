#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1

# default arguments
cc_script_cfg_path_default="./src/cfg.cc.blocknet.sh"
cc_firejail_default="firejail"
cc_proxychains_default="proxychains4 -q"

# include specific tools
source "./src/tools.cc.wallet.profile.sh" || exit 1

# showhelp is auto set by tools
tool_firejail_show_help

# handle arguments
cc_script_cfg_path=
cc_install_dir_path=
cc_chain_dir_path=
cc_proxychains=${cc_proxychains_default}
cc_wallet_name=
cc_firejail_profile_name_suffix=
cc_action_cc_config=

# process command line arguments
argc=$#
argv=("$@")
tool_firejail_process_arguments ${argc} ${argv}

# start measuring time
tool_time_start

# include main cc cfg script IE: ./src/cfg.cc.blocknet.sh
tool_variable_check_load_default cc_script_cfg_path cc_script_cfg_path_default
tool_realpath cc_script_cfg_path "parameter #1 cc cfg script path"
tool_check_version_and_include_script ${cc_script_cfg_path} "loading cc cfg script" 

# check included cfg variables
tool_variable_check_load_default cc_bin_file_name_prefix "" "cc cfg"
tool_variable_check_load_default cc_gui_cfg_dir_name "" "cc cfg"
tool_variable_check_load_default cc_install_dir_path_default "" "wallet default install dir path"

# prepare install directory path
cc_install_dir_path_default_tmp=${cc_dexsetup_dir_path}"/../"${cc_install_dir_path_default}
tool_variable_check_load_default cc_install_dir_path cc_install_dir_path_default_tmp
tool_realpath cc_install_dir_path "cc install dir path"
tool_make_and_check_dir_path cc_install_dir_path "cc install directory"

# cc install directory git
cc_git_src_path=${cc_install_dir_path}"/git.src"
tool_make_and_check_dir_path cc_git_src_path "cc install directory git.src"

# cc install directory bin files path
cc_bin_path=${cc_install_dir_path}"/bin"
tool_make_and_check_dir_path cc_bin_path "cc bin files directory"

# cc chain directory path
tool_variable_check_load_default cc_chain_dir_path cc_chain_dir_path_default "cc chain dir path"
tool_realpath cc_chain_dir_path "cc chain dir path"
tool_make_and_check_dir_path cc_chain_dir_path "cc chain dir path"

# cc chain conf file
tool_variable_check_load_default cc_conf_name_default "" "cc_conf_name_default"
cc_main_cfg_path=${cc_chain_dir_path}"/"${cc_conf_name_default}
tool_variable_check_load_default cc_main_cfg_path "" "cc conf file path"

# wallet dat file name
tool_variable_check_load_default cc_wallet_name cc_wallet_name_default "wallet dat naming"

# wallet backup directory
cc_backup_dir_path=${cc_dexsetup_dir_path}"/backup/"${cc_bin_file_name_prefix}"/"${cc_wallet_name}

# update cc chain conf file
tool_variable_check_load_default cc_main_cfg_add "" "cc conf to add"
tool_update_cc_cfg ${cc_main_cfg_path} "${cc_main_cfg_add}" ${cc_ticker} ${cc_action_cc_config}

# if firejail suffix name is not specified use .cc_wallet_name instead
cc_firejail_profile_name_suffix_tmp="."${cc_wallet_name}
tool_variable_check_load_default cc_firejail_profile_name_suffix cc_firejail_profile_name_suffix_tmp "firejail suffix naming"

# firejail profile file name suffix if custom not exist default will be loaded
cc_firejail_profile_middlename=${cc_bin_file_name_prefix}${cc_firejail_profile_name_suffix}
tool_variable_check_load_default cc_firejail_profile_middlename cc_firejail_profile_middlename "firejail profile name"

# cli command directory for this prefix
cc_cli_dir_name="cli"${cc_firejail_profile_name_suffix}

# change directory where firejail profile templates are

cc_firejail_template_profiles_dir="src"
tool_cd ${cc_firejail_template_profiles_dir} "helper files data dir"

# prepare firejail profile and START scripts for firejail sandboxed make script

cc_custombuild_firejail_profile_file_name_src="setup.cc.make.firejail.profile"
cc_custombuild_firejail_profile_file_name_dst="firejail.${cc_bin_file_name_prefix}.dev.env.profile"
echo "INFO >> copy firejail make profile >> ${cc_custombuild_firejail_profile_file_name_dst}"
cp ${cc_custombuild_firejail_profile_file_name_src} ${cc_install_dir_path}"/"${cc_custombuild_firejail_profile_file_name_dst}
(test $? != 0) && echo "ERROR >> copy file >> ${cc_custombuild_firejail_profile_file_name_dst} >> failed" && exit 1

cc_custombuild_script_path=${cc_install_dir_path}"/firejail.${cc_bin_file_name_prefix}.dev.env.sh"
echo "INFO >> create script >> ${cc_custombuild_script_path} >> to start custom build firejail sandbox"
echo "
cd ${cc_git_src_path}
(test $? != 0) && echo \"ERROR >> cd ${cc_git_src_path} >> failed\" && exit 1
firejail --profile=./../${cc_custombuild_firejail_profile_file_name_dst} --whitelist=\`pwd\` bash
(test $? != 0) && echo \"ERROR >> firejail failed\" && exit 1
" > ${cc_custombuild_script_path} && chmod 755 ${cc_custombuild_script_path}
(test $? != 0) && echo "ERROR >> create script >> ${cc_custombuild_script_path} >> failed" && exit 1

# copy and rename firejail templates to cc install directories

firejail_list=`ls | grep firejail.cc_template.`
for f in $firejail_list; do
    new_name=`echo ${f} | sed -e "s+\\\.cc_template\\\.+\\\.${cc_firejail_profile_middlename}\\\.+g"`
    cp ${f} ${cc_install_dir_path}"/"${new_name}
    (test $? != 0) && echo "ERROR >> file >> ${f} >> copy failed" && exit 1
done
echo "INFO >> copy firejail templates"

# update firejail files by cc

tool_cd ${cc_install_dir_path} "cc_install_dir_path"

tool_eval_arg cc_firejail_profile_add

cc_firejail_profile_add=`echo "$cc_firejail_profile_add" | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\\n/g'`
tool_variable_info cc_firejail_profile_add ""
#~ cc_firejail_profile_add=`echo "$cc_firejail_profile_add" | sed -z 's/\n/\\\n/g'`
#~ echo "2: $cc_firejail_profile_add"
#~ cc_firejail_profile_add=`echo "${cc_firejail_profile_add}" | sed -e "s+\n+\\\n+g"`
#~ echo "2: $cc_firejail_profile_add"

firejail_list=`ls | grep firejail\\\.${cc_firejail_profile_middlename}\\\.`
for f in $firejail_list; do
    echo "updating "${f}
    sed -i \
        -e "s+{cc_install_dir_path}+${cc_install_dir_path}+g" \
        -e "s+{cc_chain_dir_path}+${cc_chain_dir_path}+g" \
        -e "s+{cc_conf_name_default}+${cc_conf_name_default}+g" \
        -e "s+{cc_bin_file_name_prefix}+${cc_bin_file_name_prefix}+g" \
        -e "s+{cc_firejail_profile_middlename}+${cc_firejail_profile_middlename}+g" \
        -e "s+{cc_cli_dir_name}+${cc_cli_dir_name}+g" \
        -e "s+{cc_gui_cfg_dir_name}+${cc_gui_cfg_dir_name}+g" \
        -e "s+{cc_wallet_name}+${cc_wallet_name}+g" \
        -e "s+{cc_proxychains}+${cc_proxychains}+g" \
        -e "s+{cc_firejail_profile_add}+${cc_firejail_profile_add}+g" \
        -e "s+{cc_backup_dir_path}+${cc_backup_dir_path}+g" \
        ${f}
done
echo "INFO >> update firejail profiles"

# update firejail run scripts permissions

firejail_list=`ls | grep firejail\\\.${cc_firejail_profile_middlename}\\\..*sh`
firejail_scripts=""
for f in $firejail_list; do
    firejail_scripts="${firejail_scripts}
${f}"
    chmod 755 ${f}
    (test $? != 0) && echo "ERROR >> file >> ${f} >> chmod 755 failed" && exit 1
done

# make cli command directory and generate all supported commands

function tool_firejail_mk_cli_script() {  #var name filename #var name cmd
    (test "${1}" != "" ) && local filename=`eval echo "\\${${1}}"`
    (test "${2}" != "" ) && local cmd=`eval echo \"\\${${2}}\"`
    
    (test "${filename}" = "" ) && echo "ERROR >> ${FUNCNAME[*]} >> variable >> ${1} >> value >> ${filename} >> load failed" && exit 1
    
    (test "${cmd}" = "" ) && echo "ERROR >> ${FUNCNAME[*]} >> variable >> ${2} >> value >> ${cmd} >> load failed" && exit 1
    
    echo "${cmd}" > "${filename}" && chmod 755 "${filename}"
    (test $? != 0) && echo "ERROR >> ${FUNCNAME[*]} >> ${filename} >> script generate failed" && exit 1
    
    echo "INFO >> ${FUNCNAME[*]} >> script >> ${filename} >> generate success"
}

# make and change to cli dir

tool_make_and_check_dir_path cc_cli_dir_name "cli commands directory"
tool_cd ${cc_cli_dir_name} "cli commands directory"

# gen cli command script
cli_file="cli"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} \$@
"
tool_firejail_mk_cli_script cli_file cli_cmd_full

# gen help command script
cli_file="help"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} help \$@ | less
"
tool_firejail_mk_cli_script cli_file cli_cmd_full

# encrypt wallet
cli_file="encrypt"
cli_id="encrypt"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} encryptwallet \"\$(read -sp 'pwd: ' undo; echo \$undo;undo=)\"
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# generate new address
cli_file="getnewaddress.default"
cli_id="getnewaddress.default"
cli_cmd_full="#!/bin/bash
./cli getnewaddress \"\$(read -p 'label: ' undo; echo \$undo;undo=)\"
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# generate new legacy
cli_file="getnewaddress.legacy"
cli_id="getnewaddress.legacy"
cli_cmd_full="#!/bin/bash
./cli getnewaddress \"\$(read -p 'label: ' undo; echo \$undo;undo=)\" \"legacy\"
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# generate new segwit
cli_file="getnewaddress.segwit"
cli_id="getnewaddress.segwit"
cli_cmd_full="#!/bin/bash
./cli getnewaddress \"\$(read -p 'label: ' undo; echo \$undo;undo=)\" \"p2sh-segwit\"
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# generate new bech32
cli_file="getnewaddress.bech32"
cli_id="getnewaddress.bech32"
cli_cmd_full="#!/bin/bash
./cli getnewaddress \"\$(read -p 'label: ' undo; echo \$undo;undo=)\" \"p2sh-bech32\"
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# backup wallet
cli_file="backup"
cli_id="backup"
cli_cmd_full="#!/bin/bash
wallet_path=${cc_backup_dir_path}/${cc_wallet_name}_\`date +'%Y_%m_%d_%H%M%S'\`.dat
echo \"Creating backup at: \${wallet_path}\"
echo \"Please copy whole backup directory to secured external drive\"
./cli backupwallet \"\${wallet_path}\"
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen unlock unlock wallet old style
cli_file="unlock.full"
cli_id="unlock.old"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} walletpassphrase \"\$(read -sp 'pwd: ' undo; echo \$undo;undo=)\" 9999999999
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen unlock unlock wallet new style
cli_file="unlock.full"
cli_id="unlock.new"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} -stdinwalletpassphrase walletpassphrase 9999999999
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen unlock unlock wallet for staking only
cli_file="unlock.staking.only"
cli_id="unlock.staking.only"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} walletpassphrase \"\$(read -sp 'pwd: ' undo; echo \$undo;undo=)\" 9999999999 true
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen lock wallet
cli_file="lock"
cli_id="lock"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} walletlock
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen stop wallet
cli_file="stop"
cli_id="stop"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} stop
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen basic wallet info
cli_file="getwalletinfo.basic"
cli_id="getwalletinfo.basic"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getwalletinfo | grep -e balance -e txcount -e unlocked 
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen getstakingstatus
cli_file="getstakingstatus"
cli_id="getstakingstatus"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getstakingstatus 
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen getstakinginfo for PKOIN
cli_file="getstakinginfo"
cli_id="getstakinginfo"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getstakinginfo 
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen getstakereport for PKOIN
cli_file="getstakereport"
cli_id="getstakereport"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getstakereport 
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen getblockchaininfo
cli_file="getblockchaininfo"
cli_id="getblockchaininfo"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getblockchaininfo
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen getblockchaininfo.basics
cli_file="getblockchaininfo.basics"
cli_id="getblockchaininfo.basics"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getblockchaininfo | grep -e blocks -e headers -e bestblockhash 
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen getnettotals
cli_file="getnettotals.basics"
cli_id="getnettotals.basics"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getnettotals | grep -e totalbytes
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen connections count
cli_file="getconnectioncount"
cli_id="getconnectioncount"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getconnectioncount
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen gte peer info
cli_file="getpeerinfo.basic"
cli_id="getpeerinfo.basic"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} getpeerinfo | grep \"\\\"addr\\\"\" | grep \"\.\"
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen enable network
cli_file="setnetworkactive.true"
cli_id="setnetworkactive.true"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} setnetworkactive true
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen disable network
cli_file="setnetworkactive.false"
cli_id="setnetworkactive.false"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} setnetworkactive false
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen list UTXOs
cli_file="listunspent.basic"
cli_id="listunspent.basic"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} listunspent 0 | grep -e address -e label -e amount -e confirmations
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen list address and balance
cli_file="listaddressgroupings.basic"
cli_id="listaddressgroupings"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} listaddressgroupings | grep -v -e \"\\[\" -e \"\\]\"
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen list address and all time recv
cli_file="listreceivedbyaddress.basic"
cli_id="listreceivedbyaddress"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} listreceivedbyaddress 0 true | grep -e address -e label -e amount
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# gen list UTXOs
cli_file="dxGetTokenBalances"
cli_id="dxcmdall"
cli_cmd_full="#!/bin/bash
./../bin/${cc_bin_file_name_prefix}.cli.bin -datadir=${cc_chain_dir_path} dxGetTokenBalances
"
if [[ "${cc_cli_not_compatible}" != *" ${cli_id} "* ]] ;then
    tool_firejail_mk_cli_script cli_file cli_cmd_full
fi

# cross all wallet specific CLI commands to be added
i=0
while :
do
    # load CLI file name and command
    cli_file=${cc_cli_add[i]}
    ((i++))
    cli_cmd=${cc_cli_add[i]}
    ((i++))
    
    # verify CLI file name and command
    if [[ "${cli_file}" == '' ]]; then
        break
    fi
    
    if [[ "${cli_cmd}" == '' ]]; then
        break
    fi
    
    # evaluate command
    cli_cmd=`eval echo ${cli_cmd}`
    
    # log information
    tool_variable_info cli_file "command name to be added"
    tool_variable_info cli_cmd "command content to be added"
    
    # add bash prefix
    cli_cmd="#!/bin/bash
${cli_cmd}"

    # make command file
    tool_firejail_mk_cli_script cli_file cli_cmd
done

# list of generated scripts
echo "Generated firejail sandbox profiles >> ${cc_install_dir_path} >> ${firejail_scripts}"

# exit

echo "*** FIREJAIL CC SETUP SUCCESS ***"

tool_time_finish_print

exit 0

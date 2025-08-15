#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1
source "./src/tools.cc.dexbot.profile.sh" || exit 1

# showhelp is auto set by tools
tool_dexbot_show_help

# handle arguments
cc_script_cfg_path_block=${1}
cc_script_cfg_path_maker=${2}
cc_script_cfg_path_taker=${3}
cc_script_cfg_path_dexbot=${4}
cc_script_cfg_path_strategy=${5}
cc_action_source=
cc_action_cc_config=
cc_action_xb_config=
cc_action_strategy=
cc_firejail_default="firejail"
cc_firejail=${cc_firejail_default}
cc_proxychains_default="proxychains4 -q"
cc_proxychains=${cc_proxychains_default}
cc_dexbot_install_dir_path=
cc_chain_dir_path_blocknet=
cc_chain_dir_path_maker=
cc_chain_dir_path_taker=
cc_conf_name_blocknet=
cc_conf_name_maker=
cc_conf_name_taker=
cc_dexbot_naming_suffix=
cc_address_maker=
cc_address_taker=

tool_realpath cc_script_cfg_path_block "parameter #1 block"
tool_realpath cc_script_cfg_path_maker "parameter #2 maker"
tool_realpath cc_script_cfg_path_taker "parameter #3 taker"
tool_realpath cc_script_cfg_path_dexbot "parameter #4 dexbot"
tool_realpath cc_script_cfg_path_strategy "parameter #5 strategy"

(test "${cc_script_cfg_path_maker}" = "${cc_script_cfg_path_taker}") && echo "ERROR >> maker and taker argument can not be the same" && exit 1

argc=$#
argv=("$@")
tool_dexbot_process_arguments ${argc} ${argv}




# version to check...
cc_setup_helper_version="20210827"

# update blocknet blockchain and xbridge configuration
tool_dexbot_update_cc_cfg_xb_cfg ${cc_script_cfg_path_block} "blocknet"

# backup some blocknet variables for later usage in dexbot strategy config
cc_localhost="127.0.0.1"
tool_variable_check_load_default cc_rpcuser_block_bak cc_rpcuser
tool_variable_check_load_default cc_rpcpassword_block_bak cc_rpcpassword
tool_variable_check_load_default cc_rpchostname_block_bak cc_localhost
tool_variable_check_load_default cc_rpcport_block_bak cc_rpcport

# update maker blockchain and xbridge configuration
tool_dexbot_update_cc_cfg_xb_cfg ${cc_script_cfg_path_maker} "maker"
cc_ticker_maker_check=${cc_ticker}

# update taker blockchain and xbridge configuration
tool_dexbot_update_cc_cfg_xb_cfg ${cc_script_cfg_path_taker} "taker"
cc_ticker_taker_check=${cc_ticker}




# clean dexbot cfg variables
cc_dexbot_install_dir_path_default=

# include dexbot cfg
tool_check_version_and_include_script ${cc_script_cfg_path_dexbot} "loading dexbot cfg" 

# check dexbot configuration variables
tool_variable_check_load_default cc_dexbot_install_dir_path_default "" "dexbot default install dir path"
tool_variable_check_load_default cc_dexbot_git_src_url cc_dexbot_git_src_url "dexbot cfg"
tool_variable_check_load_default cc_dexbot_git_branch cc_dexbot_git_branch "dexbot cfg"
tool_variable_check_load_default cc_dexbot_git_commit_id cc_dexbot_git_commit_id "dexbot cfg"
tool_variable_check_load_default cc_dexbot_strategy_template_path_relative cc_dexbot_strategy_template_path_relative "dexbot cfg"

# prepare install directory path
cc_dexbot_install_dir_path_default_tmp=${cc_dexsetup_dir_path}"/../"${cc_dexbot_install_dir_path_default}
tool_variable_check_load_default cc_dexbot_install_dir_path cc_dexbot_install_dir_path_default_tmp
tool_realpath cc_dexbot_install_dir_path "dexbot install dir path"
tool_make_and_check_dir_path cc_dexbot_install_dir_path "dexbot install dir path"

# dexbot git source path gen
cc_dexbot_git_src_path=${cc_dexbot_install_dir_path}"/git.src"
echo "INFO >> using >> cc_dexbot_git_src_path >> ${cc_dexbot_git_src_path}"

# dexbot git source dir recreate
tool_make_and_check_dir_path "cc_dexbot_git_src_path" "dexbot git dir"

# dexbot change directory
tool_cd ${cc_dexbot_git_src_path} "dexbot git dir"

# dexbot git clone
echo "INFO >> dexbot >> git clone >> cc_dexbot_git_src_url >> ${cc_dexbot_git_src_url}"
${cc_proxychains} git clone ${cc_dexbot_git_src_url} ./
(test $? != 0) && echo "WARNING >> dexbot git clone >> ${cc_dexbot_git_src_url} >> failed/already exist"

# dexbot checkout branch
echo "INFO >> dexbot >> git checkout >> cc_dexbot_git_branch >> ${cc_dexbot_git_branch}"
${cc_proxychains} git checkout ${cc_dexbot_git_branch}
(test $? != 0) && echo "ERROR >> git checkout >> ${cc_dexbot_git_branch} >> failed" && exit 1

# if dexbot update
if [ "${cc_action_source}" = "update" ]; then
    echo "INFO >> removing existing cc_dexbot_git_src_path >> ${cc_dexbot_git_src_path}"
    git stash && proxychains4 git pull
    (test $? != 0) && echo "update dexbot by git failed. try again later" && exit 1
fi

# dexbot commit_id check
tool_git_commit_id_check "${cc_dexbot_git_commit_id}" "dexbot"

# dexbot install requirements
echo "INFO >> dexbot installing requirements"
PIP_BREAK_SYSTEM_PACKAGES=1 ${cc_proxychains} pip3 install -r requirements.txt
(test $? != 0) && echo "ERROR >> dexbot install requirements failed" && exit 1

# move above dir
tool_cd ".." "dexbot cd .."

# load dexbot strategy configuration script
tool_check_version_and_include_script ${cc_script_cfg_path_strategy} "loading dexbot strategy cfg" 

# load dexbot strategy configuration custom or default naming suffix
tool_variable_check_load_default cc_dexbot_naming_suffix cc_dexbot_naming_suffix_default "dexbot strategy cfg"
tool_variable_check_load_default cc_address_maker cc_address_maker_default "dexbot strategy cfg"
tool_variable_check_load_default cc_address_taker cc_address_taker_default "dexbot strategy cfg"

# check if tickers from maker taker configuration vs dexbot strategy configuration match
tool_cmp ${cc_ticker_maker} ${cc_ticker_maker_check}
tool_cmp ${cc_ticker_taker} ${cc_ticker_taker_check}

# copy dexbot strategy template, update template, create run scripts

# prepare maker/taker strategy and runscript name and path
cc_dexbot_strategy_maker_file_name="strategy_${cc_ticker_maker}_${cc_ticker_taker}_${cc_dexbot_naming_suffix}"
cc_dexbot_strategy_taker_file_name="strategy_${cc_ticker_taker}_${cc_ticker_maker}_${cc_dexbot_naming_suffix}"
cc_dexbot_strategy_maker_file_path=${cc_dexbot_git_src_path}"/"${cc_dexbot_strategy_maker_file_name}".py"
cc_dexbot_strategy_taker_file_path=${cc_dexbot_git_src_path}"/"${cc_dexbot_strategy_taker_file_name}".py"

cc_dexbot_run_strategy_maker_name="run.firejail.${cc_ticker_maker}.${cc_ticker_taker}.${cc_dexbot_naming_suffix}.sh"
cc_dexbot_run_strategy_taker_name="run.firejail.${cc_ticker_taker}.${cc_ticker_maker}.${cc_dexbot_naming_suffix}.sh"

# check if files not already exists to not be overwritten
if [ "${cc_action_strategy}" != "update" ]; then
    tool_file_if_exist_exit ${cc_dexbot_strategy_maker_file_path} "maker strategy config path"
    tool_file_if_exist_exit ${cc_dexbot_strategy_taker_file_path} "taker strategy config path"
    tool_file_if_exist_exit ${cc_dexbot_run_strategy_maker_name} "run maker strategy script path"
    tool_file_if_exist_exit ${cc_dexbot_run_strategy_taker_name} "run taker strategy script path"
fi

# copy strategy template
tool_cp ${cc_dexbot_git_src_path}${cc_dexbot_strategy_template_path_relative} ${cc_dexbot_strategy_maker_file_path} "maker strategy"
tool_cp ${cc_dexbot_git_src_path}${cc_dexbot_strategy_template_path_relative} ${cc_dexbot_strategy_taker_file_path} "taker strategy"

# restore blocknet rpc setting for updating dexbot strategy template
cc_rpc_user=${cc_rpcuser_block_bak}
cc_rpc_password=${cc_rpcpassword_block_bak}
cc_rpc_hostname=${cc_rpchostname_block_bak}
cc_rpc_port=${cc_rpcport_block_bak}

# scan dexbot strategy template file for needed variables
# try to match and replace dexbot strategy template file with dexbot strategy config variable values
tool_dexbot_strategy_template_update ${cc_dexbot_strategy_maker_file_path}

cc_ticker_maker=${cc_ticker_taker_check}
cc_ticker_taker=${cc_ticker_maker_check}

cc_address_maker_bak=${cc_address_maker}
cc_address_taker_bak=${cc_address_taker}
cc_address_maker=${cc_address_taker_bak}
cc_address_taker=${cc_address_maker_bak}

tool_dexbot_strategy_template_update ${cc_dexbot_strategy_taker_file_path} "_opposite"

# generate dexbot strategy firejail run script for maker
echo "#!/bin/bash

# run script generated with ./setup.cc.dexbot.profile.sh --help

cd ${cc_dexbot_git_src_path} || exit 1
firejail \\
--name=${cc_dexbot_strategy_maker_file_name} \\
--whitelist=\`pwd\` \\
--read-only=\`pwd\` \\
--mkfile=\`pwd\`/${cc_dexbot_strategy_maker_file_name}.tmp.cfg \\
--read-write=\`pwd\`/${cc_dexbot_strategy_maker_file_name}.tmp.cfg \\
--mkfile=\`pwd\`/${cc_dexbot_strategy_maker_file_name}.tmp.pricing \\
--read-write=\`pwd\`/${cc_dexbot_strategy_maker_file_name}.tmp.pricing \\
--whitelist=\${HOME}/.proxychains \\
--read-only=\${HOME}/.proxychains \\
--whitelist=\${HOME}/.local/bin \\
--read-only=\${HOME}/.local/bin \\
--whitelist=\${HOME}/.local/lib \\
--read-only=\${HOME}/.local/lib \\
    ${cc_proxychains} \\
            python3 dexbot_v2_run.py --config ${cc_dexbot_strategy_maker_file_name} \$@
" > ${cc_dexbot_run_strategy_maker_name} && chmod 755 ${cc_dexbot_run_strategy_maker_name}
(test $? != 0) && echo "ERROR >> dexbot strategy run script >> ${cc_dexbot_run_strategy_maker_name} >> generate failed" && exit 1

# generate dexbot strategy firejail run script for taker
echo "#!/bin/bash

# run script generated with ./setup.cc.dexbot.profile.sh --help

cd ${cc_dexbot_git_src_path} || exit 1
firejail \\
--name=${cc_dexbot_strategy_taker_file_name} \\
--whitelist=\`pwd\` \\
--read-only=\`pwd\` \\
--mkfile=\`pwd\`/${cc_dexbot_strategy_taker_file_name}.tmp.cfg \\
--read-write=\`pwd\`/${cc_dexbot_strategy_taker_file_name}.tmp.cfg \\
--mkfile=\`pwd\`/${cc_dexbot_strategy_taker_file_name}.tmp.pricing \\
--read-write=\`pwd\`/${cc_dexbot_strategy_taker_file_name}.tmp.pricing \\
--whitelist=\${HOME}/.proxychains \\
--read-only=\${HOME}/.proxychains \\
--whitelist=\${HOME}/.local/bin \\
--read-only=\${HOME}/.local/bin \\
--whitelist=\${HOME}/.local/lib \\
--read-only=\${HOME}/.local/lib \\
    ${cc_proxychains} \\
            python3 dexbot_v2_run.py --config ${cc_dexbot_strategy_taker_file_name} \$@
" > ${cc_dexbot_run_strategy_taker_name} && chmod 755 ${cc_dexbot_run_strategy_taker_name}
(test $? != 0) && echo "ERROR >> dexbot strategy run script >> ${cc_dexbot_run_strategy_taker_name} >> generate failed" && exit 1

# generate dexbot proxy cache firejail run script
cc_dexbot_run_proxy_cache_file_name="run.firejail.proxy.sh"
if [ ! -f "${cc_dexbot_run_proxy_cache_file_name}" ]; then
    echo "INFO >> creating ${cc_dexbot_run_proxy_cache_file_name}"
    
    echo "#!/bin/bash

# run proxy script generated with ./setup.cc.dexbot.profile.sh --help

cd ${cc_dexbot_git_src_path} || exit 1
firejail \\
--name=proxy_server_cachce \\
--whitelist=\`pwd\` \\
--read-only=\`pwd\` \\
--mkfile=\`pwd\`/proxy.tmp.pricing \\
--read-write=\`pwd\`/proxy.tmp.pricing \\
--whitelist=\${HOME}/.proxychains \\
--read-only=\${HOME}/.proxychains \\
--whitelist=\${HOME}/.local/bin \\
--read-only=\${HOME}/.local/bin \\
--whitelist=\${HOME}/.local/lib \\
--read-only=\${HOME}/.local/lib \\
    ${cc_proxychains} \\
            python3 dexbot_v2_proxy_run.py \$@
" > ${cc_dexbot_run_proxy_cache_file_name} && chmod 755 ${cc_dexbot_run_proxy_cache_file_name}
    (test $? != 0) && echo "ERROR >> dexbot proxy cache firejail run script >> ${cc_dexbot_run_proxy_cache_file_name} >> generate failed" && exit 1
fi

# list of generated scripts
echo "Generated dexbot strategies and pricing proxy >> ${cc_dexbot_install_dir_path} >>"
echo "${cc_dexbot_run_strategy_taker_name}"
echo "${cc_dexbot_run_strategy_maker_name}"
echo "${cc_dexbot_run_proxy_cache_file_name}"

# exit

echo "*** DEXBOT SETUP SUCCESS ***"

exit 0

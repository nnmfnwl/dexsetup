#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1
source "./src/tools.cc.blockdx.firejail.sh" || exit 1

# showhelp is auto set by tools
tool_blockdx_firejail_show_help

# handle arguments
cc_script_cfg_path_default="./src/cfg.blockdx.sh"
cc_script_cfg_path=
cc_blocknet_cfg_path_default="./src/cfg.cc.blocknet.sh"
cc_blocknet_cfg_path=
# install dir path default is included in blockdx config
cc_install_dir_path=
cc_firejail_profile_name_default="default"
cc_firejail_profile_name=

cc_firejail_default="firejail"
cc_firejail=${cc_firejail_default}
cc_proxychains_default="proxychains -q"
cc_proxychains=${cc_proxychains_default}

# process command line arguments
argc=$#
argv=("$@")
tool_blockdx_firejail_process_arguments ${argc} ${argv}

# start measuring time
tool_time_start

tool_variable_info cc_firejail
tool_variable_info cc_proxychains
tool_variable_info cc_firejail_profile_name

# include main blockdx cfg script IE: ./src/cfg.blockdx.sh
tool_variable_check_load_default cc_script_cfg_path cc_script_cfg_path_default
tool_realpath cc_script_cfg_path "parameter #1 blockdx cfg script path"
tool_check_version_and_include_script ${cc_script_cfg_path} "loading blockdx cfg script" 

# check included "./src/cfg.blockdx.sh" cfg variables
tool_variable_check_load_default cc_install_dir_path_default "" "blockdx default install dir path"

# check ./src/cfg.cc.blocknet.sh cfg version
tool_variable_check_load_default cc_blocknet_cfg_path cc_blocknet_cfg_path_default "cfg.blocknet.sh arg"
tool_realpath cc_blocknet_cfg_path "cfg.blocknet.sh arg"
tool_check_script_version cc_blocknet_cfg_path "cfg.blocknet.sh arg"

# load custom variables from /src/cfg.cc.blocknet.sh cfg
tool_load_script_variable cc_blocknet_cfg_path cc_chain_dir_path_default cc_chain_dir_path "blocknet chain data dir"
tool_realpath cc_chain_dir_path "blocknet chain data dir"
tool_dir_if_notexist_exit cc_chain_dir_path "blocknet chain data dir"
tool_load_script_variable cc_blocknet_cfg_path cc_conf_name_default cc_blocknet_conf_name "blocknet conf file name"
cc_blocknet_conf_path=${cc_chain_dir_path}"/"${cc_blocknet_conf_name}

# load custom variable from blocknet.conf
tool_load_script_variable cc_blocknet_conf_path rpcuser rpcuser "blocknet conf file rpcuser"
tool_load_script_variable cc_blocknet_conf_path rpcport rpcport "blocknet conf file rpcport"
tool_load_script_variable cc_blocknet_conf_path rpcpassword rpcpassword "blocknet conf file rpcpassword"

# prepare install directory path
cc_install_dir_path_default_tmp=${cc_dexsetup_dir_path}"/../"${cc_install_dir_path_default}
tool_variable_check_load_default cc_install_dir_path cc_install_dir_path_default_tmp
tool_realpath cc_install_dir_path "cc install dir path"
tool_make_and_check_dir_path cc_install_dir_path "cc install dir path"

# firejail blockdx profile name
tool_variable_check_load_default cc_firejail_profile_name cc_firejail_profile_name_default

# firejail blockdx run script file path
cc_blockdx_firejail_run_script_path=${cc_install_dir_path}"/firejail.blockdx."${cc_firejail_profile_name}".sh"
tool_realpath cc_blockdx_firejail_run_script_path "blockdx firejail run script"

# prepare blockdx profile data path
cc_profile_data_path=${cc_install_dir_path}"/data/profile/"${cc_firejail_profile_name}"/"
tool_make_and_check_dir_path cc_profile_data_path "blockdx firejail profiles data path"

# blockdx default meta json file
cc_profile_app_meta_json_path=${cc_profile_data_path}"/app-meta.json"

# prepare bin files path
cc_bin_dir="data/download/bin"
cc_bin_path=${cc_install_dir_path}"/"${cc_bin_dir}
tool_realpath cc_bin_path "binary files path"
tool_dir_if_notexist_exit cc_bin_path "binary file path" 

# firejail blockdx run script file path
cc_blockdx_firejail_run_script2_filename="firejail.blockdx."${cc_firejail_profile_name}".sh"
cc_blockdx_firejail_run_script2_path=${cc_bin_path}"/"${cc_blockdx_firejail_run_script2_filename}
tool_realpath cc_blockdx_firejail_run_script2_path "blockdx firejail run script"

# generate firejail blockdx run script 1
script_data="#!/bin/bash

# run script generated with ./setup.cc.blockdx.firejail.sh --help

cd ${cc_bin_dir} || exit 1

firejail \\
--name=${cc_firejail_profile_name} \\
--whitelist=\`pwd\` \\
--read-only=\`pwd\` \\
--whitelist=\${HOME}/.proxychains \\
--read-only=\${HOME}/.proxychains \\
--mkdir=${cc_profile_data_path} \\
--whitelist=${cc_profile_data_path} \\
--whitelist=${cc_chain_dir_path}/blocknet.conf \\
--read-only=${cc_chain_dir_path}/blocknet.conf \\
--whitelist=${cc_chain_dir_path}/xbridge.conf \\
--read-only=${cc_chain_dir_path}/xbridge.conf \\
    ./${cc_blockdx_firejail_run_script2_filename}
"
tool_make_and_chmod_script_or_exit cc_blockdx_firejail_run_script_path script_data "create blockdx firejail run script"

# generate firejail blockdx run script 2
script_data2="#!/bin/bash

# run script generated with ./setup.cc.blockdx.firejail.sh --help

mkdir -p ~/.config/ || exit 1
ln -s ${cc_profile_data_path} ~/.config/BLOCK-DX || exit 1

${cc_proxychains} \\
    ./block-dx --no-sandbox --no-zygote --disable-gpu
"
tool_make_and_chmod_script_or_exit cc_blockdx_firejail_run_script2_path script_data2 "create blockdx firejail run script2"

cc_profile_app_meta_json_data="{
  \"locale\": \"en\",
  \"zoomFactor\": 1,
  \"pricingSource\": \"CRYPTO_COMPARE\",
  \"apiKeys\": {},
  \"pricingUnit\": \"BTC\",
  \"pricingFrequency\": 120000,
  \"pricingEnabled\": true,
  \"showWallet\": false,
  \"addresses\": {},
  \"confUpdaterDisabled\": true,
  \"tos\": true,
  \"port\": \"${rpcport}\",
  \"blocknetIP\": \"127.0.0.1\",
  \"upgradedToV4\": true,
  \"tokenPaths\": {
    \"BLOCK\": \"${cc_chain_dir_path}\",
    \"TBLOCK\": \"${cc_chain_dir_path}\"
  },
  \"user\": \"${rpcuser}\",
  \"password\": \"${rpcpassword}\",
  \"selectedWallets\": [
    \"blocknet--v4.2.0\",
    \"blocktest--v4.3.3\"
  ],
  \"showAllOrders\": false,
  \"keyPair\": [
    \"BLOCK\",
    \"BTC\"
  ],
  \"autofillAddresses\": true,
  \"isFirstRun\": false,
  \"bounds\": {
    \"x\": 156,
    \"y\": 20,
    \"width\": 1052,
    \"height\": 720
  }
}
"

tool_make_and_chmod_script_or_exit cc_profile_app_meta_json_path cc_profile_app_meta_json_data "blockdx default app json file"

tool_time_finish_print

exit 0

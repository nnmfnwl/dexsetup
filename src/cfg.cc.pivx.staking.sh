cc_setup_helper_version="20210827"

source "./src/cfg.cc.pivx.sh" || exit 1

cc_chain_dir_path_default="~/.pivx_staking"
cc_wallet_name_default="wallet_pivx_staking"

cc_port=52482
cc_rpcport=52483

# lines will eval before add
cc_main_cfg_add='
staking=
'${cc_main_cfg_add}

cc_setup_helper_version="20210827"

source "./src/cfg.cc.blocknet.sh" || exit 1

cc_chain_dir_path_default="~/.blocknet_dao"
cc_wallet_name_default="wallet_block_dao"

cc_port=41432
cc_rpcport=41434

# lines will eval before add
cc_main_cfg_add='
classic=0
staking=0
'${cc_main_cfg_add}

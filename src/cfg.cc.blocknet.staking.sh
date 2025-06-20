cc_setup_helper_version="20210827"

source "./src/cfg.cc.blocknet.sh" || exit 1

cc_chain_dir_path_default="~/.blocknet_staking"
cc_wallet_name_default="wallet_block_staking"

cc_port=41422
cc_rpcport=41424

# lines will eval before add
cc_main_cfg_add='
classic=1
staking=1
'${cc_main_cfg_add}

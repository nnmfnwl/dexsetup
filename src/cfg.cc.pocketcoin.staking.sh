cc_setup_helper_version="20210827"

source "./src/cfg.cc.pocketcoin.sh" || exit 1

cc_chain_dir_path_default="~/.pocketcoin_staking"
cc_wallet_name_default="wallet_pkoin_staking"

cc_port=37080
cc_rpcport=37081

# lines will eval before add
cc_main_cfg_add='
staking=1
'${cc_main_cfg_add}

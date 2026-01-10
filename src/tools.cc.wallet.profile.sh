
function tool_firejail_show_help() {
    if [ "${showhelp}" == "yes" ]; then
        echo ""
        echo "*** ABOUT ***"
        echo ""
        echo "crypto currency firejail sandboxing setup helper script for Debian based Linux operating systems or subsystems"
        echo ""
        echo "*** USAGE ***"
        echo ""
        echo ""${0}" <optional arguments>"
        echo ""
        echo "*** ARGUMENTS(optional) ***"
        echo ""
        echo "<|path/to/custom/wallet/config/script.sh>"
        echo " >> relative or absolute path for valid crypto config script"
        echo " >> first path argument is always taken as path to crypto config script"
        echo " >> (default: ${cc_script_cfg_path_default})"
        echo ""
        echo "<|/path/to/crypto/custom/blockchain/data/directory/>"
        echo " >> crypto currency blockchain path directory(default specified in config script)"
        echo " >> second path argument is always taken as custom crypto install directory"
        echo " >> it is mandatory to set custom install directory first"
        echo " >> (default: variable cc_chain_dir_path_default= specified in ${cc_script_cfg_path_default})"
        echo ""
        echo "<|/path/to/crypto/custom/bin/directory/>"
        echo " >> crypto currency directory root bin path directory(default specified in config script)"
        echo " >> third path argument is always taken as custom crypto bin directory"
        echo " >> (default: variable cc_install_dir_path_default= specified in ${cc_script_cfg_path_default} as relative path to root of dexsetup)"
        echo ""
        echo "<|update_cc_config>"
        echo " >> existing target main cc configuration files will be updated"
        echo " >> (default: '${cc_action_cc_config}')"
        echo ""
        echo "<|noproxychains>"
        echo " >> by default, generated scripts uses proxychains(by default tor network) to transmit data private way"
        echo " >> noproxychains option is here to disable privacy, also it will speeed up wallet data download/upload process"
        echo " >> (default: ${cc_proxychains_default})"
        echo ""
        echo "<|wallet_ticker_custom_name>"
        echo " >> custom wallet.dat naming(default is specified in config script, custom must start by word wallet)"
        echo ""
        echo "<|custom_firejail_profile_name_suffix>"
        echo " >> if no custom profile name is specified, wallet_ticker_custom_name or cc_wallet_name_default is used"
        echo " >> to make multiple custom firejail profile names/profiles"
        echo " >> ie: to start multiple wallets with multiple data directories at same time"
        echo " >> ie: to have profiles for multiple wallet dat files"
        echo ""
        echo "example:"
        echo ""${0}" ${cc_script_cfg_path_default}"
        echo ""${0}" ${cc_script_cfg_path_default} wallet_block"
        echo ""${0}" ${cc_script_cfg_path_default} ~/.blocknet wallet_block_dex update_cc_config"
        echo ""${0}" ${cc_script_cfg_path_default} ~/.blocknet_staking wallet_block_staking ~/dexsetup/blocknet"
        echo ""
        exit 0
    fi
}

function tool_firejail_process_arguments() {  #argc  #argv
    argc=${1}
    argv=${2}

    for (( j=0; j<argc; j++ )); do
        if [[ "${argv[j]}" == "noproxychains" ]]; then
            if [ "${cc_proxychains}" = "${cc_proxychains_default}" ]; then
                cc_proxychains=
                tool_info " " cc_firejail "proxychains disabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [[ "${argv[j]}" == *"/"* ]] ;then
            if [ "${cc_script_cfg_path}" = "" ]; then
                cc_script_cfg_path="${argv[j]}"
                tool_info " " cc_script_cfg_path "custom cc wallet config path arg"
            elif [ "${cc_chain_dir_path}" = "" ]; then
                cc_chain_dir_path="${argv[j]}"
                tool_info " " cc chain dir path "ARG"
            elif [ "${cc_install_dir_path}" = "" ]; then
                cc_install_dir_path="${argv[j]}"
                tool_info " " cc_install_dir_path} "ARG"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "update_cc_config" ]; then
            if [ "${cc_action_cc_config}" = "" ]; then
                cc_action_cc_config="update"
                tool_info " " cc_action_cc_config "update cc config enabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [[ "${argv[j]}" == "wallet"* ]] ;then
            if [ "${cc_wallet_name}" = "" ]; then
                cc_wallet_name="${argv[j]}"
                tool_info " " cc_wallet_name "custom wallet name set"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        else
            if [ "${cc_firejail_profile_name_suffix}" = "" ]; then
                cc_firejail_profile_name_suffix="${argv[j]}"
                tool_info " " cc_firejail_profile_name_suffix "custom firejail profile name set"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        fi    
    done
}

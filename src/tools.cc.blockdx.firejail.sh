
function tool_blockdx_firejail_show_help() {
    if [ "${showhelp}" == "yes" ]; then
        echo ""
        echo "*** ABOUT ***"
        echo ""
        echo "crypto currency BlockDX GUI firejail sanboxing profile setup helper script for Debian"
        echo ""
        echo "*** USAGE ***"
        echo ""
        echo ""${0}" <optional arguments>"
        echo ""
        echo "*** ARGUMENTS(optional) ***"
        echo ""
        echo "<path/to/crypto/blockdx/config/script.sh>"
        echo " >> relative or absolute path for valid blocknet BlockDX DEX configuration script"
        echo " >> first path argument is always taken as path to blockdx config script"
        echo ""
        echo "<path/to/crypto/blocknet/config/script.sh>"
        echo " >> relative or absolute path for valid blocknet crypto currency configuration script"
        echo " >> with this blocknet instance the blockdx will be configured with"
        echo " >> second path argument is always taken as path to blocknet config script"
        echo ""
        echo "<custom firejail profile name>"
        echo " >> by default 'default' profile name is used"
        echo " >> ability to run multiple BlockDX instances connected to two different blocknet wallets"
        echo ""
        echo "</path/to/custom/blockdx/install/directory/>"
        echo " >> BlockDX installation root path directory"
        echo " >> (default specified in config script)"
        echo " >> third path argument is always taken as custom blockdx install directory"
        echo ""
        echo "<|noproxychains>"
        echo " >> by default, generated scripts uses proxychains(by default tor network) to transmit data private way"
        echo " >> noproxychains option is here to disable privacy, also it will speeed up data download/upload process"
        echo ""
        echo "<|nofirejail>"
        echo " >> by default, generated scripts uses firejail secured sandbox to prevent malicious activities or data leak)"
        echo " >> nofirejail option is here to disable sanboxing"
        echo " >> it is NOT recommended to use this option"
        echo ""
        echo "example:"
        echo ""${0}" ./src/cfg.blockdx.sh "
        echo ""${0}" ./src/cfg.blockdx.sh ./src/cfg.blockdx.sh ./src/cfg.cc.blockdx.sh ~/dexsetup/blockdx/blockdx.1.9.5 default"
        echo ""
        exit 0
    fi
}

function tool_blockdx_firejail_process_arguments() {  #argc  #argv
    argc=${1}
    argv=${2}

    for (( j=0; j<argc; j++ )); do
        if [ "${argv[j]}" = "nofirejail" ]; then
            if [ "${cc_firejail}" = "${cc_firejail_default}" ]; then
                cc_firejail=
                tool_info " " cc_firejail "firejail disabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "noproxychains" ]; then
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
                tool_info " " cc_script_cfg_path "custom blockdx config path arg"
            elif [ "${cc_blocknet_cfg_path}" = "" ]; then
                cc_blocknet_cfg_path="${argv[j]}"
                tool_info " " cc_blocknet_cfg_path "custom blocknet config path arg"
            elif [ "${cc_install_dir_path}" = "" ]; then
                cc_install_dir_path="${argv[j]}"
                tool_info " " cc_install_dir_path "custom install dir path arg"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        else
            if [ "${cc_firejail_profile_name}" = "" ]; then
                cc_firejail_profile_name="${argv[j]}"
                tool_info " " cc_firejail_profile_name "custom firejail profile arg"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        fi   
    done
}

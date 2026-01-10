
function tool_wallet_show_help() {
    if [ "${showhelp}" == "yes" ]; then
        echo ""
        echo "*** ABOUT ***"
        echo ""
        echo "crypto currency wallet and daemon setup helper script for Debian based Linux operating systems or subsystems"
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
        echo "<|download|build>"
        echo " >> download >> download and extract precompiled binary files"
        echo " >> build >> build session from source code"
        echo " >> (default: ${cc_action1_default})"
        echo ""
        echo "<|install|update|reinstall|continue|purge>"
        echo " >> install >> action for new installation"
        echo " >> update >> action to try clean,update and rebuild source into latest version"
        echo " >> reinstall >> action for source code to be removed and recompiled from scratch"
        echo " >> continue >> action to try continue in previously canceled installation"
        echo " >> purge >> action to remove all files related to previous download or build"
        echo " >> (default: ${cc_action2_default})"
        echo ""
        echo "<|/path/to/custom/cryptop/install/directory/>"
        echo " >> crypto currency intallation root path directory(default specified in config script like ~/dexsetup/***)"
        echo " >> second path argument is always taken as custom crypto install directory"
        echo " >> (default: variable cc_install_dir_path_default= specified in ${cc_script_cfg_path_default} as relative path to root of dexsetup)"
        echo ""
        echo "<|nofirejail>"
        echo " >> by default whole build process is done in firejail(secured sandbox environment to prevent malicious activities or data leak)"
        echo " >> nofirejail option is here to disable sanboxing"
        echo " >> it is NOT recommended to use this option"
        echo " >> (default: ${cc_firejail_default})"
        echo ""
        echo "<|noproxychains>"
        echo " >> by default, build process uses proxychains(by default tor network) to transmit data private way"
        echo " >> noproxychains option is here to disable privacy, also it will speeed up data downloading process"
        echo " >> (default: ${cc_proxychains_default})"
        echo ""
        echo "examples:"
        echo ""${0}" ${cc_script_cfg_path_default} build install"
        echo ""
        exit 0
    fi
}

function tool_wallet_process_arguments() {  #argc  #argv
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
        elif [ "${argv[j]}" = "download" ]; then
            if [ "${cc_action1}" = "" ]; then
                cc_action1="download"
                tool_info " " cc_action1 "download|build"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "build" ]; then
            if [ "${cc_action1}" = "" ]; then
                cc_action1="build"
                tool_info " " cc_action1 "download|build"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "install" ]; then
            if [ "${cc_action2}" = "" ]; then
                cc_action2="install"
                tool_info " " cc_action2 "install|update|reinstall|continue|purge"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "update" ]; then
            if [ "${cc_action2}" = "" ]; then
                cc_action2="update"
                tool_info " " cc_action2 "install|update|reinstall|continue|purge"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "reinstall" ]; then
            if [ "${cc_action2}" = "" ]; then
                cc_action2="reinstall"
                tool_info " " cc_action2 "install|update|reinstall|continue|purge"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "continue" ]; then
            if [ "${cc_action2}" = "" ]; then
                cc_action2="continue"
                tool_info " " cc_action2 "install|update|reinstall|continue|purge"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "purge" ]; then
            if [ "${cc_action2}" = "" ]; then
                cc_action2="purge"
                tool_info " " cc_action2 "install|update|reinstall|continue|purge"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [[ "${argv[j]}" == *"/"* ]] ;then
            if [ "${cc_script_cfg_path}" = "" ]; then
                cc_script_cfg_path="${argv[j]}"
                tool_info " " cc_script_cfg_path "custom cc wallet config path arg"
            elif [ "${cc_install_dir_path}" = "" ]; then
                cc_install_dir_path="${argv[j]}"
                tool_info " " cc_install_dir_path "custom install dir path arg"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    done
}

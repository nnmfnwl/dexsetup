
function tool_simplex_show_help() {
    if [ "${showhelp}" == "yes" ]; then
        echo ""
        echo "*** ABOUT ***"
        echo ""
        echo "Simplex(ultimate privacy messenger) setup helper script for Debian"
        echo "To know more about Simplex, visit simplex.chat"
        echo ""
        echo "*** USAGE ***"
        echo ""
        echo ""${0}" <optional arguments>"
        echo ""
        echo "*** ARGUMENTS(optional) ***"
        echo ""
        echo "<path/to/custom/simplex/config/script.sh>"
        echo " >> relative or absolute path for valid Simplex configuration script"
        echo " >> first path argument is always taken as path to Simplex config script"
        echo " >> (default: ${cc_script_cfg_path_default})"
        echo ""
        echo "<download|build>"
        echo " >> download >> download and extract precompiled binary files"
        echo " >> build >> build simplex from source code"
        echo " >> (default: ${cc_action1_default})"
        echo ""
        echo "<install|update|purge>"
        echo " >> install >> action to try new installation"
        echo " >> update >> action to try update to new version"
        echo " >> purge >> action to try remove all download and generated data"
        echo " >> (default: ${cc_action2_default})"
        echo ""
        echo "</path/to/custom/simplex/install/directory/>"
        echo " >> Custom previously installed Simplex root directory path"
        echo " >> second path argument is always taken as custom simplex install directory"
        echo " >> (default: specified in config script)"
        echo ""
        echo "<|noproxychains>"
        echo " >> by default, generated scripts uses proxychains(by default tor network) to transmit data private way"
        echo " >> noproxychains option is here to disable privacy, it also increase speeed up data download/upload process"
        echo ""
        echo "<|nofirejail>"
        echo " >> by default, generated scripts uses firejail secured sandbox to prevent malicious activities or data leak)"
        echo " >> nofirejail option is here to disable sanboxing"
        echo " >> it is NOT recommended to use this option"
        echo ""
        echo "example:"
        echo ""${0}" ./src/cfg.simplex.sh"
        echo ""${0}" ./src/cfg.simplex.sh download install ./src/cfg.simplex.sh ~/dexsetup/simplex/latest"
        exit 0
    fi
}


function tool_simplex_process_arguments() {  #argc  #argv
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
                tool_info " " cc_script_cfg_path "custom simplex config path arg"
            elif [ "${cc_install_dir_path}" = "" ]; then
                cc_install_dir_path="${argv[j]}"
                tool_info " " cc_install_dir_path "custom install dir path arg"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "download" ]; then
            if [ "${cc_action1}" = "" ]; then
                cc_action1="download"
                tool_info " " cc_action1 "download enabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "build" ]; then
            if [ "${cc_action1}" = "" ]; then
                cc_action1="build"
                tool_info " " cc_action1 "build enabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "install" ]; then
            if [ "${cc_action2}" = "" ]; then
                cc_action2="install"
                tool_info " " cc_action2 "install enabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "update" ]; then
            if [ "${cc_action2}" = "" ]; then
                cc_action2="update"
                tool_info " " cc_action2 "update enabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "purge" ]; then
            if [ "${cc_action2}" = "" ]; then
                cc_action2="purge"
                tool_info " " cc_action2 "purge enabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        fi    
    done
}

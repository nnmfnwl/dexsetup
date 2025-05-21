
function tool_torbrowser_firejail_show_help() {
    if [ "${showhelp}" == "yes" ]; then
        echo ""
        echo "*** ABOUT ***"
        echo ""
        echo "Tor Browser firejail sanboxing profile setup helper script for Debian"
        echo ""
        echo "*** USAGE ***"
        echo ""
        echo ""${0}" <optional arguments>"
        echo ""
        echo "*** ARGUMENTS(optional) ***"
        echo ""
        echo "<path/to/torbrowser/config/script.sh>"
        echo " >> relative or absolute path for valid Tor browser configuration script"
        echo " >> first path argument is always taken as path to torbrowser config script"
        echo " >> (default: ${cc_script_cfg_path_default})"
        echo ""
        echo "<path/to/torbrowser/firejail/profile/template>"
        echo " >> relative or absolute path for valid Tor browser firejail profile template"
        echo " >> second path argument is always taken as path to Tor browser firejail profile template"
        echo ""
        echo "</path/to/custom/torbrowser/install/directory/>"
        echo " >> TorBrowser installation root path directory"
        echo " >> (default specified in config script)"
        echo " >> third path argument is always taken as custom torbrowser install directory"
        echo ""
        echo "<custom firejail profile name>"
        echo " >> by default 'default' profile name is used"
        echo " >> ability to have and even run multiple TorBrowser instances(profiles)"
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
        echo ""${0}""
        echo ""${0}" ./src/cfg.torbrowser.sh ./src/firejail.torbrowser.profile ~/dexsetup/torbrowser/latest default"
        echo ""
        exit 0
    fi
}

function tool_torbrowser_firejail_process_arguments() {  #argc  #argv
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
                tool_info " " cc_script_cfg_path "custom torbrowser config path arg"
            elif [ "${cc_firejail_profile_template_path}" = "" ]; then
                cc_firejail_profile_template_path="${argv[j]}"
                tool_info " " cc_firejail_profile_template_path "custom install dir path arg"
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

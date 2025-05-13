
function tool_session_firejail_show_help() {
    if [ "${showhelp}" == "yes" ]; then
        echo ""
        echo "*** ABOUT ***"
        echo ""
        echo "Session(ultimate privacy messenger) firejail sanboxing profile setup helper script for Debian"
        echo "To have multiple session profiles even run them at same time!"
        echo ""
        echo "*** USAGE ***"
        echo ""
        echo ""${0}" <optional arguments>"
        echo ""
        echo "*** ARGUMENTS(optional) ***"
        echo ""
        echo "<path/to/session/config/script.sh>"
        echo " >> relative or absolute path for valid Session configuration script"
        echo " >> first path argument is always taken as path to Session config script"
        echo " >> (default: ${cc_script_cfg_path_default})"
        echo ""
        echo "<custom firejail profile name>"
        echo " >> ability to have and even run multiple Session instances(profiles)"
        echo " >> (default: ${cc_firejail_profile_name_default})"
        echo ""
        echo "</path/to/custom/session/install/directory/>"
        echo " >> Custom previously installed Session root directory path"
        echo " >> second path argument is always taken as custom session install directory"
        echo " >> (default: specified in config script)"
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
        echo ""${0}" ./src/cfg.session.sh "
        echo ""${0}" ./src/cfg.session.sh ./src/cfg.session.sh ~/dexsetup/session/session.1.9.5 default"
        echo ""${0}" ./src/cfg.session.sh custom_profile_name"
        echo ""
        exit 0
    fi
}

function tool_session_firejail_process_arguments() {  #argc  #argv
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
                tool_info " " cc_script_cfg_path "custom session config path set"
            elif [ "${cc_install_dir_path}" = "" ]; then
                cc_install_dir_path="${argv[j]}"
                tool_info " " cc_install_dir_path "custom install dir path set"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        else
            if [ "${cc_firejail_profile_name}" = "" ]; then
                cc_firejail_profile_name="${argv[j]}"
                tool_info " " cc_firejail_profile_name "custom firejail profile set"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        fi   
    done
}

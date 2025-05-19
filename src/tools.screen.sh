
function tool_screen_show_help() {
    # showhelp is auto set by tools
    if [ "${showhelp}" == "yes" ]; then
        echo ""
        echo "*** ABOUT ***"
        echo ""
        echo "EXPERIMENTAL SCRIPT. MOST OF THINGS ARE HARD CODED AND NOT DYNAMIC LIKE IN FINAL STABLE STAGE"
        echo ""
        echo "crypto currency screen start/stop/update maker script for Debian based Linux operating systems or subsystems"
        echo "start/stop/update.screen.<instance_default>.cli/qui.sh helpers made by dexsetup commands history"
        echo ""
        echo "*** USAGE ***"
        echo ""
        echo ""${0}" <arguments>"
        echo ""
        echo "*** ARGUMENTS ***"
        echo ""
        echo "<install|update|clean>"
        echo " >> install - create script for the first time"
        echo " >> update - overwrite existing script"
        echo " >> clean - cleanup existing dexsetup history"
        echo ""
        echo "<|instance_custom_name>"
        echo " >> generate screen script only for custom dexsetup instance specified by name(must start by word instance_"
        echo ""
        echo "<|nohtop>"
        echo " >> skip to create htop screen window"
        echo ""
        echo "<|nodexsetup>"
        echo " >> skip to create DXLP screen window"
        echo ""
        echo "<|noedit>"
        echo " >> skip to create edit screen window"
        echo ""
        echo "<|notorbrowser>"
        echo " >> skip to create tor browser window"
        echo ""
        echo "<|nobravebrowser>"
        echo " >> skip to create brave browser window"
        echo ""
        echo "<|nosession>"
        echo " >> skip to create session app window"
        echo ""
        echo "<|nowalletautorun>"
        echo " >> no wallet will be automatically started, but predefined in command line typed in, executed must be manually"
        echo ""
        echo "<|nodexbotautorun>"
        echo " >> no dexbot strategies  be automatically started, but predefined in command line typed in, executed must be manually"
        echo ""
        echo "<|noproxychains>"
        echo " >> by default, generated scripts uses proxychains(by default tor network) to transmit data private way"
        echo " >> noproxychains option is here to disable privacy, also it will speeed up wallet data download/upload process"
        echo ""
        echo "example:"
        echo ""${0}" install"
        echo ""
        exit 0
    fi
}

function tool_screen_process_arguments() {  #argc  #argv
    argc=${1}
    argv=${2}
    
    for (( j=0; j<argc; j++ )); do
        if [[ "${argv[j]}" == "instance_"* ]] ;then
            if [ "${cc_instance}" == "${cc_instance_default}" ]; then
                cc_instance="${argv[j]}"
                tool_info " " cc_instance "using custom instance name"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
            elif [ "${argv[j]}" = "install" ]; then
            if [ "${cc_action_screen}" = "" ]; then
                cc_action_screen="install"
                tool_info " " cc_action_screen "install enabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "update" ]; then
            if [ "${cc_action_screen}" = "" ]; then
                cc_action_screen="update"
                tool_info " " cc_action_screen "update enabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "clean" ]; then
            if [ "${cc_action_screen}" = "" ]; then
                cc_action_screen="clean"
                tool_info " " cc_action_screen "clean enabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "nohtop" ]; then
            if [ "${cc_nohtop}" = "" ]; then
                cc_nohtop="nohtop"
                tool_info " " cc_nohtop "htop disabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "nodexsetup" ]; then
            if [ "${cc_nodexsetup}" = "" ]; then
                cc_nodexsetup="nodexsetup"
                tool_info " "  cc_nodexsetup "dexsetup disabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "noedit" ]; then
            if [ "${cc_noedit}" = "" ]; then
                cc_noedit="noedit"
                tool_info " " cc_noedit "edit disabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "nowalletautorun" ]; then
            if [ "${cc_nowalletautorun}" = "" ]; then
                cc_nowalletautorun="nowalletautorun"
                tool_info " " cc_nowalletautorun "walletautorun disabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "nodexbotautorun" ]; then
            if [ "${cc_nodexbotautorun}" = "" ]; then
                cc_nodexbotautorun="nodexbotautorun"
                tool_info " " cc_nodexbotautorun "dexbotautorun disabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "notorbrowser" ]; then
            if [ "${cc_notorbrowser}" = "" ]; then
                cc_notorbrowser="notorbrowser"
                tool_info " " cc_notorbrowser "tor browser disabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [[ "${argv[j]}" =~ ^[0-9]+$ ]]; then
            if [ "${cc_sleepnum}" == "${cc_sleepnum_default}" ]; then
                cc_sleepnum="${argv[j]}"
                tool_info " " cc_sleepnum "sleepnum is ${cc_sleepnum}"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "noproxychains" ]; then
            if [ "${cc_proxychains}" = "${cc_proxychains_default}" ]; then
                cc_proxychains=
                tool_info " " cc_proxychains "proxychains disabled"
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

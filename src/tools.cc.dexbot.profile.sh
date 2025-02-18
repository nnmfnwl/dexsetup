
function tool_dexbot_show_help() {
    if [ "${showhelp}" == "yes" ]; then
        echo ""
        echo "*** ABOUT ***"
        echo ""
        echo "crypto currency blocknet decentralized exchange trading bot setup helper script for Debian based Linux operating systems or subsystems"
        echo ""
        echo "*** USAGE ***"
        echo ""
        echo ""${0}" <path/to/crypto/blocknet/config/script.sh> <path/to/crypto/maker/config/script.sh> <path/to/crypto/taker/config/script.sh> <path/to/dexbot/config/script.sh> <path/to/dexbot/strategy/config/script.sh> <optional arguments>"
        echo ""
        echo "*** ARGUMENTS(mandatory) ***"
        echo ""
        echo "<path/to/crypto/blocknet/script.sh>"
        echo " >> relative or absolute path for valid blocknet crypto currency configuration script"
        echo " >> blocknet used as xbridge entry point to blocknet network"
        echo ""
        echo "<path/to/crypto/maker/script.sh>"
        echo " >> relative or absolute path for valid maker crypto currency configuration script"
        echo ""
        echo "<path/to/crypto/taker/script.sh>"
        echo " >> relative or absolute path for valid maker crypto currency configuration script"
        echo ""
        echo "<path/to/dexbot/config/script.sh>"
        echo " >> relative or absolute path for valid dexbot configuration script"
        echo ""
        echo "<path/to/dexbot/strategy/config/script.sh>"
        echo " >> relative or absolute path for valid dexbot strategy configuration script"
        echo ""
        echo "*** ARGUMENTS(optional) ***"
        echo ""
        echo "<update_source>"
        echo " >> existing source code of dexbot will be updated with last version of repository"
        echo " >> THIS COULD CAUSE PREVIOUS GENERATED TRADING PAIR SCRIPTS INCOMPATIBILITY"
        echo ""
        echo "<update_cc_config>"
        echo " >> existing target main cc configuration files will be overwritten"
        echo ""
        echo "<update_xb_config>"
        echo " >> existing target xbridge configuration variables will be overwritten"
        echo ""
        echo "<update_strategy>"
        echo " >> existing target dexbot strategy generated files will be overwritten"
        echo ""
        echo "</path/to/custom/dexbot/install/directory/>"
        echo " >> crypto currency maker bot scripts installation root path directory"
        echo " >> (default specified in config script)"
        echo " >> first path argument is always taken as custom dexbot install directory"
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
        echo "<|optional_suffix>"
        echo " >> optional suffix for generated files. Useful when ie, predefined multiple strategies on same pair running simultaneously or..."
        echo ""
        echo "<|optional_address_maker>"
        echo "<|optional_address_taker>"
        echo " >> of optional suffix string is set, next 2 strings are maker and taker address"
        echo "example:"
        echo ""${0}" ./src/cfg.cc.blocknet.sh ./src/cfg.cc.blocknet.sh ./src/cfg.cc.litecoin.sh  ./src/cfg.dexbot.alfa.sh  ./src/cfg.strategy.block.ltc.sh mybasicstrategy BBBblocknetaddressBBB LLLlitecoinaddressLLL"
        echo ""
        exit 0
    fi
}


function tool_dexbot_process_arguments() {  #argc  #argv
    argc=${1}
    argv=${2}

    for (( j=5; j<argc; j++ )); do
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
        elif [ "${argv[j]}" = "update_source" ]; then
            if [ "${cc_action_source}" = "" ]; then
                cc_action_source="update"
                tool_info " " cc_action_source "update source enabled"
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
        elif [ "${argv[j]}" = "update_xb_config" ]; then
            if [ "${cc_action_xb_config}" = "" ]; then
                cc_action_xb_config="update"
                tool_info " " cc_action_xb_config "update xb config enabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [ "${argv[j]}" = "update_strategy" ]; then
            if [ "${cc_action_strategy}" = "" ]; then
                cc_action_strategy="update"
                tool_info " " cc_action_strategy "INFO >> update strategy enabled"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        elif [[ "${argv[j]}" == *"/"* ]] ;then
            if [ "${cc_dexbot_install_dir_path}" = "" ]; then
                cc_dexbot_install_dir_path="${argv[j]}"
                tool_info " " cc_dexbot_install_dir_path "custom install dir path arg"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        else
            if [ "${cc_dexbot_naming_suffix}" = "" ]; then
                cc_dexbot_naming_suffix="${argv[j]}"
                tool_info " " cc_dexbot_naming_suffix "custom dexbot naming"
            elif [ "${cc_address_maker}" = "" ]; then
                cc_address_maker="${argv[j]}"
                tool_info " " cc_address_maker "maker address"
            elif [ "${cc_address_taker}" = "" ]; then
                cc_address_taker="${argv[j]}"
                tool_info " " cc_address_taker "taker address"
            else
                echo "Invalid argument: $j ${argv[j]}"
                exit 1
            fi
        fi    
    done
}


# function to apply crypto config update and xbridge config update
function tool_dexbot_update_cc_cfg_xb_cfg() { # cfg.path # blocknet|maker|taker info #
    local cc_script_cfg_path_tmp=${1}
    local naming_suffix=${2}
    
    ## clean up variables
    cc_xbridge_cfg_name_default=
    
    ## check version and include script
    tool_check_version_and_include_script ${cc_script_cfg_path_tmp} ${naming_suffix}
    
        ## check chain directory
        cc_chain_dir_path=${cc_chain_dir_path_default}
        cc_chain_dir_path=`eval realpath -m ${cc_chain_dir_path}`
        mkdir -p ${cc_chain_dir_path}
        (test ! -d "${cc_chain_dir_path}") && echo "ERROR >> ${naming_suffix} >> make chain directory >> ${cc_chain_dir_path} >> failed" && exit 1
        echo "INFO >> ${naming_suffix} >> using cc_chain_dir_path >> ${cc_chain_dir_path}"
        
        ## check if xbridge config path cfg exists from blocknet configuration or try to extract it
        (test "${cc_xbridge_cfg_path}" = "") && (test "${cc_xbridge_cfg_name_default}" = "") && echo "ERROR >> ${naming_suffix} >> source config file >> ${1} >> invalid or missing cc_xbridge_cfg_name_default" && exit 1
        (test "${cc_xbridge_cfg_path}" = "") && cc_xbridge_cfg_path=${cc_chain_dir_path}"/"${cc_xbridge_cfg_name_default}
        
        ## main wallet conf file load
        cc_conf_path=${cc_chain_dir_path}"/"${cc_conf_name_default}
        echo "INFO >> ${naming_suffix} >> checking main cc config >> ${cc_conf_path}"
        (test ! -f "${cc_conf_path}") && touch ${cc_conf_path}
        (test ! -f "${cc_conf_path}") && echo "ERROR >> ${naming_suffix} >> ${cc_conf_path} >> not exist" && exit 1
        conf_data=$(<${cc_conf_path})
        
            ## create xbridge cfg file if not exist
            echo "INFO >> ${naming_suffix} >> checking xbridge config >> ${cc_xbridge_cfg_path}"
            (test ! -f "${cc_xbridge_cfg_path}") && touch ${cc_xbridge_cfg_path}
            (test ! -f "${cc_xbridge_cfg_path}") && echo "ERROR >> ${naming_suffix} >> ${cc_xbridge_cfg_path} >> not exist" && exit 1
            
            # read xbridge cfg file to variable
            echo "INFO >> ${naming_suffix} >> reading actual xbridge config"
            cc_xbridge_cfg_data=$(<${cc_xbridge_cfg_path})
            (test $? != 0) && echo "ERROR >> ${naming_suffix} >> ${cc_xbridge_cfg_path} >> read failed" && exit 1
            
            # remove xbridge cfg blank spaces from the end of lines
            echo "INFO >> ${naming_suffix} >> removing xbridge config blank spaces"
            cc_xbridge_cfg_data=$(
            echo "${cc_xbridge_cfg_data}" | sed \
                -e "s/[[:blank:]]*$//"
            )
            (test $? != 0) && echo "ERROR >> ${naming_suffix} >> ${cc_xbridge_cfg_path} >> remove blank spaces failed" && exit 1
            
            # for case if xbridge is already configured with another wallet
            # and xbridge is not marked to be updated
            # so we need to search for user, password and port in xbridge configuration
            # and apply values to man cc config if not exist or marked to be updated
            if [ "${cc_action_xb_config}" != "update" ]; then
                echo "${cc_xbridge_cfg_data}" | grep "\[${cc_ticker}\]" > /dev/null
                if [ $? == 0 ]; then
                    echo "INFO >> ${naming_suffix} >> searching [ticker] section config values"
                    # print [TICKER] lines up to next [ticker] or EOF as DELETELINE
                    tmp_xb_cfg_cc_section=$(
                    echo "$cc_xbridge_cfg_data" | sed \
                        -n "/^\[${cc_ticker}\]$/,/\(\[.*\]\|^$\)/ p"
                    )
                    (test $? != 0) && echo "ERROR >> ${naming_suffix} >> xbridge ticker section replace failed" && exit 1
                    
                    # replace rpc password/port/user if not updated because already exists
                    cc_rpcuser_tmp=`echo "${tmp_xb_cfg_cc_section}" | grep "^Username=" | cut -d "=" -f2`
                    cc_rpcpassword_tmp=`echo "${tmp_xb_cfg_cc_section}" | grep "^Password=" | cut -d "=" -f2`
                    cc_rpcport_tmp=`echo "${tmp_xb_cfg_cc_section}" | grep "^Port=" | cut -d "=" -f2`
                    (test "${cc_rpcuser_tmp}" != "") && cc_rpcuser=${cc_rpcuser_tmp}
                    (test "${cc_rpcpassword_tmp}" != "") && cc_rpcpassword=${cc_rpcpassword_tmp}
                    (test "${cc_rpcport_tmp}" != "") && cc_rpcport=${cc_rpcport_tmp}
                fi
            fi
            
    # filter out comments in cc_main_cfg_add variable
    cc_main_cfg_add=`echo "${cc_main_cfg_add}" | grep -v "^#"`
    (test $? != 0) && echo "ERROR >> filter out comments in cc_main_cfg_add variable >> failed" && exit 1
    
    # go all config lines to be added
    for cfg_line in ${cc_main_cfg_add}; do
        
        echo "FOR INFO >> processing add main conf line >> ${cfg_line}"
        # reprocess line by eval
        cfg_line=`eval echo ${cfg_line}`
        (test $? != 0) && echo "ERROR >> eval line >> ${cfg_line} >> failed" && exit 1
        
        # extract variable name and check if not empty
        var_name=`echo $cfg_line | cut -d "=" -f1`
        
        if [ "${var_name}" != "" ]; then
            
            #~ echo "updating/adding variable >> $var_name"
            
            if [ "${cc_action_cc_config}" = "update" ]; then
                # if existing variable, comment it
                # if commented variable, add new next to
                conf_data=$(
                echo "$conf_data" | sed \
                    -e "s/^${var_name}=/#~ ${var_name}=/" \
                    -e "0,/^#~ ${var_name}=/s/^#~ ${var_name}=.*/${cfg_line}\n&/"
                )
                (test $? != 0) && echo "ERROR >> update line >> ${cfg_line} >> ${cc_conf_path} >> failed" && exit 1
            fi
            
            # if variable not added next to comment, so add new line(PLEASE LET NEWLINE THERE)
            echo "${conf_data}" | grep "^${var_name}=" > /dev/null || conf_data="${conf_data}
${cfg_line}"
            (test $? != 0) && echo "ERROR >> add line >> ${cfg_line} >> ${cc_conf_path} >> failed" && exit 1
        fi
    done
    
    # replace rpc password/port/user if not updated because already exists
    cc_rpcpassword=`echo "${conf_data}" | grep "^rpcpassword=" | cut -d "=" -f2`
    cc_rpcport=`echo "${conf_data}" | grep "^rpcport=" | cut -d "=" -f2`
    cc_rpcuser=`echo "${conf_data}" | grep "^rpcuser=" | cut -d "=" -f2`
    
    # write down updated config to file
    echo "${conf_data}" > ${cc_conf_path}
    (test $? != 0) && echo "ERROR >> ${naming_suffix} >> update config >> ${cc_conf_path} >> failed" && exit 1
    
    
    
    
    
    # add xbridge cfg [MAIN] section if missing
    echo "INFO >> ${naming_suffix} >> updating xbridge config main section"
    echo "${cc_xbridge_cfg_data}" | grep "\[Main\]" > /dev/null
    if [ $? != 0 ]; then
        cc_xbridge_cfg_data="[Main]
ExchangeWallets=${cc_ticker}
FullLog=true
ShowAllOrders=true
${cc_xbridge_cfg_data}"
    fi

    # check xbridge MAIN section validity
    echo "${cc_xbridge_cfg_data}" | grep "ExchangeWallets=" > /dev/null
    (test $? != 0) && echo "ERROR >> ${naming_suffix} >> invalid xbridge cfg [Main], ExchangeWallets is missing >> ${cc_xbridge_cfg_path}" && exit 1
    
    # add ticker to ExchangeWallets section if missing
    echo "${cc_xbridge_cfg_data}" | grep "ExchangeWallets=" | grep "${cc_ticker}" > /dev/null
    if [ $? != 0 ]; then
        cc_xbridge_cfg_data=$(
        echo "${cc_xbridge_cfg_data}" | sed \
            -e "/^ExchangeWallets=/ s/$/,${cc_ticker}/"
        )
        (test $? != 0) && echo "ERROR >> ${naming_suffix} >> add ticker to ExchangeWallets section failed >> ${cc_xbridge_cfg_path}" && exit 1
    fi
    
    # null config
    cc_xbridge_cfg_add_eval=
    # process xbridge config to be added line by line
    for cc_xbridge_cfg_line in ${cc_xbridge_cfg_add}; do
        
        echo "FOR INFO >> processing add xbridge conf line >> ${cc_xbridge_cfg_line}"
        
        # reprocess line by eval
        cc_xbridge_cfg_line=$(eval "echo \"${cc_xbridge_cfg_line}\"")
        cc_xbridge_cfg_add_eval="${cc_xbridge_cfg_add_eval}
${cc_xbridge_cfg_line}"
        (test $? != 0) && echo "ERROR >> eval xbridge line >> ${cc_xbridge_cfg_line} >> failed" && exit 1
    done
    
    # remove actual section lines adn replace em with new xbridge config
    echo "${cc_xbridge_cfg_data}" | grep "\[${cc_ticker}\]" > /dev/null
    if [ $? == 0 ] && [ "${cc_action_xb_config}" = "update" ]; then
        echo "INFO >> ${naming_suffix} >> removing old xbridge config [ticker] section"
        # replace all [TICKER] lines up to next [ticker] or EOF as DELETELINE
        # replace first DELETELINE with REPLACELINE
        # remove all DELETELINE lines
        cc_xbridge_cfg_data=$(
        echo "$cc_xbridge_cfg_data" | sed \
            -e "/^\[${cc_ticker}\]$/,/\(\[.*\]\|^$\)/ s/.*=.*/DELETELINE/" \
            -e "0,/^DELETELINE$/ s/^DELETELINE$/REPLACELINE/" \
            -e "/^DELETELINE$/d"
        )
        (test $? != 0) && echo "ERROR >> ${naming_suffix} >> xbridge ticker section replace failed" && exit 1
        
        # add all configuration above REPLACELINE
        echo "INFO >> ${naming_suffix} >> updating xbridge config [ticker] section"
        for cc_xbridge_cfg_line in ${cc_xbridge_cfg_add_eval}; do
                cc_xbridge_cfg_data=$(
                echo "$cc_xbridge_cfg_data" | sed \
                    -e "0,/^REPLACELINE$/s/^REPLACELINE$/${cc_xbridge_cfg_line}\n&/"
            )
            (test $? != 0) && echo "ERROR >> add xbridge line >> ${cc_xbridge_cfg_line} >> failed" && exit 1
        done
        
        # finally remove REPLACELINE itself
        cc_xbridge_cfg_data=$(
        echo "$cc_xbridge_cfg_data" | sed \
            -e "/^REPLACELINE$/d"
        )
        (test $? != 0) && echo "ERROR >> ${naming_suffix} >> xbridge ticker section replaceline delete failed" && exit 1
    fi
    
    # add xbridge ticker section if is missing
    echo "${cc_xbridge_cfg_data}" | grep "\[${cc_ticker}\]" > /dev/null
    if [ $? != 0 ]; then
        echo "INFO >> ${naming_suffix} >> adding missing ticker section"
        cc_xbridge_cfg_data="${cc_xbridge_cfg_data}
[${cc_ticker}]${cc_xbridge_cfg_add_eval}"
    fi

    # check xbridge ticker section
    echo "${cc_xbridge_cfg_data}" | grep "\[${cc_ticker}\]" > /dev/null
    (test $? != 0) && echo "ERROR >> ${naming_suffix} >> invalid xbridge cfg [ticker] >> ${cc_xbridge_cfg_path}" && exit 1
    
    # write down updated config to file
    echo "INFO >> ${naming_suffix} >> writting down updated xbridge config file"
    echo "${cc_xbridge_cfg_data}" > ${cc_xbridge_cfg_path}
    (test $? != 0) && echo "ERROR >> ${naming_suffix} >> update config >> ${cc_xbridge_cfg_path} >> failed" && exit 1
    
    return 0
}



function tool_dexbot_strategy_template_update() {  #strategy.file.path #opposite.bot.yes
    # check parameters
    (test "${1}" == "") && echo "ERROR >> load strategy template var list >> no strategy file path parameter" && exit 1
    (test ! -f "${1}") && echo "ERROR >> load strategy template var list >> ${1} >> not exist" && exit 1
    
    help_text_var_name_suffix=_help_text
    
    (test "${2}" != "") && opposite_bot_suffix=_opposite
    
    # load template to variable
    local strategy_conf_data=$(<${1})
    local strategy_file=$(<${1})
    
    # extract template variables to update
    strategy_conf_data=`echo "$strategy_conf_data" | grep -o \{[a-z_]*\}`
    (test $? != 0) && echo "ERROR >> load strategy template var list >> ${1} >> grep variables failed" && exit 1
    
    # cut out variable names
    strategy_conf_data=$(
        echo "$strategy_conf_data" | sed \
            -e "s/{//g" \
            -e "s/}//g"
        )
    (test $? != 0) && echo "ERROR >> load strategy template var list >> ${1} >> sed variables failed" && exit 1
    
    echo "INFO >> load strategy template var list >> success"
    
    # for all template variables try to update template file
    for variable_name in ${strategy_conf_data}; do
    
        eval `echo "variable_value=\\$${variable_name}"`
        (test $? != 0) && echo "ERROR >> extract dexbot strategy config >> ${variable_name} >> failed"
        
        eval `echo "variable_value_opposite=\\$${variable_name}${opposite_bot_suffix}"`
        (test $? != 0) && echo "ERROR >> extract dexbot strategy opposite config >> ${variable_value_opposite} >> failed"
        
        eval `echo "variable_help_text=\\$${variable_name}${help_text_var_name_suffix}"`
        (test $? != 0) && echo "ERROR >> extract dexbot strategy help text >> ${variable_help_text} >> failed"
        
        eval `echo "variable_opposite_help_text=\\$${variable_name}${opposite_bot_suffix}${help_text_var_name_suffix}"`
        (test $? != 0) && echo "ERROR >> extract dexbot strategy opposite help text >> ${variable_opposite_help_text} >> failed"
        
        if [ "${variable_value_opposite}" != "" ]; then
            variable_value=${variable_value_opposite}
        fi
        
        if [ "${variable_opposite_help_text}" != "" ]; then
            variable_help_text=${variable_opposite_help_text}
        fi
        
        if [ "${variable_value}" == "" ]; then
            echo "-------"
            echo "WARNING >> missing >> ${variable_name} >> $variable_help_text"
            read -p "Please enter variable value or press enter to skip: " variable_value
        fi
        
        if [ "${variable_value}" != "" ]; then
            echo "FOR INFO >> processing dexbot strategy conf to update template variable >> ${variable_name} >> ${variable_value}"
            strategy_file=$(
            echo "$strategy_file" | sed \
                -e "s/{${variable_name}}/${variable_value}/g"
            )
            (test $? != 0) && echo "ERROR >> update dexbot template >> {${variable_name}} >> ${variable_value} >> failed" && exit 1
        fi
    done

    # 
    #~ echo "${cc_xbridge_cfg_data}" | grep "\[${cc_ticker}\]" > /dev/null
    #~ (test $? != 0) && echo "ERROR >> ${naming_suffix} >> invalid xbridge cfg [ticker] >> ${cc_xbridge_cfg_path}" && exit 1
    
    # write down updated dexbot startegy to file
    echo "${strategy_file}" > ${1}
    (test $? != 0) && echo "ERROR >> dexbot strategy file >> ${1} >> update failed" && exit 1
    
    echo "INFO >> dexbot strategy file >> ${1} >> update success"
    
    return 0
}


#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1

# show help
if [ "${showhelp}" == "yes" ]; then
    echo ""
    echo "*** ABOUT ***"
    echo ""
    echo "proxychains configuration update script in userspace"
    echo ""
    echo "*** USAGE ***"
    echo ""
    echo ""${0}" <install|update|reinstall>"
    echo ""
    echo "*** ARGUMENTS(mandatory) ***"
    echo ""
    echo "<install|update|reinstall>"
    echo " >> install >> action to try to copy and update default proxychains configuration"
    echo " >> update >> action to try update existing proxychains configuration"
    echo " >> reinstall >> action to try to delete actual configuration and do install"
    echo ""
    echo "*** EXAMPLES ***"
    echo ""${0}" install"
    echo ""${0}" update"
    echo ""${0}" reinstall"
    echo ""
    exit 0
fi

# handle arguments
cc_action=

argc=$#
argv=("$@")

for (( j=0; j<argc; j++ )); do
    if [ "${argv[j]}" = "install" ]; then
        if [ "${cc_action}" = "" ]; then
            cc_action="install"
            echo "INFO >> install enabled"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [ "${argv[j]}" = "update" ]; then
        if [ "${cc_action}" = "" ]; then
            cc_action="update"
            echo "INFO >> update enabled"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [ "${argv[j]}" = "reinstall" ]; then
        if [ "${cc_action}" = "" ]; then
            cc_action="reinstall"
            echo "INFO >> reinstall enabled"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    else
        echo "Invalid argument: $j ${argv[j]}"
        exit 1
    fi
done

# real config paths
cc_cfg_proxychains_root_cfg_path="/etc/proxychains4.conf"
cc_cfg_proxychains_user_dir_path="${HOME}/.proxychains"
cc_cfg_proxychains_user_cfg_path="${cc_cfg_proxychains_user_dir_path}/proxychains.conf"

# create user config dir
tool_realpath cc_cfg_proxychains_user_dir_path "user config dir path"
tool_make_and_check_dir_path cc_cfg_proxychains_user_dir_path "user config dir path"

# real path paths
tool_realpath cc_cfg_proxychains_root_cfg_path "root config path"
tool_realpath cc_cfg_proxychains_user_cfg_path "user config path"

# check root config exist
tool_file_if_notexist_exit ${cc_cfg_proxychains_root_cfg_path}

# if install action, user config file should not exist and will be compied
if [ "${cc_action}" = "install" ]; then
    tool_file_if_exist_exit ${cc_cfg_proxychains_user_cfg_path} "user config"
    tool_cp ${cc_cfg_proxychains_root_cfg_path} ${cc_cfg_proxychains_user_cfg_path}

# if update action, user config must already exist will be let as it be
elif [ "${cc_action}" = "update" ]; then
    tool_file_if_notexist_exit ${cc_cfg_proxychains_user_cfg_path} "user config"

# if reinstall action, user config must already exist and will be removed an new copy created
elif [ "${cc_action}" = "reinstall" ]; then
    tool_file_if_notexist_exit ${cc_cfg_proxychains_user_cfg_path} "user config"
    rm ${cc_cfg_proxychains_user_cfg_path}
    tool_cp ${cc_cfg_proxychains_root_cfg_path} ${cc_cfg_proxychains_user_cfg_path}
else
    echo "ERROR >> cc_action >> value >> ${cc_action} >> is invalid"
    exit 1
fi

# update user config
# configuration file path

# updating localhost to be accessible
cfg_line="localnet 127\.0\.0\.0\/255\.0\.0\.0"

sed -i \
    -e "s/.*${cfg_line}.*/${cfg_line}/g" \
    ${cc_cfg_proxychains_user_cfg_path}
(test $? != 0) && echo "ERROR >> proxychains config >> ${cc_cfg_proxychains_user_cfg_path} >> localhost enable >> update failed" && exit 1

cat ${cc_cfg_proxychains_user_cfg_path} | grep -e "^${cfg_line}$"
(test $? != 0) && echo "ERROR >> proxychains config >> ${cc_cfg_proxychains_user_cfg_path} >> localhost enable >> check failed" && exit 1

# updating socks4 to socks5
cfg_line_old="socks4.*127.0.0.1 9050"
cfg_line_new="socks5  127.0.0.1 9050"

sed -i \
    -e "s/${cfg_line_old}/${cfg_line_new}/g" \
    ${cc_cfg_proxychains_user_cfg_path}
(test $? != 0) && echo "ERROR >> proxychains config >> ${cc_cfg_proxychains_user_cfg_path} >> socks5 enable >> update failed" && exit 1

cat ${cc_cfg_proxychains_user_cfg_path} | grep -e "^${cfg_line_new}$"
(test $? != 0) && echo "ERROR >> proxychains config >> ${cc_cfg_proxychains_user_cfg_path} >> socks5 enable >> check failed" && exit 1

echo "INFO >> proxychains config >> ${cc_cfg_proxychains_user_cfg_path} >> processing success"

exit 0

#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1

# default arguments
cc_script_cfg_path_default="./src/cfg.torbrowser.sh"
cc_firejail_profile_name_default="default"
cc_firejail_default="firejail"
cc_proxychains_default="proxychains -q"

# include specific tool
source "./src/tools.torbrowser.firejail.sh" || exit 1

# showhelp is auto set by tools
tool_torbrowser_firejail_show_help

# handle arguments
cc_script_cfg_path=
cc_install_dir_path=
cc_firejail_profile_name=
cc_firejail=${cc_firejail_default}
cc_proxychains=${cc_proxychains_default}
cc_firejail_profile_template_path=

# process command line arguments
argc=$#
argv=("$@")
tool_torbrowser_firejail_process_arguments ${argc} ${argv}

# start measuring time
tool_time_start

tool_variable_info cc_firejail
tool_variable_info cc_proxychains
tool_variable_info cc_firejail_profile_name

# include main torbrowser cfg script IE: ./src/cfg.torbrowser.sh
tool_variable_check_load_default cc_script_cfg_path cc_script_cfg_path_default
tool_realpath cc_script_cfg_path "parameter #1 torbrowser cfg script path"
tool_check_version_and_include_script ${cc_script_cfg_path} "loading torbrowser cfg script" 

# check included "./src/cfg.torbrowser.sh" cfg variables
tool_variable_check_load_default cc_install_dir_path_default "" "torbrowser default install dir path"
tool_variable_check_load_default cc_firejail_profile_name_default "" "torbrowser default firejail profile name"

# check included firejail template profile
tool_variable_check_load_default cc_firejail_profile_template_path cc_firejail_profile_template_path_default "torbworser firejail profile template"
tool_file_if_notexist_exit ${cc_firejail_profile_template_path} "torbworser firejail profile template"

# prepare install directory path
cc_install_dir_path_default_tmp=${cc_dexsetup_dir_path}"/../"${cc_install_dir_path_default}
tool_variable_check_load_default cc_install_dir_path cc_install_dir_path_default_tmp
tool_realpath cc_install_dir_path "cc install dir path"
tool_make_and_check_dir_path cc_install_dir_path "cc install dir path"

# firejail torbrowser profile name
tool_variable_check_load_default cc_firejail_profile_name cc_firejail_profile_name_default

# firejail torbrowser run script file path
cc_torbrowser_firejail_run_script_path=${cc_install_dir_path}"/firejail.torbrowser."${cc_firejail_profile_name}".sh"
tool_realpath cc_torbrowser_firejail_run_script_path "torbrowser firejail run script"

# prepare torbrowser profile data path
cc_profile_data_path=${cc_install_dir_path}"/data/profile/"${cc_firejail_profile_name}"/"
tool_make_and_check_dir_path cc_profile_data_path "torbrowser firejail profiles data path"

# prepare torbrowser profile data bin path
cc_profile_data_path_bin=${cc_profile_data_path}"/tor-browser/"
tool_realpath cc_profile_data_path_bin "torbrowser firejail profiles data bin path"

# firejail profile path
cc_firejail_profile_path=${cc_profile_data_path}"/firejail.torbrowser.profile"
tool_realpath cc_firejail_profile_path "torbrowser firejail profile path"

# prepare bin files path
cc_bin_path=${cc_install_dir_path}"/data/download/bin"
tool_realpath cc_bin_path "binary files path"
tool_dir_if_notexist_exit cc_bin_path "binary file path" 

# generate firejail torbrowser run script
script_data="#!/bin/bash

# run script generated with ./setup.torbrowser.firejail.sh --help

cd ./data/profile/${cc_firejail_profile_name}/tor-browser/ || exit 1

firejail --profile=\`pwd\`/../firejail.torbrowser.profile \\
--name=torbrowser.${cc_firejail_profile_name} \\
--whitelist=\`pwd\` \\
    ./start-tor-browser.desktop
"
tool_make_and_chmod_script_or_exit cc_torbrowser_firejail_run_script_path script_data "create torbrowser firejail run script"

# copy predefined firejail profile for torbrowser
tool_cp ${cc_firejail_profile_template_path} ${cc_firejail_profile_path}

# copy all data needed newly created profile
tool_cp_dir_recursive cc_bin_path cc_profile_data_path_bin "copy torbrowser bin files"

tool_time_finish_print

exit 0

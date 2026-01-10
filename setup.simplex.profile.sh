#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1

# default arguments
cc_script_cfg_path_default="./src/cfg.simplex.sh"
cc_firejail_profile_name_default="default"
cc_firejail_default="firejail"
cc_proxychains_default="proxychains -q"

# include specific tool
source "./src/tools.simplex.firejail.sh" || exit 1

# showhelp is auto set by tools
tool_simplex_firejail_show_help

# handle arguments
cc_script_cfg_path=
cc_install_dir_path=
cc_firejail_profile_name=
cc_firejail=${cc_firejail_default}
cc_proxychains=${cc_proxychains_default}

# process command line arguments
argc=$#
argv=("$@")
tool_simplex_firejail_process_arguments ${argc} ${argv}

# start measuring time
tool_time_start

tool_variable_info cc_firejail
tool_variable_info cc_proxychains
tool_variable_info cc_firejail_profile_name

# include main simplex cfg script IE: ./src/cfg.simplex.sh
tool_variable_check_load_default cc_script_cfg_path cc_script_cfg_path_default
tool_realpath cc_script_cfg_path "parameter #1 simplex cfg script path"
tool_check_version_and_include_script ${cc_script_cfg_path} "loading simplex cfg script" 

# check included "./src/cfg.simplex.sh" cfg variables
tool_variable_check_load_default cc_install_dir_path_default "" "simplex default install dir path"
tool_variable_check_load_default cc_firejail_profile_name_default "" "simplex default profile name"
tool_variable_check_load_default cc_proxychains_cfg "" "simplex proxychains configuration file"

# prepare install directory path
cc_install_dir_path_default_tmp=${cc_dexsetup_dir_path}"/../"${cc_install_dir_path_default}
tool_variable_check_load_default cc_install_dir_path cc_install_dir_path_default_tmp
tool_realpath cc_install_dir_path "cc install dir path"
tool_make_and_check_dir_path cc_install_dir_path "cc install dir path"

# firejail simplex profile name
tool_variable_check_load_default cc_firejail_profile_name cc_firejail_profile_name_default

# firejail simplex run script file path
cc_simplex_firejail_run_script_path=${cc_install_dir_path}"/firejail.simplex."${cc_firejail_profile_name}".sh"
tool_realpath cc_simplex_firejail_run_script_path "simplex firejail run script"

# prepare simplex profile data path
cc_profile_config_path=${cc_install_dir_path}"/data/profile/"${cc_firejail_profile_name}".config/"
tool_make_and_check_dir_path cc_profile_config_path "simplex firejail profiles data config path"
cc_profile_local_path=${cc_install_dir_path}"/data/profile/"${cc_firejail_profile_name}".local/"
tool_make_and_check_dir_path cc_profile_local_path "simplex firejail profiles data local path"

# prepare simplex proxychains file path
cc_proxychains_cfg_data_path=${cc_install_dir_path}"/data/profile/"${cc_firejail_profile_name}".proxychains.cfg"
tool_realpath cc_proxychains_cfg_data_path "simplex proxychains configuration file"

# prepare bin files path
cc_bin_dir="data/download/bin"
cc_bin_path=${cc_install_dir_path}"/"${cc_bin_dir}
tool_realpath cc_bin_path "binary files path"
tool_dir_if_notexist_exit cc_bin_path "binary file path" 

# firejail simplex run script file path
cc_simplex_firejail_run_script2_filename="firejail.simplex."${cc_firejail_profile_name}".sh"
cc_simplex_firejail_run_script2_path=${cc_install_dir_path}"/data/profile/"${cc_simplex_firejail_run_script2_filename}
tool_realpath cc_simplex_firejail_run_script2_path "simplex firejail run script"

# generate proxychain configuration file

tool_make_and_chmod_script_or_exit cc_proxychains_cfg_data_path cc_proxychains_cfg "create simplex proxychains configuration"

# generate firejail simplex run script 1
script_data="#!/bin/bash

# run script generated with ./setup.simplex.profile.sh --help

GTK_IM_MODULE=xim

cd \"\$(dirname \"\$(realpath \"\$0\")\")\"

cd ${cc_bin_dir} || exit 1

mkdir -p ${cc_profile_config_path} || exit 1
mkdir -p ${cc_profile_local_path} || exit 1

firejail \\
--name=simplex.${cc_firejail_profile_name} \\
--whitelist=\`pwd\` \\
--read-only=\`pwd\` \\
--whitelist=${cc_simplex_firejail_run_script2_path} \\
--read-only=${cc_simplex_firejail_run_script2_path} \\
--whitelist=${cc_proxychains_cfg_data_path} \\
--read-only=${cc_proxychains_cfg_data_path} \\
--whitelist=${cc_profile_config_path} \\
--whitelist=${cc_profile_local_path} \\
--private-tmp \\
--private-dev \\
    ./../../profile/${cc_simplex_firejail_run_script2_filename}
"
tool_make_and_chmod_script_or_exit cc_simplex_firejail_run_script_path script_data "create simplex firejail run script"

# generate firejail simplex run script 2
script_data2="#!/bin/bash

# run script generated with ./setup.cc.simplex.firejail.sh --help

mkdir -p ~/.config/ || exit 1
mkdir -p ~/.local/share/ || exit 1
mkdir -p ~/.proxychains/ || exit 1

ln -s ${cc_profile_config_path} ~/.config/simplex || exit 1
ln -s ${cc_profile_local_path} ~/.local/share/simplex || exit 1
ln -s ${cc_proxychains_cfg_data_path} ~/.proxychains/proxychains.conf || exit 1

# useful to enable if simplex activate development version
#~ ln -s ${cc_profile_config_path} ~/.config/simplex-development || exit 1

#~ ${cc_proxychains} ./simplex --no-sandbox --no-zygote --disable-gpu

#~ torsocks -d ./simplex --no-zygote --no-sandbox --disable-gpu

#~ torsocks ./simplex --no-zygote --no-sandbox --disable-gpu

#~ proxychains4 ./simplex --no-zygote --no-sandbox --disable-gpu

proxychains4 -q ./bin/simplex --no-sandbox --no-zygote --disable-gpu

#~ ./simplex-desktop --no-zygote --no-sandbox --disable-gpu
"

tool_make_and_chmod_script_or_exit cc_simplex_firejail_run_script2_path script_data2 "create simplex firejail run script2"

tool_time_finish_print

exit 0

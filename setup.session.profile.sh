#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1

# default arguments
cc_script_cfg_path_default="./src/cfg.session.sh"
cc_firejail_profile_name_default="default"
cc_firejail_default="firejail"
cc_proxychains_default="proxychains -q"

# include specific tool
source "./src/tools.session.firejail.sh" || exit 1

# showhelp is auto set by tools
tool_session_firejail_show_help

# handle arguments
cc_script_cfg_path=
cc_install_dir_path=
cc_firejail_profile_name=
cc_firejail=${cc_firejail_default}
cc_proxychains=${cc_proxychains_default}

# process command line arguments
argc=$#
argv=("$@")
tool_session_firejail_process_arguments ${argc} ${argv}

# start measuring time
tool_time_start

tool_variable_info cc_firejail
tool_variable_info cc_proxychains
tool_variable_info cc_firejail_profile_name

# include main session cfg script IE: ./src/cfg.session.sh
tool_variable_check_load_default cc_script_cfg_path cc_script_cfg_path_default
tool_realpath cc_script_cfg_path "parameter #1 session cfg script path"
tool_check_version_and_include_script ${cc_script_cfg_path} "loading session cfg script" 

# check included "./src/cfg.session.sh" cfg variables
tool_variable_check_load_default cc_install_dir_path_default "" "session default install dir path"
tool_variable_check_load_default cc_firejail_profile_name_default "" "torbrowser default firejail profile name"

# prepare install directory path
cc_install_dir_path_default_tmp=${cc_dexsetup_dir_path}"/../"${cc_install_dir_path_default}
tool_variable_check_load_default cc_install_dir_path cc_install_dir_path_default_tmp
tool_realpath cc_install_dir_path "cc install dir path"
tool_make_and_check_dir_path cc_install_dir_path "cc install dir path"

# firejail session profile name
tool_variable_check_load_default cc_firejail_profile_name cc_firejail_profile_name_default

# firejail session run script file path
cc_session_firejail_run_script_path=${cc_install_dir_path}"/firejail.session."${cc_firejail_profile_name}".sh"
tool_realpath cc_session_firejail_run_script_path "session firejail run script"

# prepare session profile data path
cc_profile_data_path=${cc_install_dir_path}"/data/profile/"${cc_firejail_profile_name}"/"
tool_make_and_check_dir_path cc_profile_data_path "session firejail profiles data path"

# prepare bin files path
cc_bin_dir="data/download/bin"
cc_bin_path=${cc_install_dir_path}"/"${cc_bin_dir}
tool_realpath cc_bin_path "binary files path"
tool_dir_if_notexist_exit cc_bin_path "binary file path" 

# firejail session run script file path
cc_session_firejail_run_script2_filename="firejail.session."${cc_firejail_profile_name}".sh"
cc_session_firejail_run_script2_path=${cc_bin_path}"/"${cc_session_firejail_run_script2_filename}
tool_realpath cc_session_firejail_run_script2_path "session firejail run script"

# generate firejail session run script 1
script_data="#!/bin/bash

# run script generated with ./setup.session.profile.sh --help

#~ cd "$(dirname "$(realpath "$0")")"
cd \"\$(dirname \"\$(realpath \"\$0\")\")\"

cd ${cc_bin_dir} || exit 1

mkdir -p ${cc_profile_data_path} || exit 1

firejail \\
--name=session.${cc_firejail_profile_name} \\
--whitelist=\`pwd\` \\
--read-only=\`pwd\` \\
--whitelist=\${HOME}/.proxychains \\
--read-only=\${HOME}/.proxychains \\
--whitelist=${cc_profile_data_path} \\
--private-tmp \\
--private-dev \\
    ./${cc_session_firejail_run_script2_filename}
"
tool_make_and_chmod_script_or_exit cc_session_firejail_run_script_path script_data "create session firejail run script"

# generate firejail session run script 2
script_data2="#!/bin/bash

# run script generated with ./setup.cc.session.firejail.sh --help

mkdir -p ~/.config/ || exit 1
ln -s ${cc_profile_data_path} ~/.config/Session || exit 1

#~ ${cc_proxychains} ./session-desktop --no-sandbox --no-zygote --disable-gpu

#~ torsocks -d ./session-desktop --no-zygote --no-sandbox --disable-gpu

#~ torsocks ./session-desktop --no-zygote --no-sandbox --disable-gpu

#~ proxychains4 ./session-desktop --no-zygote --no-sandbox --disable-gpu

proxychains4 -q ./session-desktop --no-sandbox --no-zygote --disable-gpu

#~ ./session-desktop --no-zygote --no-sandbox --disable-gpu

"

tool_make_and_chmod_script_or_exit cc_session_firejail_run_script2_path script_data2 "create session firejail run script2"

tool_time_finish_print

exit 0

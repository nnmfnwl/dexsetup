#!/bin/bash

# include global tools
source "./src/tools.sh" || exit 1

# default arguments
cc_script_cfg_path_default="./src/cfg.session.sh"
cc_action1_default="download"
cc_action2_default="install"
cc_firejail_default="firejail"
cc_proxychains_default="proxychains -q"

# include specific tool
source "./src/tools.session.sh" || exit 1

# showhelp is auto set by tools
tool_session_show_help

# handle arguments
cc_script_cfg_path=
cc_action1=
cc_action2=
cc_firejail=${cc_firejail_default}
cc_proxychains=${cc_proxychains_default}
cc_install_dir_path=

# process command line arguments
argc=$#
argv=("$@")
tool_session_process_arguments ${argc} ${argv}

# start measuring time
tool_time_start

tool_variable_info cc_firejail
tool_variable_info cc_proxychains

# check make script exist
cc_script_make_path="./src/setup.session.make.sh"
tool_realpath cc_script_make_path "make script path"
# TODO make session is not implemented yet
#~ tool_file_if_notexist_exit ${cc_script_make_path} "make script path"

# check download script exist
cc_script_download_path="./src/setup.download.extract.sh"
tool_realpath cc_script_download_path "download script path"
tool_file_if_notexist_exit ${cc_script_download_path} "download script path"

# include main session cfg script IE: ./src/cfg.session.sh
tool_variable_check_load_default cc_script_cfg_path cc_script_cfg_path_default
tool_realpath cc_script_cfg_path "parameter #1 session cfg script path"
tool_check_version_and_include_script ${cc_script_cfg_path} "loading session cfg script" 

# check included cfg variables
tool_variable_check_load_default cc_download_url "" "session package download url"
tool_variable_check_load_default cc_download_sha512sum "" "session package sha512sum "
tool_variable_check_load_default cc_download_extracted_bin_files_dir "" "session download extracted bin files dir"

# check download build install update purge arguments
tool_variable_check_load_default cc_action1 cc_action1_default "download|build action"
tool_variable_check_load_default cc_action2 cc_action2_default "install|update|purge action"

# prepare install directory path
cc_install_dir_path_default_tmp=${cc_dexsetup_dir_path}"/../"${cc_install_dir_path_default}
tool_variable_check_load_default cc_install_dir_path cc_install_dir_path_default_tmp
tool_realpath cc_install_dir_path "cc install dir path"
tool_make_and_check_dir_path cc_install_dir_path "cc install dir path"

# prepare package files path
cc_pkg_path=${cc_install_dir_path}"/data/download/pkg"
tool_realpath cc_pkg_path "pkg file dir"

# prepare extracted bin files path
cc_extracted_pkg_bin_files_path=${cc_pkg_path}"/"${cc_download_extracted_bin_files_dir}
tool_realpath cc_extracted_pkg_bin_files_path "extracted pkg bin files path"

# prepare git source files path
cc_git_src_path=${cc_install_dir_path}"/data/download/git.src"
tool_realpath cc_git_src_path "src files dir"

# prepare build bin files path
cc_git_build_bin_file_path=${cc_git_src_path}"/"${cc_git_build_bin_file_dir}
tool_realpath cc_git_build_bin_file_path "build bin files path"

# prepare bin files path
cc_bin_path=${cc_install_dir_path}"/data/download/bin"
tool_realpath cc_bin_path "binary files dir"

# solve install update purge arguments initialization

if [ "${cc_action2}" = "install" ]; then
    tool_dir_if_exist_exit cc_pkg_path "checking if pkg not already installed" "please try update|purge argument"
    tool_dir_if_exist_exit cc_git_src_path "checking if git src not already installed" "please try update|purge argument"
    tool_dir_if_exist_exit cc_bin_path "checking if bin not already installed" "please try update|purge argument"
    
    tool_make_and_check_dir_path cc_pkg_path "pkg directory"
    tool_make_and_check_dir_path cc_git_src_path "git src directory"
    tool_make_and_check_dir_path cc_bin_path "bin directory"
    
elif [ "${cc_action2}" = "update" ]; then
    # downloaded package sha512sum could be actually up to date so do not need to remove pkg dir
    tool_make_and_check_dir_path cc_pkg_path "pkg directory"
    tool_make_and_check_dir_path cc_git_src_path "git src directory"
    
    # any previous binary files must be removed to be sure we update correctly
    rm -rfv "${cc_bin_path}"
    (test $? != 0) && echo "WARNING >> directories >> ${cc_bin_path} >> remove failed"
    tool_make_and_check_dir_path cc_bin_path "bin directory"
    
elif [ "${cc_action2}" = "purge" ]; then
    if [ "${cc_action1}" = "download" ]; then
        rm -rfv "${cc_pkg_path}"
        (test $? != 0) && echo "WARNING >> directories >> ${cc_pkg_path} >> remove failed"
    else
        rm -rfv "${cc_git_src_path}"
        (test $? != 0) && echo "WARNING >> directories >> ${cc_git_src_path} >> remove failed"
    fi
    
    rm -rfv "${cc_bin_path}"
    (test $? != 0) && echo "WARNING >> directories >> ${cc_bin_path} >> remove failed"
    exit 0
    
else
    echo "ERROR >> action<install|update|purge> not specified"
    exit 1
fi

# run download or checkout and build script inside sandbox

# download binary files directly
if [ "${cc_action2}" = "install" ] || [ "${cc_action2}" = "update" ]; then
    echo "********************** ENTER FIREJAIL SANDBOX ******************************"
    if [ "${cc_action1}" = "download" ]; then
        if [ "${cc_firejail}" != "" ]; then
            # process securely sandboxed by firejail
            cc_firejail_make_args_expand=`eval echo ${cc_firejail_make_args}`
            firejail --profile=./src/setup.cc.make.firejail.profile \
                --whitelist=`pwd` --read-only=`pwd` \
                --whitelist=${cc_pkg_path} \
                ${cc_firejail_make_args_expand} \
                    ${cc_script_download_path} ${cc_script_cfg_path} ${cc_action2} ${cc_pkg_path} "${cc_proxychains}"
            (test $? != 0) && echo "ERROR >> checkout and build script failed" && exit 1
        else
                    # process not sandboxed
                    ${cc_script_download_path} ${cc_script_cfg_path} ${cc_action2} ${cc_pkg_path} "${cc_proxychains}"
            (test $? != 0) && echo "ERROR >> checkout and build script failed" && exit 1
        fi
    elif [ "${cc_action1}" = "build" ]; then
        echo "Not implemented Yet"
        exit 1
        if [ "${cc_firejail}" != "" ]; then
            # process securely sandboxed by firejail
            cc_firejail_make_args_expand=`eval echo ${cc_firejail_make_args}`
            firejail --profile=./src/setup.cc.make.firejail.profile \
                --whitelist=`pwd` --read-only=`pwd` \
                --whitelist=${cc_git_src_path} \
                ${cc_firejail_make_args_expand} \
                    ${cc_script_make_path} ${cc_script_cfg_path} ${cc_action2} ${cc_git_src_path} "${cc_proxychains}"
            (test $? != 0) && echo "ERROR >> checkout and build script failed" && exit 1
        else
                    # process not sandboxed
                    ${cc_script_make_path} ${cc_script_cfg_path} ${cc_action2} ${cc_git_src_path} "${cc_proxychains}"
            (test $? != 0) && echo "ERROR >> checkout and build script failed" && exit 1
        fi
    fi
    echo "********************** EXIT FIREJAIL SANDBOX ******************************"
fi

# copy binary files

# copy bin files extracted from package
if [ "${cc_action1}" = "download" ]; then
    src=${cc_extracted_pkg_bin_files_path}
    dst=${cc_bin_path}
    tool_cp_dir_recursive src dst "downloaded extracted session package"

# copy bin files build from source
elif [ "${cc_action1}" = "build" ]; then
    src=${cc_git_build_bin_file_path}
    dst=${cc_bin_path}
    tool_cp_dir_recursive src dst "git source build session"
    
else
    echo "ERROR >> action<download|build> not specified"
    exit 1
fi

# finally check by antivirus if present and scan all files in sandbox

clamscan_path="/usr/bin/clamscan"
if [ -f "${clamscan_path}" ]; then
    echo "INFO >> using clamscan_path >> ${clamscan_path}"
    ${clamscan_path} -r -v -z --no-summary ${cc_bin_path}"/"*
    (test $? != 0) && echo "ERROR >> AV SCAN >> ${clamscan_path} ${cc_bin_path}/* >> FAILED" && rm -rf ${cc_bin_path}"/"* && exit 1
    echo "INFO >> AV SCAN >> ${cc_bin_path}/* >> success"
fi

echo "*** MAIN SESSION SETUP SUCCESS ***"

tool_time_finish_print

exit 0

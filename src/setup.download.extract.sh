#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1

# handle arguments

cc_script_cfg_path=${1}
cc_action=${2}
cc_pkg_path=${3}
cc_proxychains=${4}

# check arguments

tool_variable_check_load_default cc_script_cfg_path "" "pkg download cfg"
tool_variable_check_load_default cc_pkg_path "" "pkg download pkg local path"
tool_variable_check_load_default cc_action "" "pkg download action"
tool_variable_info cc_proxychains "pkg download proxychains"

# include cc config

tool_check_version_and_include_script ${cc_script_cfg_path} "cc_script_cfg_path"

# get variables by specific architecture and check included cfg variables

tool_variable_arch_load cc_download_url "pkg download url"
tool_variable_check_load_default cc_download_url "" "pkg download url"
tool_variable_arch_load cc_download_sha512sum "pkg download sha512"
tool_variable_arch_load cc_download_sha256sum "pkg download sha256"
if [[ "${cc_download_sha512sum}" == "" ]] && [[ "${cc_download_sha256sum}" == ""  ]]; then
    tool_info "" "" "none of sha512 or sha256 is set"
    exit 1
fi

# change directory

tool_cd ${cc_pkg_path} "cc_pkg_path"

# get base file name to be downloaded

tool_basename cc_download_url cc_download_pkg_file_name

# download file from url

if [ "${cc_action}" = "install" ]; then
    
    # check file not exist
    tool_file_if_exist_exit ${cc_download_pkg_file_name} "checking existing package download"
    
    # download
    tool_wget_download_or_continue cc_proxychains cc_download_url "download pkg"
    
    # verify file hash sum
    tool_sha512sum_file cc_download_pkg_file_name cc_download_sha512sum_check "downloaded pkg"
    if [ "${cc_download_sha512sum}" != "" ]; then
        tool_compare cc_download_sha512sum cc_download_sha512sum_check "downloaded pkg sha512sum"
    fi
    
    tool_sha256sum_file cc_download_pkg_file_name cc_download_sha256sum_check "downloaded pkg"
    if [ "${cc_download_sha256sum}" != "" ]; then
        tool_compare cc_download_sha256sum cc_download_sha256sum_check "downloaded pkg sha256sum"
    fi
    
elif [ "${cc_action}" = "update" ] || [ "${cc_action}" = "continue" ]; then
    
    # if download file already exist
    if [ -f "${cc_download_pkg_file_name}" ]; then
        
        # verify hash sum of actual downloaded pkg
        tool_sha512sum_file cc_download_pkg_file_name cc_download_sha512sum_check "check prev download pkg"
        if [ "${cc_download_sha512sum}" != "" ]; then
            tool_compare_try cc_download_sha512sum_check cc_download_sha512sum "continue prev download pkg"
            sha512ret=$?
        else
            sha512ret=0
        fi
        
        tool_sha256sum_file cc_download_pkg_file_name cc_download_sha256sum_check "check prev download pkg"
        if [ "${cc_download_sha256sum}" != "" ]; then
            tool_compare_try cc_download_sha256sum_check cc_download_sha256sum "continue prev download pkg"
            sha256ret=$?
        else
            sha256ret=0
        fi
        
        # if hash sum does not match
        if [[ "${sha256ret}" != "0" ]] || [[ "${sha512ret}" != "0" ]]; then
            # try to continue download
            tool_wget_download_or_continue_try cc_proxychains cc_download_url "continue prev download pkg"
            # again verify has sum of downloaded pkg
            tool_sha512sum_file cc_download_pkg_file_name cc_download_sha512sum_check "check prev download pkg"
            if [ "${cc_download_sha512sum}" != "" ]; then
                tool_compare_try cc_download_sha512sum_check cc_download_sha512sum "continue prev download pkg"
                sha512ret=$?
            else
                sha512ret=0
            fi
            
            tool_sha256sum_file cc_download_pkg_file_name cc_download_sha256sum_check "check prev download pkg"
            if [ "${cc_download_sha256sum}" != "" ]; then
                tool_compare_try cc_download_sha256sum_check cc_download_sha256sum "continue prev download pkg"
                sha256ret=$?
            else
                sha256ret=0
            fi
            
            # if package sha512 not match delete it
            if [[ "${sha256ret}" != "0" ]] || [[ "${sha512ret}" != "0" ]]; then
                tool_rmfile cc_download_pkg_file_name
            fi
        fi
    fi
    
    # if previous download recovery process failed, try download again from scratch
    if [ ! -f "${cc_download_pkg_file_name}" ]; then
        # download
        tool_wget_download_or_continue cc_proxychains cc_download_url "download pkg"
        # verify file hash sum
        tool_sha512sum_file cc_download_pkg_file_name cc_download_sha512sum_check "downloaded pkg"
        if [ "${cc_download_sha512sum}" != "" ]; then
            tool_compare cc_download_sha512sum cc_download_sha512sum_check "downloaded pkg sha512sum"
        fi
        
        tool_sha256sum_file cc_download_pkg_file_name cc_download_sha256sum_check "downloaded pkg"
        if [ "${cc_download_sha256sum}" != "" ]; then
            tool_compare cc_download_sha256sum cc_download_sha256sum_check "downloaded pkg sha256sum"
        fi
    fi

else
    echo "ERROR >>  action >> ${cc_action} >> is invalid"
    exit 1
fi

# extract package

dst="./"
tool_tar_extract cc_download_pkg_file_name dst "dowloaded pkg"

# custom post-extract process, ie PIVX post sapling,

if [ "${cc_command_post_extract}" != "" ]; then
    eval `echo ${cc_command_post_extract}`
    (test $? != 0) && echo "ERROR >> custom post make command >> ${cc_command_post_extract} >> failed" && exit 1
    tool_info "" cc_command_post_extract "custom post package extract command success"
fi

# exit

echo "*** DOWNLOAD AND EXTRACT SETUP SUCCESS ***"

exit 0

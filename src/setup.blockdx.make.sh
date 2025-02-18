#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1

# handle arguments

cc_script_cfg_path=${1}
cc_action=${2}
cc_git_src_path=${3}
cc_proxychains=${4}

# check arguments

tool_variable_check_load_default cc_script_cfg_path "" "blockdx make cfg"
tool_variable_check_load_default cc_git_src_path "" "blockdx make local git src path"
tool_variable_check_load_default cc_action cc_action "blockdx make action"
tool_variable_info cc_proxychains "blockdx make proxychains"

# include cc config

tool_check_version_and_include_script ${cc_script_cfg_path} "cc_script_cfg_path"

# check included cfg variables

tool_variable_check_load_default cc_git_src_url "" "blockdx git src url"
tool_variable_check_load_default cc_git_commit_id "" "blockdx git commit id" 
tool_variable_check_load_default cc_git_branch "" "blockdx download version"
tool_variable_check_load_default cc_git_build_bin_file_dir "" "blockdx build dir"

# change directory

tool_cd ${cc_git_src_path} "cc_git_src_path"

# actions

echo "INFO >> using >> cc_git_src_url >> ${cc_git_src_url}"
echo "INFO >> action >> cc_action >> ${cc_action}"

if [ "${cc_action}" = "install" ]; then
    ${cc_proxychains} git clone ${cc_git_src_url} ./
    (test $? != 0) && echo "ERROR >> git clone >> ${cc_git_src_url} >> failed" && exit 1
    
elif [ "${cc_action}" = "update" ]; then
    ${cc_proxychains} git clone ${cc_git_src_url} ./
    (test $? != 0) && echo "WARNING >> git clone >> ${cc_git_src_url} >> failed or already done"
    
    ${cc_proxychains} git stash
    (test $? != 0) && echo "WARNING >> git stash failed"
    
    cc_default_master_branch_name="master"
    tool_variable_check_load_default cc_git_src_branch_master cc_default_master_branch_name
    
    ${cc_proxychains} git checkout ${cc_git_src_branch_master} \
    && ${cc_proxychains} git pull
    (test $? != 0) && echo "ERROR >> git pull >> ${cc_git_src_url} >> failed" && exit 1

else
    echo "ERROR >>  action >> ${cc_action} >> is invalid"
    exit 1
fi

# checkout branch

echo "INFO >> using >> cc_git_src_branch >> ${cc_git_src_branch}"
${cc_proxychains} git checkout ${cc_git_src_branch}
(test $? != 0) && echo "ERROR >> git checkout >> ${cc_git_src_url} >> failed" && exit 1

# verify git commit id

tool_git_commit_id_check ${cc_git_commit_id} "blockdx check commit id"

# configure process

if [ "${cc_command_configure}" != "" ]; then
    echo "INFO >> using >> cc_command_configure >> ${cc_command_configure}"
    eval `echo ${cc_command_configure}`
    (test $? != 0) && echo "ERROR >> configure  >> ${cc_command_configure} >> failed" && exit 1
fi

# npm build native packages

echo "INFO >> npm install"
npm install
(test $? != 0) && echo "ERROR >> npm install >> failed" && exit 1

echo "INFO >> npm run pack-native"
${cc_proxychains} npm run pack-native
(test $? != 0) && echo "ERROR >> npm run pack-native >> failed" && exit 1

# custom post-make process, ie PIVX post sapling,

if [ "${cc_command_post_make}" != "" ]; then
    echo "INFO >> using custom post make command >> cc_command_post_make >> ${cc_command_post_make}"
    eval `echo ${cc_command_post_make}`
    (test $? != 0) && echo "ERROR >> custom post make command >> ${cc_command_post_make} >> failed" && exit 1
fi

# exit

echo "*** MAKE CC SETUP SUCCESS ***"

exit 0

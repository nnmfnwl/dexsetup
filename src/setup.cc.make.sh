#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1

# handle arguments

cc_script_cfg_path=${1}
cc_action=${2}
cc_git_src_path=${3}
cc_proxychains=${4}

# check arguments

tool_variable_check_load_default cc_script_cfg_path cc_script_cfg_path "cc make"
tool_variable_check_load_default cc_git_src_path cc_git_src_path "cc make"
tool_variable_check_load_default cc_action cc_action "cc make"
tool_variable_check_load_default cc_proxychains cc_proxychains "cc make"

# include cc config

tool_check_version_and_include_script ${cc_script_cfg_path} "cc_script_cfg_path"

# change directory

tool_cd ${cc_git_src_path} "cc_git_src_path"

# actions

echo "INFO >> using >> cc_git_src_url >> ${cc_git_src_url}"
if [ "${cc_action}" = "install" ]; then
    ${cc_proxychains} git clone ${cc_git_src_url} ./
    (test $? != 0) && echo "ERROR >> git clone >> ${cc_git_src_url} >> failed" && exit 1
    
elif [ "${cc_action}" = "update" ]; then
    ${cc_proxychains} git clone ${cc_git_src_url} ./
    (test $? != 0) && echo "WARNING >> git clone >> ${cc_git_src_url} >> failed or already done"
    
    ${cc_proxychains} make clean
    (test $? != 0) && echo "WARNING >> make clean failed or already done"
    
    ${cc_proxychains} git stash
    (test $? != 0) && echo "WARNING >> git stash failed"
    
    cc_default_master_branch_name="master"
    tool_variable_check_load_default cc_git_src_branch_master cc_default_master_branch_name
    
    ${cc_proxychains} git checkout ${cc_git_src_branch_master} \
    && ${cc_proxychains} git pull
    (test $? != 0) && echo "ERROR >> git pull >> ${cc_git_src_url} >> failed" && exit 1

elif [ "${cc_action}" = "continue" ]; then
    ${cc_proxychains} git clone ${cc_git_src_url} ./
    (test $? != 0) && echo "WARNING >> git clone >> ${cc_git_src_url} >> failed or already done"
    
    ${cc_proxychains} git stash
    (test $? != 0) && echo "WARNING >> git stash failed"
    
    cc_default_master_branch_name="master"
    tool_variable_check_load_default cc_git_src_branch_master cc_default_master_branch_name
    
    ${cc_proxychains} git checkout ${cc_git_src_branch_master} \
    && ${cc_proxychains} git pull
    (test $? != 0) && echo "WARNING >> git checkout and pull >> ${cc_git_src_url} >> failed or already done"
    
else
    echo "ERROR >>  action >> ${cc_action} >> is invalid"
    exit 1
fi

# checkout branch

echo "INFO >> using >> cc_git_src_branch >> ${cc_git_src_branch}"
${cc_proxychains} git checkout ${cc_git_src_branch}
(test $? != 0) && echo "ERROR >> git checkout >> ${cc_git_src_url} >> failed" && exit 1

# verify git commit id

tool_git_commit_id_check ${cc_git_commit_id} "cc make"

# custom predefined post git command if specified

if [ "${cc_command_post_git}" != "" ]; then
    echo "INFO >> using custom pre build command >> cc_command_post_git >> "
    echo "${cc_command_post_git}"
    echo ""
    eval `echo ${cc_command_post_git}`
    (test $? != 0) && echo "ERROR >> custom pre dependencies command >> ${cc_command_post_git} >> failed" && exit 1
    echo "INFO >> cc_command_post_git >> finish success"
fi

# autogen

echo "INFO >> autogen >> autogen.sh"
${cc_proxychains} sh autogen.sh
(test $? != 0) && echo "ERROR >> sh autogen.sh >> failed" && exit 1

# custom pre-dependencies process, ie, to fix some libraries incompatibility...

if [ "${cc_command_pre_depends}" != "" ]; then
    echo "INFO >> using custom pre dependencies command >> cc_command_pre_depends >> "
    echo "${cc_command_pre_depends}"
    echo ""
    eval `echo ${cc_command_pre_depends}`
    (test $? != 0) && echo "ERROR >> custom pre dependencies command >> ${cc_command_pre_depends} >> failed" && exit 1
    echo "INFO >> cc_command_pre_depends >> finish success"
fi

# clean up previously failed download depends TODO

if [ "${cc_action}" = "update" ] || [ "${cc_action}" = "continue" ]; then
    echo "INFO >> removing >> ./depends/sources/download-stamps/*"
    rm ./depends/sources/download-stamps/*
fi

# build and extract dependencies

echo "INFO >> using >> make depends >> ${cc_make_depends}"
if [ "${cc_make_depends}" != "" ]; then
    
    # checkout and make depends
    ${cc_proxychains} make -j${cc_make_cpu_threads} -C depends ${cc_make_depends}
    (test $? != 0) && echo "ERROR >> make dependencies >> ${cc_make_depends} >> failed" && exit 1
    #~ (test $? != 0) && echo "WARNING >> make dependencies >> ${cc_make_depends} >> failed"
    
    # detect machine architecture
    cd "depends/built/" && cc_archdir=`ls` && cd ../../
    (test "${cc_archdir}" == "") && echo "ERROR >> get machine architecture failed" && exit 1
    
    # extract built depends
    for f in $cc_make_depends; do (pwd; tar xvzf "./depends/built/${cc_archdir}/${f}/"*".tar.gz" -C "./depends/${cc_archdir}/"); done
    (test $? != 0) && echo "ERROR >> extract built depends >> ${f} >> failed" && exit 1
fi


# configure process

echo "INFO >> using >> cc_command_configure >> ${cc_command_configure}"
eval `echo ${cc_command_configure}`
(test $? != 0) && echo "ERROR >> configure  >> ${cc_command_configure} >> failed" && exit 1

# custom pre-make process, ie, to fix some libraries incompatibility...

if [ "${cc_command_pre_make}" != "" ]; then
    echo "INFO >> using custom pre make command >> cc_command_pre_make >> ${cc_command_pre_make}"
    eval `echo ${cc_command_pre_make}`
    (test $? != 0) && echo "ERROR >> custom pre make command >> ${cc_command_pre_make} >> failed" && exit 1
fi

# make process

make -j${cc_make_cpu_threads}
(test $? != 0) && echo "ERROR >> make failed" && exit 1

# custom post-make process, ie PIVX post sapling,

if [ "${cc_command_post_make}" != "" ]; then
    echo "INFO >> using custom post make command >> cc_command_post_make >> ${cc_command_post_make}"
    eval `echo ${cc_command_post_make}`
    (test $? != 0) && echo "ERROR >> custom post make command >> ${cc_command_post_make} >> failed" && exit 1
fi

# exit

echo "*** MAKE CC SETUP SUCCESS ***"

exit 0

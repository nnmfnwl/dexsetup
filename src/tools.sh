#!/bin/bash

# version to check...
cc_setup_helper_version="20210827"

########################################################################
# RUNTIME
########################################################################

# not allowed to run as root

id | grep root && echo "ERROR >> IT IS NOT ALLOWED TO RUN THIS SCRIPT AS ROOT !!!" && exit 1

# help

if [ "${#}" != "0" ]; then
    argc=$#
    argv=("$@")
    for (( j=0; j<argc; j++ )); do
        if [ "${argv[j]}" = "help" ] || [ "${argv[j]}" = "-help" ] || [ "${argv[j]}" = "--help" ] || [ "${argv[j]}" = "-h" ]; then
            showhelp="yes"
            return 0
        fi
    done
fi

if [ "${showhelp}" = "" ]; then
    echo "INFO >> including tools >> tools.sh"
fi

########################################################################
# TOOLS
########################################################################

#
function tool_time_start() {
    time_at_start=`date -u`
}

#
function tool_time_finish_print() {
    time_at_finish=`date -u`
    echo "STARTED >> ${time_at_start}"
    echo "FINISHED >> ${time_at_finish}"
}

# 
function tool_realpath() {  #path.variable.name  #prefix.info
    (test "${2}" = "" ) && local prefix="${FUNCNAME[*]}" || local prefix="${FUNCNAME[*]} >> ${2}"
    (test "${1}" == "") && echo "ERROR >> ${prefix} >> realpath variable >> ${1} >> is missing" && exit 1
    local dir_path=`eval echo "\\${${1}}"`
    dir_path=`eval realpath -m ${dir_path}`
    (test $? != 0) && echo "ERROR >> ${prefix} >> ${1} = ${dir_path} >> is invalid" && exit 1
    eval `echo "$1=\"${dir_path}\""`
    echo "INFO >> ${prefix} >> ${1} = ${dir_path}"
}

#
function tool_eval_arg() { #var.name.to.eval #prefix.info
    (test "${2}" = "" ) && local prefix="${FUNCNAME[*]}" || local prefix="${FUNCNAME[*]} >> ${2}"
    (test "${1}" == "") && echo "ERROR >> ${prefix} >> eval variable >> ${1} >> is missing" && exit 1
    
    eval "tmp1=\"\${${1}}\""
    #~ local tmp1=`eval echo "\\${${1}}"`
    (test $? != 0) && echo "ERROR >> ${prefix} >> ${1} = eval expand failed" && exit 1
    
    eval "${1}=\"${tmp1}\"" && eval "tmp2=\"${tmp1}\""
    (test $? != 0) && echo "ERROR >> ${prefix} >> ${1} = eval save failed" && exit 1
    
    echo "INFO >> ${prefix} >> expand >> ${1} >> ${tmp1} >> ${tmp2} >> success"
}

#
function tool_variable_arch_load() { #var.name.load.with._arch #prefix.info
    (test "${2}" = "" ) && local prefix="${FUNCNAME[*]}" || local prefix="${FUNCNAME[*]} >> ${2}"
    (test "${1}" == "") && echo "ERROR >> ${prefix} >> variable >> ${1} >> is missing" && exit 1
    
    arch_val=`uname -m`
    (test $? != 0) && echo "ERROR >> ${prefix} >> ${1} = uname -m failed" && exit 1
    
    eval "tmp1=\"\${${1}_${arch_val}}\""
    #~ local tmp1=`eval echo "\\${${1}}"`
    (test $? != 0) && echo "ERROR >> ${prefix} >> ${1}_${arch_val} = eval expand failed" && exit 1
    
    eval "${1}=\"${tmp1}\"" && eval "tmp2=\"${tmp1}\""
    (test $? != 0) && echo "ERROR >> ${prefix} >> ${1}_${arch_val} = eval save failed" && exit 1
    
    echo "INFO >> ${prefix} >> expand >> ${1}_${arch_val} >> ${tmp1} >> ${tmp2} >> success"
}

# function include bash source code in
function tool_check_version_and_include_script() { # cfg.path # prefix.info #
    # default prefix
    local prefix_info=${2}
    (test "${prefix_info}" == "" ) && local prefix_info="main"
    
    # cfg script path
    local bash_script_path=${1}
    (test "${bash_script_path}" == "") && echo "ERROR >> ${prefix_info} >> no script path parameter" && exit 1
    
    # initial info
    echo "INFO >> ${prefix_info} >> trying to check version and include script >> ${bash_script_path}"
    
    # script realpath
    bash_script_path=`realpath ${bash_script_path}`
    (test $? != 0) && echo "ERROR >> ${prefix_info} >> script realpath >> ${1} >> is invalid" && exit 1
    
    # check version
    version=`cat "${bash_script_path}" | grep "cc_setup_helper_version=\"${cc_setup_helper_version}\""`
    (test "${version}" == "" ) && echo "ERROR >> ${prefix_info} >> script file >> ${bash_script_path} >> version >> ${version} >> is invalid" && exit 1
    
    # include script
    source ${bash_script_path}
    (test $? != 0) && echo "ERROR >> ${prefix_info} >> script file >> ${bash_script_path} >> not found" && exit 1
    
    # final success
    echo "INFO >> ${prefix_info} >> including >> ${bash_script_path}"
    
    return 0
}

#
function tool_basename() { #in.var.name #out.var.name #prefix.info
    info=${3}
    (test "${1}" == "") && echo "ERROR >> ${info} >> No path variable name argument" && exit 1
    local in=`eval echo "\\${${1}}"`
    (test "${2}" == "") && echo "ERROR >> ${info} >> No result variable name argument" && exit 1
    local out=`eval echo "\\${${2}}"`
    out=`basename ${in}`
    (test $? != 0) && echo "ERROR >> ${info} >> basename >> in = ${1} = ${in} >> to >> out = ${2} = ${out} >> failed" && exit 1
    eval `echo "$2=\"${out}\""`
    (test $? != 0) && echo "ERROR >> ${info} >> variable >> out = ${2} = ${out} >> set failed" && exit 1
    echo "INFO >> ${info} >> Get base from >> ${in} >> ${out} >> success"
}

#
function tool_sha512sum_file() { #var.name.file #var.name.sha.out #prefix.info
    info=${3}
    (test "${1}" == "") && echo "ERROR >> ${info} >> No path variable name argument" && exit 1
    local in=`eval echo "\\${${1}}"`
    (test "${2}" == "") && echo "ERROR >> ${info} >> No result variable name argument" && exit 1
    local out=`eval echo "\\${${2}}"`
    echo "INFO >> ${info} >> computing sha512 >> ${in} >>..."
    out=`sha512sum ${in} | cut -d " " -f1`
    (test $? != 0) && echo "ERROR >> ${info} >> sha512sum >> in = ${1} = ${in} >> to >> out = ${2} = ${out} >> failed" && exit 1
    eval `echo "$2=\"${out}\""`
    (test $? != 0) && echo "ERROR >> ${info} >> sha512sum >> variable >> out = ${2} = ${out} >> set failed" && exit 1
    echo "INFO >> ${info} >> Get sha512 from >> ${in} >> ${out} >> success"
}

# 
function tool_make_and_check_dir_path() {  #dir.path.var.name  #prefix.info
    info=${2}
    (test "${1}" == "") && echo "ERROR >> ${info} >> no dir path variable name argument" && exit 1
    local src=`eval echo "\\${${1}}"`
    (test "${src}" = "" ) && echo "ERROR >> ${info} >> dir >> ${1} >> value >> ${src} >> load failed" && exit 1
    tool_realpath src ${info}
    (test ! -d "${src}") && mkdir -p ${src}
    (test ! -d "${src}") && echo "ERROR >> ${info}>> make dir >> ${1} = ${src} >> failed" && exit 1
    eval `echo "$1=\"${src}\""`
    echo "INFO >> ${info} >> make and check dir >> ${1} = ${src} >> success"
}

# 
function tool_git_commit_id_check() {  #commit.id  #prefix.info
    actual_git_commit_id=`git rev-parse HEAD`
    echo "INFO >> ${2} >> checking actual vs exp git commit id >> ${actual_git_commit_id} vs ${1}"
    (test "${actual_git_commit_id}" != "${1}") && echo "ERROR >> ${2} >> git commit id check >> ${1} >> failed" && exit 1
}

# 
function tool_dir_if_notexist_exit() {  #file.path.var.name  #prefix.info #add.error.info
    (test "${1}" == "") && echo "ERROR >> ${2} >> no file path variable name argument" && exit 1
    local var=`eval echo "\\${${1}}"`
    (test "${var}" == "") && echo "ERROR >> ${2} >> ${1} >> no file path value" && exit 1
    (test ! -d "${var}") && echo "ERROR >> ${2} >> ${1} >> directory does not exists >> ${3}" && exit 1
    echo "INFO >> ${2} >> ${1} >> ${var}"
}

# 
function tool_dir_if_exist_exit() {  #file.path.var.name  #prefix.info #add.error.info
    (test "${1}" == "") && echo "ERROR >> ${2} >> no file path variable name argument" && exit 1
    local var=`eval echo "\\${${1}}"`
    (test "${var}" == "") && echo "ERROR >> ${2} >> ${1} >> no file path value" && exit 1
    (test -d "${var}") && echo "ERROR >> ${2} >> ${1} >> directory already exists >> ${3}" && exit 1
    echo "INFO >> ${2} >> ${1} >> ${var}"
}

# 
function tool_file_if_notexist_exit() {  #file.path  #prefix.info
    (test "${1}" == "") && echo "ERROR >> ${2} >> no source argument" && exit 1
    (test ! -f "${1}") && echo "ERROR >> ${2} >> ${1} >> file does not exists" && exit 1
}

# 
function tool_file_if_exist_exit() {  #file.path  #prefix.info
    (test "${1}" == "") && echo "ERROR >> ${2} >> no source argument" && exit 1
    (test -f "${1}") && echo "ERROR >> ${2} >> ${1} >> file already exists" && exit 1
}

# 
function tool_cp() {  #src  #dst  #prefix.info
    (test "${1}" == "") && echo "ERROR >> ${3} >> no source argument" && exit 1
    (test "${2}" == "") && echo "ERROR >> ${3} >> no destination argument" && exit 1
    cp ${1} ${2}
    (test $? != 0) && echo "ERROR >> ${3} >> copy >> ${1} >> to >> ${2} >> failed" && exit 1
}

# 
function tool_cp_dir_recursive() {  #src.dir  #dst.dir #prefix.info
    (test "${3}" = "" ) && local prefix="${FUNCNAME[*]}" || local prefix="${FUNCNAME[*]} >> ${3}"
    (test "${1}" = "" ) && echo "ERROR >> ${prefix} >> function parameter 1 #var.name not set" && exit 1
    (test "${2}" = "" ) && echo "ERROR >> ${prefix} >> function parameter 2 #var.name not set" && exit 1
    local src=`eval echo "\\${${1}}"`
    local dst=`eval echo "\\${${2}}"`
    
    (test "${src}" = "" ) && echo "ERROR >> ${prefix} >> src = ${1} = ${src} >> load failed" && exit 1
    (test "${dst}" = "" ) && echo "ERROR >> ${prefix} >> dst = ${2} = ${dst} >> load failed" && exit 1
    
    tool_realpath src "${3}"
    tool_realpath dst "${3}"
    tool_dir_if_notexist_exit src "${3}"
    tool_make_and_check_dir_path dst "${3}"
    cp -ur ${src}/* ${dst}/
    (test $? != 0) && echo "ERROR >> ${prefix} >> copy >> ${1} = ${src} >> to >> ${2} = ${dst} >> failed" && exit 1
    echo "INFO >> ${prefix} >> copy >> ${1} = ${src} >> to >> ${2} = ${dst} >> success"
}

# 
function tool_cd() { #path #prefix.info
    (test "${1}" == "") && echo "ERROR >> ${2} >> cd >> no path argument" && exit 1
    cd ${1}
    (test $? != 0) && echo "ERROR >> ${2} >> cd >> ${1} >> failed" && exit 1
    echo "INFO >> ${2} >> cd >> ${1}"
}

# 
function tool_cmp() {  #cmp1  #cmp2 #prefix info
    (test "${1}" != "${2}" ) && echo "ERROR >> ${3} >> compare >> ${1} >> ${2} >> failed" && exit 1
}

#
function tool_compare_try() { #var.name1 #var.name2 #prefix.info
    (test "${1}" = "" ) && echo "ERROR >> ${FUNCNAME[*]} >> function parameter 1 #var.name not set" && exit 1
    (test "${2}" = "" ) && echo "ERROR >> ${FUNCNAME[*]} >> function parameter 2 #var.name not set" && exit 1
    local variable1=`eval echo "\\${${1}}"`
    local variable2=`eval echo "\\${${2}}"`
    
    (test "${3}" != "" ) && local prefix=">> ${3}" || local prefix=""
    
    echo "INFO >> ${FUNCNAME[*]} ${prefix} >> 1 = ${1} = ${variable1}"
    echo "INFO >> ${FUNCNAME[*]} ${prefix} >> 2 = ${2} = ${variable2}"
    
    (test "${variable1}" != "${variable2}" ) && echo "INFO >> ${FUNCNAME[*]} ${prefix} >> ${1} and ${2} >> not match" && return 1
    echo "INFO >> ${FUNCNAME[*]} ${prefix} >> ${1} and ${2} >> match"
    return 0
}

#
function tool_compare() { #var.name1 #var.name2 #prefix.info
    tool_compare_try ${1} ${2} ${3}
    (test $? != 0) && exit 1
}

#
function tool_variable_info() {  #var.name #prefix.info
    (test "${2}" = "" ) && local prefix="${FUNCNAME[*]}" || local prefix="${FUNCNAME[*]} >> ${2}"
    (test "${1}" = "" ) && echo "ERROR >> ${prefix} >> arg 1 #var.name is not set" && exit 1
    local variable=`eval echo "\\${${1}}"`
    echo "INFO >> ${prefix} >> using variable >> ${1} = ${variable}"
}

# "" is not prefix
# " " one space is function name prefix
# "  " double space is function stack prefix
# one or double space started prefix adds same as above
# other like format prefix is exact prefix
function tool_info() { #prefix #var.name #suffix
    if [[ "${1}" == "" ]] ;then
        local prefix=""
    elif [[ "${1}" == " " ]] ;then
        local prefix=" >> ${FUNCNAME[0]}"
    elif [[ "${1}" == "  " ]] ;then
        local prefix=" >> ${FUNCNAME[*]}"
    elif [[ "${1}" == "  "* ]] ;then
        local prefix=" >> ${FUNCNAME[*]} >>${1}"
    elif [[ "${1}" == " "* ]] ;then
        local prefix=" >> ${FUNCNAME[0]} >>${1}"
    else
        local prefix=" >> ${1}"
    fi
    
    (test "${2}" = "" ) && local variable="" || local variable=" >> ${2} = `eval echo "\\${${2}}"`"
    (test "${3}" = "" ) && local suffix="" || local suffix=" >> ${3}"
    
    echo "INFO${prefix}${variable}${suffix}"
}

# 
function tool_variable_check_load_default_try() { #var.name  #var.name.default  #prefix.info
    # args load and verify args
    (test "${3}" = "" ) && local prefix="${FUNCNAME[*]}" || local prefix="${FUNCNAME[*]} >> ${3}"
    (test "${1}" = "" ) && echo "ERROR >> ${prefix} >> arg 1 #var.name is not set" && exit 1
    
    #~ local var=`eval echo "\\${${1}}"`
    eval "var=\"\${${1}}\""
    (test "${2}" = "" ) && local var_default="" || local var_default=`eval echo "\\${${2}}"`
    
    # process args
    (test "${var}" = "" ) && var=${var_default}
    (test "${var}" = "" ) && echo "ERROR >> ${prefix} >> variable = ${1} = ${var} >> default = ${2} = ${var_default} >> load failed" && return 1
    
    # fill return variable
    eval "${1}=\"${var}\""
    
    echo "INFO >> ${prefix} >> using variable = ${1} = ${var}"
    return 0
}

#
function tool_variable_check_load_default() { #var.name  #var.name.default  #prefix.info
    tool_variable_check_load_default_try "${1}" "${2}" "${3}"
    (test $? != 0) && exit 1
}

# remove file or 
function tool_rmfile() {  # variable name of file # prefix info
    (test "${1}" != "" ) && local filename=`eval echo "\\${${1}}"` || local filename=""
    (test "${2}" != "" ) && local prefix=">> ${2}" || local prefix=""
    
    (test "${filename}" = "" ) && echo "ERROR >> ${FUNCNAME[*]} ${prefix} >> file variable >> ${1} >> file name >> ${filename} >> invalid" && exit 1
    
    rm "${filename}"
    (test $? != 0) && echo "ERROR >> ${FUNCNAME[*]} ${prefix} >> remove file >> ${1} >> ${filename} >> failed" && exit 1
    
    echo "INFO >> ${FUNCNAME[*]} ${prefix} >> remove file >> ${1} >> ${filename} >> success"
}

# wget download or continue
function tool_wget_download_or_continue_try() { #var.name.proxy #var.name.url #prefix.info
    (test "${1}" != "" ) && local proxy=`eval echo "\\${${1}}"` || local proxy=""
    (test "${2}" != "" ) && local url=`eval echo "\\${${2}}"` || local url=""
    (test "${3}" != "" ) && local prefix=">> ${3}" || local prefix=""
    
    (test "${url}" = "" ) && echo "ERROR >> ${FUNCNAME[*]} ${prefix} >> url = ${2} = ${url} >> invalid" && exit 1
    
    ${proxy} wget --continue ${url}
    (test $? != 0) && echo "ERROR >> ${FUNCNAME[*]} ${prefix} >> wget >> url = ${2} = ${url} >> failed" && return 1
    
    echo "INFO >> ${FUNCNAME[*]} ${prefix} >> wget >> url = ${1} = ${url} >> success"
    return 0
}

# wget download or continue
function tool_wget_download_or_continue() { #var.name.proxy #var.name.url #prefix.info
    (test "${1}" != "" ) && local proxy=`eval echo "\\${${1}}"` || local proxy=""
    (test "${2}" != "" ) && local url=`eval echo "\\${${2}}"` || local url=""
    (test "${3}" != "" ) && local prefix=">> ${3}" || local prefix=""
    
    (test "${url}" = "" ) && echo "ERROR >> ${FUNCNAME[*]} ${prefix} >> url = ${2} = ${url} >> invalid" && exit 1
    
    ${proxy} wget --continue ${url}
    (test $? != 0) && echo "ERROR >> ${FUNCNAME[*]} ${prefix} >> wget >> url = ${2} = ${url} >> failed" && exit 1
    
    echo "INFO >> ${FUNCNAME[*]} ${prefix} >> wget >> url = ${1} = ${url} >> success"
}

#
function tool_tar_extract() { #var.name.tar.gz.file #var.name.dst.dir #prefix.info
    (test "${1}" != "" ) && local file=`eval echo "\\${${1}}"` || local file=""
    (test "${2}" != "" ) && local dst=`eval echo "\\${${2}}"` || local dst=""
    (test "${3}" != "" ) && local prefix=">> ${3}" || local prefix=""
    
    (test "${file}" = "" ) && echo "ERROR >> ${FUNCNAME[*]} ${prefix} >> file = ${1} = ${file} >> invalid" && exit 1
    (test "${dst}" = "" ) && echo "ERROR >> ${FUNCNAME[*]} ${prefix} >> dst = ${2} = ${dst} >> invalid" && exit 1
    
    if [[ "${file}" == *".deb" ]] ;then
        dpkg -x "${file}" "${dst}"
    else
        tar --extract -f "${file}" -C "${dst}"
    fi
    (test $? != 0) && echo "ERROR >> ${FUNCNAME[*]} ${prefix} >> extract >> file = ${1} = ${file} >> to >> dst = ${2} = ${dst} >> failed" && exit 1
    
    echo "INFO >> ${FUNCNAME[*]} ${prefix} >> extract >> file = ${1} = ${file} >> to >> dst = ${2} = ${dst} >> success"
}

# verify script version by variable cc_setup_helper_version
function tool_check_script_version() { # var.name.script.path # prefix.info
    # parameters check
    (test "${1}" != "" ) && local path=`eval echo "\\${${1}}"` || local path=""
    (test "${2}" != "" ) && local prefix="${FUNCNAME[*]} >> ${2}" || local prefix="${FUNCNAME[*]}"
    (test "${path}" = "" ) && echo "ERROR >> ${prefix} >> script path = ${1} = ${path} >> is invalid" && exit 1
    
    # script realpath
    tool_realpath path
    
    # file check exist
    tool_file_if_notexist_exit ${path} ${prefix}
    
    # check version
    version=`cat "${path}" | grep "cc_setup_helper_version=\"${cc_setup_helper_version}\""`
    (test "${version}" == "" ) && echo "ERROR >> ${prefix} >> script >> ${1} = ${path} >> version is not >> ${cc_setup_helper_version}" && exit 1
    
    # final success
    echo "INFO >> ${prefix} >> check script version >> ${path} >> success"
    
    return 0
}

#
function tool_load_script_variable() { # var.name.script.path # var.name # var.name.load_here # prefix.info
    # args load
    (test "${1}" != "" ) && local script=`eval echo "\\${${1}}"` || local script=""
    local varname=${2}
    local varname_data=${3}
    (test "${4}" != "" ) && local prefix="${FUNCNAME[*]} >> ${4}" || local prefix="${FUNCNAME[*]}"
    
    # args verify
    (test "${script}" = "" ) && echo "ERROR >> ${prefix} >> script path = ${1} = ${script} >> is invalid" && exit 1
    (test "${varname}" = "" ) && echo "ERROR >> ${prefix} >> var name to find = ${varname} >> is invalid" && exit 1
    (test "${varname_data}" = "" ) && echo "ERROR >> ${prefix} >> var name to write data = ${varname_data} >> is invalid" && exit 1
    
    # check if script exists
    tool_realpath script
    tool_file_if_notexist_exit ${script}
    
    # backup original variable
    eval "local tmp=\$${varname}"
    (test $? != 0) && echo "ERROR >> ${prefix} >> backup >> ${varname} >> failed" && exit 1
    
    # load variable from file
    local eval_input=`cat ${script} | grep ^${varname}= | tail -n 1`
    
    # try also search variable from last included source
    if [ "${eval_input}" = "" ]; then
        eval_input=`cat ${script} | grep "^source " | tail -n 1 | cut -d "\"" -f2`
        if [ "${eval_input}" != "" ]; then
            eval_input=`cat ${eval_input} | grep ^${varname}= | tail -n 1`
        fi
    fi
    (test "${eval_input}" = "" ) && echo "ERROR >> ${prefix} >> load >> ${varname} >> from >> ${script} >> failed" && exit 1
    
    eval "${eval_input}"
    (test $? != 0) && echo "ERROR >> ${prefix} >> load >> ${varname} >> from >> ${script} >> failed" && exit 1
    
    if [ "${varname}" != "${varname_data}" ]; then
        # return variable
        eval "${varname_data}=\$${varname}"
        (test $? != 0) && echo "ERROR >> ${prefix} >> write >> ${varname} >> failed" && exit 1
    
        #restore original variable
        eval "${varname}=${tmp}"
        (test $? != 0) && echo "ERROR >> ${prefix} >> restore >> ${varname} >> failed" && exit 1
    fi
    echo "INFO >> ${prefix} >> load variable << ${varname} >> from file >> ${script} >> success"
}

# make file with content and chmod 755 or exit on fail
function tool_make_and_chmod_script_or_exit() {  #var name filename #var content
    (test "${1}" != "" ) && local filename=`eval echo "\\${${1}}"` || local filename=""
    (test "${2}" != "" ) && local cmd=`eval echo \"\\${${2}}\"` || local cmd=""
    
    (test "${filename}" = "" ) && echo "ERROR >> ${FUNCNAME[*]} >> file variable >> ${1} >> file name >> ${filename} >> load failed" && exit 1
    
    (test "${cmd}" = "" ) && echo "ERROR >> ${FUNCNAME[*]} >> content variable >> ${2} >> content data load failed" && exit 1
    
    #~ echo "INFO >> ${FUNCNAME[*]} >> making file >> ${1} >> ${filename}"
    echo "${cmd}" > "${filename}" && chmod 755 "${filename}"
    (test $? != 0) && echo "ERROR >> ${FUNCNAME[*]} >> making file >> ${1} >> ${filename} >> failed" && exit 1
    
    echo "INFO >> ${FUNCNAME[*]} >> making file >> ${1} >> ${filename} >> success"
}

# function to apply crypto config update
function tool_update_cc_cfg() { # cc_main_cfg_path # cc_main_cfg_add # cc_ticker # cc_action_cc_config #
    local cc_main_cfg_path=${1}
    local cc_main_cfg_add=${2}
    local naming_suffix=${3}
    local cc_action_cc_config=${4}
    
    ## main wallet conf file load
    echo "INFO >> ${naming_suffix} >> checking main cc config >> ${cc_main_cfg_path}"
    (test ! -f "${cc_main_cfg_path}") && touch ${cc_main_cfg_path}
    (test ! -f "${cc_main_cfg_path}") && echo "ERROR >> ${naming_suffix} >> ${cc_main_cfg_path} >> not exist" && exit 1
    cc_main_cfg_data=$(<${cc_main_cfg_path})
    
    # filter out comments in cc_main_cfg_add variable
    cc_main_cfg_add=`echo "${cc_main_cfg_add}" | grep -v "^#"`
    (test $? != 0) && echo "ERROR >> filter out comments in cc_main_cfg_add variable >> failed" && exit 1
    
    # test duplicates variable
    cc_main_cfg_add_dup_test=""
    
    # go all config lines to be added
    for cfg_line in ${cc_main_cfg_add}; do
        
        echo "FOR INFO >> processing add main conf line >> ${cfg_line}"
        # reprocess line by eval
        cfg_line=`eval echo ${cfg_line}`
        (test $? != 0) && echo "ERROR >> eval line >> ${cfg_line} >> failed" && exit 1
        
        # extract variable name and check if not empty
        var_name=`echo $cfg_line | cut -d "=" -f1`
        var_value=`echo $cfg_line | cut -d "=" -f2`
        
        # check variable to add duplicates, only first one value is applied
        echo "${cc_main_cfg_add_dup_test}" | grep "=${var_name}=" > /dev/null && already_exist="1" || already_exist="0"
        
        if [[ "${var_name}" != "" ]] && [[ "${already_exist}" != "1"  ]]; then
            
            #~ echo "updating/adding variable >> $var_name"
            
            # configuration update option
            if [ "${cc_action_cc_config}" = "update" ]; then
            
                # configuration value is not empty so will be replaced
                if [ "${var_value}" != "" ]; then
                    # if existing variable, comment it
                    # if commented variable, then add new variable next to
                    cc_main_cfg_data=$(
                    echo "$cc_main_cfg_data" | sed \
                       -e "s/^${var_name}=/#~ ${var_name}=/" \
                       -e "0,/^#~ ${var_name}=/s/^#~ ${var_name}=.*/${cfg_line}\n&/"
                    )
                    (test $? != 0) && echo "ERROR >> update line >> ${cfg_line} >> ${cc_main_cfg_path} >> failed" && exit 1
               
                # else configuration value is empty so will be just commented out
                else
                    # if existing variable, comment it
                    # if commented variable, then add new commented out variable next to
                    cc_main_cfg_data=$(
                    echo "$cc_main_cfg_data" | sed \
                       -e "s/^${var_name}=/#~ ${var_name}=/" \
                       -e "0,/^#~ ${var_name}=/s/^#~ ${var_name}=.*/#~ ${cfg_line}\n&/"
                    )
                    (test $? != 0) && echo "ERROR >> update line >> ${cfg_line} >> ${cc_main_cfg_path} >> failed" && exit 1
                fi
            fi
            
            # if variable in configuration still does not exist, then add it
            if [ "${var_value}" != "" ]; then
                # if variable not added next to comment, so add new line(PLEASE LET NEWLINE THERE)
                echo "${cc_main_cfg_data}" | grep "^${var_name}=" > /dev/null || cc_main_cfg_data="${cc_main_cfg_data}
${cfg_line}"
                (test $? != 0) && echo "ERROR >> add line >> ${cfg_line} >> ${cc_main_cfg_path} >> failed" && exit 1
            
            # if variable or commented variable still does not exist, then add variable as commented variable
            else
                # if variable not added next to comment, so add new line(PLEASE LET NEWLINE THERE)
                echo "${cc_main_cfg_data}" | grep -e "^#~ ${var_name}=" -e "^${var_name}=" > /dev/null || cc_main_cfg_data="${cc_main_cfg_data}
#~ ${cfg_line}"
                (test $? != 0) && echo "ERROR >> add line >> ${cfg_line} >> ${cc_main_cfg_path} >> failed" && exit 1
            fi
            
            # add into duplicates list check and prevent double update
            cc_main_cfg_add_dup_test="${cc_main_cfg_add_dup_test}=${var_name}="
        fi
    done
    
    #~ # replace rpc password/port/user if not updated because already exists
    #~ cc_rpcpassword=`echo "${cc_main_cfg_data}" | grep "^rpcpassword=" | cut -d "=" -f2`
    #~ cc_rpcport=`echo "${cc_main_cfg_data}" | grep "^rpcport=" | cut -d "=" -f2`
    #~ cc_rpcuser=`echo "${cc_main_cfg_data}" | grep "^rpcuser=" | cut -d "=" -f2`
    
    # write down updated config to file
    echo "${cc_main_cfg_data}" > ${cc_main_cfg_path}
    (test $? != 0) && echo "ERROR >> ${naming_suffix} >> update config >> ${cc_main_cfg_path} >> failed" && exit 1
    
    return 0
}

########################################################################
# RUNTIME
########################################################################

# detect dexsetup directory and path

cc_dexsetup_dir_path=`pwd`
tool_realpath cc_dexsetup_dir_path
cc_dexsetup_dir=`basename ${cc_dexsetup_dir_path}`

if [ "$cc_dexsetup_dir" != "dexsetup" ]; then
    echo "ERROR >> dexsetup scripts must be executed from <dexsetup> directory"
    exit 1
fi


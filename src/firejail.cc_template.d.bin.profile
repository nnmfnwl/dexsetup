# Firejail profile for {cc_bin_file_name_prefix}.d.bin
# Description:
# This file is overwritten after every install/update
# Persistent local customizations
include fiejail.{cc_firejail_profile_middlename}.d.bin.local
# Persistent global definitions
include globals.local

### need to add this line to add in screen sessions >> is in disable-shell.inc
ignore noexec ${PATH}/bash
noblacklist ${PATH}/bash

### proxychains config
mkdir ${HOME}/.proxychains
noblacklist ${HOME}/.proxychains
whitelist ${HOME}/.proxychains
read-only ${HOME}/.proxychains

### home directory whitelisting to prevent whole home directory tree reveal
mkdir {cc_chain_dir_path}
noblacklist {cc_chain_dir_path}
whitelist {cc_chain_dir_path}

noblacklist {cc_install_dir_path}/bin/{cc_bin_file_name_prefix}.d.bin
whitelist {cc_install_dir_path}/bin/{cc_bin_file_name_prefix}.d.bin
ignore noexec {cc_install_dir_path}/bin/{cc_bin_file_name_prefix}.d.bin
read-only {cc_install_dir_path}/bin/{cc_bin_file_name_prefix}.d.bin

### backup directory for wallet dat files
mkdir {cc_backup_dir_path}
noblacklist {cc_backup_dir_path}
whitelist {cc_backup_dir_path}

{cc_firejail_profile_add}

include disable-common.inc
include disable-devel.inc
#include disable-exec.inc
include disable-interpreters.inc
#~ include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc

# seems like d and make does not need this
#~ include whitelist-common.inc
#~ include whitelist-var-common.inc

#~ caps.drop all
machine-id
no3d
nodvd
nogroups
### MUST HAVE nonewprivs >> This ensures that child processes cannot acquire new privileges using execve(2)
nonewprivs
noroot
nosound
notv
nou2f
novideo
#~ seccomp
#~ shell none
#tracelog
#x11
#private-bin ../home/jano/Downloads/bitcoin/git.debian/src/qt/bitcoin-qt,mc
private-dev
# Causes problem with loading of libGL.so
#private-etc alternatives,ca-certificates,crypto-policies,fonts,pki,ssl
private-tmp

### network
#~ protocol unix,inet,inet6
# net eth0
#~ netfilter

### environment
#~ shell none

memory-deny-write-execute

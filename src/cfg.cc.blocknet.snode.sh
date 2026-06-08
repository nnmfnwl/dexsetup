cc_setup_helper_version="20210827"

source "./src/cfg.cc.blocknet.sh" || exit 1

cc_chain_dir_path_default="~/.blocknet_snode"
cc_wallet_name_default="wallet_block_snode"

cc_port=41412
cc_rpcport=41414

# commands will be evaluated and executed line by line to first fail which means return non 0
cc_command_list_post_profile=(
'setting torrc config path variable'
'torcfg=/usr/share/tor/tor-service-defaults-torrc'

'setting snode HSV3 data path variable'
'hscfg=/var/lib/tor/ohs_blocknet_snode/'

'setting snode HSV3 data path variable'
'hshostnamecfg=/var/lib/tor/ohs_blocknet_snode/hostname'

'detecting su vs sudo administration command'
'sudo -v; (test \$? != 0) && su_cmd=\"echo \\\"Please enter <root> password\\\" && su - -c\" || su_cmd=\"echo \\\"Please enter <\${USER}> sudo password\\\" && sudo sh -c\"'

'using variables'
'
echo \"torcfg \${torcfg}\";
echo \"hscfg \${hscfg}\";
echo \"hshostnamecfg \${hshostnamecfg}\";
echo \"su_cmd \${su_cmd}\"
'

'administration password >> updating system >> installing tor >> setting up snode onion hidden service domain name >> could take a minute...'
'${su_cmd} \"(apt update && apt install tor) && ((cat ${torcfg} | grep -q ohs_blocknet_snode) && (echo \\\"**** HSV3 already configured ****\\\") || (echo \\\"HiddenServiceDir ${hscfg}\\\" >> ${torcfg} && echo \\\"HiddenServiceVersion 3\\\" >> ${torcfg} && echo \\\"HiddenServicePort ${cc_port} 127.0.0.1:${cc_port}\\\" >> ${torcfg} && service tor@default restart && sleep 6)) && ((cat ${cc_main_cfg_path} | grep -q \\\"^externalip=\\\") && (echo -n \\\"# \\\" >> ${cc_main_cfg_path}) && (echo \\\"**** ${cc_main_cfg_path} configuration file MUST be corrected manually ****\\\") || (echo \\\"adding externalip configuration line into ${cc_main_cfg_path}\\\")) && (echo -n \\\"externalip=\\\" >> ${cc_main_cfg_path}) && (cat ${hshostnamecfg} >> ${cc_main_cfg_path}) && (echo \\\"TOR ONION Hidden-service-v3 for Blocknet service node configuration success\\\")\"'
)

# lines will eval before add
cc_main_cfg_add='
maxconnections=21
maxuploadtarget=2777

rpcthreads=16
rpcworkqueue=128

dxnowallets=1

servicenode=1
enableexchange=1
xrouter=0
# externalip=${cc_snode_hostname}
'${cc_main_cfg_add}


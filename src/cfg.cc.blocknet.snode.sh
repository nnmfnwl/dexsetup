cc_setup_helper_version="20210827"

source "./src/cfg.cc.blocknet.sh" || exit 1

cc_chain_dir_path_default="~/.blocknet_snode"
cc_wallet_name_default="wallet_block_snode"

cc_port=41412
cc_rpcport=41414

# commands will be evaluated and executed line by line to first fail which means return non 0
cc_command_list_post_profile=(
'setting variable of torrc config'
'torrc=/usr/share/tor/tor-service-defaults-torrc'

'detecting su vs sudo administration command'
'sudo -v; (test $? != 0) && su_cmd=\"echo \\\"Please enter ROOT password\\\"; su -c\" || su_cmd=\"echo \\\"Please enter ${USER} sudo password\\\"; sudo sh -c\";'

'administration password needed >> updating system >> installing tor >> setting up snode onion hidden service domain name >> adding domain name into blocknet configuration file >> process could take a minute...'
'${su_cmd} -c \"apt update && apt install tor && cat ${torrc} | grep -q ohs_blocknet_snode || (echo \\\"HiddenServiceDir /var/lib/tor/ohs_blocknet_snode/\\\" >> ${torrc} && echo \\\"HiddenServiceVersion 3\\\" >> ${torrc} && echo \\\"HiddenServicePort ${cc_port} 127.0.0.1:${cc_port}\\\" >> ${torrc} && service tor@default restart && sleep 6 && ohsdn=\$(cat /var/lib/tor/ohs_blocknet_snode/hostname) && echo \\\"externalip=\${ohsdn}\\\" >> ${cc_main_cfg_path})\"'
)

# lines will eval before add
cc_main_cfg_add='
#Accept connections from outside (default: 1 if no -proxy or -connect)
listen=1
server=1
port=${cc_port}

rpcbind=127.0.0.1
rpcallowip=127.0.0.1
rpcport=${cc_rpcport}
rpcuser=${cc_rpcuser}
rpcpassword=${cc_rpcpassword}

#Automatically create Tor hidden service (default: 1)
listenonion=0
#~ onlynet=<net>
# Make outgoing connections only through network <net> (ipv4, ipv6 or
# onion). Incoming connections are not affected by this option.
# This option can be specified multiple times to allow multiple networks.
onlynet=ipv6
onlynet=ipv4=multi
onlynet=onion=multi
#proxy=127.0.0.1:9050
onion=127.0.0.1:9050
bind=127.0.0.1
bantime=180

maxconnections=7
maxuploadtarget=777

txindex=1

dxnowallets=1

classic=1
staking=1

rpcthreads=16
rpcworkqueue=256

#rpcxbridgetimeout - Timeout for internal XBridge RPC calls (default: 120 seconds)
rpcxbridgetimeout=210

servicenode=1
enableexchange=1
xrouter=0
# externalip=${cc_snode_hostname}
'

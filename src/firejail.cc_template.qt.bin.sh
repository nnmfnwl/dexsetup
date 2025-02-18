
cd {cc_install_dir_path} || exit 1
firejail \
--profile=./firejail.{cc_firejail_profile_middlename}.qt.bin.profile \
{cc_proxychains} \
./bin/{cc_bin_file_name_prefix}.qt.bin -printtoconsole -nodebuglogfile -datadir={cc_chain_dir_path} -wallet={cc_wallet_name} $@

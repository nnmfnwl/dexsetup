
cd {cc_install_dir_path}/{cc_cli_dir_name} || exit 1
firejail \
--profile=./../firejail.{cc_firejail_profile_middlename}.cli.bin.profile \
{cc_proxychains} \
bash

#!/bin/bash

# include tools
source "./src/tools.sh" || exit 1

# showhelp is auto set by tools
if [ "${showhelp}" == "yes" ]; then
    echo ""
    echo "*** ABOUT ***"
    echo ""
    echo "crypto currency dependency setup helper script for Debian based Linux operating systems or subsystems"
    echo ""
    echo "*** USAGE ***"
    echo ""
    echo ""${0}" <arguments>"
    echo ""
    echo "*** ARGUMENTS ***"
    echo ""
    echo "<clibuild>"
    echo " >> install console interface build dependencies and main console interface tools:"
    echo " >> >> console interface build packages"
    echo " >> >> firejail sandboxing"
    echo " >> >> tor and proxychains network privacy tools"
    echo " >> >> >> this is mandatory argument"
    echo ""
    echo "<|clitools>"
    echo " >> install console interface tools:"
    echo " >> >> clamav - antivirus scanner is automatically used when building packages to scan for potential threads"
    echo " >> >> screen - very useful tool, used for automatization, background running, terminal multiplexing"
    echo " >> >> htop - very useful console system monitor"
    echo " >> >> joe - user friendly console text editor"
    echo " >> >> mc - console file manager"
    echo " >> >> lm-sensors - hardware monitor, used by htop"
    echo " >> >> apt-file - useful package search tool"
    echo ""
    echo "<|guibuild>"
    echo " >> install graphical user interface dependencies and main graphical tools:"
    echo " >> >> graphical user interface build packages"
    echo " >> >> qr code libraries"
    echo ""
    echo "<|guitools>"
    echo " >> install graphical user interface tools:"
    echo " >> >> gitg - gui for git"
    echo " >> >> keepassx - password manager"
    echo " >> >> geany - text and code editor"
    echo " >> >> xsensors - hardware sensors"
    echo " >> >> tigervnc-standalone-server - remote desktop"
    echo ""
    echo "<|extrabuild>"
    echo " >> install extra graphical user interface build tools like npm:"
    echo ""
    echo "<|noproxychains>"
    echo " >> by default, generated scripts uses proxychains(by default tor network) to transmit data private way"
    echo " >> noproxychains option is here to disable privacy, also it will speed up wallet data download/upload process"
    echo ""
    echo "example:"
    echo ""${0}" clibuild clitools guibuild guitools"
    echo ""
    exit 0
fi

# handle arguments

cc_proxychains_default="proxychains -q"
cc_proxychains=${cc_proxychains_default}
cc_clibuild=
cc_clitools=
cc_guibuild=
cc_guitools=
cc_extrabuild=
cc_pkg_list=""

argc=$#
argv=("$@")

for (( j=0; j<argc; j++ )); do
    if [[ "${argv[j]}" == "noproxychains" ]]; then
        if [[ "${cc_proxychains}" == "${cc_proxychains_default}" ]]; then
            cc_proxychains=
            echo "INFO >> proxychains disabled"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [[ "${argv[j]}" == "clibuild" ]] ;then
        if [[ "${cc_clibuild}" == "" ]]; then
            cc_clibuild="${argv[j]}"
            echo "INFO >> cc_clibuild >> ${cc_clibuild}"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [[ "${argv[j]}" == "clitools" ]] ;then
        if [[ "${cc_clitools}" == "" ]]; then
            cc_clitools="${argv[j]}"
            echo "INFO >> cc_clitools >> ${cc_clitools}"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [[ "${argv[j]}" == "guibuild" ]] ;then
        if [[ "${cc_guibuild}" == "" ]]; then
            cc_guibuild="${argv[j]}"
            echo "INFO >> cc_guibuild >> ${cc_guibuild}"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [[ "${argv[j]}" == "guitools" ]] ;then
        if [[ "${cc_guitools}" == "" ]]; then
            cc_guitools="${argv[j]}"
            echo "INFO >> cc_guitools >> ${cc_guitools}"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    elif [[ "${argv[j]}" == "extrabuild" ]] ;then
        if [[ "${cc_extrabuild}" == "" ]]; then
            cc_extrabuild="${argv[j]}"
            echo "INFO >> cc_extrabuild >> ${cc_extrabuild}"
        else
            echo "Invalid argument: $j ${argv[j]}"
            exit 1
        fi
    fi    
done

# cli build
if [[ "${cc_clibuild}" == "clibuild" ]] ;then
    echo "cli-build packages selected to be installed"
    cc_pkg_list=${cc_pkg_list}" curl git make cmake clang clang-tools clang-format libclang1 libboost-all-dev wget basez libprotobuf-dev protobuf-compiler libssl-dev openssl gcc g++ python3-pip python3-dateutil cargo pkg-config libseccomp-dev libcap-dev libsecp256k1-dev firejail firejail-profiles seccomp proxychains4 tor libsodium-dev libgmp-dev"
else
    echo "clibuild packages are mandatory"
    echo "If you really know what you are doing, feel free to edit script and run)"
    exit 1
fi

# cli tools
if [[ "${cc_clitools}" == "clitools" ]] ;then
    echo "cli-tools packages selected to be installed"
    cc_pkg_list=${cc_pkg_list}" clamav screen htop joe mc lm-sensors apt-file net-tools sshfs"
fi

# gui build
if [[ "${cc_guibuild}" == "guibuild" ]] ;then
    echo "gui-build packages selected to be installed"
    cc_pkg_list=${cc_pkg_list}" qt5-qmake-bin qt5-qmake qttools5-dev-tools qttools5-dev qtbase5-dev-tools qtbase5-dev libqt5charts5-dev python3-gst-1.0 libqrencode-dev"
fi

# gui tools
if [[ "${cc_guitools}" == "guitools" ]] ;then
    echo "gui-tools packages selected to be installed"
    scc_pkg_list=${cc_pkg_list}" gitg keepassx geany xsensors tigervnc-standalone-server"
fi

# extra build tools like npm
if [[ "${cc_extrabuild}" == "extrabuild" ]] ;then
    echo "extra-build packages selected to be installed"
    cc_pkg_list=${cc_pkg_list}" npm"
fi

# installing all selected packages
echo "packages: ${cc_pkg_list}"
echo "please enter root password to install packages"
su - -c "apt install ${scc_pkg_list}"

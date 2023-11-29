#!/bin/bash
# by
# DLTransfer

# args={path}
DownloadTransfer() {
	tfPath=$1
	cd $tfPath

	wget $(curl -L -s https://api.github.com/repos/Mikubill/transfer/releases/latest | grep -o -E "https://(.*)transfer_(.*)_linux_amd64.tar.gz")
	wget $(curl -L -s https://api.github.com/repos/Mikubill/transfer/releases/latest | grep -o -E "https://(.*)transfer_(.*)checksums.txt")
	tar -zxvf transfer_*.tar.gz
	sha256sum -c transfer_*.txt 2>&1 | grep OK
}

# args={path,transfer cmd}
TrsfOnSh() {
	toPath=$1
	toArgs=$2 #${*:2}
	if [[ -f $toPath/transfer ]]; then
		$toPath/transfer $toArgs
	else
		DownloadTransfer "$toPath"
		$toPath/transfer $toArgs
	fi
}

# args={transfer cmd}
TrsfOnShDef() {
	todCMD=$1
	TrsfOnSh . "$todCMD"
}

# args={key,input,output}
TrsfDecrypt() {
	tfDK=$1
	tfDiput=$2
	tfDout=$3
	TrsfOnShDef "decrypt -k $tfDK $tfDiput -o $tfDout"
}

###########main############
#TrsfOnShDef "$1"

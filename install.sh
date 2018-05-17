#!/bin/bash
now=$(date +%Y%m%d_%Hh%M)
MyLog=install-btci_$now.log

echo "
*****************************************
*                 	            	*
*      Bitcoin Incognito (BTCi)		*
*      masternode setup by tof          *
*                             		*
*****************************************

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!                                                 !
! Make sure you double check before hitting enter !
!                                                 !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

"|tee $MyLog

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -ne "${GREEN}Please paste your masternode private key : ${NC}"|tee -a $MyLog
read KEY
echo $KEY >> $MyLog
sleep 3

sudo apt update -y|tee -a $MyLog
sudo apt upgrade -y|tee -a $MyLog
sudo apt install curl pwgen -y|tee -a $MyLog
IP==$(curl -s4 icanhazip.com)
echo $IP >> $MyLog
#dev tools NOT needed if you don't compile
#sudo apt install wget nano unrar unzip -y
#sudo apt install libboost-all-dev libevent-dev software-properties-common -y
sudo apt install software-properties-common -y|tee -a $MyLog
sudo add-apt-repository ppa:bitcoin/bitcoin -y|tee -a $MyLog
sudo apt update|tee -a $MyLog
#sudo apt install libdb4.8-dev libdb4.8++-dev -y
echo "Installing required dependencies ... "|tee -a $MyLog
sudo apt install libdb4.8 libdb4.8++ -y|tee -a $MyLog
sudo apt install libboost-system1.58.0 libboost-filesystem1.58.0 libboost-program-options1.58.0 \
libboost-thread1.58.0 libssl1.0.0 libminiupnpc10 libevent-2.0-5 libevent-pthreads-2.0-5 \
libevent-core-2.0-5 -y|tee -a $MyLog
sleep 3
echo -ne "${GREEN}Copying binaries to /usr/local/bin : ${NC}"|tee -a $MyLog
chmod -c a+x btci*|tee -a $MyLog
sudo cp -v btci* /usr/local/bin|tee -a $MyLog
echo -e "Creating a dedicated user to run BTCi : "|tee -a $MyLog
sudo useradd -m -s /bin/bash btci && echo -e "${GREEN}btci${NC}"|tee -a $MyLog
echo -e "Becoming user ${GREEN}btci${NC} to copy and run BTCi binaries : "|tee -a $MyLog
sudo su - btci <<EOF|tee -a $MyLog
echo -e "
${GREEN}Creating the ${RED}Configuration File (in user's home) ${NC}
"
mkdir ~/.BTCi
echo "#Bitcoin Incognito (BTCi) configuration file
rpcuser=$(pwgen -s 8 -1)
rpcpassword=$(pwgen -s 32 -1)
rpcallowip=127.0.0.1
externalip$IP
daemon=1
server=1
listen=1
masternode=1
masternodeaddr$IP:7250
masternodeprivkey=$KEY" > ~/.BTCi/btci.conf
echo -e "${GREEN}STARTING THE DAEMON${NC}"
btcid
sleep 3
echo -e "
Thank you for installing BTCi.  Please move on to the ${RED}NEXT${NC} step.
"
EOF


#!/bin/bash
#install.sh : a script to install Bitcoin Incognito (BTCi)
tmpdir=$(mktemp -d)
now=$(date +%Y%m%d_%Hh%M)
MyLog=$tmpdir/install-btci_$now.log

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

sudo apt-get update -y|tee -a $MyLog
sudo apt-get upgrade -y|tee -a $MyLog
sudo apt-get install curl pwgen -y|tee -a $MyLog
IP=$(curl -s4 icanhazip.com)
echo " IP : $IP" >> $MyLog
#dev tools NOT needed if you don't compile
#sudo apt-get install wget nano unrar unzip -y
#sudo apt-get install libboost-all-dev libevent-dev software-properties-common -y
sudo apt-get install software-properties-common -y|tee -a $MyLog
sudo add-apt-repository ppa:bitcoin/bitcoin -y|tee -a $MyLog
sudo apt-get update|tee -a $MyLog
#sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
echo "Installing required dependencies ... "|tee -a $MyLog
sudo apt-get install libdb4.8 libdb4.8++ -y|tee -a $MyLog
sudo apt-get install libboost-system1.58.0 libboost-filesystem1.58.0 libboost-program-options1.58.0 \
libboost-thread1.58.0 libssl1.0.0 libminiupnpc10 libevent-2.0-5 libevent-pthreads-2.0-5 \
libevent-core-2.0-5 -y|tee -a $MyLog
echo -ne "${GREEN}Copying binaries to $tmpdir : ${NC}"|tee -a $MyLog
chmod -c a+x btci*|tee -a $MyLog
chmod -c a+rx $tmpdir >> $MyLog
sudo cp -v btci* $tmpdir|tee -a $MyLog
echo -e "Creating a dedicated user to run BTCi : "|tee -a $MyLog
sudo useradd -m -s /bin/bash btci && echo -e "${GREEN}btci${NC}"|tee -a $MyLog
echo -e "Becoming user ${GREEN}btci${NC} to copy and run BTCi binaries : "|tee -a $MyLog
sudo su - btci <<EOF|tee -a $MyLog
mkdir bin
cp -v $tmpdir/btci* bin
echo -e "
${GREEN}Creating the ${RED}Configuration File (in user's home) ${NC}
"
mkdir ~/.BTCi
echo "#Bitcoin Incognito (BTCi) configuration file
rpcuser=$(pwgen -s 8 -1)
rpcpassword=$(pwgen -s 32 -1)
rpcallowip=127.0.0.1
externalip=$IP
daemon=1
server=1
listen=1
masternode=1
masternodeaddr=$IP:7250
masternodeprivkey=$KEY" > ~/.BTCi/btci.conf
echo -e "${GREEN}STARTING THE DAEMON${NC}"
btcid
sleep 3
(crontab -l;echo "@reboot /home/btci/bin/btcid")|crontab -
echo -e "
Thank you for installing BTCi.
To have btcid started after a reboot, this line was added to your crontab : 
@reboot /usr/local/bin/btcid
(run 'crontab -e' and choose your favorite editor to change this)
Please move on to the ${RED}NEXT${NC} step.
"
mkdir logs
EOF
cp -v $MyLog logs
exit

echo "
A full log of this setup can be found in /home/btci/logs/install-btci_$now.log
The BTCi daemon is started with the user btci ... 
To connect as that user, type 'sudo su - btci'
"


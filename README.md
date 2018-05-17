# Bitcoin Incognito (BTCi) masternode install script
## Use this script on a fresh install of Ubuntu 16.04 (x64)
This is a simplified version, manage your memory & firewall settings as you need ...

Stable and cheap VPS hosts here : https://www.scaleway.com/

My BTCi address if this helped you and you consider a donation : B5riAb43z9i3CEVYBK9vjwN1nRF6UsJoze 
<p>(FYI, i don't have enough collateral to run my own BTCi masternode, but i have a few smaller ones)

## This guide is meant for setting up a "hot/cold" setup with Windows & Linux.

## Use this script on a fresh install of Ubuntu 16.04 - MUST BE x64

# Part 1 - Sending Collateral Coins

1. Open your Windows wallet - MAKE SURE IT IS SYNCED WITH THE NETWORK
2. Go to Tools -> Debug Console
3. Type: getaccountaddress MN# (# is your masternode number you want to use)
4. Send 1500 BTCi to this address
5. Go to Tools -> Debug Console
6. Type: masternode outputs (This can take a minute before an output is shown)
7. Type: masternode genkey
7. Save your TX ID (The first number) and your Index Number (Second number, either a 1 or 0)
8. Save your generated key as well as this will be needed in your VPS as your private key
9. Save these with a notepad
10. Close the wallet
11. Move to Part 2 for now

# Part 2 - Getting your Linux VPS Started Up 
##Read all instructions and follow prompts closely !

1. Connect to your linux VPS, then copy and paste the following to get started :
<p><B>NOTE : do NOT run software as ROOT</B>, this script will create a dedicated user for it !
```
sudo apt install git && git clone https://github.com/tofke/btcimn.git && cd btcimn && chmod -c u+x install.sh && ./install.sh
```
2. follow the prompts closely and don't mess it up!
##NOTE : this is where things get different from the initial script
3. Move to Part 3

# Part 3 - Editing your Windows Config File

1. Open your wallet
2. Go to Tools -> Open Masternode Configuration File
3. Enter the following on one single line after the example configuration
```
<alias> <ip>:7250 <private_key> <tx_id> <index>
```
4. It should look something like this:
``` 
MN1 66.65.43.32:7250 87dfjnKNfdjNlwomdmKKMdkaNIE a3eofJJkdlMlfKokfmalmofO 0
```
5. Save and close the file and restart your wallet.

# Part 4 - Starting the Masternode

1. In your wallet, go to Tools -> Debug Console
2. Enter ```startmasternode alias 0 <alias>``` with ```<alias>``` being the name of your masternode from Part 3
3. Enjoy!  You can start this process over again for another MN on a fresh Linux VPS!

# Feel free to consider a donation if this helped : 
BTCi : B5riAb43z9i3CEVYBK9vjwN1nRF6UsJoze

*Official BTCi Discord: https://discord.gg/4YVntwG

# Recommended Tools

- MobaXterm : the best SSH client (and much more) for Windows i know : https://mobaxterm.mobatek.net/download.html


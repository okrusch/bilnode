#!bin/sh

echo "*****************************"
echo "*****************************"
echo "** Starting Bitcoin Daemon **"
echo "*****************************"
echo "*****************************"

cd ~/bitcoin

#somehow loads the entire blockchain????
bitcoind

ln -s ~/bitcoin/blockchain/.bitcoin/data/debug.log ~/bitcoind-mainnet.log


echo "*****************************"
echo "*****************************"
echo "** Testing Bitcoin Daemon **"
echo "*****************************"
echo "*****************************"

bitcoin-cli getbestblockhash

echo "*****************************"
echo "*****************************"
echo "** Step 2 complete! **"
echo "*****************************"
echo "*****************************"

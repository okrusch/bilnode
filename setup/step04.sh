#!bin/sh

echo "*****************************"
echo "*****************************"
echo "** Downlaoding LND **"
echo "*****************************"
echo "*****************************"

git clone https://github.com/lightningnetwork/lnd.git ~/lnd

cd ~/lnd

git checktout v0.14.2-beta


echo "*****************************"
echo "*****************************"
echo "** Installing LND **"
echo "*****************************"
echo "*****************************"

cd ~/lnd

make && make install tags="autopilotrpc chainrpc invoicesrpc routerrpc signrpc walletrpc watchtowerrpc wtclientrpc"

echo "*****************************"
echo "*****************************"
echo "** Configuring LND **"
echo "*****************************"
echo "*****************************"

mkdir ~/.lnd

cp ~/Desktop/bilnode-files/lnd-template.conf ~/.lnd/lnd.conf

echo "Edit LND Config File now!"
echo "Use nano ~/.lnd/lnd.config"
echo "U can start up Lnd by using the lnd command"

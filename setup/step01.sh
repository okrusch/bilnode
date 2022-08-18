#!bin/bash

##Setting up dependencies
echo "*****************************"
echo "*****************************"
echo "** Installing Dependencies **"
echo "*****************************"
echo "*****************************"

home_dir=/home/bilexp/bilnode
bitcoin_dir=/bitcoin

sudo apt update -y

sudo apt upgrade -y

sudo apt install -y git tar build-essential libtool autotools-dev pkg-config libssl-dev libevent-dev bsdmainutils libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-thread-dev libminiupnpc-dev libzmq3-dev libboost-test-dev

echo "*****************************"
echo "*****************************"
echo "** Dependencies installed **"
echo "*****************************"
echo "*****************************"


echo "*****************************"
echo "*****************************"
echo "** Installing Bitcoin **"
echo "*****************************"
echo "*****************************"

##Installing Bitcoin
if [ ! -d "$home_dir$bitcoin_dir" ]; then
	git clone https://github.com/bitcoin/bitcoin.git $home_dir$bitcoin_dir
else
	echo "{$home_dir$bitcoin_dir} already exists!"
fi

echo "*****************************"
echo "*****************************"
echo "** Bitcoin installed **"
echo "*****************************"
echo "*****************************"

cd $home_dir$bitcoin_dir

echo "*****************************"
echo "*****************************"
echo "** Running autgen **"
echo "*****************************"
echo "*****************************"

./autogen.sh

echo "*****************************"
echo "*****************************"
echo "** Running Config & Make **"
echo "*****************************"
echo "*****************************"

./configure CXXFLAGS="--param ggc-min-expand=1 --param ggc-min-heapsize=32768" --enable-cxx --with-zmq --without-gui --disable-shared --with-pic --disable-tests --disable-bench --enable-upnp-default --disable-wallet

make -j "$(($(nproc)+1))"

sudo make install

echo "*****************************"
echo "*****************************"
echo "** Getting RPCAUTH **"
echo "*****************************"
echo "*****************************"

if [ ! -f "rcpauth.py" ]; then
	wget https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py
fi

echo "*****************************"
echo "*****************************"
echo "** Creating Bitcoin condfig File **"
echo "*****************************"
echo "*****************************"

#cp $home_dir$template_dir/bitcoin-template.conf $home_dir$bitcoin_dir/bitcoin.conf


echo "*****************************"
echo "*****************************"
echo "** Step 1 finished! **"
echo "*****************************"
echo "*****************************"



echo "Edit the Bitcoin Config File now!"
echo "rpcauth="
#python3 rpcauth.py bilnode

echo "Node these credentials down!"

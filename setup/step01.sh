#!bin/bash

##Setting up dependencies
echo "*****************************"
echo "*****************************"
echo "** Installing Dependencies **"
echo "*****************************"
echo "*****************************"

home_dir=/home/bilexp/bilnode
bitcoin_dir=/bitcoin
bitcoin_data_dir=/bitcoin_data
template_dir=/templates

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
#change hardcoding to vars
table=$(sudo fdisk /dev/sda < /home/bilexp/bilnode/templates/fdisk_print)
echo $table

partition_check="/dev/sda1"
renew="y"
if [[ "$table" == *"$partition_check"* ]]; then
        sudo umount /dev/sda1 /home/bilexp/.bitcoin
        echo "Partition SDA1 found"
        echo "Do you want to renew the partition? (y)es/(n)o"
        #read rn
        rn="n"
        if [ $rn == "y" ]; then
                sudo fdisk /dev/sda < /home/bilexp/bilnode/templates/fdisk_del
        else
                renew="n"
        fi
else 
        echo "No Partition found"
        renew="y"
fi


if [ $renew == "y" ]; then
        echo "Making new partition"
        sudo fdisk /dev/sda < /home/bilexp/bilnode/templates/fdisk_new
        sudo mkfs -t ext4 /dev/sda1
else 
        echo "Using existing partition"
fi

#sudo fdisk /dev/sda < /home/bilexp/bilnode/templates/fdisk_print

sudo mount /dev/sda1 /home/bilexp/.bitcoin 

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

if [ ! -f "$home_dir$bitcoin_dir/rpcauth.py" ]; then
	wget https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py
else
	echo "rpcauth.py already exists!"
fi

echo "*****************************"
echo "*****************************"
echo "** Creating Bitcoin condfig File **"
echo "*****************************"
echo "*****************************"
if [ ! -f "$home_dir$bitcoin_dir/bitcoin.conf" ]; then
	cp $home_dir$template_dir/bitcoin_template.conf $home_dir$bitcoin_dir/bitcoin.conf
	if [ ! -f "$home_dir$bitcoin_dir/rpcauth.py" ]; then
        	wget https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py
		rpcaut=$(python3 rpcauth.py bilnode)
		autstring_first=${rpcaut#*rpcauth=}
		autstring=${autstring_first%Your*}
		autstring=${autstring%%*( )}
		password=${rpcaut#*password:}
		password=${password%%*( )}
		autstring=$(echo $autstring)
		sed -i "s|autstring|$autstring|g" $home_dir$bitcoin_dir/bitcoin.conf
		touch $home_dir$bitcoin_dir/pw
		echo $password > $home_dir$bitcoin_dir/pw

	else
        	echo "rpcauth.py already exists!"
		#checking fpr rpcautstring
else
	echo "bitcoin.conf already exists!"
	echo "Do you wish to overwrite it? (y)es/(n)o " 
	read ow
	if [ ow=="y" ]; then
		rm $home_dir$bitcoin_dir/bitcoin.conf
		cp $home_dir$template_dir/bitcoin_template.conf $home_dir$bitcoin_dir/bitcoin.conf
		if [ ! -f "$home_dir$bitcoin_dir/rpcauth.py" ]; then
                	wget https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py
                	rpcaut=$(python3 rpcauth.py bilnode)
                	autstring_first=${rpcaut#*rpcauth=}
                	autstring=${autstring_first%Your*}
                	autstring=${autstring%%*( )}
                	password=${rpcaut#*password:}
                	password=${password%%*( )}
                	autstring=$(echo $autstring)
                	sed -i "s|autstring|$autstring|g" $home_dir$bitcoin_dir/bitcoin.conf
                	touch $home_dir$bitcoin_dir/pw
               		echo $password > $home_dir$bitcoin_dir/pw

	        else
        	        echo "rpcauth.py already exists!"
               		 #checking fpr rpcautstring

	else
		echo "Not overwriting bitcoin.conf"
	fi
fi
echo "*****************************"
echo "*****************************"
echo "** Step 1 finished! **"
echo "*****************************"
echo "*****************************"

cd $home_dir$bitcoin_dir



echo "Runnig bitcoind as daemon"
bitcoind

#ln -s $bitcoind_data_dir/debug.log $home_dir$bitcoin_dir/bitcoind-mainnet.log

bitcoin-cli getbestblockhash





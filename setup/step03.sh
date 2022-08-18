#!bin/sh

echo "*****************************"
echo "*****************************"
echo "** Installing Dependencies & GO **"
echo "*****************************"
echo "*****************************"

sudo apt-get update

sudo apt-get -y upgrade

sudo snap install --classic --channel=latest/stable go

echo "*****************************"
echo "*****************************"
echo "** GO installed **"
echo "*****************************"
echo "*****************************"

sudo mv go /usr/local

mkdir ~/go

echo ""
echo ""
echo ""
echo "Add the following to the .profile file: GOPATH=/usr/local/go/bin"
echo ""
echo ""
echo "Use nano ~/.profile to edit"

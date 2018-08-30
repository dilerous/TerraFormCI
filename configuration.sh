#!/bin/bash
set -e

echo "  ----- install ruby and bundler -----  "
apt-get update
apt-get install -y ruby-full build-essential
gem install --no-rdoc --no-ri bundler

echo "  ----- install mongodb -----  "
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list
apt-get update
apt-get install -y mongodb-org

echo "  ----- start mongodb -----  "
systemctl start mongod
systemctl enable mongod

echo "  ----- copy unit file for application -----  "
mv /tmp/ubuntu.service /etc/systemd/system/raddit.service

echo "  ----- clone application repository -----  "
git clone https://github.com/Artemmkin/raddit.git

echo "  ----- install dependent gems -----  "
cd ./raddit
sudo bundle install

echo "  ----- start the application -----  "
sudo systemctl start raddit
sudo systemctl enable raddit

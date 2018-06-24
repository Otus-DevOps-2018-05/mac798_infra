#!/bin/sh

test $(whoami) = root || exec sudo sh $0 $@

MONGO_APT_LIST=/etc/apt/sources.list.d/mongodb-org-3.2.list
MONGO_REPO_KEY_FP=D68FA50FEA312927

test $(whoami) = root || $( echo "Please run $0 as root (sudo)" && exit 1 ) || exit 1

echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > ${MONGO_APT_LIST}

test -f ${MONGO_APT_LIST} || $( echo apt list not creates && exit 1) || exit 1
apt-key adv --keyserver keyserver.ubuntu.com --recv ${MONGO_REPO_KEY_FP} || $( echo cannot install repository public key && exit 1) || exit 1
apt-get update
apt-get install -y mongodb-org || $(echo "Something going wrong with package installation" && exit 1 ) || exit 1
systemctl enable mongod
service mongod start
service mongod status | grep -Eq 'Active: active' || $(echo Mongo daemon not started, giving up && exit 1) || exit 1

echo mongodb server installed and started

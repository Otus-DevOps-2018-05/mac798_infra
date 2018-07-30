#!/bin/sh

sed 's/^\(\s*bindIp:\).*/\1 0.0.0.0/' /etc/mongod.conf >/tmp/mongod.conf
mv /etc/mongod.conf /etc/mongod.conf~
mv /tmp/mongod.conf /etc/mongod.conf

systemctl restart mongod

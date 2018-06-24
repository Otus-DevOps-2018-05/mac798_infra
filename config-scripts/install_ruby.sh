#!/bin/sh

test $(whoami) = root || exec sudo sh $0 $@

apt-get update
apt-get install -y ruby-full ruby-bundler build-essential || $(echo "Something going wrong with package installation" && exit 1 ) || exit 1

ruby -v |grep -Eqi 'ruby\s*2\.[3-9]' || $( echo ruby version suspicious: $(ruby -v) && exit 1 ) || exit 1
bundle -v|grep -Eqi 'Bundler\s*version\s*1\.' || $( echo ruby-bundler version suspicious: $(bundle -v) && exit 1 ) || exit 1

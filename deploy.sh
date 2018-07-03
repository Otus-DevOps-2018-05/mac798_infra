#!/bin/sh

APP_HOME="$HOME/reddit"
EXIT_CODE=0

cur_wd=`pwd`

if [ -e "${APP_HOME}" ]; then
    echo App directory already exists!
    exit 1
fi

if git -C "${HOME}" clone -b monolith https://github.com/express42/reddit.git "$APP_HOME" && cd "${APP_HOME}" && bundle install; then
   if  puma -d; then
        echo Look for app port
        ps aux |grep puma|grep -v grep
    else
        echo "Daemon start failed?"
        EXIT_CODE=1
    fi
else
    EXIT_CODE=1
    echo Something going wrong with cloning/bundling
fi
   


cd "$cur_wd"

exit ${EXIT_CODE}

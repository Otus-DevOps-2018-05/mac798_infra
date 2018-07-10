#!/bin/sh

APP_HOME="/usr/local/share/reddit"
BASEDIR=`dirname "${APP_HOME}"`
EXIT_CODE=0

USER=$1

if [ -z "$USER" ]; then
  USER=appuser
fi

if [ -e "${APP_HOME}" ]; then
    echo App directory already exists!
    exit 1
fi

if ! grep -Eq "^${USER}:" /etc/passwd; then
  echo User ${USER} not found, trying to create!
  if ! useradd -d ${APP_HOME} -S ${USER}; then
    echo User creation failed!
    exit 1
  fi
fi

if git -C "${BASEDIR}" clone -b monolith https://github.com/express42/reddit.git "${APP_HOME}" && cd "${APP_HOME}" && chown -R ${USER} ${APP_HOME} && sudo -u ${USER} bundle install; then
  PUMA=`which puma`
cat >/lib/systemd/system/reddit-ruby.service << EOF
[Unit]
Description=Reddit blog web-app
After=network.target mongod
Requires=mongod

[Service]
User=${USER}
WorkingDirectory=${APP_HOME}
ExecStart=${PUMA}
Restart=always

[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  systemctl enable reddit-ruby
  if ! service reddit-ruby start; then
    EXIT_CODE=1
    echo Service start failed
  fi
else
    EXIT_CODE=1
    echo Something going wrong with cloning/bundling
fi



cd "$cur_wd"

exit ${EXIT_CODE}

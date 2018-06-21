# mac798_infra
mac798 Infra repository

# ДЗ 3

Подключение к внутреннему хосту в одну строку: `ssh -i ~/.ssh/appuser -l appuser -t -A 35.228.67.148 ssh 10.166.0.3`

Подключение к внутреннему хосту через команду `ssh someinternalhost` 

cat ~/.ssh/config
```
Host bastion
     HostName 35.228.67.148
     User appuser
     IdentityFile ~/.ssh/appuser
     IdentitiesOnly yes
     ForwardAgent yes

Host someinternalhost
     HostName   10.166.0.3
     User appuser
     IdentityFile ~/.ssh/appuser
     ProxyCommand ssh bastion nc %h %p
     IdentitiesOnly yes

```
И нужно проверить, что на bastion установлена команда `nc`.

## Настройки vpn

bastion_IP = 35.228.67.148
someinternalhost_IP = 10.166.0.3

# ДЗ 4

testapp_IP = 35.228.161.125

testapp_port = 9292

## Добавление правила брандмауэра при помощи утилиты gcloud
```
gcloud compute firewall-rules create default-puma-rule --allow=tcp:9292  --target-tags=puma-server --source-ranges=0.0.0.0/0
```

## Создание экземпляра VM с автоматизацией установки приложения припомощи startup-script
команда `gcloud compute instances create reddit-app --boot-disk-size=10GB --image-family ubuntu-1604-lts --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --metadata-from-file=startup-script=startup-script.sh`

Содержимое файла startup-script.sh:
```
#!/bin/sh

MONGO_APT_LIST=/etc/apt/sources.list.d/mongodb-org-3.2.list
MONGO_REPO_KEY_FP=D68FA50FEA312927
# add mongodb repo
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > ${MONGO_APT_LIST}
test -f ${MONGO_APT_LIST} || $( echo apt list not creates && exit 1) || exit 1
apt-key adv --keyserver keyserver.ubuntu.com --recv ${MONGO_REPO_KEY_FP} || $( echo cannot install repository public key && exit 1) || exit 1
# install packages
apt-get update
apt-get install -y ruby-full ruby-bundler build-essential mongodb-org || $(echo "Something going wrong with package installation" && exit 1 ) || exit 1
# check installed packages
ruby -v |grep -Eqi 'ruby\s*2\.[3-9]' || $( echo ruby version suspicious: $(ruby -v) && exit 1 ) || exit 1
bundle -v|grep -Eqi 'Bundler\s*version\s*1\.' || $( echo ruby-bundler version suspicious: $(bundle -v) && exit 1 ) || exit 1
#initialize mongodb
systemctl enable mongod
service mongod start
service mongod status | grep -Eq 'Active: active' || $(echo Mongo daemon not started, giving up && exit 1) || exit 1
echo mongodb server installed and started

# start app
APP_USER=appuser
APP_ROOT=/home/${APP_USER}
APP_HOME="$APP_ROOT/reddit"
EXIT_CODE=0

cur_wd=`pwd`

if [ -e "${APP_HOME}" ]; then
    echo App directory already exists!
    exit 1
fi

if sudo -u $APP_USER git -C "${APP_ROOT}" clone -b monolith https://github.com/express42/reddit.git "$APP_HOME" && cd "${APP_HOME}" && sudo -u $APP_USER bundle install; then
   if  sudo -u $APP_USER puma -d; then
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

exit $EXIT_CODE
```
Проверить ход выполнения скрипта можно из веб-консоли или командой `gcloud compute --project=infra-207721 instances get-serial-port-output reddit-app --zone=europe-north1-a`

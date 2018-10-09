# mac798_infra
mac798 Infra repository

# ДЗ 10 (ansible-3)
## Основное Задание
* Выполнены задания со слайдов 1 - 58
* В модуле terraform app добавлен ресурс google_compute_firewall для доступа к 80 порту
* Проверено, что приложение доступно по стандартному порту http
## Задание со *
* К экземплярам ВМ, создаваемым terraform добавлены теги окружения ('stage' или 'prod')
* файл inventory.pl изменен так, что в инвентарный реестр попадают только машины с тегом, соответствующим текущему окружению
## Задание с **
* Добавлен скрипт проверяющий синтаксическую корректность конфигурационных файлов
* Изменен travis.yml для запуска скрипта


#ДЗ 9 (ansible-2)
## Основное задание
* проделаны задания со слайдов 1-60
* создан плейбук deploy.yml для установки приложения
* проверена работа установки бд и приложения и работоспособность полученной конфигурации (создана пробная публикация в приложении)

## Задание со *
* В скрипта динамической инвентаризации использован скрипт на perl, использующий вывод команды `gcloud compute instances list --format=json`. Для его работы требуется установить библиотеку JSON (пакет libjson-perl в ubuntu/debian или JSON через CPAN).
* определение принадлежности ВМ к группе (app или db) происходит в зависимомти от тэгов ВМ.
* в качестве db_host в шаблонах берется внутренний адрес первого экземпляра ВМ в группе db

## Изменени провижионеров packer со скриптов на сценарии ansible
* созданы сценарии packer_db.yml и packer_app.yml
* Для установки пакетов использован модуль package
* Для добавления репозитория mongodb использованы модули apt_key и apt_repository
* Для установки нескольких пакетов в packer_app.yml использована конструкция loop: и подстановка {{ item }}

# ДЗ 8
## Основное задание
* Сделаны задания со слайдов 1-28
* При выполнении команды ansible-playbook с 29 видна следующая картина :
```
PLAY [Clone] ***********************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [appserver]

TASK [Clone repo] ******************************************************************************************************
changed: [appserver]

PLAY RECAP *************************************************************************************************************
appserver                  : ok=2    changed=1    unreachable=0    failed=0   
```
Видно, что changed=1, т.к. после удаления целевой директории модуль git клонирует содержимое репозитория ещё раз.

## Задание со *
* создан файл inventory.json с описанием узлов и исполняемый файл inventory.sh, который выводит содержимое json-файла
* создан исполняемый файл inventory.pl, который разбирает вывод команды `gcloud compute instances list` и выводит соответствующий json для ansible.

 # ДЗ 7
## Основное задание
* Сделаны манипуляции со слайдов 1 - 42
* создан модуль reddit_vpc с параметрами newtwork_name (по умолчанию "default"), ssh_allow_ip -- строка с адресом/сетью для которых разрешен доступ к экземплярам ВМ по ssh (по умолчанию "0.0.0.0/0"), puma_allow_ip -- строка с адресом/сетью для которых разрешен доступ к веб-приложению (по умолчанию "0.0.0.0/0"), app_vm_tag - тег для экземпляра вм c приложением, db_vm_tag - тег для экземпляра вм c бд. Вообще теги и адреса могли бы быть и списками, а не строками, но в рамках этого задания пока нет необходимости более чем в одном значении для каждого из этих параметров.
* В папке ./files/ оставлены id_rsa_test и id_rsa_test.pub. Т.к. это нигде в реальной жизни не используемые файлы, сгенерированные для прохождения тестов тревиса, и я не вижу в них никакой опасности.
* Созданы stage и prod
* во все модули добавлен параметр name_prefix, чтобы можно было разделить по именам  ресурсы созданные в stage и prod
* в модуль reddit_app добавил параметр persistent_ip, чтобы в prod-е можно было использовать постоянный ip, и при этом можно было бы создать stage-экземпляр с эфемерным адресом
* в outputs.tf добавлена выходная переменная reddit_url для удобства копирования в браузер

## Задание со *
* Создан bucket в gcs командой `gsutil mb -l europe-north1 terraform-storage-bucket`. Возможно было бы создать его при помощи модуля терраформа, как описано на слайде 59, но не вижу в этом смысла, т.к. backend "исполняется" перед созданием ресурсов и в нем невозможны подстановки, только константы (насколько я понял).
* создан файл backend.tf
```
terraform {
  backend "gcs" {
    bucket = "terraform-storage-bucket"
    prefix = "prod"
  }
}
```
* При попытке одновременного запуска `terraform apply` получаем в одном из терминалов ошибку
```
Acquiring state lock. This may take a few moments...

Error: Error locking state: Error acquiring the state lock: writing "gs://terraform-storage-bucket/prod/default.tflock" failed: googleapi: Error 412: Precondition Failed, conditionNotMet
Lock Info:
```
* аналогичные действия проделаны в директории storage

## Задание со *
* создаем в модулях reddit_app и reddit_db директории files и кладем туда скрипты для провижинеров. Запуск осуществляется так же как в предыдущем ДЗ за исключением того, что пути до исходников не "file/script.sh", а "${path.module}/files/script.sh"
* в модуле reddit_db создан выходную переменную
```
output "db_address" {
  value = "${google_compute_instance.db.0.network_interface.0.address}"
}
```
* в модуле reddit_app создан параметр db_address и передаем его скрипту провижинера, который создает systemd unit, чтобы установить переменную окружения DATABASE_URL
* при создании образа для экземпляра с mongodb к сожалению не был исправлен конфигурационный файл mongodb, поэтому, чтобы не пересоздавать образ создан провижинер, изменяющий bindIp со 127.0.0.1 на 0.0.0.0



# ДЗ 6
## Основное задание
* Проделаны все манипуляции со слайдов домашнего задания
* Определите input переменную для приватного ключа, использующегося в определении подключения для провижинеров (connection): В файле variables.tf
```
variable private_key_path {
  description = "Path to the private key used for ssh access"
  type        = "string"
}
```
* Определите input переменную для задания зоны в ресурсе "google_compute_instance" "app". У нее должно быть значение по умолчанию
```
variable "zone" {
  description = "Zone"
  default = "europe-north1-a"
  type    = "string"
}
```
* Отформатированы все файлы `*.tf` командой `terraform fmt`
* создан terraform.tfvars.example

## Задание со *
* добавление ключа для пользователя appuser1 :
```
resource "google_compute_project_metadata" "project_metadata" {
  project = "${var.project_id}"

  metadata = {
    #    "ssh-keys" = "${join("\n",formatlist("%s:%s", "${keys(var.project_ssh_users)}", "${data.template_file.ssh_users.*.rendered)}")}"
    "ssh-keys" = "appuser1:${file(var.public_key_path)}"
  }
}
```
* добавление ключей нескольких пользователей:
создадим переменную типа map { имя_пользователя: файл ключа }
```
variable "project_ssh_users" {
  default = {  }
  type        = "map"
  description = "list of project-wide user accounts allowed to connect to instances with ssh key"
}
```
```
project_ssh_users = {
  "mac08" = "~/.ssh/id_rsa.pub"
  "appuser1" = "~/.ssh/id_rsa.pub"
  "appuser2" = "~/.ssh/id_rsa.pub"
}
```
добавим данные template_file
```
data "template_file" "ssh_users" {
  count    = "${length(values(var.project_ssh_users))}"
  template = "$${remote_user}:$${keyfile_content}"

  vars {
    remote_user     = "${element(keys(var.project_ssh_users), count.index)}"
    keyfile_content = "${trimspace(file(element(values(var.project_ssh_users), count.index)))}"
  }
}
```
изменяем google_compute_project_metadata `"ssh-keys" = "${join("\n", "${data.template_file.ssh_users.*.rendered}")}"`
* Добавил из консоли в метаданные проекта ключ для пользователя appuser_web. После применения terraform apply Ключи созданные terraform-ом затерли значения, установленные  вручную.

## Задание с **
* Добавил к ресурсу resource google_compute_instance атрибут count, устанавливаемый через переменную instance_count
* Добавил к имени экземпляра вм его индекс
* В файле lb.tf 3 ресурса google_compute_forwarding_rule -- балансирующее правило брандмауэра, google_compute_target_pool -- пул экземпляров вм, являющихся конечными целями баланстровщика и google_compute_http_health_check -- правило проверки доступности целевых экземпляров вм.
* изменил описание переменной вывода app_external_ip в соответствии с тем, что вместо одного экземпляра теперь появляется список
* Добавил переменную вывода balancer_external_ip с адресом балансировщика.



# ДЗ 5

* Создан шаблон как указано в слайдах
* добавлено описание переменных в секции variables шаблона ubuntu16.json
* создан файл variables.json со значениями параметров шаблона образа
* добавлен .gitignore для variables.json и на создан variables.json.example
* создан сценарий deploy4packer.sh для установки (запекания) приложения внутрь образа
* на основе шаблона ubuntu16.json создан шаблон immutable.json для создания образа с запеченым в него приложением
* создан скрипт create-reddit-vm.sh, который создает экземляр виртуальной машаины с запеченным приложением

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

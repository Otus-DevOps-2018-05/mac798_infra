# mac798_infra
mac798 Infra repository

# ДЗ 4 (3)

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

#!/bin/bash

####
#### https://github.com/gshaposhnikov
####
#### Copyright (c) 2018 Gennady Shaposhnikov. Released under the MIT License.

### Данный скрипт, выполнит полную установку Nextcloud сервера!  

## Перед запуском скрипта в реальной системе, внесите свой корректировки и проверьте работу в тестовой среде!

# Скрипт протестирован на дистрибутиве Linux Ubuntu 16.04.05 server.
# Перед запуском скрипта, обязательно введите ip адрес сервера строка 77!
# Ваша система будет обнавлена до актуального состояния, в процессе работы скрипта.
#                               запускаем скрипт sudo ./nextcloud.sh
# Скрипт должен быть исполняемым.

# Возможные варианты загрузки скрипта, на сервер:

# Клонирование репозитория

# 1 Вариант.
# git clone https://github.com/gshaposhnikov/scripts-ubuntu-16.04.5-LTS
#          sudo ./nextcloud.sh

# 2 Вариант.
# Загрузка скрипта, от клиента на сервер (выполняем команды на клиенте:)

#        1) scp /home/user/Рабочий\ стол/zabbix.sh user@ip_адрес_сервера:/home/user   (Левая сторона до user, расположение скрипта на клиенте. Правая сторона, вместо user укажите вашу учётную запись на сервере и его ip.)
# 	     2) переходим в каталог загрузки script, в примере сd /home/user 
#        3) запускаем скрипт sudo ./name_script.sh

# или

# 3 Вариант.
# Скачивание скрипта с клиентской машины на сервер (выполняем команды на сервере:) 
#        1) scp user@ip_адрес_компьютера_с_которого_скачиваем:/home/user/name_script.sh /home/user   (/home/user директория куда файл будет скопирован)
# 	     2) переходим в каталог загрузки script, в примере сd /home/user 
#        3) запускаем скрипт sudo ./name_script.sh

 
echo $(tput setaf 2) "Обновляю все пакеты" $(tput sgr 0)

apt-get -y update 
apt-get -y upgrade 

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 2) "Устанавливаю пакет snapd" $(tput sgr 0)

apt install snapd -y

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 2) "Устанавливаю snap пакет Nextcloud" $(tput sgr 0)

snap install nextcloud

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 2) "Создаю учетную запись администратора Nextcloud (пользователь и пароль)" $(tput sgr 0)

nextcloud.manual-install admin admin

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# ВАЖНО!
# Обращаться к Nextcloud можно: через доменное имя или IP-адрес сервера, поэтому нам нужно настроить этот параметр! 
# Вместо 192.168.0.0 введите ip адрес вашего сервера, или доменное имя (example.com)

echo $(tput setaf 2) "Настройка доверенных доменов." $(tput sgr 0)

nextcloud.occ config:system:set trusted_domains 1 --value=192.168.0.0		# Измените 192.168.0.0 на реальный ip или доменное имя!

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 2) "Устанавливаю самоподписанный SSL-сертификат." $(tput sgr 0)

nextcloud.enable-https self-signed

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 2) "Открываю веб-порты в брандмауэре." $(tput sgr 0)

ufw allow 80,443/tcp

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 1) "Вы можете войти на сервер Nextcloud, набрав в адресной строке браузера https://ip-адрес сервера/" $(tput sgr 0)

echo $(tput setaf 1) "Логин: admin" $(tput sgr 0)

echo $(tput setaf 1) "Пароль: admin" $(tput sgr 0)















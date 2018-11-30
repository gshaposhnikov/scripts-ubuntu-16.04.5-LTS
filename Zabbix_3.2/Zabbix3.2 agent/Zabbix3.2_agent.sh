#!/bin/bash

####
#### https://github.com/gshaposhnikov
####
#### Copyright (c) 2018 Gennady Shaposhnikov. Released under the MIT License.

### Данный скрипт, выполнит полную установку Zabbix-агента 3.2!  

## Перед запуском скрипта в реальной системе, внесите свой корректировки, (если они нужны) и проверьте работу в тестовой среде!

# Скрипт протестирован на дистрибутиве Linux Ubuntu 16.04 LTS.
# Если вы считаете необходимым, внесите соответствующие исправления в скрипт перед его запуском!
# Ваша система будет обнавлена до актуального состояния, в процессе работы скрипта.
#                               запускаем скрипт sudo ./zabbix.sh
# Скрипт должен быть исполняемым.

# Возможные варианты загрузки скрипта, на сервер:

# Загрузка скрипта, от клиента на сервер (выполняем команды на клиенте:)

#            1) scp /home/user/Рабочий\ стол/jenkins.sh user@ip_адрес_сервера:/home/user   (Левая сторона до user, расположение скрипта на клиенте. Правая сторона, вместо user укажите вашу учётную запись на сервере и его ip.)
# 	     2) переходим в каталог загрузки script, в примере сd /home/user 
#            3) запускаем скрипт sudo ./name_script.sh

# или

# Скачивание скрипта с клиентской машины на сервер (выполняем команды на сервере:) 
#            1) scp user@ip_адрес_компьютера_с_которого_скачиваем:/home/user/name_script.sh /home/user   (/home/user директория куда файл будет скопирован)
# 	     2) переходим в каталог загрузки script, в примере сd /home/user 
#            3) запускаем скрипт sudo ./name_script.sh

echo $(tput setaf 2) "Устанавливаю zabbix agent на Ubuntu Server" $(tput sgr 0)

echo $(tput setaf 2) "Подключаю репозиторий" $(tput sgr 0)

wget http://repo.zabbix.com/zabbix/3.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.2-1+xenial_all.deb
dpkg -i zabbix-release_3.2-1+xenial_all.deb
apt-get update

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Устанавливаю zabbix-agenta" $(tput sgr 0)

apt-get -y install zabbix-agent

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Записываю конфигурацию" $(tput sgr 0)

{
 echo '#Server=[zabbix server ip]'
 echo '#Hostname=[Hostname of client system ]'
 echo   'Server=192.x.x.x'			# Server=Укажите IP вашего сервера.  
 echo 'Hostname=ubuntuserver'			# Hostname=Укажите имя вашего хоста.
} >> /etc/zabbix/zabbix_agentd.conf

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Перезагружаю zabbix agentа" $(tput sgr 0)

/etc/init.d/zabbix-agent restart
systemctl enable zabbix-agent.service		


echo $(tput setaf 1) "Установка zabbix agentа успешно завершена." $(tput sgr 0)


echo $(tput setaf 1) "Для остановки или запуска агента используйте следующие команды:" $(tput sgr 0)

echo $(tput setaf 1) "/etc/init.d/zabbix-agent start" $(tput sgr 0)

echo $(tput setaf 1) "/etc/init.d/zabbix-agent stop" $(tput sgr 0)








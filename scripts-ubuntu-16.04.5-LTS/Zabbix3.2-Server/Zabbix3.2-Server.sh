#!/bin/bash

####
#### https://github.com/gshaposhnikov
####
#### Copyright (c) 2018 Gennady Shaposhnikov. Released under the MIT License.

### Данный скрипт, выполнит полную установку Zabbix-сервера 3.2 и запишет конфигурационные файлы!  

## Перед запуском скрипта в реальной системе, внесите свой корректировки, (если они нужны) и проверьте работу в тестовой среде!

# Скрипт протестирован на дистрибутиве Linux Ubuntu 16.04.5 server.
# Если вы считаете необходимым, внесите соответствующие исправления в скрипт перед его запуском!
# Ваша система будет обнавлена до актуального состояния, в процессе работы скрипта.
#                               запускаем скрипт sudo ./Zabbix3.2-Server.sh
# Скрипт должен быть исполняемым.

# Возможные варианты загрузки скрипта, на сервер:

# Загрузка скрипта, от клиента на сервер (выполняем команды на клиенте:)

#        1) scp /home/user/Рабочий\ стол/Zabbix3.2-Server.sh user@ip_адрес_сервера:/home/user   (Левая сторона до user, расположение скрипта на клиенте. Правая сторона, вместо user укажите вашу учётную запись на сервере и его ip.)
# 	     2) переходим в каталог загрузки script, в примере сd /home/user 
#        3) запускаем скрипт sudo ./Zabbix3.2-Server.sh

# или

# Скачивание скрипта с клиентской машины на сервер (выполняем команды на сервере:) 
#        1) scp user@ip_адрес_компьютера_с_которого_скачиваем:/home/user/name_script.sh /home/user   (/home/user директория куда файл будет скопирован)
# 	     2) переходим в каталог загрузки script, в примере сd /home/user 
#        3) запускаем скрипт sudo ./Zabbix3.2-Server.sh

echo $(tput setaf 2) "Установка Zabbix сервера 3.2-1+xenial" $(tput sgr 0)

echo $(tput setaf 2) "Обновляю все пакеты" $(tput sgr 0)

apt-get -y update 
apt-get -y upgrade 

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 2) "Устанавливаю MySQL сервер" $(tput sgr 0)

echo $(tput setaf 2) "Во время установки укажите пароль для пользователя root сервера mysql" $(tput sgr 0)

echo $(tput setaf 2) "Введите пароль, нас просят его повторить." $(tput sgr 0)

apt -y install mysql-server mysql-client -p1

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0) 


echo $(tput setaf 2) "Установка MySQL" $(tput sgr 0)

echo $(tput setaf 2) "Вхожу пользователем root, в командную строку mysql сервера, создаю базу и пользователя для нашего сервера" $(tput sgr 0)

echo $(tput setaf 2) "Выполнен вход поьзователем root (пароль 1, вводить не нужно для изменения в строке mysql -u root -p1 измените 1 на свой пароль ) " $(tput sgr 0)


echo $(tput setaf 2) "В mysql> Введите следующие команды:" $(tput sgr 0)

echo $(tput setaf 2) "CREATE DATABASE zabbix character set utf8 collate utf8_bin;" $(tput sgr 0)

echo $(tput setaf 2) "GRANT ALL PRIVILEGES ON zabbix.* TO zabbix@localhost IDENTIFIED BY 'zabbix' WITH GRANT OPTION;" $(tput sgr 0)

echo $(tput setaf 2) "FLUSH PRIVILEGES;" $(tput sgr 0)

echo $(tput setaf 2) "exit;" $(tput sgr 0)

mysql -u root -p1  # 1 измените на свой пароль.

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0) 

echo $(tput setaf 2) "Устанавливаю Apache2" $(tput sgr 0)

apt-get -y install apache2 

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Устанавливаю PHP зависимости" $(tput sgr 0)

apt-get -y install php-mbstring php-bcmath php-xml 

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Добавляю библиотеки php7.0" $(tput sgr 0)

apt-get -y install libapache2-mod-php7.0

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Перезапускаю Apache2" $(tput sgr 0)

service apache2 reload

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 2) "Подключаю репозиторий с zabbix сервером" $(tput sgr 0)

wget http://repo.zabbix.com/zabbix/3.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.2-1+xenial_all.deb
dpkg -i zabbix-release_3.2-1+xenial_all.deb
apt-get update

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 2) "Устанавливаю сервер и Web интерфейс для него" $(tput sgr 0)

apt-get -y install zabbix-server-mysql
apt-get -y install zabbix-frontend-php 

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Записываю конфигурацию временного пояса в настройках PHP фаил /etc/apache2/conf-available/zabbix.conf" $(tput sgr 0)

echo $(tput setaf 2) "Записываю конфигурацию timezone Samara в файл /etc/apache2/conf-available/zabbix.conf" $(tput sgr 0)

{
 echo '# Define /zabbix alias, this is the default'
 echo '<IfModule mod_alias.c>'
 echo   'Alias /zabbix /usr/share/zabbix'
 echo '</IfModule>'
 echo ''
 echo '<Directory "/usr/share/zabbix">'
 echo    'Options FollowSymLinks'
 echo    'AllowOverride None'
 echo    'Order allow,deny'
 echo    'Allow from all'
 echo ''
 echo    '<IfModule mod_php5.c>'
 echo        'php_value max_execution_time 300'
 echo        'php_value memory_limit 128M'
 echo        'php_value post_max_size 16M'
 echo        'php_value upload_max_filesize 2M'
 echo        'php_value max_input_time 300'
 echo        'php_value always_populate_raw_post_data -1'
 echo        'php_value date.timezone Europe/Samara'	        #Samara замените на вашу тайм зону.
 echo    '</IfModule>'
 echo    '<IfModule mod_php7.c>'
 echo        'php_value max_execution_time 300'
 echo        'php_value memory_limit 128M'
 echo        'php_value post_max_size 16M'
 echo        'php_value upload_max_filesize 2M'
 echo        'php_value max_input_time 300'
 echo        'php_value always_populate_raw_post_data -1'
 echo        '# php_value date.timezone Europe/Samara'		#Samara замените на вашу тайм зону.
 echo    '</IfModule>'
 echo '</Directory>'
 echo ''
 echo '<Directory "/usr/share/zabbix/conf">'
 echo    'Order deny,allow'
 echo    'Deny from all'
 echo    '<files *.php>'
 echo        'Order deny,allow'
 echo        'Deny from all'
 echo    '</files>'
 echo '</Directory>'
 echo ''
 echo '<Directory "/usr/share/zabbix/app">'
 echo    'Order deny,allow'
 echo    'Deny from all'
 echo    '<files *.php>'
 echo        'Order deny,allow'
 echo        'Deny from all'
 echo    '</files>'
 echo '</Directory>'
 echo ''
 echo '<Directory "/usr/share/zabbix/include">'
 echo    'Order deny,allow'
 echo    'Deny from all'
 echo    '<files *.php>'
 echo        'Order deny,allow'
 echo        'Deny from all'
 echo    '</files>'
 echo '</Directory>'
 echo ''
 echo '<Directory "/usr/share/zabbix/local">'
 echo    'Order deny,allow'
 echo    'Deny from all'
 echo    '<files *.php>'
 echo        'Order deny,allow'
 echo        'Deny from all'
 echo    '</files>'
 echo '</Directory>'
} > /etc/apache2/conf-available/zabbix.conf

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Записываю конфигурацию таймзоны Samara в секцию [Date] файл /etc/php/7.0/apache2/php.ini" $(tput sgr 0)

{
  echo '[Date]'
  echo 'date.timezone = Europe/Samara'
} >> /etc/php/7.0/apache2/php.ini

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Перезагружаю Apache2" $(tput sgr 0)

service apache2 reload

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Импортирую базу данных" $(tput sgr 0)

echo $(tput setaf 2) "Вводим пароль zabbix и ожидаем пока пройдет импорт базы?" $(tput sgr 0)

cd /usr/share/doc/zabbix-server-mysql
mysql -u zabbix -pzabbix zabbix < create.sql

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 2) "Записываю конфигурацию zabbix сервера в файл /etc/zabbix/zabbix_server.conf." $(tput sgr 0)

{
  echo 'DBHost=localhost'
  echo 'DBName=zabbix'
  echo 'DBUser=zabbix'
  echo 'DBPassword=zabbix'				  
} >> /etc/zabbix/zabbix_server.conf

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 2) "Запускаю службу zabbix-server" $(tput sgr 0)

service zabbix-server start
systemctl enable zabbix-server.service

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 1) "Вы можете зайти на сам сервер, набрав в адресной строке браузера http://ip-сервера/zabbix" $(tput sgr 0)

echo $(tput setaf 1) "Логин: Admin (обязательно с большой буквы)" $(tput sgr 0)

echo $(tput setaf 1) "Пароль: zabbix" $(tput sgr 0)















#!/bin/bash

####
#### https://github.com/gshaposhnikov
####
#### Copyright (c) 2018 Gennady Shaposhnikov. Released under the MIT License.

### Данный скрипт, выполнит полную установку и настройку пакета Fail2Ban, запишет в конфигурационные файлы простейшую конфигурацию! 
### Основная задача программы, защитита SSH-сервиса от атак Brute Force.    

## Перед запуском скрипта в реальной системе, внесите свой корректировки, (если они нужны) и проверьте работу в тестовой среде!

# Скрипт протестирован на дистрибутиве Linux Ubuntu 16.04.5 LTS.
# Если вы считаете необходимым, внесите соответствующие исправления в скрипт перед его запуском!
# Ваша система будет обнавлена до актуального состояния, в процессе работы скрипта.
#                               запускаем скрипт sudo ./Fail2Ban.sh
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
 

# Обновление системы.
echo $(tput setaf 2) "Обновляю систему." $(tput sgr 0)

apt-get update

apt-get -y dist-upgrade 

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Установка Fail2Ban
echo $(tput setaf 2) "Установка Fail2Ban" $(tput sgr 0)

sudo apt -y install fail2ban

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Копированием переименовываю файл и записываю конфигурацию в него.
echo $(tput setaf 2) "Создаю файл jail.local" $(tput sgr 0)

sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Записываю конфигурацию Fail2Ban сервера в файл /etc/fail2ban/jail.local" $(tput sgr 0)

echo $(tput setaf 2) "IP адрес будет заблокирован на 12 часов, если с него в течение 10 минут было произведено 3 неудачных попытки авторизации" $(tput sgr 0)

{
  
  echo '[ssh]'								 
  echo 'enabled  = true'
  echo 'filter   = sshd'
  echo 'action   = iptables[name=SSH, port=ssh, protocol=tcp]'
  echo 'logpath  = /var/log/auth.log'
  echo 'findtime    = 600'
  echo 'maxretry    = 3'
  echo 'bantime     = 43200'
				  
} >> /etc/fail2ban/jail.local

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Перезапускаю сервис fail2ban для применения настроек.
echo $(tput setaf 2) "Перезапускаю сервис Fail2Ban" $(tput sgr 0)

sudo service fail2ban restart

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "" $(tput sgr 0)

echo $(tput setaf 2) "Установка и настройка пакета Fail2Ban, успешно завершена." $(tput sgr 0)

echo $(tput setaf 2) "" $(tput sgr 0)

echo $(tput setaf 2) "Комментарий" $(tput sgr 0)							                  # Комментарий от автора. 

echo $(tput setaf 2) "В случае возникновения ошибок, проверьте лог файл" $(tput sgr 0)   

echo $(tput setaf 2) "tail -n 50 -f /var/log/fail2ban.log" $(tput sgr 0)						  # Комментарий завершен.

echo $(tput setaf 2) "" $(tput sgr 0)

echo $(tput setaf 2) "Комментарий завершен" $(tput sgr 0)							







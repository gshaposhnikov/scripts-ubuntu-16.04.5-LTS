#!/bin/bash

####
#### https://github.com/gshaposhnikov
####
#### Copyright (c) 2018 Gennady Shaposhnikov. Released under the MIT License.

### Данный скрипт, выполнит полную установку и настройку onlyoffice-communityserver и его зависимостей!   

## Перед запуском скрипта в реальной системе, внесите свой корректировки, (если они нужны) и проверьте работу в тестовой среде!

# Скрипт протестирован на дистрибутиве Linux Ubuntu 16.04 LTS.
# Если вы считаете необходимым, внесите соответствующие исправления в скрипт перед его запуском!
# Ваша система будет обнавлена до актуального состояния, в процессе работы скрипта.
#                               запускаем скрипт sudo ./onlyoffice.sh
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


echo $(tput setaf 2) "Обновляю систему." $(tput sgr 0)

apt-get -y update

apt-get -y dist-upgrade 

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Добавление репозитория, содержащего актуальные версии пакетов Mono, установка apt-transport-https." $(tput sgr 0)

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

sudo apt install apt-transport-https

echo "deb https://download.mono-project.com/repo/ubuntu stable-xenial main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list

sudo apt update

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)
   
echo $(tput setaf 2) "Установка Node.js." $(tput sgr 0)

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

sudo apt-get install -y nodejs

sudo apt-get install -y build-essential

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Установка Сервера совместной работы Onlyoffice" $(tput sgr 0)

echo $(tput setaf 2) "устанавливаю GPG-ключ:" $(tput sgr 0)

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5

echo $(tput setaf 2) "Добавляю репозиторий Сервера совместной работы:" $(tput sgr 0)

sudo echo "deb http://download.onlyoffice.com/repo/debian squeeze main" | sudo tee /etc/apt/sources.list.d/onlyoffice.list

echo $(tput setaf 2) "Обновляю кэш менеджера пакетов:" $(tput sgr 0)

sudo apt-get update

echo $(tput setaf 2) "Устанавливаю Сервер совместной работы Onlyoffice:" $(tput sgr 0)

sudo apt-get install onlyoffice-communityserver

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Установка Сервера совместной работы Onlyoffice завершена:" $(tput sgr 0)






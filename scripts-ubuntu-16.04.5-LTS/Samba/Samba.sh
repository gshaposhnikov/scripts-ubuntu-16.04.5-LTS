#!/bin/bash

####
#### https://github.com/gshaposhnikov
####
#### Copyright (c) 2018 Gennady Shaposhnikov. Released under the MIT License.

### Данный скрипт, выполнит полную установку и простую настройку samba-сервера! Скрипт выведет инструкцию по подключению к серверу.  

## Перед запуском скрипта в реальной системе, внесите свой корректировки, (если они нужны) и проверьте работу в тестовой среде!

# Скрипт протестирован на дистрибутиве Linux Ubuntu 16.04.5 LTS.
# Если вы считаете необходимым, внесите соответствующие исправления в скрипт перед его запуском!
# Ваша система будет обнавлена до актуального состояния, в процессе работы скрипта.
#                               запускаем скрипт sudo ./samba.sh
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
   
echo $(tput setaf 2) "Установка Samba сервера." $(tput sgr 0)

echo $(tput setaf 2) "Создаю каталог Obmen в домашнем каталоге /home/user/ (Доступен всем), права доступа 777." $(tput sgr 0)

cd ~
mkdir Obmen
stat Obmen

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Добавляю права chmod 777 Obmen" $(tput sgr 0)

chmod 777 Obmen

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Создаю каталог Admin в домашнем каталоге /home/user/ (Доступен пользователю Admin), права доступа 777." $(tput sgr 0)

mkdir Admin
stat Admin

chmod 777 Admin

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Устанавливаю пакет Samba" $(tput sgr 0)

apt-get -y install samba 

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Перехожу в каталог /etc/samba" $(tput sgr 0)

cd /etc/samba

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Проверяю содержимое каталога командой ls, в каталоге должены быть файлы gdbcommands smb.conf tls (каталог)" $(tput sgr 0)

ls

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Создаю резервную копию smb.conf " $(tput sgr 0)

cp smb.conf smb_original.conf

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Проверяю результат командой ls, получаем вывод gdbcommands smb.conf smb_original.conf tls" $(tput sgr 0)

ls

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Устанавливаю редактор vim" $(tput sgr 0)

apt-get -y install vim 		

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Записываю параметры конфигурации в smb.conf (Параметры Obmen и Admin)" $(tput sgr 0)

echo $(tput setaf 3) "[Obmen]" $(tput sgr 0)
echo $(tput setaf 3) "comment = Obmen" $(tput sgr 0)
echo $(tput setaf 3) "path = home/user/Obmen" $(tput sgr 0)
echo $(tput setaf 3) "browseable = yes" $(tput sgr 0)
echo $(tput setaf 3) "guest ok = yes" $(tput sgr 0)
echo $(tput setaf 3) "writeable = yes" $(tput sgr 0)
echo $(tput setaf 3) "public = yes" $(tput sgr 0)
echo $(tput setaf 3) "Пустая строка" $(tput sgr 0)
echo $(tput setaf 3) "[Admin]" $(tput sgr 0)
echo $(tput setaf 3) "comment = Admin" $(tput sgr 0)
echo $(tput setaf 3) "path = home/user/Admin" $(tput sgr 0)
echo $(tput setaf 3) "writable = yes" $(tput sgr 0)
echo $(tput setaf 3) "valid users = admin" $(tput sgr 0)
echo $(tput setaf 3) "read list = admin" $(tput sgr 0)
echo $(tput setaf 3) "write list = admin" $(tput sgr 0)

{
  echo '[Obmen]'
  echo 'comment = Obmen'
  echo 'path = home/user/Obmen'
  echo 'browseable = yes'
  echo 'guest ok = yes'
  echo 'writeable = yes'
  echo 'public = yes'

  echo '[Admin]'
  echo 'comment = Admin'
  echo 'path = home/user/Admin'
  echo 'writable = yes'
  echo 'valid users = admin'
  echo 'read list = admin'
  echo 'write list = admin'
} >> /etc/samba/smb.conf

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Проверяем конфигурацию Samba утилитой" $(tput sgr 0)

echo $(tput setaf 2) "Всё в порядке, если:" $(tput sgr 0)

echo $(tput setaf 2) "[sudo] пароль для user:" $(tput sgr 0)
echo $(tput setaf 2) "Load smb config files from /etc/samba/smb.conf" $(tput sgr 0)
echo $(tput setaf 2) "rlimit_max: increasing rlimit_max (1024) to minimum Windows limit (16384)" $(tput sgr 0)
echo $(tput setaf 2) "Processing section "[Obmen]"" $(tput sgr 0) 
echo $(tput setaf 2) "Loaded services file OK." $(tput sgr 0)
echo $(tput setaf 2) "Server role: ROLE_STANDALONE" $(tput sgr 0)

testparm

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Добавляю системную учётную запись Admin, она без пароля в учётных записях пользователя отключена." $(tput sgr 0)

echo $(tput setaf 2) "В системе она использоваться не будет, создана для авторизации в Samba." $(tput sgr 0) 

useradd admin 

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Добавляю пользователя Samba, по умолчанию admin имя должно соответствовать реальной системной записи. Введите свой пароль !!!!!" $(tput sgr 0)

echo $(tput setaf 2) "New SMB password: (Введите свой пароль на подключение к серверу Samba)" $(tput sgr 0)

echo $(tput setaf 2) "Retype new SMB password: (Повторно введите пароль)" $(tput sgr 0)

echo $(tput setaf 2) "Added user admin 	(Учётная запись пользователя добавлена на сервер Samba)" $(tput sgr 0)

smbpasswd -a admin

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Перезагрузка службы Samba" $(tput sgr 0)

service smbd restart

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Samba server, установлен на вашем компьютере. В дректории home/user создана папка Obmen и Admin с правами 777 на чтение и запись." $(tput sgr 0)

echo $(tput setaf 2) "В конфигурационный файл /etc/samba/smb.conf добавлена секция Obmen и Admin (Каталог Obmen доступен всем, каталог Admin только тем кто знает пароль.)" $(tput sgr 0)

echo $(tput setaf 2) "# Change this to the workgroup/NT-domain name your Samba server will part of
   workgroup = WORKGROUP, MYGROUP, OFFICE и т.д (В конфигурационный файл /etc/samba/smb.conf через запятую укажите все рабочие группы, по умолчанию доступен WORKGROUP." $(tput sgr 0)

echo $(tput setaf 1) "Подключение к серверу из Windows систем: Откройте мой компьютер, в адресной строке введите \\ip адрес сервера" $(tput sgr 0)

echo $(tput setaf 1) "Подключение к серверу из Linux систем: Откройте файловый менеджер - Обзор сети (Сеть) - в адресной строке введите smb:\\ip адрес сервера" $(tput sgr 0)

echo $(tput setaf 1) "Каталог Obmen доступна всем пользователям, каталог Admin будет доступен всем кто введёт логин admin и пароль указанный в процессе установки!" $(tput sgr 0)

echo $(tput setaf 3) "Установка завершена!" $(tput sgr 0)

echo $(tput setaf 2) "Проверка статуса, для выхода нажмите Ctrl+C" $(tput sgr 0)

service smbd status



#!/bin/bash

####
#### https://github.com/gshaposhnikov
####
#### Copyright (c) 2018 Gennady Shaposhnikov. Released under the MIT License.

### Данный скрипт, выполнит полную установку и настройку пакета Jenkins и его зависимостей! Выведет подробную инструкцию, по настройке Jenkins.   

## Перед запуском скрипта в реальной системе, внесите свой корректировки, (если они нужны) и проверьте работу в тестовой среде!

# Скрипт протестирован на дистрибутиве Linux Ubuntu 16.04 LTS.
# Если вы считаете необходимым, внесите соответствующие исправления в скрипт перед его запуском!
# Ваша система будет обнавлена до актуального состояния, в процессе работы скрипта.
#                               запускаем скрипт sudo ./jenkins.sh
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

apt-get -y update

apt-get -y dist-upgrade 

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Установка Java, пакета Oracle JDK 8
echo $(tput setaf 2) "Устанавливаю Java" $(tput sgr 0)

echo $(tput setaf 2) "Добавляю адрес репозитория Java, и обновляю индексы пакетов:" $(tput sgr 0)
echo $(tput setaf 2) "Устанавливаю Oracle JDK 8:" $(tput sgr 0)

sudo add-apt-repository ppa:webupd8team/java
sudo apt-get -y update
sudo apt-get -y install oracle-java8-installer

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "Установка Oracle JDK 8, успешно завершена!" $(tput sgr 0)

# Установка Jenkins
# Добавляю ключ репозитория Jenkins
echo $(tput setaf 2) "Установка Jenkins" $(tput sgr 0) 
  
echo $(tput setaf 2) "Добавляю ключ репозитория Jenkins:" $(tput sgr 0)

echo $(tput setaf 2) "Система должна вернуть OK" $(tput sgr 0)

wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Добавляю адрес репозитория Debian в файл sources.list.
echo $(tput setaf 2) "Добавляю адрес репозитория Debian в файл sources.list." $(tput sgr 0)

echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Обновляю индекс пакетов.
echo $(tput setaf 2) "Обновляю индекс пакетов:" $(tput sgr 0)

sudo apt-get update

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Устанавливаю Jenkins и зависимости пакета:
echo $(tput setaf 2) "Устанавливаю Jenkins и зависимости пакета:" $(tput sgr 0)

sudo apt-get -y install jenkins

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Запускаю сервис Jenkins.
echo $(tput setaf 2) "Запускаю Jenkins с помощью systemctl:" $(tput sgr 0)

sudo systemctl start jenkins

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Открываю порт ufw
echo $(tput setaf 2) "По умолчанию Jenkins использует порт 8080. Открывыю его в брандмауэре ufw:" $(tput sgr 0)

sudo ufw allow 8080

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Получение пароля администратора, для доступа к установке. 
echo $(tput setaf 2) "Выполняю запрос пароля инициализации администратора (Скопируйте 32-значный буквенно-цифровой пароль и вставьте его в поле Administrator password, затем нажмите Continue):" $(tput sgr 0)

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 2) "" $(tput sgr 0)
echo $(tput setaf 2) "" $(tput sgr 0)
echo $(tput setaf 2) "Установка Jenkins, успешно завершена!" $(tput sgr 0)

# Комментарий для настройки в браузере.
echo $(tput setaf 2) "Все дальнейшие настройки, нужно выполнить в ручную!" $(tput sgr 0)

echo $(tput setaf 2) "Чтобы выполнить начальную настройку Jenkins в браузере, откройте ссылку:" $(tput sgr 0)

echo $(tput setaf 2) "http://ip_address_or_domain_name:8080" $(tput sgr 0)

echo $(tput setaf 2) "На экране появится страница Unlock Jenkins, на которой указан путь к файлу с паролем:" $(tput sgr 0)

echo $(tput setaf 2) "Unlock Jenkins" $(tput sgr 0)

echo $(tput setaf 2) "To ensure Jenkins is securely set up by the" $(tput sgr 0)

echo $(tput setaf 2) "administrator, a password has been written to the log " $(tput sgr 0)

echo $(tput setaf 2) "[…]" $(tput sgr 0)

# Запрос 32-значного пароля.
echo $(tput setaf 2) "Выполняю запрос пароля инициализации администратора:" $(tput sgr 0)

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


echo $(tput setaf 2) "Скопируйте 32-значный буквенно-цифровой пароль и вставьте его в поле Administrator password, затем нажмите Continue" $(tput sgr 0)

echo $(tput setaf 2) "Чтобы начать установку стандартного набора плагинов, нажмите Install suggested plugins." $(tput sgr 0)

echo $(tput setaf 2) "Чтобы создать администратора, заполните форму Create First Admin User и нажмите Save and Finish." $(tput sgr 0)

echo $(tput setaf 2) "В выводе вы увидите:" $(tput sgr 0)

echo $(tput setaf 2) "Jenkins is ready!" $(tput sgr 0)

echo $(tput setaf 2) "Your Jenkins setup is complete." $(tput sgr 0)

echo $(tput setaf 2) "Start using Jenkins" $(tput sgr 0)

echo $(tput setaf 2) "" $(tput sgr 0)
echo $(tput setaf 2) "" $(tput sgr 0)
echo $(tput setaf 2) "Настройка Jenkins, успешно завершена!." $(tput sgr 0)




#!/bin/bash

####
#### https://github.com/gshaposhnikov
####
#### Copyright (c) 2018 Gennady Shaposhnikov. Released under the MIT License.

### Данный скрипт, выполнит полную установку и настройку тикет системы best practice и его зависимостей! В самом низу, есть инструкция по настройке. 
 
## Перед запуском скрипта в реальной системе, внесите свой корректировки и проверьте работу в тестовой среде!

# Скрипт протестирован на дистрибутиве Linux Ubuntu 16.04 LTS.
# Перед запуском, обязательно проверьте и внесите свои параметры в скрипт (такие как: оперативная память - доступная для сервера sendmeil, ip адрес сервера     
# и др). Все важные пункты в коде выделены # и требуют внимания с вашей стороны! Данный скрипт мной протестирован! Перед выполнением на реальной машине 
# протестируйте в тестовой среде. Обязательно убедитесь в правильности своих настроек, особенно имени сервера ubuntu и ip адреса хоста!!!

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

# Базовые настройки готового сервера, приведены в конце скрипта.

# Настройка сервера.

echo $(tput setaf 2) "Обновляю систему." $(tput sgr 0)

apt-get -y update

apt-get -y dist-upgrade 

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Отключаю файервол.

echo $(tput setaf 2) "Отключаю файервол." $(tput sgr 0)

sudo ufw disable					

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Устанавливаю mysql-server и все зависимости, для работы с БД.

echo $(tput setaf 2) "Устанавливаю mysql-server и все зависимости, для работы с БД." $(tput sgr 0)

sudo apt-get -y install mysql-server mysql-client libmysqlclient-dev		 # Во время исполнения скрипта, введите пароль на учётную запись root mysql.

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Оптимизирую размер буфера под работу SQL а именно в файле /etc/mysql/mysql.conf.d/mysqld.cnf добавляю в раздел Fine Tuning строку (50-80% ОЗУ):

echo $(tput setaf 2) "Записываю конфигурацию в файл /etc/mysql/mysql.conf.d/mysqld.cnf." $(tput sgr 0)

# запись в файл /etc/mysql/mysql.conf.d/mysqld.cnf
{
 echo 'skip-external-locking'
echo '#' 
echo '# Instead of skip-networking the default is now to listen only on'
echo '# localhost which is more compatible and is not less secure.' 
echo 'bind-address            = 127.0.0.1' 
echo '#' 
echo '# * Fine Tuning'
echo '#'
echo 'innodb_buffer_pool_size = 2048M'                                              # Укажите объём доступной оперативной памяти, 50-80% ОЗУ. 
echo 'key_buffer_size         = 16M'
echo 'max_allowed_packet      = 16M'
echo 'thread_stack            = 192K'
echo 'thread_cache_size       = 8'
echo '# This replaces the startup script and checks MyISAM tables if needed'
echo '# the first time they are touched'
echo 'myisam-recover-options  = BACKUP'
echo '#max_connections        = 100'
echo '#table_cache            = 64'
echo '#thread_concurrency     = 10'
echo '#'
echo '# * Query Cache Configuration'
echo '#'
echo 'query_cache_limit       = 1M'
echo 'query_cache_size        = 16M'
echo '#'
echo '# * Logging and Replication'
echo '#'
echo '# Both location gets rotated by the cronjob.'
echo '# Be aware that this log type is a performance killer.'
echo '# As of 5.1 you can enable the log at runtime!'
echo '#general_log_file        = /var/log/mysql/mysql.log'
echo '#general_log             = 1'
echo '#'
echo '# Error log - should be very few entries.'
echo '#'
echo 'log_error = /var/log/mysql/error.log'
echo '#'
echo '# Here you can see queries with especially long duration'
echo '#log_slow_queries       = /var/log/mysql/mysql-slow.log'
echo '#long_query_time = 2'
echo '#log-queries-not-using-indexes'
echo '#'
echo '# The following can be used as easy to replay backup logs or for replication.'
echo '# note: if you are setting up a replication slave, see README.Debian about'
echo '#       other settings you may need to change.'
echo '#server-id              = 1'
echo '#log_bin                        = /var/log/mysql/mysql-bin.log'
echo 'expire_logs_days        = 10'
echo 'max_binlog_size   = 100M'
echo '#binlog_do_db           = include_database_name'
echo '#binlog_ignore_db       = include_database_name'
echo '#'
echo '# * InnoDB'
echo '#'
echo '# InnoDB is enabled by default with a 10MB datafile in /var/lib/mysql/.'
echo '# Read the manual for more InnoDB related options. There are many!'
echo '#'
echo '# * Security Features'
echo '#'
echo '# Read the manual, too, if you want chroot!'
echo '# chroot = /var/lib/mysql/'
echo '#'
echo '# For generating SSL certificates I recommend the OpenSSL GUI "tinyca".'
echo '#'
echo '# ssl-ca=/etc/mysql/cacert.pem'
echo '# ssl-cert=/etc/mysql/server-cert.pem'
echo '# ssl-key=/etc/mysql/server-key.pem'

} > /etc/mysql/mysql.conf.d/mysqld.cnf

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Запускаю мастер настройки безопасности mysql и перезапускаю демон:

echo $(tput setaf 2) "Запускаю мастер настройки безопасности mysql и перезапускаю сервис mysql:" $(tput sgr 0)

echo $(tput setaf 2) "Предложение установить плагин? [Y/n] n" $(tput sgr 0)
echo $(tput setaf 2) "Change the root password? [Y/n] n" $(tput sgr 0)
echo $(tput setaf 2) "Remove anonymous users? [Y/n] y" $(tput sgr 0)
echo $(tput setaf 2) "Disallow root login remotely? [Y/n] y" $(tput sgr 0)
echo $(tput setaf 2) "Remove test database and access to it? [Y/n] y" $(tput sgr 0)
echo $(tput setaf 2) "Reload privilege tables now? [Y/n] y" $(tput sgr 0)

sudo mysql_secure_installation

# n
# n
# y
# y
# y
# y

sudo service mysql restart

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Устанавливаю веб сервер и все зависимости для работы веб-сервера:
 
echo $(tput setaf 2) "Устанавливаю веб сервер и все зависимости для работы веб-сервера:" $(tput sgr 0)

sudo apt-get -y install make apache2 libapache2-mod-fcgid libssl-dev libyaml-perl libgd2-xpm-dev libgd-gd2-perl libgraphviz-perl

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Создаю пользователя для трекера заявок и добавляю его в группу пользователей apache: 

echo $(tput setaf 2) "Создаю пользователя для трекера заявок и добавляю его в группу пользователей apache:" $(tput sgr 0)

sudo adduser --system --group rt
sudo usermod -aG rt www-data

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Для отправки с сервера почтовых сообщений ставлю нужные пакеты (при установке укаываю режим работы Satellite (Спутник)

echo $(tput setaf 2) "Для отправки с сервера почтовых сообщений ставлю нужные пакеты (при установке укаываю режим работы Satellite (Спутник)" $(tput sgr 0)

sudo apt-get -y install postfix mailutils

# Postfix Configuration
# Из списка выбрать 
# Satellite system
# System mail name:
# server — OK			                                                               # Вместо server укажите ваше имя сервера. (ubuntu)
# SMTP relay host
# smtp.yandex.ru:587 — OK 

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Записываю конфигурацию в файл postfix /etc/postfix/main.cf добавляю В секции #TLS parameters (для красоты после smtp_tls_session_cache_database )

echo $(tput setaf 2) "Записываю конфигурацию в файл postfix /etc/postfix/main.cf добавляю В секции #TLS parameters" $(tput sgr 0)

# запись в файл /etc/postfix/main.cf
{
echo '# See /usr/share/postfix/main.cf.dist for a commented, more complete version'
echo ''
echo ''
echo '# Debian specific:  Specifying a file name will cause the first'
echo '# line of that file to be used as the name.  The Debian default'
echo '# is /etc/mailname.'
echo '#myorigin = /etc/mailname'
echo ''
echo 'smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)'
echo 'biff = no'
echo ''
echo '# appending .domain is the MUAs job.'				                         # В оригинале: # appending .domain is the MUA's job. (Не влияет на работоспособность скрипта)
echo 'append_dot_mydomain = no'
echo ''
echo '# Uncomment the next line to generate "delayed mail" warnings'
echo '#delay_warning_time = 4h'
echo ''
echo 'readme_directory = no'
echo ''
echo '# TLS parameters'							
echo 'smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem'
echo 'smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key'
echo 'smtpd_use_tls=yes'
echo 'smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache'
echo 'smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache'	
echo ''										
echo 'smtp_sasl_auth_enable = yes'						                    # Конфигурация postfix	<Начало>				
echo 'smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd'
echo 'smtp_sasl_security_options = noanonymous'
echo 'smtp_sasl_type = cyrus'
echo 'smtp_sasl_mechanism_filter = login'
echo 'smtp_sender_dependent_authentication = yes'				                    # Не изменяйте эту конфигурацию, если вы не уверены в правильной настройке! 
echo 'sender_dependent_relayhost_maps = hash:/etc/postfix/sender_relay'
echo 'smtp_generic_maps = hash:/etc/postfix/generic'
echo 'smtp_tls_CAfile = /etc/postfix/cacert.pem'
echo 'smtp_use_tls = yes'							                    # Конфигурация postfix	<Конец>
echo ''
echo '# See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for'
echo '# information on enabling SSL in the smtp client.'
echo ''
echo 'smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination'
echo 'myhostname = server'
echo 'alias_maps = hash:/etc/aliases'
echo 'alias_database = hash:/etc/aliases'
echo 'mydestination = $myhostname, server, localhost.localdomain, localhost'
echo 'relayhost = smtp.yandex.ru:587'
echo 'mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128'
echo 'mailbox_size_limit = 0'
echo 'recipient_delimiter = +'
echo 'inet_interfaces = loopback-only'
echo 'inet_protocols = all'

} > /etc/postfix/main.cf

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Создаю файл /etc/postfix/sasl_passwd и указываю логин и пароль для аутентификации на внешнем почтовом сервере

echo $(tput setaf 2) "Записываю конфигурацию в файл /etc/postfix/sasl_passwd и указываю логин и пароль для аутентификации на внешнем почтовом сервере" $(tput sgr 0)

# запись в файл /etc/postfix/sasl_passwd
{
 echo 'smtp.yandex.ru          test@yandex.com:123'                                                     # Замените test@yandex.ru на свой ящик    company@yandex.com:123 (вместо 123 пароль от вашего ящика).  
 		
	   
} > /etc/postfix/sasl_passwd

echo $(tput setaf 2) "Меняю режим доступа к файлу и заугружаю информацию в postfix:" $(tput sgr 0)

sudo chmod 400 /etc/postfix/sasl_passwd
sudo postmap /etc/postfix/sasl_passwd

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Записываю конфигурацию в файл /etc/postfix/generic в котором указываю что для отправки писем с этого сервера используется ящик alert в формате: 

echo $(tput setaf 2) "Записываю конфигурацию в файл /etc/postfix/generic в котором указываю что для отправки писем с этого сервера используется ящик alert в формате:" $(tput sgr 0)

# запись в файл /etc/postfix/generic
{
 echo '@server         test@yandex.com'	                                                                 # @server измените на своё имя хоста      company@yandex.com  (Испраления обязательны) 
                                 

} > /etc/postfix/generic

echo $(tput setaf 2) "Загружаю конфиг в postfix:" $(tput sgr 0)

sudo postmap /etc/postfix/generic

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Создаю файл /etc/postfix/sender_relay в котором говорю что для домена example.com будет использоваться relay smtp.yandex.ru в формате:

echo $(tput setaf 2) "Записываю конфигурацию в файл /etc/postfix/sender_relay в котором говорю что для домена example.com будет использоваться relay smtp.yandex.ru в формате:" $(tput sgr 0)

# запись в файл /etc/postfix/sender_relay
{
 echo '@yandex.com             smtp.yandex.ru'	 
   
} > /etc/postfix/sender_relay

echo $(tput setaf 2) "Загружаю конфиг в postfix:" $(tput sgr 0)

sudo postmap /etc/postfix/sender_relay

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Копирую доступный (в Ubuntu 16.04 LTS) корневой сертификат в файл /etc/postfix/cacert.pem и перезапускаю службу

echo $(tput setaf 2) "Копирую доступный (в Ubuntu 16.04.5 LTS) корневой сертификат в файл /etc/postfix/cacert.pem и перезапускаю службу" $(tput sgr 0)

sudo cat /etc/ssl/certs/thawte_Primary_Root_CA.pem | sudo tee -a /etc/postfix/cacert.pem

sudo service postfix restart

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Создаю тестовое сообщение и отправляю его:

echo $(tput setaf 2) "Создаю тестовое сообщение и отправляю его:" $(tput sgr 0)

echo "Hello World" | mail -s "Test Message" test@yandex.com -aFrom:123   	                           # Test замените на свой ящик  company@yandex.com -aFrom:123 (вместо 123 пароль от вашего ящика).  

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)					                           # Проверьте почту, если всё указано верно вы получите сообщение "Hello World".


# Устанавливаю все необходимое для установки rt (устанавливать буду из скаченного пакета):

echo $(tput setaf 2) "Устанавливаю все необходимое для установки rt:" $(tput sgr 0)

sudo apt-get -y install perl make

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Скачиваю установочный файл 

echo $(tput setaf 2) "Скачиваю установочный файл rt-4.4.3:" $(tput sgr 0)

cd ~ 
wget https://download.bestpractical.com/pub/rt/release/rt-4.4.3.tar.gz 	                                    # На момент написания скрипта версия rt-4.4.3 актуальна, август 2018 
                                                                                                            # но вы можете проверить наличие более новых версии. Для этого перейдите по ссылке в браузере https://download.bestpractical.com/pub/rt/release/

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Распаковываю пакет во временную директорию и перейду в нее:

echo $(tput setaf 2) "Распаковываю пакет во временную директорию и перейду в нее:" $(tput sgr 0)

sudo tar xzvf rt-4.4.3.tar.gz -C /tmp			                                                    # Если устанавливаете новую версию, измените rt-4.4.3. на устанавливаемую версию! 
cd /tmp/rt-4.4.3					                                                    # Если устанавливаете новую версию, измените rt-4.4.3. на устанавливаемую версию! 
		
echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Для подготовки пакета к установке запускаю скрипт ./configure

echo $(tput setaf 2) "Для подготовки пакета к установке запускаю скрипт ./configure" $(tput sgr 0)

sudo ./configure --with-web-user=www-data --with-web-group=www-data --enable-graphviz --enable-gd--enable-externalauth

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Теперь нужно настроить для работы CPAN:

echo $(tput setaf 2) "Теперь нужно настроить для работы CPAN:" $(tput sgr 0)
echo $(tput setaf 2) "Cкопируйте эти команды в терминал. 1-4" $(tput sgr 0)

echo $(tput setaf 2) "Would you like to configure as much as possible automatically? [Yes] yes" $(tput sgr 0)	# Скопируйте эти команды в терминал.
echo $(tput setaf 2) "cpan[1] o conf prerequisites_policy follow" $(tput sgr 0)					# Удобнее по SSH.
echo $(tput setaf 2) "cpan[2] o conf build_requires_install_policy" $(tput sgr 0)
echo $(tput setaf 2) "cpan[3] o conf commit" $(tput sgr 0)
echo $(tput setaf 2) "cpan[4] q" $(tput sgr 0)


sudo cpan

# yes

# o conf prerequisites_policy follow

# o conf build_requires_install_policy

# o conf commit

# q

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

# Для проверки готовности системы к установке запускаю тестирование и так как точно не хватает многих модулей - запускаю автоматическую подготовку системы 
# P.S. Второй шаг может длиться до получаса

echo $(tput setaf 2) "Для проверки готовности системы к установке запускаю тестирование и так как точно не хватает многих модулей - запускаю автоматическую подготовку системы" $(tput sgr 0)

sudo make testdeps

echo $(tput setaf 2) "VALIDATE PASSWORD PLUGIN can be used to test passwords
and improve security. It checks the strength of password
and allows the users to set only those passwords which are
secure enough. Would you like to setup VALIDATE PASSWORD plugin? y" $(tput sgr 0)			           # sudo make fixdeps 1 вопрос!			
echo $(tput setaf 2) "Do you want to build the XS Stash module? [y] y" $(tput sgr 0)
echo $(tput setaf 2) "Do you want to run the live tests (y/N)? [N] y" $(tput sgr 0)

sudo make fixdeps		                                                                                   # После 1 выполнения, иногда остаються ошибки. Поэтому тест будет выполнен дважды. 
sudo make fixdeps

# y

# y

# y

                        

sudo make testdeps

echo $(tput setaf 2) "Последняя сторока:" $(tput sgr 0)								    # После выполнения команды sudo make testdeps, все зависимости должны быть найдены All dependencies have been found.
echo $(tput setaf 2) "All dependencies have been found." $(tput sgr 0)

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Завершающий этап установки: запуск сценарий установки и инициализация БД (нужен пароль от mysql root из шага №2)

echo $(tput setaf 2) "Запускаю сценарий установки и инициализации БД (нужен пароль от mysql root из шага №2)" $(tput sgr 0)

sudo make install
sudo make initialize-database

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Для корректной работы веб интерфейса записываю конфигурацию в файл /etc/apache2/sites-available/000-default.conf 

echo $(tput setaf 2) "Записываю конфигурацию в файл /etc/apache2/sites-available/000-default.conf" $(tput sgr 0)

# запись в файл /etc/apache2/sites-available/000-default.conf
{
echo '<VirtualHost *:80>'
echo '        # The ServerName directive sets the request scheme, hostname and port that'
echo '        # the server uses to identify itself. This is used when creating'
echo '        # redirection URLs. In the context of virtual hosts, the ServerName'
echo '        # specifies what hostname must appear in the request is Host: header to' 		                     # В оригинале: # specifies what hostname must appear in the request's Host: header to (Не влияет на работоспособность скрипта)  
echo '        # match this virtual host. For the default virtual host (this file) this'
echo '        # value is not decisive as it is used as a last resort host regardless.'
echo '        # However, you must set it for any further virtual host explicitly.'
echo '        #ServerName www.example.com'
echo ''
echo '        ServerName rt.yandex.com'								                     # <Начало конфига>
echo '        AddDefaultCharset UTF-8'								 
echo '        DocumentRoot /opt/rt4/share/html'
echo '        Alias /NoAuth/images/ /opt/rt4/share/html/NoAuth/images/'				
echo '        ScriptAlias / /opt/rt4/sbin/rt-server.fcgi/'					
echo '        <Location />'
echo '        ## Apache version < 2.4 (e.g. Debian 7.2)'
echo '        # Order allow, deny'
echo '        # Allow from all'
echo '        ## Apache 2.4'
echo '        Require all granted'
echo '        </Location>'									                     # <Конец>
echo ''
echo '#       ServerAdmin webmaster@localhost'
echo '#       DocumentRoot /var/www/html'
echo ''
echo '        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,'
echo '        # error, crit, alert, emerg.'
echo '        # It is also possible to configure the loglevel for particular'
echo '        # modules, e.g.'
echo '        #LogLevel info ssl:warn'
echo ''
echo '        ErrorLog ${APACHE_LOG_DIR}/error.log'
echo '        CustomLog ${APACHE_LOG_DIR}/access.log combined'
echo ''
echo '        # For most configuration files from conf-available/, which are'
echo '        # enabled or disabled at a global level, it is possible to'
echo '        # include a line for only one particular virtual host. For example the'
echo '        # following line enables the CGI configuration for this host only'
echo '        # after it has been globally disabled with "a2disconf".'
echo '        #Include conf-available/serve-cgi-bin.conf'
echo '</VirtualHost>'

} > /etc/apache2/sites-available/000-default.conf

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Перезапускаю Apache2.

echo $(tput setaf 2) "Перезапускаю Apache2." $(tput sgr 0)

sudo service apache2 restart

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)


# Записываю конфигурацию в файл /opt/rt4/etc/RT_SiteConfig.pm (язык, имя сайта, адрес и имя для обращения и т.д.) и перезапукаю apahe:

echo $(tput setaf 2) "Записываю конфигурацию в файл /opt/rt4/etc/RT_SiteConfig.pm (язык, имя сайта, адрес и имя для обращения) и перезапускаю apache2:" $(tput sgr 0)

# запись в файл /opt/rt4/etc/RT_SiteConfig.pm
{
echo 'use utf8;'
echo ''
echo '# Any configuration directives you include  here will override'
echo '# RTs default configuration file, RT_Config.pm'			           # В оригинале # RT's default configuration file, RT_Config.pm (Не влияет на работоспособность скрипта)
echo ''
echo '# To include a directive here, just copy the equivalent statement'
echo '# from RT_Config.pm and change the value. Weve included a single'            # В оригинале # from RT_Config.pm and change the value. We've included a single' (Не влияет на работоспособность скрипта)
echo '# sample value below.'
echo '#'
echo '# If this file includes non-ASCII characters, it must be encoded in'
echo '# UTF-8.'
echo '#'
echo '# This file is actually a perl module, so you can include valid'
echo '# perl code, as well.'
echo '#'
echo '# The converse is also true, if this file isnt valid perl, youre'            # В оригинале: # The converse is also true, if this file isn't valid perl, you're  (Не влияет на работоспособность скрипта)
echo '# going to run into trouble. To check your SiteConfig file, use'
echo '# this command:'
echo '#'
echo '#   perl -c /path/to/your/etc/RT_SiteConfig.pm'
echo '#'
echo '# You must restart your webserver after making changes to this file.'
echo '#'
echo ''
echo '# You may also split settings into separate files under the etc/RT_SiteConfig.d/'
echo '# directory.  All files ending in ".pm" will be parsed, in alphabetical order,'
echo '# after this file is loaded.'
echo ''
echo 'Set( @LexiconLanguages, qw(en ru));'						           # Языки доступные для тикет системы.  
echo 'Set( $rtname, 'rt.test.com');'							           # Введите rt.company.com
echo 'Set( $WebDomain, 'rt.test.com');'						               # Введите rt.company.com
echo 'Set( $Organisation, 'rt.test.com');'						           # Введите rt.company.com
echo 'Set( @ReferrerWhitelist, qw(rt.test.com:80 192.x.x.x:80));'		   # Введите rt.company.com Введите ip адрес сервера вместо 192.x.x.x:80 
echo 'Set( $Timezone, 'Europe/Samara');'						           # Исправьте временную зону (если необходимо).
echo 'Set( $LogoLinkURL, 'http://rt.test.com/');'					       # Введите rt.company.com
echo ''
echo 'Set( $rtname, 'example.com');'							           # Укажите имя организации (rt.company.com)
echo ''
echo '# You must install Plugins on your own, this is only an example'
echo '# of the correct syntax to use when activating them:'
echo '#     Plugin( "RT::Authen::ExternalAuth" );'
echo ''
echo '1;'

} > /opt/rt4/etc/RT_SiteConfig.pm

sudo service apache2 restart

echo $(tput setaf 3) "Выполнено!" $(tput sgr 0)

echo $(tput setaf 3) "Установка open source тикет-системы Best Practical Solutions завершена." $(tput sgr 0)
echo $(tput setaf 3) " В браузере набираем ip в примере 192.x.x.x          вводим логин root" $(tput sgr 0)
echo $(tput setaf 3) "                                                     Пароль password " $(tput sgr 0)

# В браузере набираем ip в примере 192.x.x.x                               Вводим логин root
#                                                                          Пароль password
# и попадаем в Дашборд Best PRACTICAL.





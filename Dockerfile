FROM yuhjyechang/ubuntu-apache2
# FROM php:5.6-apache
# FROM php:7.0-apache
# FROM php:7.4-apache

ENV TZ=America/Fortaleza

RUN apt update && apt install -y apt-utils

# RUN apt install -y apache2

# Ativar https
RUN a2enmod ssl

# Permissão para o usuário do apache acessar a pasta de arquivos do protocolo
# se necessário, adcionar o usuário da máquina atual no grupo www-data
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite && service apache2 restart

RUN apt-get install software-properties-common -y

RUN add-apt-repository ppa:ondrej/php

RUN apt update

ENV DEBIAN_FRONTEND noninteractive

RUN apt install -y php5.6

# Configuração Cron
RUN apt-get update \
    && apt-get install -y \
    vim \
    curl 
    # crontab

# Instalação de libs
RUN apt update \
    && apt install -y \
    libzip-dev \
    zlib1g-dev \
    freetds-bin \
    freetds-dev \
    freetds-common \
    libct4 \
    libsybdb5 \
    tdsodbc \
    libfreetype6-dev \
    # libjpeg62-turbo-dev \s
    libmcrypt-dev \
    libldap2-dev \
    zlib1g-dev \
    libc-client-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/

# RUN apt update && apt -y install unixodbc-dev

# Instalação outras extensões do PHP
# RUN docker-php-ext-install mysqli pdo_mysql zip mssql bcmath dba dom pdo_dblib soap sysvmsg sysvsem sysvshm calendar
RUN apt update

RUN apt install -y php5.6-mbstring php5.6-mysql php5.6-zip php5.6-mssql php5.6-bcmath php5.6-dba php5.6-dom php5.6-soap php5.6-sysvmsg php5.6-sysvsem php5.6-sysvshm php5.6-calendar
# pdo-dblib

# RUN docker-php-ext-install mysqli pdo_mysql zip bcmath dba dom pdo_dblib soap sysvmsg sysvsem sysvshm calendar

# Instalar PECL
RUN apt install -y php5.6-dev

# Instalação do APCu cache
# # RUN pecl install apcu && echo extension=apcu.so > /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini
# RUN pecl install apcu-4.0.11 && echo extension=apcu.so > /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini
RUN pecl install apcu-4.0.11 && echo extension=apcu.so > /usr/lib/php/20131226/apcu.ini


# RUN apt install zip unzip wget

# RUN cp /usr/src/php/cgi/config9.m4 config.m4

# # RUN pecl install sqlsrv-5.3.0
# # RUN pecl install pdo_sqlsrv-5.3.0
# RUN pecl install sqlsrv-3.0.1 
# RUN pecl install pdo_sqlsrv-3.0.1

# Instalação do sqlsrv e pdo_sqlsrv
# RUN echo extension=pdo_sqlsrv.so > /usr/local/etc/php/conf.d/docker-php-ext-pdo-sqlsrv.ini
# RUN echo extension=sqlsrv.so > /usr/local/etc/php/conf.d/docker-php-ext-sqlsrv.ini

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
# RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ln -snf /usr/share/zoneinfo/America/Fortaleza /etc/localtime && echo America/Fortaleza > /etc/timezone
# ln -snf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && echo America/Sao_Paulo > /etc/timezone
# ln -snf /usr/share/zoneinfo/America/Cuiaba /etc/localtime && echo America/Cuiaba > /etc/timezone
#!/usr/bin/env bash
sudo dnf update -y
sudo dnf install -y php-cli phpunit composer php-fpm php-mysqlnd php-zip php-devel php-gd php-mcrypt php-mbstring php-curl php-xml php-pear php-bcmath php-json
php -v

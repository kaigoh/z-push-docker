#!/bin/bash

# Copy over the Nginx config...
if [[ -f /config/nginx.conf ]]
then
  cp /config/nginx.conf /etc/nginx/conf.d/default.conf
fi

# Copy over the PHP-FPM config...
if [[ -f /config/php-fpm.conf ]]
then
  cp /config/php-fpm.conf /etc/php7/php-fpm.conf
fi

# Copy over the Z-Push configs...
php /var/lib/z-push/docker_config_loader.php

chmod 777 -R /var/log/z-push/ /var/lib/z-push/
chown -R nginx:nobody z-push/ /var/log/z-push/ /var/lib/z-push/

php-fpm7
nginx

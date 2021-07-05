#!/bin/sh
sed -e "s/define('BACKEND_PROVIDER', '')/define('BACKEND_PROVIDER', 'BackendIMAP')/" \
    -e "s|define('TIMEZONE', '')|define('TIMEZONE', '"$MAILSERVER_TIMEZONE"')|" /usr/share/nginx/z-push/config.php.dist > /usr/share/nginx/z-push/config.php
#    -e "s|define('STATE_DIR', '/var/lib/z-push/')|define('STATE_DIR', '/state/')|" \
#    -e "s|define('LOGFILEDIR', '/var/log/z-push/')|define('LOGFILEDIR', '/data/logs/')|" \

sed -e "s/define('IMAP_SERVER', 'localhost')/define('IMAP_SERVER', '"$MAILSERVER_ADDRESS"')/" \
    -e "s/define('IMAP_PORT', 143)/define('IMAP_PORT', '"$MAILSERVER_PORT"')/" \
    -e "s|define('IMAP_OPTIONS', '/notls/norsh')|define('IMAP_OPTIONS', '/ssl/norsh/novalidate-cert')|" \
    -e "s/define('IMAP_SMTP_METHOD', 'mail')/define('IMAP_SMTP_METHOD', 'smtp')/" \
    -e "s|imap_smtp_params = array()|imap_smtp_params = array('host' => '"$MAILSERVER_PORT_SMTP_SERVER"', 'port' => '"$MAILSERVER_PORT_SMTP_PORT"', 'auth' => true, 'username' => 'imap_username', 'password' => 'imap_password', 'verify_peer_name' => false, 'verify_peer' => false, 'allow_self_signed' => true)|" \
    -e "s/define('IMAP_FOLDER_CONFIGURED', false)/define('IMAP_FOLDER_CONFIGURED', true)/" /usr/share/nginx/z-push/backend/imap/config.php.dist > /usr/share/nginx/z-push/backend/imap/config.php

sed -i "s/define('IMAP_FOLDER_PREFIX', '')/define('IMAP_FOLDER_PREFIX', '"$MAILSERVER_FOLDER_PREFIX"')/" /usr/share/nginx/z-push/backend/imap/config.php
sed -i "s/server_name  localhost;/server_name  "$SERVER_ADDRESS";/" /etc/nginx/conf.d/default.conf

chmod 777 /var/log/z-push/ /var/lib/z-push/
chown -R nginx:nobody z-push/ /var/log/z-push/ /var/lib/z-push/

php-fpm7
nginx

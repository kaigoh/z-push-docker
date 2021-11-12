FROM nginx:alpine

ENV MAILSERVER_TIMEZONE=Europe/London \
  SERVER_ADDRESS=localhost \
  MAILSERVER_FOLDER_PREFIX= \
  MAILSERVER_ADDRESS=localhost \
  MAILSERVER_PORT=143 \
  SMTPSERVER_ADDRESS=localhost \
  SMTPSERVER_PORT=587 \
  MAILSERVER_PROTOCOL=tcp:// \
  MAILSERVER_IMAP_OPTION=ssl
  
WORKDIR /usr/share/nginx
ADD start-z-push.sh .

RUN apk update && \
	apk add php7 php7-imap php7-curl php7-fpm php7-posix php7-pdo php7-mbstring php7-iconv php7-openssl php7-memcached php7-soap php7-pcntl php7-sysvshm php7-sysvsem php7-dom php7-xml php7-xmlreader php7-xmlwriter php7-simplexml php7-xsl ca-certificates && \
	rm -rf /var/cache/apk/* && \
	wget https://www.davical.org/downloads/awl_0.62.orig.tar.xz && \
	mkdir -p /usr/share/awl && \
	tar xf awl_0.62.orig.tar.xz -C /usr/share/awl && \
	wget https://github.com/Z-Hub/Z-Push/archive/refs/tags/2.6.4.beta1.tar.gz -O z-push.tar.gz && \
	tar xzf z-push.tar.gz && \
	mv Z-Push-2.6.4.beta1/src z-push && \
	rm z-push.tar.gz && \
	rm -rf Z-Push-2.6.4.beta1 && \
	mkdir -p /var/log/z-push/ /var/lib/z-push/ && \
	chmod 777 /var/log/z-push/ /var/lib/z-push/ && \
	chown -R nginx:nobody z-push/ /var/log/z-push/ /var/lib/z-push/ && \
	echo "daemon off;" >> /etc/nginx/nginx.conf && \
	chmod +x start-z-push.sh && \
	mv /usr/share/nginx/z-push/config.php /usr/share/nginx/z-push/config.php.dist && \
	mv /usr/share/nginx/z-push/backend/imap/config.php /usr/share/nginx/z-push/backend/imap/config.php.dist

ADD default.conf /etc/nginx/conf.d/
ADD php-fpm.conf /etc/php7/

EXPOSE 80

CMD "./start-z-push.sh"

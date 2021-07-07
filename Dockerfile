FROM nginx:alpine
MAINTAINER Dylan WU

ENV MAILSERVER_TIMEZONE=Asia/Shanghai \
  SERVER_ADDRESS=localhost \
  MAILSERVER_FOLDER_PREFIX= \
  MAILSERVER_ADDRESS=localhost \
  MAILSERVER_PORT=143 \
  MAILSERVER_PORT_SMTP_SERVER=localhost \
  MAILSERVER_PORT_SMTP_PORT=587 \
  MAILSERVER_PROTOCOL=tcp:// \
  MAILSERVER_IMAP_OPTION=ssl
  
WORKDIR /usr/share/nginx
ADD start-z-push.sh .

RUN apk update && \
	apk add php7 php7-imap php7-fpm php7-posix php7-pdo php7-mbstring php7-iconv ca-certificates && \
	rm -rf /var/cache/apk/* && \
	wget https://github.com/Z-Hub/Z-Push/archive/refs/tags/2.6.4.beta1.tar.gz -O z-push.tar.gz && \
	tar xzf z-push.tar.gz && \
	mv Z-Push-2.6.4.beta1/src z-push && \
	rm z-push.tar.gz && \
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

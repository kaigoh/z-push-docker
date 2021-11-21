FROM nginx:alpine

# Set the timezone
ENV TZ=Europe/London

# IMAP Variables
ENV IMAP_SERVER=localhost
ENV IMAP_PORT=143
ENV IMAP_OPTIONS='/ssl/norsh/novalidate-cert'
ENV IMAP_FOLDER_PREFIX=''
ENV IMAP_FOLDER_INBOX=INBOX
ENV IMAP_FOLDER_SENT=Sent
ENV IMAP_FOLDER_DRAFT=Drafts
ENV IMAP_FOLDER_TRASH=Trash
ENV IMAP_FOLDER_JUNK=Junk
ENV IMAP_FOLDER_ARCHIVE=Archive

# SMTP Variables
ENV SMTP_SERVER=localhost
ENV SMTP_PORT=25
ENV SMTP_USERNAME='imap_username'
ENV SMTP_PASSWORD='imap_password'

# CalDAV Variables
ENV CALDAV_PROTOCOL=https
ENV CALDAV_SERVER=localhost
ENV CALDAV_PORT=80
ENV CALDAV_PATH=/remote.php/dav/calendars/%u/
ENV CALDAV_PERSONAL=personal

# CardDAV Variables
ENV CARDDAV_PROTOCOL=https
ENV CARDDAV_SERVER=localhost
ENV CARDDAV_PORT=80
ENV CARDDAV_PATH='/remote.php/dav/addressbooks/users/%u/'
ENV CARDDAV_DEFAULT_PATH='/remote.php/dav/addressbooks/users/%u/contacts/'
ENV CARDDAV_GAL_PATH='/caldav.php/%d/GAL/'
ENV CARDDAV_GAL_MIN_LENGTH=5
ENV CARDDAV_CONTACTS_FOLDER_NAME='%u Addressbook'
  
WORKDIR /usr/share/nginx
ADD start-z-push.sh .

RUN apk update && \
	apk add bash php7 php7-imap php7-curl php7-fpm php7-posix php7-pdo php7-pdo_mysql php7-mbstring php7-iconv php7-openssl php7-memcached php7-soap php7-pcntl php7-sysvshm php7-sysvsem php7-dom php7-xml php7-xmlreader php7-xmlwriter php7-simplexml php7-xsl ca-certificates && \
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

RUN mkdir -p /config

ADD config/. /config

VOLUME [ "/config" ]

ADD docker_config_loader.php /var/lib/z-push/

EXPOSE 80

CMD "./start-z-push.sh"

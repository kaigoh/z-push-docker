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

# SQL Statemachine Variables
ENV STATE_SQL_ENGINE=mysql
ENV STATE_SQL_SERVER=localhost
ENV STATE_SQL_PORT=3306
ENV STATE_SQL_DATABASE=zpush
ENV STATE_SQL_USER=root
ENV STATE_SQL_PASSWORD=

WORKDIR /usr/share/nginx
ADD start-z-push.sh .

RUN apk update
RUN apk add bash php7 php7-imap php7-curl php7-fpm php7-posix php7-pdo php7-pdo_mysql php7-mbstring php7-iconv php7-openssl php7-memcached php7-soap php7-pcntl php7-sysvshm php7-sysvsem php7-dom php7-xml php7-xmlreader php7-xmlwriter php7-simplexml php7-xsl ca-certificates
RUN rm -rf /var/cache/apk/*
RUN wget https://www.davical.org/downloads/awl_0.62.orig.tar.xz
RUN mkdir -p /usr/share/awl
RUN tar xf awl_0.62.orig.tar.xz -C /usr/share/awl
RUN wget https://github.com/Z-Hub/Z-Push/archive/refs/tags/2.6.4.beta1.tar.gz -O z-push.tar.gz
RUN tar xzf z-push.tar.gz
RUN mv Z-Push-2.6.4.beta1/src z-push
RUN rm z-push.tar.gz
RUN rm -rf Z-Push-2.6.4.beta1
RUN mkdir -p /var/log/z-push/ /var/lib/z-push/
RUN chmod 777 /var/log/z-push/ /var/lib/z-push/
RUN chown -R nginx:nobody z-push/ /var/log/z-push/ /var/lib/z-push/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN chmod +x start-z-push.sh
RUN mv /usr/share/nginx/z-push/config.php /usr/share/nginx/z-push/config.php.dist
RUN mv /usr/share/nginx/z-push/backend/imap/config.php /usr/share/nginx/z-push/backend/imap/config.php.dist
RUN mkdir -p /config
RUN mkdir -p /opt/z-push

VOLUME [ "/config", "/var/lib/z-push/", "/var/log/z-push/" ]

ADD config/. /config

ADD docker_config_loader.php /opt/z-push/

EXPOSE 80

CMD "./start-z-push.sh"

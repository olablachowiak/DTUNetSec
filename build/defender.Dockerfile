FROM alpine:latest

RUN apk update --update-cache
RUN apk add --no-cache \
  curl \
  tar \
  libc6-compat \
  bash \
  sudo \
  netcat-openbsd \
  # Security tools
  iputils \
  iptables \
  suricata \
  # SSH
  openssh \
  openssh-server \
  # HTTP
  apache2 \
  php php-apache2 php-common php-session \
  # Supervisor
  supervisor \
  && rm -rf /var/cache/apk/*

RUN curl -L https://github.com/CISOfy/lynis/archive/refs/heads/master.tar.gz -o lynis.tar.gz && \
  tar -xzvf lynis.tar.gz && \
  mv lynis-master /opt/lynis && \
  rm lynis.tar.gz

RUN ssh-keygen -A && \
  adduser -D defender && \
  echo "defender:defender" | chpasswd

# HTTP
ADD defender/httpd/ /var/www/localhost/htdocs/
RUN echo "LoadModule php_module modules/mod_php8.so" >> /etc/apache2/httpd.conf
RUN echo "AddHandler php-script .php" >> /etc/apache2/httpd.conf
RUN sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/apache2/httpd.conf
RUN chmod 755 /var/www/localhost/htdocs/

# Supervisor
RUN mkdir -p /etc/supervisor/conf.d
RUN /usr/bin/echo_supervisord_conf > /etc/supervisor/supervisord.conf
RUN sed -i -e "s/^nodaemon=false/nodaemon=true/" /etc/supervisor/supervisord.conf

ADD defender/supervisor/ /etc/supervisor/conf.d/
RUN echo "[include]" >> /etc/supervisor/supervisord.conf
RUN echo "files=/etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf

# Expose ports (Note: this does nothing)
EXPOSE 22 80

ENTRYPOINT ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

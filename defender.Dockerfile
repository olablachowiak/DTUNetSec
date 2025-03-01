FROM alpine:3.11

RUN apk update --update-cache && \
  apk add --no-cache \
  bash \
  sudo \
  # IP stuff
  iputils \
  iptables \
  # SSH
  openssh \
  openssh-server \
  # HTTP
  apache2 \
  php php-apache2 php-common php-session \
  # Supervisor
  supervisor  

RUN ssh-keygen -A && \
  adduser -D defender && \
  echo "defender:defender" | chpasswd

# HTTP
ADD defender/httpd/ /var/www/localhost/htdocs/
RUN echo "LoadModule php7_module modules/mod_php7.so" >> /etc/apache2/httpd.conf
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

FROM alpine:latest

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update --update-cache

RUN apk add --no-cache \
    sudo \
    bash \
    # MQTT
    mosquitto \
    # CoAP
    libcoap \
    # SSH
    openssh \
    openssh-server \
    # IPP
    cups \
    # FTP
    vsftpd \
    # Supervisor
    supervisor \
    && rm -rf /var/cache/apk/*

USER root

# SSH
RUN ssh-keygen -A && \
    passwd -d root
COPY containers/iot/sshd/sshd_config /etc/ssh/sshd_config
RUN chmod +rwx /etc/ssh/sshd_config

# FTP 
COPY containers/iot/vsftpd/vsftpd.conf /etc/vsftpd.conf
RUN sed -i 's,\r,,;s, *$,,' /etc/vsftpd.conf
ADD containers/iot/vsftpd/secret.txt /secret.txt

# Mosquitto
ADD containers/iot/mosquitto/mosquitto.conf /var/conf/mosquitto.conf

# CUPS
COPY containers/iot/cups/cupsd.conf /etc/cups/cupsd.conf
RUN sed -i 's/^#FileDevice No/FileDevice Yes/' /etc/cups/cups-files.conf


# Supervisor
RUN mkdir -p /etc/supervisor/conf.d
RUN /usr/bin/echo_supervisord_conf > /etc/supervisor/supervisord.conf
RUN sed -i -e "s/^nodaemon=false/nodaemon=true/" /etc/supervisor/supervisord.conf

ADD containers/iot/supervisor/ /etc/supervisor/conf.d/
RUN echo "[include]" >> /etc/supervisor/supervisord.conf
RUN echo "files=/etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf

COPY containers/iot/post.sh /post.sh
RUN chmod +x /post.sh

ENTRYPOINT ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

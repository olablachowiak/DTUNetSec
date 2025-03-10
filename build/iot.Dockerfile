FROM alpine:latest

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v3.10/main" >> /etc/apk/repositories && \
    apk update --update-cache

# Install specific vulnerable package versions
RUN apk add --no-cache --force-overwrite \
    mosquitto=1.6.3-r0 \
    vsftpd=3.0.3-r6 \
    openssh=8.1_p1-r0 \
    openssh-server=8.1_p1-r0 \
    cups=2.2.12-r1 \
    busybox-extras=1.30.1-r5 \
    live-media \
    live-media-utils

RUN apk add --no-cache \
    sudo \
    bash \
    # CoAP
    libcoap \
    # Supervisor
    supervisor \
    && rm -rf /var/cache/apk/*

USER root

# SSH
RUN ssh-keygen -A && \
    passwd -d root
COPY containers/iot/sshd/sshd_config /etc/ssh/sshd_config
RUN chmod +rwx /etc/ssh/sshd_config
RUN echo "pts/0" >> /etc/securetty

# FTP 
COPY containers/iot/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN sed -i 's,\r,,;s, *$,,' /etc/vsftpd/vsftpd.conf
ADD containers/iot/vsftpd/secret.txt /secret.txt

# Mosquitto
ADD containers/iot/mosquitto/mosquitto.conf /etc/mosquitto/mosquitto.conf

# Telnet
ADD containers/iot/inetd/inetd.conf /etc/inetd/inetd.conf


# CUPS
COPY containers/iot/cups/cupsd.conf /etc/cups/cupsd.conf
RUN sed -i 's/^#FileDevice No/FileDevice Yes/' /etc/cups/cups-files.conf

# Supervisor
RUN mkdir -p /etc/supervisor/conf.d /var/log/supervisor
ADD containers/iot/supervisor/ /etc/supervisor/conf.d/
ADD containers/iot/supervisord.conf /etc/supervisor/supervisord.conf

COPY containers/iot/post.sh /post.sh
RUN chmod +x /post.sh

ENTRYPOINT ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

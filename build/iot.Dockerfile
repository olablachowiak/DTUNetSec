FROM alpine:latest

RUN apk update --update-cache
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
    # FTP
    lftp \
    # IPP
    ipptool \
    # RTSP
    gst-rtsp-server \
    # Supervisor
    supervisor \
    && rm -rf /var/cache/apk/*

# SSH
RUN ssh-keygen -A && \
  adduser -D iot && \
  echo "iot:iot" | chpasswd






# Supervisor
RUN mkdir -p /etc/supervisor/conf.d
RUN /usr/bin/echo_supervisord_conf > /etc/supervisor/supervisord.conf
RUN sed -i -e "s/^nodaemon=false/nodaemon=true/" /etc/supervisor/supervisord.conf

ADD iot/supervisor/ /etc/supervisor/conf.d/
RUN echo "[include]" >> /etc/supervisor/supervisord.conf
RUN echo "files=/etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf

ENTRYPOINT ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
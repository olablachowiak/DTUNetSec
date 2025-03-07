FROM alpine:latest

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update --update-cache
RUN apk add --no-cache \
    sudo \
    bash \
    mosquitto \
    libcoap \
    openssh \
    openssh-server \
    lftp \
    ipptool \
    gst-rtsp-server \
    supervisor \
    && rm -rf /var/cache/apk/*

# Creating anonymous user
RUN ssh-keygen -A && \
    adduser -D -s /bin/bash anonymous && \
    passwd -d anonymous

# Set up SSH for anonymous user
RUN mkdir -p /home/anonymous/.ssh && \
    chmod 700 /home/anonymous/.ssh && \
    chown anonymous:anonymous /home/anonymous/.ssh

# Copy custom sshd_config
COPY iot/config_files/sshd_config /etc/ssh/sshd_config

# Ensure correct permissions for sshd_config
RUN chmod 644 /etc/ssh/sshd_config

# Supervisor configuration
RUN mkdir -p /etc/supervisor/conf.d
RUN /usr/bin/echo_supervisord_conf > /etc/supervisor/supervisord.conf
RUN sed -i -e "s/^nodaemon=false/nodaemon=true/" /etc/supervisor/supervisord.conf

# Copy supervisor configuration files
COPY iot/supervisor/ /etc/supervisor/conf.d/
RUN echo "[include]" >> /etc/supervisor/supervisord.conf
RUN echo "files=/etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf

EXPOSE 22

ENTRYPOINT ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

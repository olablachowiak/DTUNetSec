FROM alpine

RUN apk update && apk add --no-cache \
  openssh python3 iptables bash sudo iputils && \
  ssh-keygen -A && \
  adduser -D defender && echo "defender:defender" | chpasswd && \
  mkdir -p /var/www && \
  echo "Welcome to the Defender HTTP Server" > /var/www/index.html

EXPOSE 22 8080

RUN /usr/sbin/sshd -D &

WORKDIR /var/www

CMD ["python3", "-m", "http.server", "8080"]

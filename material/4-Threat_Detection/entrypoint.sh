#!/bin/sh

/usr/sbin/sshd -D &

cd /var/www

# Simple python http server
python3 -m http.server 8080
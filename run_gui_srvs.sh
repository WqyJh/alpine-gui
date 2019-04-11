#!/bin/sh

DISPLAY=:1
USER=`whoami`

setup() {
    sudo apk add xvfb x11vnc supervisor xfce4 xfce4-terminal faenza-icon-theme 

    cat << EOF | sudo tee /etc/supervisord.conf
[supervisord]
nodaemon=true

[program:xvfb]
command=/usr/bin/Xvfb $DISPLAY -screen 0 1920x1080x24
autorestart=true
user=$USER
priority=100

[program:x11vnc]
command=/usr/bin/x11vnc -xkb -noxrecord -noxfixes -noxdamage -display $DISPLAY -nopw -wait 5 -shared -permitfiletransfer -tightfilexfer
user=$USER
autorestart=true
priority=200

[program:xfce4]
environment=HOME="/home/$USER",DISPLAY="$DISPLAY",USER="$USER"
command=/usr/bin/startxfce4
user=$USER
autorestart=true
priority=400
EOF
}

start() {
    sudo /usr/bin/supervisord -c /etc/supervisord.conf
}

help() {
    echo "Usage:"
    echo "$0 setup: Install the vnc and desktop environment"
    echo "$0 start: Run desktop environment, then users can connect via vnc"
}


case "$1" in
	start)
        start
        ;;
    setup)
        setup
        ;;
    *)
        help
        ;;
esac

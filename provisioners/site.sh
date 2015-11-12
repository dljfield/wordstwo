#!/usr/bin/env bash

echo -e "\033[0;32m >>> Setting up site"

cat <<EOF > /etc/nginx/sites-available/wordstwo
server {
    listen 80;
    listen [::]:80 ipv6only=on;

    root /var/www/wordstwo/public;
    index index.html index.htm;

    server_name wordstwo.dev;

    location / {
        try_files \$uri \$uri/ =404;
    }

    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
EOF

ln -s /etc/nginx/sites-available/wordstwo /etc/nginx/sites-enabled/wordstwo

sudo service nginx reload

#!/bin/bash
function laravel(){
    mkdir -p /data/www/$1.jingyi-good.com 
    cd /data/www/$1.jingyi-good.com
    rm -rf $2
    composer create-project --prefer-dist laravel/$2
    cd $2
    if [ "$2" == "lumen" ];then
    lumen_cfg $1
    else
    laravel_cfg $1
    fi
    composer dump-autoload
    cd 
    nginx_cfg $1 $2
}
function lumen_cfg(){
    chmod -R 777 storage
    sed -i 's/UTC/Asia\/Shanghai\nAPP_ID=wxa02ce99b50401101\nAPP_SECRET=5c9e00d42a74132b5f153c49c8f32be6/g' .env
    sed -i 's/DB_DATABASE=homestead/DB_DATABASE='$1'/g' .env
    sed -i 's/DB_USERNAME=homestead/DB_USERNAME=root/g' .env
    sed -i 's/DB_PASSWORD=secret/DB_PASSWORD=jinjun123/g' .env 
}
function laravel_cfg(){
    chmod -R 777 storage
    chmod -R 777 bootstrap/cache
    sed -i 's/utf8mb4/utf8/g' config/database.php
    sed -i 's/DB_DATABASE=homestead/DB_DATABASE='$1'/g' .env
    sed -i 's/DB_USERNAME=homestead/DB_USERNAME=root/g' .env
    sed -i 's/DB_PASSWORD=secret/DB_PASSWORD=jinjun123/g' .env        
    sed -i 's/PUSHER_APP_SECRET=/PUSHER_APP_SECRET=\nAPP_ID=wxa02ce99b50401101\nAPP_SECRET=5c9e00d42a74132b5f153c49c8f32be6/g' .env
    sed -i 's/UTC/Asia\/Shanghai/g' config/app.php
}
function nginx_cfg(){
    cat >/etc/nginx/conf.d/$1.jingyi-good.com.conf <<EOF
server {
    listen   80;
    server_name  $1.jingyi-good.com;

    # note that these lines are originally from the "location /" block
    root   /data/www/$1.jingyi-good.com/$2/public;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_pass unix:/var/run/php-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF
systemctl restart nginx
}
laravel bee lumen
laravel soup laravel
sudo /root/certbot-auto --nginx
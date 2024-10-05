apt-get update && apt-get install -y curl

    sudo -u vagrant docker --version
    if [[ ! $? -eq 0 ]]; then
        sudo -u vagrant curl -fsSL https://get.docker.com -o install-docker.sh
        sh install-docker.sh

        groupadd docker
        usermod -aG docker vagrant
    fi
    sudo -u vagrant docker --version

    ip a | grep "inet "

docker network create --driver bridge RED_INTERNA

    docker run -d --name mariadb_cont --network RED_INTERNA -e MYSQL_ROOT_PASSWORD=maria_db -e MYSQL_USER=pepe -e MYSQL_PASSWORD=despliegue mariadb:latest 

    sudo mkdir /php-apache && sudo touch /php-apache/info.php
    sudo chmod -R o+rw /php-apache
    echo "<?php phpinfo(); ?>" >> /php-apache/info.php

    docker run -d --name apache_cont --network RED_INTERNA -v /php-apache:/var/www/html -p 80:80 php:apache 

    docker run -d --name phpmyadmin_cont --network RED_INTERNA -e PMA_HOST=mariadb_cont -p 8080:80 phpmyadmin/phpmyadmin 
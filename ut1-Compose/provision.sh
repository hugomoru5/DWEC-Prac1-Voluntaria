apt-get update && apt-get install -y curl

    sudo -u vagrant docker --version
    if [[ ! $? -eq 0 ]]; then
        sudo -u vagrant curl -fsSL https://get.docker.com -o install-docker.sh
        sh install-docker.sh

        sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose

        groupadd docker
        usermod -aG docker vagrant
    fi
    sudo -u vagrant docker --version
    docker-compose --version

    ip a | grep "inet "

    sudo mkdir /php-apache && sudo touch /php-apache/info.php
    sudo chmod -R o+rw /php-apache
    echo "<?php phpinfo(); ?>" >> /php-apache/info.php

    cd /vagrant && sudo docker-compose up -d
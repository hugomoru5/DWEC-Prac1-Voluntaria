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

    docker run -d \                         #Inicia el contenedor
    --name mariadb_cont \                   #Lo nombra
    --network RED_INTERNA \                 #Le asigna la red interna creada
    -e MYSQL_ROOT_PASSWORD=maria_db \       #Le asigna la contraseña de root
    -e MYSQL_USER=pepe \                    #Asigna el usuario
    -e MYSQL_PASSWORD=despliegue \          #Asigna la contraseña
    mariadb:latest                          #Selecciona la última version del contenedor de mariadb

    sudo mkdir /php-apache && sudo touch /php-apache/info.php
    sudo chmod -R o+rw /php-apache
    echo "<?php phpinfo(); ?>" > php-apache/info.php

    docker run -d \                         #Inicia el contenedor
    --name apache_cont \                    #Lo nombra
    --network RED_INTERNA \                 #Le asigna la red interna creada
    -v /php-apache:/var/www/html \          #Asigna la carpeta local al directorio del contenedor
    -p 80:80 \                              #Mapea el puerto 80 del contenedor al de la máquina virtual
    php:apache                              #Descarga y selecciona la imagen de php apache (última versión)

    docker run -d \                         #Inicia el contenedor
    --name phpmyadmin_cont \                #Lo nombra
    --network RED_INTERNA \                 #Le asigna la red interna creada
    -e PMA_HOST=mariadb_cont \              #Asigna a la variable interna PMA_HOST el nombre del servidor de bases de datos
    -p 8080:80 \                            #Asigna el puerto 8080 de la máquina virtual al puerto 80 del contenedor
    phpmyadmin/phpmyadmin                   #Selecciona y descarga la última versión de phpmyadmin si no existe en el Docker local
# DEAPW - Introducción a Docker Compose, Hugo Moruno

## Índice

1. [Requisitos](#lista-de-requisitos)
2. [Ejercicio](#base-del-ejercicio)


## Lista de requisitos 

[-> Índice](#índice)

- [x] Conseguir que toda la estructura de [el ejercicio anterior](../ut1-Docker/README.md) se monte con vagrant usando docker-compose.yml.

## Ejercicio 

[-> Índice](#índice)

*Vagrant y VirtualBox*

#### Requisitos del ejercicio

- Máquina con Windows 10 o superior.
- Conexión a internet.
- Instalación de Vagrant 2.x.x.
- Instalación de VirtualBox 7.0.x (Las distribuciones de 7.1.x no soportan vagrant; 6/10/2024).

#### Pasos

- Una vez hecho todo lo anterior, comenzaremos creando una máquina virtual genérica con el sistema debian12 (6/10/2024; v4.3.12 [Vagrant box debian12](https://app.vagrantup.com/generic/boxes/debian12)) basado en la versión del núcleo de Linux: 6.1.0-17-amd64

    - Para ello abriremos una terminal en powershell y nos situamos en la carpeta que deseemos.
    - Una vez situados, ejecutaremos el siguiente comando:

        ```powershell
        vagrant init generic/debian12
        ```

    ##### vagrantfile

    - Debemos comprobar que se nos ha creado el archivo *vagrantfile* sin extensión.
    - Una vez creado, sustituiremos todo su contenido por el siguiente:

    ```ruby
    Vagrant.configure("2") do |config|
    config.vm.box = "generic/debian12"  #Selecciona y descarga la última versión de debian12
    config.vm.synced_folder "./vmfiles", "/vagrant" #Monta el volúmen de la MV en el directorio del contenedor
    config.vm.provision "shell", path: "provision.sh" #Ejecuta el contenido del archivo provision.sh en la máquina recién creada
    config.vm.network "forwarded_port", guest: 80, host: 8080 #Mapeo del puerto 80 (puerto para acceder a php-apache desde el mundo).
    config.vm.network "forwarded_port", guest: 8080, host: 4430 #Mapeo del puerto 8080 (puerto para acceder a phpMyAdmin desde el mundo).
    end
    ```

    - Ahora, crearemos el archivo provision.sh e introduciremos el siguiente contenido:

    ```bash
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
    ```

    - El archivo anterior es una versión del archivo cedido por el profesor en: [Apuntes luiscastelar github](https://github.com/luiscastelar/clases24_25/blob/main/comun/docker.md#preparaci%C3%B3n-para-aula)

    - En la carpeta donde hayamos creado ambos archivos, creamos el directorio:

        ```powershell
        mkdir vmfiles 
        ```

    - Dentro del directorio, creamos el archivo: /vmfiles/docker-compose.yml

    - En el archivo anterior copiamos el siguiente contenido:

    ```yml
    name: ut1compose
    services:
        mariadb:
            container_name: mariadb_cont
            networks:
                - RED_INTERNA
            environment:
                - MYSQL_ROOT_PASSWORD=maria_db
                - MYSQL_USER=pepe
                - MYSQL_PASSWORD=despliegue
            image: mariadb:latest
        php:
            container_name: apache_cont
            networks:
                - RED_INTERNA
            volumes:
                - /php-apache:/var/www/html
            ports:
                - 80:80
            image: php:apache
        phpmyadmin:
            container_name: phpmyadmin_cont
            networks:
                - RED_INTERNA
            environment:
                - PMA_HOST=mariadb_cont
            ports:
                - 8080:80
            image: phpmyadmin/phpmyadmin
    networks:
        RED_INTERNA:
            name: RED_INTERNA
    ```

    - Una vez hechos todos los pasos, nos debería crear una estructura tal que:

        [carpeta]  
        |  
        |---- /vmfiles  
        |     |  
        |     |---- docker-compose.yml  
        |  
        |---- vagranfile  
        |  
        |---- provision.sh  

    - Habiendo comprobado que la estructura sea la anterior y que todos los archivos contengan el contenido dado, entonces, ejecutamos el comando:

        ```powershell
        vagrant up
        ```

    - Deberías obtener una salida por consola parecida a la siguiente: [Vagrant up Compose Console](./documents/vagrant-up.txt)

    Comprobar que se haya ejecutado correctamente con los siguiente comandos:  
    - Comprobar máquina virtual:
            ```
            vagrant global status
            ```  

    - Entonces aparecerá la máquina creada y el hash correspondiente.  
    - Entrar en la máquina usando:
            ```
                vagrant ssh (reemplazar por el código/hash).
            ```

    - Una vez dentro, ejecutar el siguiente comando:
            ```
                docker stats
            ```

    - Una vez ejecutado te saldrá el estado de los contenedores instalados.
    - Como comprobación final, en la máquina windows donde se aloja todo, ve a un buscador e introduce: http://localhost:8080/info.php y debería aparecer toda la información del contenedor de apache.
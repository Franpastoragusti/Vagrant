#instalaciones requeridas
sudo apt-get -y update

# Instalación de  Apache

sudo apt-get -y install apache2

# Instalación de Git

sudo apt-get -y install git

# Instalación de MySQL, rellenando el prompt y asignando password a root

sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server libapache2-mod-auth-mysql php5-mysql

# Instalación de PHP
sudo apt-get -y install php5 libapache2-mod-php5 php5-mcrypt

#Borramos posibles carpetas con el mismo nombre y la creada por apache
sudo rm -rf /var/www/servidor
sudo rm -rf /var/www/index.html

#Clonamos el proyecto de servidor
git clone https://github.com/Franpastoragusti/Gestor-FCT /var/www/servidor

#Cambiamos a la rama que toca
cd /var/www/servidor	
git checkout 3dSistemas

#Añadimos el .conf del proyecto
sudo chmod 774 /etc/apache2/sites-available/
sudo chgrp vagrant /etc/apache2/sites-available/
sudo echo "<VirtualHost *:80>
    ServerAdmin fran@mail.com
	ServerName gestorfct.com
	ServerAlias www.gestorfct.com
    DocumentRoot /var/www/servidor/web

    <Directory /var/www/servidor/web>
        AllowOverride All
        Order Allow,Deny
        Allow from All
        <IfModule mod_rewrite.c>
            Options -MultiViews
            RewriteEngine On
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteRule ^(.*)$ app.php [QSA,L]
        </IfModule>
    </Directory>

    ErrorLog /var/log/apache2/myproj_error.log
    CustomLog /var/log/apache2/myproj_access.log combined
</VirtualHost>
" >> /etc/apache2/sites-available/servidor.conf

#activamos los host virtuales
cd /etc/apache2/sites-available/
sudo a2ensite servidor.conf
sudo a2dissite default
sudo a2enmod rewrite
sudo service apache2 reload

#instalamos composer para el proyecto de symfony
cd /var/www/servidor
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '61069fe8c6436a4468d0371454cf38a812e451a14ab1691543f25a9627b97ff96d8753d92a00654c21e2212a5ae1ff36') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

#instalamos las dependencias del proyecto via composer
composer install 
#cambiamos los parametros de la configuracion de base de datos en symfony
sudo echo "# This file is auto-generated during the composer install
parameters:
    database_host: 127.0.0.1
    database_port: null
    database_name: projectserver
    database_user: root
    database_password: root
    mailer_transport: smtp
    mailer_host: 127.0.0.1
    mailer_user: null
    mailer_password: null
    secret: ThisTokenIsNotSoSecretChangeIt
" > /var/www/servidor/app/config/parameters.yml && cd /var/www/servidor
#creamos la bbdd
php bin/console doctrine:database:create

#iniciamos el servicio
php bin/console server:run
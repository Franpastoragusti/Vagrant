#instalaciones requeridas
sudo apt-get -y update

# Instalación de  Apache

sudo apt-get -y install apache2

# Instalación de MySQL, rellenando el prompt y asignando password a root

sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server libapache2-mod-auth-mysql php5-mysql

# Instalación de PHP
sudo apt-get -y install php5 libapache2-mod-php5 php5-mcrypt

# Instalación de Wordpress
rm -rf /var/www/wordpress
rm -rf /var/www/index.php
cd /var/www
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz 
rm -rf /var/www/latest.tar.gz

SQL_HOST=localhost
SQL_USER="root"
SQL_PASSWORD="root"
####Montamos los parametros de conexión.
SQL_ARGS="-u $SQL_USER -p$SQL_PASSWORD -s -e"
#### Montamos la sentencia SQL y la lanzamos
mysql $SQL_ARGS "CREATE DATABASE wordpress;"
mysql $SQL_ARGS "CREATE USER wordpressuser@localhost;"
mysql $SQL_ARGS "SET PASSWORD FOR wordpressuser@localhost= PASSWORD('123456');"
mysql $SQL_ARGS "GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED BY '123456';"
mysql $SQL_ARGS "FLUSH PRIVILEGES;"

cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php

sed -i -e 's/database_name_here/wordpress/g'  /var/www/wordpress/wp-config.php
sed -i -e 's/username_here/wordpressuser/g'  /var/www/wordpress/wp-config.php
sed -i -e 's/password_here/123456/g'  /var/www/wordpress/wp-config.php

sudo chown wordpressuser:www-data /var/www -R 
sudo chmod g+w /var/www -R 


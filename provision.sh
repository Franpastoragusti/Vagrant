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
cd /var/www
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz 

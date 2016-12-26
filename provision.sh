#instalaciones requeridas
apt-get -y update
sudo apt-get -y install apache2
sudo apt-get -y install git

#borramos posibles carpetas con el mismo nombre y la creada por apache
sudo rm -rf /var/www/sitio1
sudo rm -rf /var/www/sitio2
sudo rm -rf /var/www/index.html
#clonar las paginas de ejemplo
git clone https://github.com/Franpastoragusti/sitio1.git /var/www/sitio1
git clone https://github.com/Franpastoragusti/sitio2.git /var/www/sitio2

#movemos los archivos de configuracion al apache
sudo mv /var/www/sitio1/sitio1.conf /etc/apache2/sites-available/sitio1.conf
sudo mv /var/www/sitio2/sitio2.conf /etc/apache2/sites-available/sitio2.conf

cd /etc/apache2/sites-available/
sudo a2ensite sitio1.conf
sudo a2ensite sitio2.conf
sudo a2dissite default
sudo service apache2 reload
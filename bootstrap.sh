
#!/usr/bin/env bash

DBNAME=wordpress_db
DBUSER=keepcoding
DBPASSWD=keepcoding

apt-get update

debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"


#  intall wordpress, php, mysql y admin interface
sudo apt-get update
sudo apt-get -y install wordpress php libapache2-mod-php mysql-server php-mysql 

# crear DB
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'%' identified by '$DBPASSWD'"
mysql -uroot -p$DBPASSWD -e "FLUSH PRIVILEGES"

# update mysql conf file to allow remote access to the db
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart

#Instalación apache
apt-get -y install apache2 php-curl php-gd php-mysql php-gettext 
#a2enmod rewrite

#Configuración apache
cat > /etc/apache2/sites-available/wordpress.conf <<EOF
Alias /blog /usr/share/wordpress
<Directory /usr/share/wordpress>
    Options FollowSymLinks
    AllowOverride Limit Options FileInfo
    DirectoryIndex index.php
    Order allow,deny
    Allow from all
</Directory>
<Directory /usr/share/wordpress/wp-content>
    Options FollowSymLinks
    Order allow,deny
    Allow from all
</Directory>
EOF


sudo service apache2 reload -y

sudo service apache2 restart

sudo touch /usr/share/wordpress/wp-content/debug.log

# Configurar Wordpress para que use la DB
cat > /etc/wordpress/config-10.0.15.30.php <<EOF
<?php
define('DB_NAME', '$DBNAME');
define('DB_USER', '$DBUSER');
define('DB_PASSWORD', '$DBPASSWD');
define('DB_HOST', '10.0.15.30');
define('DB_COLLATE', 'utf8_general_ci');
define('WP_CONTENT_DIR', '/usr/share/wordpress/wp-content');
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);
?>
EOF

sudo a2ensite wordpress
sudo service apache2 reload -y
sudo service mysql start -y

# Instalar Filebeat
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install -y filebeat

# Deshabilitar el output de elasticsearch y habilitando el del logstach:
sudo rm /etc/filebeat/filebeat.yml
sudo cp /vagrant/filebeat.yml /etc/filebeat

# load the  index template into Elasticsearch manually:
sudo filebeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["10.0.15.31:9201"]'
sudo filebeat setup -e -E output.logstash.enabled=false -E output.elasticsearch.hosts=['10.0.15.31:9201'] -E setup.kibana.host=10.0.15.31:5601

sudo filebeat modules enable apache mysql system

sudo systemctl start filebeat
sudo systemctl enable filebeat


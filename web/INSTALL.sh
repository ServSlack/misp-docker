#!/bin/sh
#
# Install Postfix anf Other Required Packages
#sudo apt update && apt upgrade -qy 
sudo apt install sudo systemctl locales postfix mailutils curl gcc git gpg-agent make libcaca-dev liblua5.4-dev \
python3 openssl redis-server vim zip unzip virtualenv libfuzzy-dev sqlite3 moreutils python3-dev python3-pip \
libxml2-dev libxslt1-dev zlib1g-dev python-setuptools openssl cmake iputils-ping vim sudo wget screen pv \
lsb-release curl apt-transport-https mysql-client apache2 apache2-doc apache2-utils -qy
#
sudo -E apt install software-properties-common -qy
#sudo -E DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.11 python3.10-venv python3 python3-pip -y
#
# Install PHP 7.4 and required PHP modules;
#sudo apt install software-properties-common -qy
sudo -E add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install -qy php7.4 libapache2-mod-php7.4 php7.4 php7.4-cli php7.4-dev php7.4-json php7.4-xml php7.4-mysql php7.4-opcache \
php7.4-readline php7.4-mbstring php7.4-zip php7.4-redis php7.4-gnupg php7.4-intl php7.4-bcmath php7.4-gd php7.4-curl php7.4-apcu
#
#sudo apt install php8.2 libapache2-mod-php8.2 -y
sudo a2enmod php7.4
sudo update-alternatives --set php /usr/bin/php7.4
#
# Next, update the following PHP configuration options;
sudo sed -i 's/^\(upload_max_filesize\) = .*$/\1 = 150M/g' /etc/php/7.4/apache2/php.ini
sudo sed -i 's/^\(post_max_size\) = .*$/\1 = 50M/g' /etc/php/7.4/apache2/php.ini
sudo sed -i 's/^\(max_execution_time\) = .*$/\1 = 300/g' /etc/php/7.4/apache2/php.ini
sudo sed -i 's/^\(memory_limit\) = .*$/\1 = 8196M/g' /etc/php/7.4/apache2/php.ini
sudo sed -i 's/^\(session\.sid_length\) = .*$/\1 = 32/g' /etc/php/7.4/apache2/php.ini
sudo sed -i 's/^\(session\.use_strict_mode\) = .*$/\1 = 1/g' /etc/php/7.4/apache2/php.ini
sudo sed -i 's/^\(session\.save_handler\) = .*$/\1 = redis/g' /etc/php/7.4/apache2/php.ini
sudo sed -i '0,/.*session.save_path.*/s/.*session.save_path.*/session.save_path = "tcp:'\\/''\\/'localhost:6379?database=13"/' /etc/php/7.4/apache2/php.ini
#
expose_php=Off
display_errors=Off
#
# Enable ssdeep, rdkafka, brotli, redis and simdjson
sudo -E pecl channel-update pecl.php.net
sudo cp "/usr/lib/$(gcc -dumpmachine)"/libfuzzy.* /usr/lib && sudo pecl install ssdeep && sudo printf "autodetect\n" | sudo pecl install rdkafka
cd /tmp/
sudo git clone --recursive --depth=1 https://github.com/kjdev/php-ext-brotli.git && cd php-ext-brotli && sudo phpize && sudo ./configure && sudo make && sudo make install
#
echo "############# SIMDJSON INSTALLATION #####################" && sleep 2 
sudo -E pecl channel-update pecl.php.net
sudo -E pecl install simdjson
echo "############# END SIMDJSON INSTALLATION #####################" && sleep 2
#
sudo cp /usr/lib/php/20190902/ssdeep.so /usr/lib/php/7.4/ssdeep.so
sudo cp /usr/lib/php/20190902/rdkafka.so /usr/lib/php/7.4/rdkafka.so
sudo cp /usr/lib/php/20190902/brotli.so /usr/lib/php/7.4/brotli.so
sudo cp /usr/lib/php/20190902/simdjson.so /usr/lib/php/7.4/simdjson.so
sudo sh -c 'for dir in /etc/php/*; do echo "extension=rdkafka.so" > "$dir/mods-available/rdkafka.ini"; done; phpenmod rdkafka'
sudo sh -c 'for dir in /etc/php/*; do echo "extension=brotli.so" > "$dir/mods-available/brotli.ini"; done ;phpenmod brotli'
sudo sh -c 'for dir in /etc/php/*; do echo "extension=ssdeep.so" > "$dir/mods-available/ssdeep.ini"; done ;phpenmod redis ;phpenmod ssdeep'
sudo sh -c 'for dir in /etc/php/*; do echo "extension=simdjson.so" > "$dir/mods-available/simdjson.ini"; done ;phpenmod simdjson'
#
# Configure TIMEZONE
export TIMEZONE=America/Sao_Paulo
sudo ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime &&sudo echo $TIMEZONE > /etc/timezone
DEBIAN_FRONTEND=noninteractive apt install  tzdata -qy
#sudo DEBIAN_FRONTEND=noninteractive apt install  tzdata -qy
#
# Create 
sudo mkdir ${PATH_TO_MISP}
sudo chown $WWW_USER:$WWW_USER ${PATH_TO_MISP}
#
# Clone the MISP Core Github repository into the directory above;
cd ${PATH_TO_MISP}
${SUDO_WWW} git clone https://github.com/MISP/MISP.git ${PATH_TO_MISP}
${SUDO_WWW} git submodule update --init --recursive
${SUDO_WWW} git submodule foreach --recursive git config core.filemode false
${SUDO_WWW} git config core.filemode false
#
# Create a python3 virtualenv
${SUDO_WWW} python3 -m venv ${PATH_TO_MISP}/venv
#
# mkdir /var/www/.cache/
sudo mkdir /var/www/.cache/
sudo chown $WWW_USER:$WWW_USER /var/www/.cache
#
# Create the necessary links and cache to the just installed libraries;
sudo ldconfig
#
# Install required PHP packages for Supervisor 
cd /var/www/MISP/app
#
sudo printf "y\n" | sudo -E -u www-data php composer.phar require --with-all-dependencies lstrojny/fxmlrpc guzzlehttp/guzzle php-http/message jakub-onderka/openid-connect-php aws/aws-sdk-php elasticsearch/elasticsearch supervisorphp/supervisor php-http/message-factory bacon/bacon-qr-code spomky-labs/otphp
#
#sudo printf "y\n" | sudo -E -u www-data php composer.phar require --with-all-dependencies lstrojny/fxmlrpc guzzlehttp/guzzle psr/http-factory jakub-onderka/openid-connect-php aws/aws-sdk-php elasticsearch/elasticsearch supervisorphp/supervisor php-http/message-factory bacon/bacon-qr-code spomky-labs/otphp
#
cd ${PATH_TO_MISP}/app/files/scripts
${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install wheel
#
cd ${PATH_TO_MISP}/app/files/scripts/mixbox
${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install .
#
cd ${PATH_TO_MISP}/app/files/scripts/python-cybox
${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install .
#
cd ${PATH_TO_MISP}/app/files/scripts/python-stix
${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install .
#
cd $PATH_TO_MISP/app/files/scripts/python-maec
${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install .
#
cd ${PATH_TO_MISP}/app/files/scripts/cti-python-stix2
${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install .
#
# Install PyMISP:
cd ${PATH_TO_MISP}/PyMISP
${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install .
#
# Install Packages PyDeep, lief, zmq, redis, python-magic, plyara, taxii2-client, ;
${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install pydeep2 
${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install lief
${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install zmq redis
${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install python-magic
${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install plyara
${SUDO_WWW} ${PATH_TO_MISP}/venv/bin/pip install taxii2-client
#
# Install CakePHP
# Create PHP composer directory;
cd ${PATH_TO_MISP}/app
sudo mkdir /var/www/.composer ; sudo chown $WWW_USER:$WWW_USER /var/www/.composer
sudo printf "y\n" | ${SUDO_WWW} sh -c "cd ${PATH_TO_MISP}/app ; php composer.phar install"
#
# Enable CakeResque with php7.4-redis
sudo phpenmod redis
sudo phpenmod gnupg
#
# Enable CAKE Workers:
${SUDO_WWW} cp -fa ${PATH_TO_MISP}/INSTALL/setup/config.php ${PATH_TO_MISP}/app/Plugin/CakeResque/Config/config.php
#
# Import MYSQL Schema:
sudo mysql -u $MYSQL_USER --password="$MYSQL_PASSWORD" $MYSQL_DATABASE -h $MYSQL_HOST -P 3306 2>&1 < /var/www/MISP/INSTALL/MYSQL.sql
#
# Set Proper Permissions and Ownership of MISP directories
# Once the installation of MISP is done, update the ownership and permissions of the directories;
${SUDO_WWW} chown -R ${WWW_USER}:${WWW_USER} ${PATH_TO_MISP}
${SUDO_WWW} chmod -R 750 ${PATH_TO_MISP}
${SUDO_WWW} chmod -R g+ws ${PATH_TO_MISP}/app/tmp
${SUDO_WWW} chmod -R g+ws ${PATH_TO_MISP}/app/files
${SUDO_WWW} chmod -R g+ws $PATH_TO_MISP/app/files/scripts/tmp
#
# Check Apache Config:
sudo cp ${PATH_TO_MISP}/INSTALL/apache.24.misp.ssl /etc/apache2/sites-enabled/misp-ssl.conf
sudo cat /etc/apache2/sites-enabled/misp-ssl.conf
sudo apache2ctl configtest
#
# Disable status / Enable modules rewrite e headers
sudo a2dismod status
sudo a2enmod ssl
sudo a2enmod rewrite
sudo a2enmod headers
#
# Disable default apache site and enable MISP as default:
sudo a2dissite 000-default
sudo a2ensite misp-ssl
#
# Enable MISP Log Rotation
sudo cp ${PATH_TO_MISP}/INSTALL/misp.logrotate /etc/logrotate.d/misp
sudo chmod 0640 /etc/logrotate.d/misp
#
# Configure MISP
# Rename the default configurations as follows;
${SUDO_WWW} cp -a ${PATH_TO_MISP}/app/Config/bootstrap.default.php ${PATH_TO_MISP}/app/Config/bootstrap.php
${SUDO_WWW} cp -a ${PATH_TO_MISP}/app/Config/database.default.php ${PATH_TO_MISP}/app/Config/database.php
${SUDO_WWW} cp -a ${PATH_TO_MISP}/app/Config/core.default.php ${PATH_TO_MISP}/app/Config/core.php
${SUDO_WWW} cp -a ${PATH_TO_MISP}/app/Config/config.default.php ${PATH_TO_MISP}/app/Config/config.php
#
# Update database connection details;
cd /var/www/MISP/app/Config/ && sudo cp database.default.php database.php
${SUDO_WWW} sed -i "s/'host' => 'localhost'/'host' => 'misp_db'/g" /var/www/MISP/app/Config/database.php
${SUDO_WWW} sed -i "s/'login' => 'db login',/'login' => 'misp',/g" /var/www/MISP/app/Config/database.php
${SUDO_WWW} sed -i "s/'password' => 'db password',/'password' => 'misp',/g" /var/www/MISP/app/Config/database.php
#
# Define property permissions:
${SUDO_WWW} chown -R ${WWW_USER}:${WWW_USER} ${PATH_TO_MISP}
${SUDO_WWW} chmod -R 750 ${PATH_TO_MISP}
${SUDO_WWW} chmod -R g+ws ${PATH_TO_MISP}/app/tmp
${SUDO_WWW} chmod -R g+ws ${PATH_TO_MISP}/app/files
${SUDO_WWW} chmod -R g+ws $PATH_TO_MISP/app/files/scripts/tmp
${SUDO_WWW} chmod +x $PATH_TO_MISP/app/Console/worker/start.sh
${SUDO_WWW} chown -R $WWW_USER:$WWW_USER ${PATH_TO_MISP}/app/Config
${SUDO_WWW} chmod -R 750 ${PATH_TO_MISP}/app/Config
#
# Configure Apache Web Server for MISP
# MISP ships with sample Apache HTTP/HTTPS configuration file under /var/www/MISP/INSTALL/apache.24.misp.ssl.
# Copy this file to Apache Sites available directory;
sudo cp /var/www/MISP/INSTALL/apache.24.misp.ssl /etc/apache2/sites-available/misp.conf
#
# Generate SSL
sudo openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/CN=${FQDN}" \
-keyout /etc/ssl/private/misp.local.key -out /etc/ssl/private/misp.local.crt
#
# Disable default Apache sites and enable MISP site;
sudo a2dissite 000-default.conf
sudo a2ensite misp.conf
#
sudo apt-get clean all
#
echo " ################# END INSTALL WITH MISP USER ################ "

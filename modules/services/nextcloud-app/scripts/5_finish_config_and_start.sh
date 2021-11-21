#!/bin/bash

touch 5-0.txt

# Move nextcloud to its final destination and set permissions
chown -R www-data:www-data nextcloud/
mv nextcloud/ /var/www

touch 5-1.txt

# Enable Apache modules. Replace default site
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime

touch 5-2.txt

a2dissite 000-default
a2ensite nextcloud
systemctl reload apache2

touch 5-3.txt

# sed -i "s/0 => /0 => '*',\n    1 => /" /var/www/nextcloud/config/config.php

touch finish.txt
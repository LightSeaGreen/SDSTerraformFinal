#!/bin/bash

touch 4_2-0.txt

sed -i "s/0 => /0 => '*',\n    1 => /" /var/www/nextcloud/config/config.php

touch 4_2-1.txt

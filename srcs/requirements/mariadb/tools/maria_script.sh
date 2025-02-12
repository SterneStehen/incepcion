#!/bin/bash

# Import environment variables from /etc/environment
set -a
source /etc/environment
set +a

# Generate the init.sql file with necessary SQL commands
cat >/etc/mysql/init.sql <<EOL
CREATE DATABASE IF NOT EXISTS ${DATABASE_NAME};
CREATE USER IF NOT EXISTS '${USER_DATABASE}'@'%' IDENTIFIED BY '${DATABASE_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DATABASE_NAME}.* TO '${USER_DATABASE}'@'%';
FLUSH PRIVILEGES;
EOL

echo "Initialization script has been created."
# Check if the MySQL system database exists
DB_PATH="/var/lib/mysql/mysql"
if [ -f "/etc/mysql/my.cnf" ]; then
    echo "Configuration file exists."
fi

if [ -d "$DB_PATH" ]; then
    echo "MySQL system database exists."
    exec mysqld_safe
else
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
    mysqld
fi
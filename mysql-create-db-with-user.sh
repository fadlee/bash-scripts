#!/bin/bash

# Prompt the user for MySQL root password
read -s -p "Enter MySQL root password (press Enter for no password): " ROOT_PASSWORD
echo

# Prompt the user for database name
read -p "Enter new database name: " DB_NAME

# Prompt the user for database user
read -p "Enter new database user: " DB_USER

# Prompt the user for database user password
read -s -p "Enter database user password: " DB_PASSWORD
echo

# Set the MySQL password flag
MYSQL_PASSWORD_FLAG=""
[ -n "$ROOT_PASSWORD" ] && MYSQL_PASSWORD_FLAG="-p$ROOT_PASSWORD"

# MySQL commands to create the database and user
MYSQL_COMMAND="mysql -u root $MYSQL_PASSWORD_FLAG -e"

# Create the MySQL database
$MYSQL_COMMAND "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

# Create the MySQL user and grant privileges
$MYSQL_COMMAND "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
$MYSQL_COMMAND "FLUSH PRIVILEGES;"

echo "MySQL database and user created successfully."

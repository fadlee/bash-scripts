#!/bin/bash

# Prompt for MySQL connection details
read -p "Enter MySQL host (press Enter for default): " DB_HOST
read -p "Enter MySQL username (press Enter for default): " DB_USER

# Prompt for MySQL password without echoing
echo -n "Enter MySQL password (press Enter for default): "
stty -echo
read DB_PASSWORD
stty echo
echo

# Prompt for old and new database names
read -p "Enter old database name: " OLD_DB_NAME
read -p "Enter new database name: " NEW_DB_NAME

mysql_param=""
[ -n "$DB_HOST" ] && mysql_param+=" -h$DB_HOST"
[ -n "$DB_USER" ] && mysql_param+=" -u$DB_USER"
[ -n "$DB_PASSWORD" ] && mysql_param+=" -p$DB_PASSWORD"

mysql $mysql_param -e "CREATE DATABASE $NEW_DB_NAME;"

# Dump the entire old database and pipe it directly to the new database
mysqldump $mysql_param --single-transaction $OLD_DB_NAME | mysql $mysql_param $NEW_DB_NAME

# Drop the old database (comment this line if you want to keep the old database)
mysql $mysql_param -e "DROP DATABASE $OLD_DB_NAME;"

echo "Database renaming completed."

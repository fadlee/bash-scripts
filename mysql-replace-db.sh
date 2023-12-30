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

mysql_param=""
[ -n "$DB_HOST" ] && mysql_param+=" -h$DB_HOST"
[ -n "$DB_USER" ] && mysql_param+=" -u$DB_USER"
[ -n "$DB_PASSWORD" ] && mysql_param+=" -p$DB_PASSWORD"

# Prompt the user for the SQL file containing the source database dump
read -p "Enter the SQL file name (e.g., source_database_dump.sql): " SQL_FILE

# Check if the specified SQL file exists
if [ ! -f "$SQL_FILE" ]; then
  echo "Error: The specified SQL file does not exist."
  exit 1
fi

# Check if the target database exists
if mysql $mysql_param -e "USE $TARGET_DB_NAME;" 2>/dev/null; then
  # Target database exists, drop it
  mysql $mysql_param -e "DROP DATABASE $TARGET_DB_NAME;"
fi

mysql $mysql_param -e "CREATE DATABASE $TARGET_DB_NAME;"

# Import the source dump into the target database
mysql $mysql_param $TARGET_DB_NAME < $SQL_FILE

echo "Database import completed."

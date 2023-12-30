#!/bin/bash

# MySQL connection parameters for target database
DEFAULT_TARGET_DB_USER=""
DEFAULT_TARGET_DB_PASSWORD=""
DEFAULT_TARGET_DB_HOST=""
TARGET_DB_NAME="target_database"

# Prompt the user for the MySQL database host
read -p "Enter MySQL host (press Enter for default): " TARGET_DB_HOST
TARGET_DB_HOST=${TARGET_DB_HOST:-$DEFAULT_TARGET_DB_HOST}
HOST_PARAM=""
[ -n "$TARGET_DB_HOST" ] && HOST_PARAM="-h $TARGET_DB_HOST"

# Prompt the user for the MySQL username
read -p "Enter MySQL username (press Enter for default): " TARGET_DB_USER
TARGET_DB_USER=${TARGET_DB_USER:-$DEFAULT_TARGET_DB_USER}
USER_PARAM=""
[ -n "$TARGET_DB_USER" ] && USER_PARAM="-u $TARGET_DB_USER"

# Prompt the user for the MySQL password
read -s -p "Enter MySQL password (press Enter for empty password): " TARGET_DB_PASSWORD
echo
PASSWORD_PARAM=""
[ -n "$TARGET_DB_PASSWORD" ] && PASSWORD_PARAM="-p$TARGET_DB_PASSWORD"

# Prompt the user for the SQL file containing the source database dump
read -p "Enter the SQL file name (e.g., source_database_dump.sql): " SQL_FILE

# Check if the specified SQL file exists
if [ ! -f "$SQL_FILE" ]; then
  echo "Error: The specified SQL file does not exist."
  exit 1
fi

# Check if the target database exists
if mysql $USER_PARAM $PASSWORD_PARAM $HOST_PARAM -e "USE $TARGET_DB_NAME;" 2>/dev/null; then
  # Target database exists, drop it
  mysql $USER_PARAM $PASSWORD_PARAM $HOST_PARAM -e "DROP DATABASE $TARGET_DB_NAME;"
fi

mysql $USER_PARAM $PASSWORD_PARAM $HOST_PARAM -e "CREATE DATABASE $TARGET_DB_NAME;"

# Import the source dump into the target database
mysql $USER_PARAM $PASSWORD_PARAM $HOST_PARAM $TARGET_DB_NAME < $SQL_FILE

echo "Database import completed."

#!/bin/bash

# Prompt the user for MySQL connection details
read -p "Enter MySQL host (press Enter for default): " DB_HOST
read -p "Enter MySQL username (press Enter for default): " DB_USER
read -s -p "Enter MySQL password (press Enter for default): " DB_PASSWORD
echo

# Prompt the user for a list of database names (space-separated)
read -p "Enter space-separated database names: " DATABASES

# Convert space-separated database names to an array
IFS=' ' read -ra DATABASE_ARRAY <<< "$DATABASES"

# Backup directory (current folder where the script is called)
BACKUP_DIR="$(pwd)"

# Current date and time for the backup filename
DATE=$(date +"%Y%m%d%H%M%S")

# Iterate over each database and perform mysqldump
for DB_NAME in "${DATABASE_ARRAY[@]}"
do
  # Create backup file name
  BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${DATE}.sql"

  # Perform mysqldump without -h, -u, -p if the values are empty
  mysqldump $([ -n "$DB_HOST" ] && echo "-h$DB_HOST") \
            $([ -n "$DB_USER" ] && echo "-u$DB_USER") \
            $([ -n "$DB_PASSWORD" ] && echo "-p$DB_PASSWORD") \
            --databases $DB_NAME > $BACKUP_FILE

  # Check if mysqldump was successful
  if [ $? -eq 0 ]; then
    echo "Backup of $DB_NAME completed successfully. File: $BACKUP_FILE"
  else
    echo "Error: Backup of $DB_NAME failed."
  fi
done

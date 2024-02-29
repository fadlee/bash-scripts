#!/bin/bash

# set up a cron job to run it hourly:
# 0 * * * * /backups/mysql-backup-hourly.sh

# MySQL connection details
DB_HOST="localhost"
DB_USER="your_mysql_user"
DB_PASSWORD="your_mysql_password"

# List of databases to backup (space-separated)
DATABASES="db1 db2 db3"

# Backup root directory
BACKUP_ROOT_DIR="/path/to/backup/directory"

# Function to perform MySQL backup
perform_backup() {
  local DB_NAME=$1
  local FREQUENCY=$2
  local APPEND_NAME=$3
  local BACKUP_DIR="$BACKUP_ROOT_DIR/$FREQUENCY"
  local BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${APPEND_NAME}.sql"

  # Skip backup if file already exists
  if [ -f "$BACKUP_FILE.gz" ]; then
    echo "Skipping backup of $DB_NAME for $FREQUENCY. File already exists: $BACKUP_FILE.gz"
    return
  fi

  # Ensure the backup directory exists
  mkdir -p "$BACKUP_DIR"

  # Perform mysqldump
  mysqldump -h$DB_HOST -u$DB_USER -p$DB_PASSWORD --databases $DB_NAME > $BACKUP_FILE

  gzip $BACKUP_FILE

  # Check if mysqldump was successful
  if [ $? -eq 0 ]; then
    echo "Backup of $DB_NAME for $FREQUENCY completed successfully. File: $BACKUP_FILE.gz"
  else
    echo "Error: Backup of $DB_NAME for $FREQUENCY failed."
  fi
}

# Create backups
for DB_NAME in $DATABASES
do
  perform_backup $DB_NAME "hourly" $(date +"%Y-%m-%d-%H") # 2023-12-30-16
  perform_backup $DB_NAME "daily" $(date +"%Y-%m-%d") # 2023-12-30
  perform_backup $DB_NAME "weekly" $(date +"%Y-w%U") # 2023-w52
  perform_backup $DB_NAME "monthly" $(date +"%Y-%m") # 2023-12
done

# Remove backups older than specified days
find "$BACKUP_ROOT_DIR/hourly" -type f -name "${DATABASES// /_}_*" -mtime +1 -exec rm {} \;
find "$BACKUP_ROOT_DIR/daily" -type f -name "${DATABASES// /_}_*" -mtime +7 -exec rm {} \;
find "$BACKUP_ROOT_DIR/weekly" -type f -name "${DATABASES// /_}_*" -mtime +30 -exec rm {} \;
find "$BACKUP_ROOT_DIR/monthly" -type f -name "${DATABASES// /_}_*" -mtime +365 -exec rm {} \;

echo "Backup process completed."

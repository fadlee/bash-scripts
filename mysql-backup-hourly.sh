#!/bin/bash

# set up a cron job to run it hourly:
# 0 * * * * /path/to/mysql-backup-hourly.sh

# MySQL connection details
DB_HOST="localhost"
DB_USER="your_mysql_user"
DB_PASSWORD="your_mysql_password"

# List of databases to backup (space-separated)
DATABASES="db1 db2 db3"

# Backup directory
BACKUP_DIR="/path/to/backup/directory"

# Current date and time for backup filenames
DATE=$(date +"%Y%m%d%H%M%S")
DAY=$(date +"%d")
WEEK=$(date +"%U")
MONTH=$(date +"%m")

# Function to perform MySQL backup
perform_backup() {
  local DB_NAME=$1
  local BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${DATE}.sql"

  # Perform mysqldump
  mysqldump -h$DB_HOST -u$DB_USER -p$DB_PASSWORD --databases $DB_NAME > $BACKUP_FILE

  # Check if mysqldump was successful
  if [ $? -eq 0 ]; then
    echo "Backup of $DB_NAME completed successfully. File: $BACKUP_FILE"
  else
    echo "Error: Backup of $DB_NAME failed."
  fi
}

# Create hourly backup
for DB_NAME in $DATABASES
do
  perform_backup $DB_NAME
done

# Remove hourly backups older than 1 day
find $BACKUP_DIR -type f -name "${DATABASES// /_}_${DATE}.sql" -mtime +1 -exec rm {} \;

# Create weekly backup (only for the first day of the week)
if [ "$DAY" -eq 01 ]; then
  for DB_NAME in $DATABASES
  do
    perform_backup $DB_NAME
    mv "$BACKUP_DIR/${DB_NAME}_${DATE}.sql" "$BACKUP_DIR/weekly_${DB_NAME}_${WEEK}.sql"
  done
fi

# Remove weekly backups older than 30 days
find $BACKUP_DIR -type f -name "weekly_*_[0-9][0-9].sql" -mtime +30 -exec rm {} \;

# Create monthly backup (only for the first day of the month)
if [ "$DAY" -eq 01 ]; then
  for DB_NAME in $DATABASES
  do
    perform_backup $DB_NAME
    mv "$BACKUP_DIR/${DB_NAME}_${DATE}.sql" "$BACKUP_DIR/monthly_${DB_NAME}_${MONTH}.sql"
  done
fi

# Remove monthly backups older than 365 days
find $BACKUP_DIR -type f -name "monthly_*_[0-9][0-9].sql" -mtime +365 -exec rm {} \;

echo "Backup process completed."

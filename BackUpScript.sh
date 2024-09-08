#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 <source_directory> <backup_directory>"
    echo ""
    echo "Description:"
    echo "  This script backs up the contents of <source_directory> to <backup_directory>."
    echo "  A timestamped subdirectory will be created in <backup_directory> to store the backup."
    echo ""
    echo "Arguments:"
    echo "  <source_directory>   The directory you want to back up."
    echo "  <backup_directory>   The directory where the backup will be stored."
    echo ""
    echo "Example:"
    echo "  $0 /home/user/documents /media/user/external_drive"
    echo "  This will back up /home/user/documents to /media/user/external_drive with a timestamp."
    exit 1
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    usage
fi

# Assign command-line arguments to variables
SOURCE_DIR="$1"
BACKUP_DIR="$2"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S") # Current timestamp
BACKUP_NAME="backup_$TIMESTAMP"         # Backup directory name

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory does not exist: $SOURCE_DIR"
    usage
fi

# Create a timestamped backup directory
mkdir -p "$BACKUP_DIR/$BACKUP_NAME"

# Perform the backup using rsync
rsync -av --delete "$SOURCE_DIR/" "$BACKUP_DIR/$BACKUP_NAME/"

# Check if rsync was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully: $BACKUP_DIR/$BACKUP_NAME"
else
    echo "Backup failed."
    exit 1
fi

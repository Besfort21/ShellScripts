#!/bin/bash

# Configuration
THRESHOLD=80               # Disk usage percentage threshold
ALERT_EMAIL="you@example.com" # Email to send alerts

# List available mount points and display them to the user
echo "Available mount points:"
df -h | awk 'NR>1 {print NR-1 ": " $6}'

# Prompt user to choose a mount point
read -p "Enter the number corresponding to the mount point you want to monitor: " CHOICE

# Validate the user's choice
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]]; then
    echo "Invalid choice. Please enter a number."
    exit 1
fi

# Extract the chosen mount point from the df output
MOUNT_POINT=$(df -h | awk -v choice="$CHOICE" 'NR==choice+1 {print $6}')

# Check if the mount point is valid
if [ -z "$MOUNT_POINT" ]; then
    echo "Invalid mount point choice."
    exit 1
fi

echo "Monitoring disk usage for: $MOUNT_POINT"

# Get the current disk usage percentage for the specified mount point
USAGE=$(df "$MOUNT_POINT" | awk 'NR==2 {print $5}' | sed 's/%//')

# Check if the usage exceeds the threshold
if [ "$USAGE" -ge "$THRESHOLD" ]; then
    # Create the alert message
    SUBJECT="Disk Space Alert: ${MOUNT_POINT} Usage High"
    MESSAGE="Warning: The disk usage on ${MOUNT_POINT} has reached ${USAGE}%. This exceeds the threshold of ${THRESHOLD}%."
    
    # Send the alert email (you may need to configure a mail utility)
    echo "$MESSAGE" | mail -s "$SUBJECT" "$ALERT_EMAIL"
    
    # Print a message to the console
    echo "Disk usage alert sent to $ALERT_EMAIL. Usage: ${USAGE}%"
else
    # Print a message to the console indicating normal usage
    echo "Disk usage is within normal limits: ${USAGE}%"
fi

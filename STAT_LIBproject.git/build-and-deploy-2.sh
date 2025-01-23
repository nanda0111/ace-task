#!/bin/bash

# Input variables
INTEGRATION_NODE="${INTEGRATION_NODE:-IN2}"         # Default node name
INTEGRATION_SERVER="${INTEGRATION_SERVER:-IS2}"     # Default server name
WORKSPACE_DIR="${WORKSPACE_DIR:-.}"                # Default workspace directory
BAR_FILE_NAME="${BAR_FILE_NAME:-STAT_LIBproject.generated.bar}" # Default BAR file name
PROJECT_DIR="/home/ace/STAT_LIBproject.git"        # Root directory of the project
BAR_FILE_DIR="$PROJECT_DIR/bar-files"              # Directory for storing BAR files
BAR_FILE="$BAR_FILE_DIR/$BAR_FILE_NAME"            # Full path to the BAR file
APPLICATION_NAME="${APPLICATION_NAME:-STAT_LIB}"   # Default application/library name
OVERRIDE_FILE="${OVERRIDE_FILE}"                   # Optional override file

LOG_FILE="/var/log/ace/build-and-deploy.log"       # Log file location

# Start the process
echo "Starting BAR file build and deployment..." | tee -a $LOG_FILE

# Step 0: Ensure the BAR file directory exists
if [ ! -d "$BAR_FILE_DIR" ]; then
  echo "BAR file directory '$BAR_FILE_DIR' does not exist. Creating it now..." | tee -a $LOG_FILE
  mkdir -p "$BAR_FILE_DIR"
fi

# Step 1: Build the BAR file
echo "Building BAR file: $BAR_FILE" | tee -a $LOG_FILE
if ! command -v mqsipackagebar &> /dev/null; then
  echo "Error: mqsipackagebar command not found. Ensure IBM ACE Toolkit is installed." | tee -a $LOG_FILE
  exit 1
fi

mqsipackagebar -w "$WORKSPACE_DIR" -a "$BAR_FILE" -k "$APPLICATION_NAME" | tee -a $LOG_FILE
if [ $? -ne 0 ]; then
  echo "Error: Failed to generate BAR file. Check the logs for details." | tee -a $LOG_FILE
  exit 1
fi

echo "BAR file generated successfully: $BAR_FILE" | tee -a $LOG_FILE

# Step 2: Deploy the BAR file
echo "Deploying BAR file to Integration Node: $INTEGRATION_NODE, Server: $INTEGRATION_SERVER" | tee -a $LOG_FILE
if ! command -v mqsideploy &> /dev/null; then
  echo "Error: mqsideploy command not found. Ensure IBM ACE Toolkit is installed." | tee -a $LOG_FILE
  exit 1
fi

mqsideploy -n "$INTEGRATION_NODE" -e "$INTEGRATION_SERVER" -a "$BAR_FILE" | tee -a $LOG_FILE
if [ $? -ne 0 ]; then
  echo "Error: Deployment failed. Check the logs for details." | tee -a $LOG_FILE
  exit 1
fi

echo "BAR file deployed successfully!" | tee -a $LOG_FILE


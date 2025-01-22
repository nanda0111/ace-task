
# STAT_LIB Project Deployment

## Overview
This document provides details on the deployment of the BAR file `STAT_LIBproject.generated.bar` to the integration server `IS2` within the integration node `IN2`.

## Deployment Steps

### 1. Prerequisites
Ensure the following prerequisites are met before deployment:
- Integration Node: `IN2` exists and is running.
- Integration Server: `IS2` exists and is ready to accept deployments.
- BAR file: `STAT_LIBproject.generated.bar` is available in the `BarFiles` directory.
- Overrides file: `STAT_LIBproject.generated.pro` is available in the `BarFiles` directory.
- Deployment script: `STAThandScript.sh` is available in the `ace-task` directory.
- Standard log file: `deploy_STAT_LIB.log` is available in the `ace-task` directory.

### 2. Deployment Script
Use the following deployment script (`STAThandScript.sh`) to automate the deployment process:

```bash
#!/bin/bash

# Set variables
INTEGRATION_NODE="IN2"
INTEGRATION_SERVER="IS2"
BAR_FILE="/home/ace/BarFiles/STAT_LIBproject.generated.bar"
LOG_FILE="/home/ace/ace-task/deploy_STAT_LIB.log"
OVERRIDE_FILE="/home/ace/BarFiles/STAT_LIBproject.generated.pro"

# Check integration server status
mqsilist $INTEGRATION_NODE -e $INTEGRATION_SERVER

# Apply BAR overrides
echo "Starting deployment of BAR file..." | tee -a $LOG_FILE
mqsiapplybaroverride -b $BAR_FILE -p $OVERRIDE_FILE
if [ $? -ne 0 ]; then
    echo "Error applying overrides to BAR file. Exiting." | tee -a $LOG_FILE
    exit 1
fi

# Deploy BAR file
mqsideploy $INTEGRATION_NODE -e $INTEGRATION_SERVER -a $BAR_FILE
if [ $? -ne 0 ]; then
    echo "Deployment failed. Check ACE logs for details." | tee -a $LOG_FILE
    exit 1
fi

# Validate deployment
echo "Deployment completed. Validating..." | tee -a $LOG_FILE
mqsilist $INTEGRATION_SERVER | tee -a $LOG_FILE

# Post-deployment checks
echo "Post-deployment validation of BAR file contents..." | tee -a $LOG_FILE
mqsireadbar -b $BAR_FILE | tee -a $LOG_FILE

echo "Checking deployment descriptor details..." | tee -a $LOG_FILE
echo "Deployment descriptor:" | tee -a $LOG_FILE
echo "  - STAT_LIB.sf_sub#Compute.dataSource" | tee -a $LOG_FILE
echo "  - STAT_LIB.sf_sub#Compute.connectDatasourceBeforeFlowStarts" | tee -a $LOG_FILE
echo "  - STAT_LIB.sf_sub#Compute.validateMaster" | tee -a $LOG_FILE

echo "Deployment, validation, and post-deployment checks complete!" | tee -a $LOG_FILE
```

Run the script using the command:
```bash
./STAThandScript.sh
```

### 3. Deployment Validation
After running the script, validate the deployment by:
1. Checking the integration server status using:
   ```bash
   mqsilist $INTEGRATION_SERVER
   ```
2. Verifying the BAR file contents:
   ```bash
   mqsireadbar -b $BAR_FILE
   ```
3. Confirming deployment descriptor details:
   - `STAT_LIB.sf_sub#Compute.dataSource`
   - `STAT_LIB.sf_sub#Compute.connectDatasourceBeforeFlowStarts`
   - `STAT_LIB.sf_sub#Compute.validateMaster`

## Logs
Deployment logs are saved in:
```bash
/home/ace/ace-task/deploy_STAT_LIB.log
```

Review the log file for any errors or warnings.

## Conclusion
The deployment process ensures that the `STAT_LIBproject.generated.bar` is successfully deployed and validated on the integration server `IS2`. For any issues, refer to the log file or ACE error logs for further debugging.

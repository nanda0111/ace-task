#!/bin/bash
#set variables
INTEGRATION_NODE="IN2"
INTEGRATION_SERVER="IS2"
BAR_FILE="/home/ace/BarFiles/STAT_LIBproject.generated.bar" 
LOG_FILE="/var/log/ace/deploy_STAT_LIB.log"
OVERRIDE_FILE="/home/ace/BarFiles/STAT_LIBproject.generated.pro"


mqsilist $INTEGRATION_NODE -e $INTEGRATION_SERVER

echo "Starting deployment of BAR file..." | tee -a $LOG_FILE

# Apply BAR overrides
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
#mqsireadbar -b $BAR_FILE | tee -a $LOG_FILE

echo "Checking deployment descriptor details..." | tee -a $LOG_FILE
echo "Deployment descriptor:" | tee -a $LOG_FILE
echo "  - STAT_LIB.sf_sub#Compute.dataSource" | tee -a $LOG_FILE
echo "  - STAT_LIB.sf_sub#Compute.connectDatasourceBeforeFlowStarts" | tee -a $LOG_FILE
echo "  - STAT_LIB.sf_sub#Compute.validateMaster" | tee -a $LOG_FILE

echo "Deployment, validation, and post-deployment checks complete!" | tee -a $LOG_FILE



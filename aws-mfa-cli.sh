#!/bin/bash
set -e

# specify your MFA_DEVICE_ARN
MFA_DEVICE_ARN=''


if [ -z "$MFA_DEVICE_ARN" ]; 
then
    echo "Please specify the MFA_DEVICE_ARN"
    exit 1
fi

read -p "Please enter MFA code: " MFA_CODE

echo "You entered '$MFA_CODE'"

COMMAND="aws --output text sts get-session-token \
    --serial-number $MFA_DEVICE_ARN \
    --token-code $MFA_CODE"

echo $COMMAND
CREDS=$($COMMAND)

KEY=$(echo $CREDS | cut -d" " -f2)
SECRET=$(echo $CREDS | cut -d" " -f4)
SESS_TOKEN=$(echo $CREDS | cut -d" " -f5)

echo "Key: $KEY"
echo "Secret: $SECRET"
echo "Session token: $SESS_TOKEN"

export AWS_ACCESS_KEY_ID=$KEY
export AWS_SECRET_ACCESS_KEY=$SECRET
export AWS_SESSION_TOKEN=$SESS_TOKEN

# check if script has been sourced or executed
(return 0 2>/dev/null) && sourced=1 || sourced=0
if [ $sourced -eq 1 ]; then
    echo "Script was sourced."
else
    echo "Script was executed, starting subshell."
    bash -l
fi


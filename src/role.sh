#!/usr/bin/env bash

function main () {
    echo "Checking roles configuration for role xmarket"
    username=$1
    input_role=$2
    echo $input_role
    role=$(cat roles.json | jq -r ".$input_role") > /dev/null 2>&1
    is_role=$?

    if [ ! $is_role -eq 0 ]; then
        echo "Couldn't find role in config file... Add role arn and try again!"
    else 
        echo "Found role arn $role"
        assume_role $username $role
    fi
}


function assume_role (){

    myname=$1
    rolearn=$2

    # Default to first mfa device of user
    mfa_serial_number=$(aws iam list-mfa-devices | jq -r '.MFADevices[0].SerialNumber')

    echo "=================="
    echo "Enter an MFA token"
    read -r TOKEN

    if [ -z "$TOKEN" ]; then

        echo >&2 "Aborting"

        exit 1
    fi

    echo " Generating a session token which will last 1 hour"

    aws sts assume-role --role-arn $rolearn  --role-session-name $myname-cli --duration-seconds 3600 --serial-number $mfa_serial_number --token-code $TOKEN --output text | tee /tmp/sartc.$$

    keyid=$(grep CREDENTIALS /tmp/sartc.$$ | awk '{ print $2 }')
    secret=$(grep CREDENTIALS /tmp/sartc.$$ | awk '{ print $4 }')
    token=$(grep CREDENTIALS /tmp/sartc.$$ | awk '{ print $5 }')

    export AWS_ACCESS_KEY_ID=$keyid
    export AWS_SECRET_ACCESS_KEY=$secret
    export AWS_SECURITY_TOKEN=$token
    #for eks needs the below
    export AWS_SESSION_TOKEN=$token
    export AWS_DEFAULT_REGION="eu-west-1"

    echo "## WARNING ##"
    echo "All commands in this session will now apply to account $rolearn account"
    echo "## WARNING ##"
}

main $1 $2
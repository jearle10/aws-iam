#!/usr/bin/env bash

profile=$1

main(){
    echo "Switching aws profile to $1"
    export AWS_PROFILE=$1 
}

main $profile
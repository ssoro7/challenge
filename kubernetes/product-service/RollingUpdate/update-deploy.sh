#!/usr/bin/env bash

usage(){
    echo ""
    echo "----------------------------------------------------------"
    echo "EXAMPLE: sudo $0 -v 1.0.0"
    echo ""
    echo "----------------------------------------------------------"
    echo "UPDATE DEPLOY SCRIPT"
    echo "THIS SCRIPT IS FOR UPDATE THE VERSION OF A DEPLOYMENT"
    echo ""
    echo "----------------------------------------------------------"

    exit 1
}

#-------------------------------------------------
#-----   set params function -----
set_params(){

    MINIKUBE_IP=$(minikube ip)

    CHECK_PRODUCTION_URL=http://$MINIKUBE_IP:30037/product/GW1390

    export VERSION=$VERSION
    export REVIEW_SERVICE_URL=http://$MINIKUBE_IP:30036
    export NODE_PORT_PUBLIC=30037

    envsubst < service.yaml | tee _service.yaml
    echo ""
    echo "-----------------------------------------------------"
    envsubst < deployment.yaml | tee _deployment.yaml
    echo ""
    echo "-----------------------------------------------------"
}

continue_on_error(){
    echo "ERROR IN LAST PLAYBOOK"

    while true; do
        read -p "DO YOU WANT TO CONTINUE? y/n:  " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) rm /opt/cecoco/cdm-module/.data/.tmp; exit 1;;
            * ) echo "PLEASE ANSWER YES OR NO.";;
        esac
    done
}

test_new_enviroment(){
attempt_counter=0
max_attempts=20

until $(curl --output /dev/null --silent --head --fail $1); do
    if [ ${attempt_counter} -eq ${max_attempts} ];then
      echo "Max attempts reached"
      exit 1
    fi

    printf '.'
    attempt_counter=$(($attempt_counter+1))
    sleep 5
done
}

#-------------------------------------------------
#-----   1 deploy the new version  -----
step_1(){

        echo "Start deploy"
        kubectl apply -f _deployment.yaml
        if [ $? -ne 0 ];then
            continue_on_error
        fi
}

#-------------------------------------------------
#-----   2 switch to production  -----
step_2(){

        echo "Create the service"
        kubectl apply -f _service.yaml
        if [ $? -ne 0 ];then
            continue_on_error
        fi
}

#-------------------------------------------------
#-----   Check current production version and   -----
check_production_deploy(){

        echo "CHECKING FINAL STATUS"
        test_new_enviroment $CHECK_PRODUCTION_URL
        echo "FINAL STATUS OK"
}

echo ""
echo "----------------------------------------------------------"
echo ""
echo "UPDATE DEPLOY SCRIPT"
echo "THIS SCRIPT IS FOR UPDATE THE VERSION OF A DEPLOYMENT"
echo ""

##
# Get parameter from command line
##
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -m|--man|-u|--usage)
      usage
      ;;
    -v|--version)
      VERSION="$2"
      shift # past argument
      shift # past value
      ;;
    *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters

##
# call usage() function if TARGET parameters is undefined
##
nvars=$#
[[ ( -z "$VERSION"  ) ]] && usage

set_params

step_1

step_2

check_production_deploy

exit 0
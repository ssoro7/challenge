#!/usr/bin/env bash

usage(){
    echo ""
    echo "----------------------------------------------------------"
    echo "EXAMPLE: sudo $0 -t blue"
    echo "EXAMPLE: sudo $0 -t green"
    echo ""
    echo "----------------------------------------------------------"
    echo "INITIAL_DEPLOY SCRIPT"
    echo "THIS SCRIPT IS FOR DEPLOYING BLUE OR GREEN ENVIROMENTS"
    echo ""
    echo "----------------------------------------------------------"

    exit 1
}

#-------------------------------------------------
#-----   set params function -----
set_params(){

    MINIKUBE_IP=$(minikube ip)

    CHECK_PRODUCTION_URL=http://$MINIKUBE_IP:30037/product/GW1390

    if ([ "$TARGET" == "blue" ]); then
        # BLUE
        export TARGET_ROLE=blue
        export VERSION=1.0.0
        export REVIEW_SERVICE_URL=http://$MINIKUBE_IP:30036
        export NODE_PORT_PUBLIC=30037
        export NODE_PORT_TEST=30038
        CHECK_URL=http://$MINIKUBE_IP:30038/product/GW1390
    fi

    if ([ "$TARGET" == "green" ]); then
        # GREEN
        export TARGET_ROLE=green
        export VERSION=1.0.1
        export REVIEW_SERVICE_URL=http://$MINIKUBE_IP:30036
        export NODE_PORT_PUBLIC=30037
        export NODE_PORT_TEST=30039
        CHECK_URL=http://$MINIKUBE_IP:30039/product/GW1390

    fi

    envsubst < service-test.yaml | tee _service-test.yaml
    echo ""
    echo "-----------------------------------------------------"
    envsubst < deployment.yaml | tee _deployment.yaml
    echo ""
    echo "-----------------------------------------------------"
    envsubst < service-public.yaml | tee _service-public.yaml
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

        echo "Start deployment"
        kubectl apply -f _deployment.yaml
        if [ $? -ne 0 ];then
            continue_on_error
        fi
}

#-------------------------------------------------
#-----   2 Cofigure the service  -----
step_2(){

        echo "Cofigure the service"
        kubectl apply -f _service-public.yaml
        if [ $? -ne 0 ];then
            continue_on_error
        fi
}

#-------------------------------------------------
#-----   Check current production version   -----
check_production_deploy(){

        echo "CHECKING FINAL STATUS"
        CURRENT_PRODUCTION=$(kubectl get service -l env=prod  -o=jsonpath={.items..metadata.labels.role})
        
        if [ "$TARGET" != $CURRENT_PRODUCTION ];then
            echo "FAIL THE CURRENT PRODUCTION VERSION IS $CURRENT_PRODUCTION"
            exit 1
        fi

        test_new_enviroment $CHECK_PRODUCTION_URL
        echo "FINAL STATUS OK"
}

echo ""
echo "----------------------------------------------------------"
echo ""
echo "INITIAL_DEPLOY SCRIPT"
echo "THIS SCRIPT IS FOR DEPLOYING BLUE OR GREEN ENVIRONMENTS"
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
    -t|--target)
      TARGET="$2"
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
[[ ( -z "$TARGET"  ) ]] && usage

set_params

step_1

step_2

check_production_deploy

exit 0
#!/usr/bin/env bash
#-------------------------------------------------
#-----   set params function -----
usage(){
    echo ""
    echo "----------------------------------------------------------"
    echo "EXAMPLE: sudo $0"
    echo ""
    echo "----------------------------------------------------------"
    echo "BLUE-GREEN-SWITCH SCRIPT"
    echo "THIS SCRIPT IS FOR SWITCHING BETWEEN ENVIROMENTS"
    echo ""
    echo "----------------------------------------------------------"

    exit 1
}


set_params(){

    MINIKUBE_IP=$(minikube ip)
    PRODUCTION=$(kubectl get service -l env=prod  -o=jsonpath={.items..metadata.labels.role})

    if ([ "$PRODUCTION" != "blue" ] && [ "$PRODUCTION" != "green" ]); then
        echo "CAN'T DETERMINATE THE PRODUCTION AND TARGET ENVIROMENTS"
        exit 1
    fi

    TARGET=green

    if ([ "$PRODUCTION" == "green" ]); then
        TARGET=blue
    fi

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


#-----   Press enter to continue function  -----
confirm_to_continue(){

    read -p "PRESS TO PROMOTE TO PRODUCTION: $TARGET"
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
#-----   2 deploy the test service  -----
step_2(){

        echo "Start deploy"
        kubectl apply -f _service-test.yaml
        if [ $? -ne 0 ];then
            continue_on_error
        fi
}


#-------------------------------------------------
#-----   3 Valitation test  -----
step_3(){

        echo "Start test"
        test_new_enviroment $CHECK_URL
}

#-------------------------------------------------
#-----   4 switch to production  -----
step_4(){

        echo "Switch to production"
        kubectl apply -f _service-public.yaml
        if [ $? -ne 0 ];then
            continue_on_error
        fi
}

#-------------------------------------------------
#-----   Check current production version -----
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
echo "BLUE-GREEN-SWITCH SCRIPT"
echo "THIS SCRIPT IS FOR SWITCHING BETWEEN ENVIROMENTS"
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
    *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL[@]}" # restore positional parameters


set_params

step_1

step_2

step_3

confirm_to_continue

step_4

check_production_deploy

exit 0
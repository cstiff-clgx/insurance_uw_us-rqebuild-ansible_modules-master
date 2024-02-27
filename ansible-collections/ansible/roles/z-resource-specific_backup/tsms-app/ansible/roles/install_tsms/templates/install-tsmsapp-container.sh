#!/bin/bash

set -e

usage() {
    echo "Usage: ./install-${NAME}-container.sh [--help] [--tsms-app-port <port>] [--tsms-db-server <server>] [--tsms-db-port <port>] [--tsms-db-uid <user>] [--tsms-db-pwd <password>] [--rqe-db-uid <user>] [--rqe-db-pwd <password>] [--test-case-root-path <path>] [--tag <tag>]"
    echo
    echo "  --tag <tag>         Container's tag of TSMS Application to run (default is latest)"
    echo "  --tsms-app-port <port>"
    echo "                      Configure TSMS API server listening port with <port> (default is 8080)"
    echo "  --tsms-db-server <server>"
    echo "                      Configure TSMS database connection string 'server' with <server> (default is 127.0.0.1)"
    echo "  --tsms-db-port <port>"
    echo "                      Configure TSMS database connection string 'port' with <port> (default is 1433)"
    echo "  --tsms-db-uid <user>"
    echo "                      Configure TSMS database connection string 'uid' with <user> (default is EC_User)"
    echo "  --tsms-db-pwd <password>"
    echo "                      Configure TSMS database connection string 'pwd' with <password> (default is Test1234)"
    echo "  --rqe-db-uid <user>"
    echo "                      Configure RQE database connection string 'uid' with <user> (default is wce)"
    echo "  --rqe-db-pwd <password>"
    echo "                      Configure RQE database connection string 'pwd' with <password> (default is wcepwd)"
    echo "  --test-case-root-path"
    echo "                      Set test case files root path on host (default is '/mnt/tsms-testcase-disk')"
    echo "  --test-case-file-system"
    echo "                      Set file system that hosts test case files ('gcp' or 'local', default is 'local')"
    echo "  --gcp-credential-file"
    echo "                      Set credential file path to access GCP services (default is empty)"
    echo
    echo "  -h, --help          Print this help message"
}

environment() {
    echo "Container: $CONTAINER:$TAG"
    echo "TSMS API"
    echo "  * Port:     $TSMS_APP_PORT"
    echo "TSMS database"
    echo "  * Server:   $TSMS_DB_SERVER"
    echo "  * Port:     $TSMS_DB_PORT"
    echo "  * User:     $TSMS_DB_UID"
    echo "  * Password: $TSMS_DB_PWD"
    echo "RQE database"
    echo "  * User:     $RQE_DB_UID"
    echo "  * Password: $RQE_DB_PWD"
    echo "Test case files:"
    echo "  * Root path:   '$TEST_CASE_ROOT_PATH'"
    echo "  * File system: '$TEST_CASE_FILE_SYSTEM'"
    echo "GCP credential file: '$GCP_CREDENTIAL_FILE'"
    echo
}

NAME="tsmsapp"
CONTAINER="gcr.io/clgx-rqebuild-app-dev-1898/${NAME}"
TAG="latest"
TSMS_APP_PORT="8080"
TSMS_DB_SERVER="127.0.0.1"
TSMS_DB_PORT="1433"
TSMS_DB_UID="EC_User"
TSMS_DB_PWD="Test1234"
RQE_DB_UID="wce"
RQE_DB_PWD="wcepwd"
TEST_CASE_ROOT_PATH="22.1"
TEST_CASE_FILE_SYSTEM="gcp"
GCP_CREDENTIAL_FILE=""

AUTH_LOGIN="yes"

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -h | --help )
    usage
    exit 0
    ;;
  --tsms-app-port )
    shift
    TSMS_APP_PORT=$1
    ;;
  --tsms-db-server )
    shift
    TSMS_DB_SERVER=$1
    ;;
  --tsms-db-port )
    shift
    TSMS_DB_PORT=$1
    ;;
  --tsms-db-uid )
    shift
    TSMS_DB_UID=$1
    ;;
  --tsms-db-pwd )
    shift
    TSMS_DB_PWD=$1
    ;;
  --rqe-db-uid )
    shift
    RQE_DB_UID=$1
    ;;
  --rqe-db-pwd )
    shift
    RQE_DB_PWD=$1
    ;;
  --test-case-root-path )
    shift
    TEST_CASE_ROOT_PATH=$1
    ;;
  --test-case-file-system )
    shift
    TEST_CASE_FILE_SYSTEM=$1
    if [[ "$TEST_CASE_FILE_SYSTEM" != "gcp" && "$TEST_CASE_FILE_SYSTEM" != "local" ]]; then
      echo "ERROR: unknown file system: '$TEST_CASE_FILE_SYSTEM'"
      echo "       possible values: 'gcp' and 'local'"
    fi
    ;;
  --gcp-credential-file )
    shift
    GCP_CREDENTIAL_FILE=$1
    ;;
  --no-auth-login )
    AUTH_LOGIN="no"
    ;;
  * )
    TAG=$1
    usage
    exit 1
    ;;
esac; shift; done
if [[ "$1" == '--' ]]; then shift; fi

echo ">> Environment"
environment

if [[ $(sudo docker ps -a | grep ${NAME} | wc -l) -gt 0 ]]; then
    echo "You are about to remove ${NAME} container."
    echo "Do you want to proceed? [Y/n]: "
    read ans
    if [[ "$ans" = "Y" ]]; then
        sudo docker rm --force $NAME
    else
        echo "Installation aborted by user."
        exit 1
    fi
fi

if [[ ! -f /usr/bin/docker-credential-gcr ]]; then
    echo ">> Get docker-credential-gcr"
    sudo wget "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v2.1.0/docker-credential-gcr_linux_amd64-2.1.0.tar.gz"
    sudo tar -xvzf docker-credential-gcr_linux_amd64-2.1.0.tar.gz docker-credential-gcr
    sudo mv docker-credential-gcr /usr/bin/. 
    sudo chmod a+x /usr/bin/docker-credential-gcr
fi

if [[ "$AUTH_LOGIN" = "yes" ]]; then
    echo ">> Setup docker login"
    sudo gcloud auth application-default login --no-launch-browser
    sudo docker-credential-gcr configure-docker
    sudo docker login -u oauth2accesstoken -p "$(sudo gcloud auth print-access-token)" https://gcr.io
fi

echo ">> Pull TSMS App container"
sudo docker pull gcr.io/clgx-rqebuild-app-dev-1898/${NAME}:${TAG}

echo ">> Run TSMS App container"
sudo docker run -d -p ${TSMS_APP_PORT}:80 --name ${NAME} \
    --env ConnectionStrings__TsmsDbServer="$TSMS_DB_SERVER" \
    --env ConnectionStrings__TsmsDbPort="$TSMS_DB_PORT" \
    --env ConnectionStrings__TsmsDbUid="$TSMS_DB_UID" \
    --env ConnectionStrings__TsmsDbPwd="$TSMS_DB_PWD" \
    --env ConnectionStrings__RqeDbUid="$RQE_DB_UID" \
    --env ConnectionStrings__RqeDbPwd="$RQE_DB_PWD" \
    --env TestCaseDefinitionSettings__RootPath="$TEST_CASE_ROOT_PATH" \
    --env TestCaseDefinitionSettings__FileSystem="$TEST_CASE_FILE_SYSTEM" \
    --env GcpSettings__CredentialFile="$GCP_CREDENTIAL_FILE" \
    gcr.io/clgx-rqebuild-app-dev-1898/${NAME}:${TAG}

#!/usr/bin/env bash

DOCKER_IMAGE="jiangxianliang/ckb-build:latest"
if [[ `uname` == 'Darwin' ]]
then
    cp /etc/localtime $PWD/localtime
    LOCALTIME_PATH="$PWD/localtime"
else
    LOCALTIME_PATH="/etc/localtime"
fi

docker_bin=$(which docker)
if [ -z "${docker_bin}" ]; then
    echo "Command not found, install docker first."
    exit 1
else
    docker version > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Run docker version failed, Maybe docker service not running or current user not in docker user group."
        exit 2
    fi
fi

docker pull ${DOCKER_IMAGE}
SOURCE_DIR=`pwd`
CONTAINER_NAME="ckb_build${SOURCE_DIR//\//_}"
WORKDIR=/opt/ckb

docker ps | grep ${CONTAINER_NAME} > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "restart docker container ${CONTAINER_NAME} "
    docker rm -f $(docker ps -a -q -f "name=${CONTAINER_NAME}")
    docker run -d -it \
           --volume ${SOURCE_DIR}:${WORKDIR} \
           --workdir ${WORKDIR} \
           --name ${CONTAINER_NAME} ${DOCKER_IMAGE}
else
    echo "Start docker container ${CONTAINER_NAME} ..."
    docker rm ${CONTAINER_NAME} > /dev/null 2>&1

    docker run -d -it \
           --volume ${SOURCE_DIR}:${WORKDIR} \
           --workdir ${WORKDIR} \
           --name ${CONTAINER_NAME} ${DOCKER_IMAGE} 
    sleep 3
fi

if [ $# -gt 0 ]; then
    echo 0
    docker exec ${CONTAINER_NAME} "$@"
fi


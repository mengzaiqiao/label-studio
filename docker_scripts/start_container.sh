#!/bin/bash

# Get the container name
source variables.sh

# Get the command-line parameters
ARG_MODE=${1:--n}
ARG_PORT=${2:-8080}

# Create a tmp folder in /tmp
mkdir -p /tmp/$IMAGE_NAME

# Parameter for docker run
WORKDIR="/home/$DOCKER_USER"
VOLUMES="-v $(pwd)/../${PROJECT_NAME}:${WORKDIR}/${PROJECT_NAME}"
NAME="--name ${CONTAINER_NAME} ${IMAGE_NAME}"
USER="--user $(id -u):$(id -g)"
PORT="-p ${ARG_PORT}:8080"

# Check the the port is valid
if [ $# -eq 2 ]; then
	if ! [[ ${ARG_PORT} =~ ^[0-9]+$ ]] ; then
		echo "The provided port must be a positive integer."
		exit 1 
    fi
fi

# Run the container in detached mode
if [ $# -eq 1 ] || [ $# -eq 2 ]; then
    if [ "$ARG_MODE" == "-d" ]; then
        echo ${DOCKER_BIN} run -d ${PORT} ${USER} ${VOLUMES} ${NAME} label-studio start $PROJECT_NAME --init
        ${DOCKER_BIN} run -d ${PORT} ${USER} ${VOLUMES} ${NAME} label-studio start $PROJECT_NAME --init
        exit 0
    fi
fi

# Run the container in notebook mode
if [ $# -eq 1 ] || [ $# -eq 2 ]; then
    if [ "$ARG_MODE" == "-n" ]; then
        echo ${DOCKER_BIN} run --rm ${PORT} ${USER} ${VOLUMES} ${NAME} label-studio start $PROJECT_NAME --init
        ${DOCKER_BIN} run --rm ${PORT} ${USER} ${VOLUMES} ${NAME} label-studio start $PROJECT_NAME --init
        exit 0
    fi
fi

# Run the container in interactive mode
if [ $# -eq 0 ] || [ $# -eq 1 ] || [ $# -eq 2 ]; then
    if [ "$ARG_MODE" == "-i" ]; then
		echo ${DOCKER_BIN} run -it --rm ${PORT} ${USER} ${VOLUMES} ${NAME}
        ${DOCKER_BIN} run -it --rm ${PORT} ${USER} ${VOLUMES} ${NAME}
		exit 0
    fi
fi

echo "start_container.sh MODE PORT: starts the container in interactive mode"
echo
echo "Modes:"
echo "  -i: (default) Starts the container in interactive mode"
echo "  -n: Starts the container with the notebook server"
echo "  -d:	Starts the container (with the notebook server) in detached mode"
echo ""
echo "Port: binds the port used by the notebook server to the specified port in the host (default:8888)"
echo ""
echo "Example:"
echo "start_container.sh -n 8880	:	Starts the container and the notebook server, binding the notebook server to the port 8880"
echo ""
exit 1



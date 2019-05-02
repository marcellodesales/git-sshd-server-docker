#!/usr/bin/env bash

# Colors
green=`tput setaf 2`
red=`tput setaf 1`
yellow=`tput setaf 3`
blue=`tput setaf 4`
reset=`tput sgr0`
CURRENT_SCRIPT=$(basename "$0")

source .env

echo ""
echo "${red}##### GIT + SSHD SERVER ${VERSION} #####${yellow}"
echo ""
date
echo ""
echo "${green}* Setting up a Git Server"
echo ""

echo "${red}==========--------- Building the new docker image -----------=========="
echo ""
echo "${green}* docker-compose build${yellow}"
echo ""
docker-compose build
echo ""

DOCKER_IMAGE=$(docker-compose config | grep image: | awk '{print $2}')

echo "${red}==========--------- Start a new Git Server -----------=========="
echo ""
echo "${green}* docker-compose up -d${yellow}"
echo ""
docker-compose stop && docker-compose up -d
echo ""

GIT_PEM_PATH=$(pwd)/.id_rsa_from_git_server
CONTAINER_NAME=$(docker ps --format '{{.Names}}' | grep git-ssh)

echo "${red}==========--------- Copying credentials from Git server Container -----------=========="
echo ""
echo "${green}* Copying the key file ${yellow}id_rsa private${green} from the Git Server" 
echo "${yellow}* docker cp ${CONTAINER_NAME}:/home/git/.ssh/id_rsa ${GIT_PEM_PATH}"
echo ""
docker cp ${CONTAINER_NAME}:/home/git/.ssh/id_rsa ${GIT_PEM_PATH}
echo ""

date
echo "${green}"
echo "* Finished setting up the server..."
echo "* Now you can run tests with test.sh copying the command below:"
echo ""
echo "${yellow}GIT_PEM_PATH=${GIT_PEM_PATH} ./test.sh"
echo ""

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
echo "${red}##### GIT REPO SETUP #####${yellow}"
echo ""
date
echo ""
echo "${red}==========--------- Git Repo Local -----------=========="
echo ""

echo "${green}* Current Dir: ${yellow}$(pwd)"
echo ""
ls -la
echo ""

echo "${red}==========--------- Add test Remote -----------=========="
echo ""

echo "${green}* Adding the git origin to current directory with server at ${yellow}$(ipconfig getifaddr en0)"
echo ""
git remote remove test || true
git remote add test git@$(ipconfig getifaddr en0):test.git

echo "${red}==========--------- Git Show test remote -----------=========="
echo ""

echo "${green}* Conectivity with the repo..."
echo "${yellow}GIT_SSH_COMMAND=\"ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 52311 -i ${GIT_PEM_PATH}\" git remote show test"
echo ""
GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 52311 -i ${GIT_PEM_PATH}" git remote show test
echo ""

echo "${red}==========--------- Git push test -----------=========="
echo ""
echo "${green}* Executing 'git push' to test github simulator"
echo "${yellow}GIT_SSH_COMMAND=\"ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 52311 -i ${GIT_PEM_PATH}\" git push -u test master"
GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 52311 -i ${GIT_PEM_PATH}" git push -u test master
echo ""

if [ ! -z "${BRANCH}" ]; then
  echo ""
  echo "${green}* Testing additional branch ${yellow}${BRANCH}"
  echo "GIT_SSH_COMMAND=\"ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 52311 -i ${GIT_PEM_PATH}\" git push test ${BRANCH} -f"
  GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 52311 -i ${GIT_PEM_PATH}" git push test ${BRANCH} -f
fi

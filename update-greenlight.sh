#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${green}Updating greenlight...${reset}"
read -p "${red}Are you sure?${reset} " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # do dangerous stuff
    docker-compose down
    ./scripts/image_build.sh perfectice-bbb release-v2
    docker-compose up -d
fi


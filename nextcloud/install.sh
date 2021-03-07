#!/usr/bin/env bash

#[[ $(docker -v) ]] || ( echo "Docker not installed. Check https://docs.docker.com/get-docker/ for installation instructions." ; exit 99 )
#[[ $(docker-compose -v) ]] || ( echo "Docker Compose not installed. Check https://docs.docker.com/compose/install/ for installation instructions." ; exit 99 )

if [[ ! $(docker -v) ]]; then
  echo "Docker not found. Installing.."
  echo
  if [[ ! $(apt -v) ]]; then
    sudo pacman -S docker
  else
    sudo apt update
    sudo apt install docker
  fi
fi

if [[ ! $(docker-compose -v) ]]; then
  echo "Docker Compose not found. Installing.."
  echo
  if [[ ! $(apt -v) ]]; then
    sudo pacman -S docker-compose
  else
    sudo apt install docker-compose
  fi
fi

basedir="$(dirname $(readlink -f $0))"
echo "basedir=$basedir" > $basedir/docker/.env

read -p "Please specify full path of data directory for Nextcloud and DB. (default: $basedir): "
if [[ -d $REPLY ]]; then
  basedir=$REPLY
fi

sed -i "s|/data/nextcloud|$basedir|g" $basedir/docker/nextcloud-docker.service
sudo cp $basedir/docker/nextcloud-docker.service /etc/systemd/system/

sudo systemctl enable nextcloud-docker.service
sudo systemctl start nextcloud-docker.service


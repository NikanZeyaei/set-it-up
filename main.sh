#!/bin/bash

source "packages.sh"
source "docker.sh"
source "dotfiles.sh"

install_packages
setup_docker
setup_dotfiles

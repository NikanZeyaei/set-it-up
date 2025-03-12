#!/bin/bash

source ./utils/log.sh

setup_docker() {
    __setup_service
    __setup_user_group
}

__setup_service() {
    log "Setting up docker service"
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
    log "Finished Setting up docker service"
}

__setup_user_group() {
    log "Setting up docker user group"
    sudo usermod -aG docker $USER
    log "Finished Setting up docker user group (you may need to logout once)"
}

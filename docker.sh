#!/bin/bash

setup_docker() {
    __setup_service
    __setup_user_group
}

__setup_service() {
    echo "Setting up docker service"
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
    echo "Finished Setting up docker service"
}

__setup_user_group() {
    echo "Setting up docker user group"
    sudo usermod -aG docker $USER
    echo "Finished Setting up docker user group (you may need to logout once)"
}

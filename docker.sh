#!/bin/bash

setup_docker() {
    echo "Setting up docker service"
    sudo systemctl start docker.service
    sudo systemctl enable docker.service

    echo "Setting up docker user group (you may need to logout once)"
    sudo usermod -aG docker $USER
}

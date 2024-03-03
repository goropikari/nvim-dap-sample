# FROM mcr.microsoft.com/vscode/devcontainers/cpp:vscode-22.04
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends build-essential gdb git sudo wget curl ca-certificates ssh unzip

# Add user
RUN echo 'ubuntu:foobar' | chpasswd
RUN echo 'Defaults visiblepw'            >> /etc/sudoers
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ubuntu

ENV PATH $PATH:/home/ubuntu/.local/bin

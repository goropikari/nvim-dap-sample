FROM mcr.microsoft.com/devcontainers/base:bullseye

ENV DEBIAN_FRONTEND=noninteractive \
    DELVE_VERSION=v1.22.0
RUN sudo apt-get update && sudo apt-get upgrade -y
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs bash-completion

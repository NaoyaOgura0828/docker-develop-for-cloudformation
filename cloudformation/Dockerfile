# Set the base image
ARG BASE_IMAGE_TAG=${BASE_IMAGE_TAG}
FROM rockylinux:${BASE_IMAGE_TAG}

# Set ARG
ARG TZ=Asia/Tokyo
ARG USER_NAME=${USER_NAME}

# Set TimeZone
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# Repository Update
RUN dnf update -y

# Install Packages
RUN dnf install git -y &&\
    dnf install jq -y &&\
    dnf install sudo -y &&\
    dnf install unzip -y

# Install awscliv2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&\
    unzip awscliv2.zip &&\
    ./aws/install &&\
    rm awscliv2.zip

# Add User
RUN adduser ${USER_NAME} --badname

# Setup to use sudo without password
RUN echo "${USER_NAME} ALL=NOPASSWD: ALL" >> /etc/sudoers

# Setup WORKDIR
WORKDIR /home/${USER_NAME}

# Change User
USER ${USER_NAME}

# Setup alias
COPY ./.alias /home/${USER_NAME}/
RUN cat ~/.alias >> ~/.bashrc &&\
    rm .alias

# Create .aws files
RUN mkdir ~/.aws &&\
    touch ~/.aws/config &&\
    touch ~/.aws/credentials &&\
    chmod 600 ~/.aws/config &&\
    chmod 600 ~/.aws/credentials

# Deploy aws_cli_credentials_manager.sh
COPY ./aws_cli_credentials_manager.sh /home/${USER_NAME}/.aws/
RUN sudo chown ${USER_NAME}:${USER_NAME} ~/.aws/aws_cli_credentials_manager.sh &&\
    chmod 700 ~/.aws/aws_cli_credentials_manager.sh

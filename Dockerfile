FROM rockylinux:9.0

# Execution user name after container startup
ARG USER_NAME

# Repository Update
RUN dnf update -y

# sudo Install
RUN dnf install sudo -y

# unzip Install
RUN dnf install unzip -y

# awscliv2 Install
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm awscliv2.zip

# Add User
RUN adduser ${USER_NAME} --badnames

# Setup to use sudo without password
RUN echo "${USER_NAME} ALL=NOPASSWD: ALL" | tee /etc/sudoers

ENTRYPOINT tail -f /dev/null
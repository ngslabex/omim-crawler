FROM ubuntu:20.04

SHELL [ "/bin/bash", "-c" ]

RUN apt-get update -y && apt-get install -y sudo python python3 python3-pip curl

RUN useradd -m ubuntu && \
    usermod -aG sudo ubuntu && \
    echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    cp /root/.bashrc /home/ubuntu/ && \
    mkdir /home/ubuntu/omim-crawler && \
    chown -R --from=root ubuntu /home/ubuntu
WORKDIR /home/ubuntu
ENV HOME /home/ubuntu
ENV USER ubuntu
USER ubuntu
ENV PATH /home/ubuntu/.local/bin:$PATH
# Avoid first use of sudo warning. c.f. https://askubuntu.com/a/22614/781671
RUN touch $HOME/.sudo_as_admin_successful

COPY requirements.txt .

RUN python3 -m pip install --no-cache-dir -r requirements.txt

ENV NVM_DIR=/home/ubuntu/nvm

ENV NODE_VERSION=24.2.0

ENV NODE_ENV=dev

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.40.3/install.sh | bash && \
    source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION \
    && nvm use $NODE_VERSION

ENV NODE_PATH=/home/ubuntu/nvm/v24.2.0/lib/node_modules

ENV PATH=/home/ubuntu/nvm/versions/node/v24.2.0/bin:$PATH


WORKDIR /home/ubuntu/omim-crawler

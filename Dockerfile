FROM ubuntu:22.04

# Set environment variables
ARG AWS_REGION=us-east-1
ARG AWS_PROFILE=default
ENV AWS_REGION=${AWS_REGION}
ENV AWS_PROFILE=${AWS_PROFILE}

ARG NODE_VERSION=20.17.0
ARG PYTHON_VERSION=3.12.9

ENV NODE_VERSION=${NODE_VERSION}
ENV PYTHON_VERSION=${PYTHON_VERSION}

ENV PYENV_ROOT=/root/.pyenv
ENV PATH=/root/.nvm/versions/node/v${NODE_VERSION}/bin:/root/.pyenv/bin:/root/.pyenv/shims:${PATH}
ENV TZ=UTC
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Pre-configure timezone to avoid prompts
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /app

RUN apt update && apt install -y build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash && \
    . $HOME/.nvm/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    ln -s "$(which node)" /usr/local/bin/node && \
    ln -s "$(which npm)" /usr/local/bin/npm

RUN curl https://pyenv.run | bash
RUN pyenv install $PYTHON_VERSION && pyenv global $PYTHON_VERSION && exec $SHELL
RUN pip3 install pipenv && \
    pip3 install virtualenv && \
    ln -s /root/.local/bin/pipenv /usr/local/bin/pipenv     

RUN apt install unzip -y && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && rm awscliv2.zip && \
    ./aws/install && rm -rf ./aws && \
    exec $SHELL && \
    npm install -g @aws-amplify/cli 


# VOLUME [ "/app", "/root/.aws", "/root/.amplify" ]

# Keep container running
CMD ["/bin/bash"] 



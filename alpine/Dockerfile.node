FROM node:alpine
LABEL maintainer="Erwan BERNARD https://github.com/edmBernard/DockerFiles"

RUN apk update && apk --no-cache add \
        linux-headers \
        nano wget \
        gcc \
        make \
        musl-dev \
        tar \
        python3 \
        py-numpy \
        yarn && \
    rm -fr /var/cache/apk/*

# configuration
ENV HOME "/home/dev"
RUN mkdir -p "$HOME"

ENV LIB_DIR "$HOME/lib"
RUN mkdir -p "$LIB_DIR"

WORKDIR $HOME/host

RUN echo "PS1='\[\033[1;36m\]alpine\[\033[00m\] \[\033[34m\]\u@\h\[\033[00m\]:\[\033[36m\]\w\[\033[00m\]$ '" > /etc/profile.d/shrc.sh

CMD ["/bin/sh","--login"]

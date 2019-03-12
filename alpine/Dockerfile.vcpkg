FROM alpine:latest
LABEL maintainer="Erwan BERNARD https://github.com/edmBernard/DockerFiles"

RUN apk update && apk --no-cache add \
        linux-headers \
        nano wget \
        gcc \
        g++ \
        make \
        cmake \
        musl-dev \
        curl unzip tar \
        git \
        ninja \
        && \
    rm -fr /var/cache/apk/*

# configuration
ENV HOME "/home/dev"
RUN mkdir -p "$HOME"

ENV LIB_DIR "$HOME/lib"
RUN mkdir -p "$LIB_DIR"

# install vcpkg for local folder
RUN cd $LIB_DIR && \
    git clone https://github.com/Microsoft/vcpkg.git && cd vcpkg && \
    ./bootstrap-vcpkg.sh -useSystemBinaries&& \
    ./vcpkg integrate install

COPY x64-linux-musl.cmake $LIB_DIR/vcpkg/triplets/

# To install new libraries
# RUN cd $LIB_DIR/vcpkg && \
#     VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install orc

WORKDIR $HOME/host

RUN echo "PS1='\[\033[1;36m\]alpine\[\033[00m\] \[\033[34m\]\u@\h\[\033[00m\]:\[\033[36m\]\w\[\033[00m\]$ '" > /etc/profile.d/shrc.sh

CMD ["/bin/sh","--login"]

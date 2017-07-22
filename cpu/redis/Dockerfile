FROM opencv:latest
MAINTAINER Erwan BERNARD

# follow the tuto from here : https://redis.io/topics/quickstart

ENV REDIS_DIR "$LIB_DIR/redis-stable"

RUN cd "$LIB_DIR" && \
    wget http://download.redis.io/redis-stable.tar.gz && \
    tar xvzf redis-stable.tar.gz && \
    rm redis-stable.tar.gz && \
    cd "$REDIS_DIR" && \
    make -j"$(nproc)" && \
    make install

# install python2 tools
RUN pip2 --no-cache-dir install \
        redis

# install python3 tools
RUN pip3 --no-cache-dir install \
        redis

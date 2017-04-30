FROM gpu_opencv:latest
MAINTAINER Erwan BERNARD

# follow the tuto from here : https://redis.io/topics/quickstart

RUN mkdir -p "/home/dev/lib"

RUN cd /home/dev/lib && \
    wget http://download.redis.io/redis-stable.tar.gz && \
    tar xvzf redis-stable.tar.gz && \
    cd redis-stable && \
    make -j"$(nproc)" && \
    make install

# install python2 tools
RUN pip2 --no-cache-dir install \
        redis

# install python3 tools
RUN pip3 --no-cache-dir install \
        redis

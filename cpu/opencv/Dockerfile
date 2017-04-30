FROM ffmpeg:latest
MAINTAINER Erwan BERNARD

# Pick up some dependencies
RUN apt-get update && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p "/home/dev/lib/opencv"
ENV OPENCV_DIR "/home/dev/lib/opencv"

# download opencv3
WORKDIR "/"
RUN cd $OPENCV_DIR && \
    wget https://github.com/opencv/opencv/archive/master.zip && \
    unzip master.zip && \
    rm master.zip
    # git clone https://github.com/opencv/opencv.git  <-- don't work anymore : GnuTLS recv error

# download opencv3 contrib
RUN cd $OPENCV_DIR && \
    wget https://github.com/opencv/opencv_contrib/archive/master.zip && \
    unzip master.zip && \
    rm master.zip
    # git clone https://github.com/opencv/opencv_contrib.git  <-- don't work anymore : GnuTLS recv error

# build opencv3
# warning if we set BUILD_EXAMPLES=OFF cmake don't find IPP anymore (strange)
RUN cd $OPENCV_DIR/opencv-master && mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=$OPENCV_DIR/opencv_contrib-master/modules \
    -D BUILD_EXAMPLES=OFF \
    -D WITH_IPP=ON ..

# install opencv3
WORKDIR "$OPENCV_DIR/opencv-master/build"
RUN cd "$OPENCV_DIR/opencv-master/build" && \
    make -j$(nproc) && \
    make install && \
    /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf' && \
    ldconfig

# link ippicv
RUN ln -s $OPENCV_DIR/opencv-master/3rdparty/ippicv/unpack/ippicv_lnx/lib/intel64/libippicv.a /usr/local/lib/libippicv.a

CMD ["/bin/bash"]

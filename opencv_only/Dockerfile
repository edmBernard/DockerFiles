FROM ubuntu:16.04
MAINTAINER Erwan BERNARD

# Pick up some dependencies
RUN apt-get update && apt-get install -y \
        build-essential cmake git nano \
        curl wget rsync unzip \
        libboost-all-dev \
        pkg-config \
        libfreetype6-dev \
        libpng-dev \
        libzmq3-dev \
        libavutil-dev \
        libjpeg8-dev \
        libtiff-dev \
        libjasper-dev \
        libgtk2.0-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libv4l-dev \
        libatlas-base-dev \
        python \
        python-dev \
        python-numpy \
        python-scipy \
        python3 \
        python3-dev \
        python3-numpy \
        python3-scipy \
        python-setuptools \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install pip for python2 and 3
RUN wget https://bootstrap.pypa.io/get-pip.py --no-check-certificate && \
    python get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

# install python2 tools
RUN pip2 --no-cache-dir install \
        numpy \
        ipython \
        ipykernel \
        jupyter \
        matplotlib \
        scipy \
        scikit-image \
        docopt \
        path.py \
        && \
    python2 -m ipykernel install

# install python3 tools
RUN pip3 --no-cache-dir install \
        numpy \
        ipython \
        ipykernel \
        jupyter \
        matplotlib \
        scipy \
        scikit-image \
        docopt \
        path.py \
        && \
    python3 -m ipykernel install

RUN ldconfig

# download opencv3
WORKDIR "/"
RUN cd / && \
    git clone https://github.com/opencv/opencv.git

# download opencv3 contrib
RUN cd / && \
    git clone https://github.com/opencv/opencv_contrib.git

# build opencv3
# warning if we set BUILD_EXAMPLES=OFF cmake don't find IPP anymore (strange)
RUN cd /opencv && mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON \
    -D WITH_IPP=ON ..

# install opencv3
WORKDIR "/opencv/build"
RUN make -j$(nproc)
RUN make install
RUN /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
RUN ldconfig

# link ippicv
RUN ln -s /opencv/3rdparty/ippicv/unpack/ippicv_lnx/lib/intel64/libippicv.a /usr/local/lib/libippicv.a

WORKDIR "/shared"

CMD ["/bin/bash"]



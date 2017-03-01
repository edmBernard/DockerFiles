FROM gcr.io/tensorflow/tensorflow:latest-devel-gpu
MAINTAINER Erwan BERNARD

RUN apt-get update && apt-get install -y \
        unzip wget build-essential cmake git nano \
        libavutil-dev \
        libjpeg8-dev \
        libtiff-dev \
        libjasper-dev \
        libpng-dev \
        libgtk2.0-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libv4l-dev \
        libatlas-base-dev \
        gfortran \
        pkg-config \
        python \
        python-dev \
        python2.7 \
        python2.7-dev \
        python-numpy \
        python-scipy \
        python3 \
        python3-dev \
        python3-numpy \
        python3-scipy \
        rsync \
        python-setuptools \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install pip for python2 and 3
RUN wget https://bootstrap.pypa.io/get-pip.py --no-check-certificate && \
    python2 get-pip.py && \
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

# install ffmpeg
RUN apt-get update &&\
    apt-get install -y ffmpeg

# download opencv3
WORKDIR "/"
RUN cd / && \
    wget https://github.com/opencv/opencv/archive/master.zip && \
    unzip master.zip && \
    rm master.zip
    # git clone https://github.com/opencv/opencv.git  <-- don't work anymore : GnuTLS recv error

# download opencv3 contrib
RUN cd / && \
    wget https://github.com/opencv/opencv_contrib/archive/master.zip && \
    unzip master.zip && \
    rm master.zip
    # git clone https://github.com/opencv/opencv_contrib.git  <-- don't work anymore : GnuTLS recv error

# build opencv3
# warning if we set BUILD_EXAMPLES=OFF cmake don't find IPP anymore (strange)
RUN cd /opencv-master && mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib-master/modules \
    -D BUILD_EXAMPLES=OFF \
    -D WITH_IPP=ON ..

# install opencv3
WORKDIR "/opencv-master/build"
RUN make -j$(nproc)
RUN make install
RUN /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
RUN ldconfig

# link ippicv
RUN ln -s /opencv-master/3rdparty/ippicv/unpack/ippicv_lnx/lib/intel64/libippicv.a /usr/local/lib/libippicv.a

WORKDIR "/shared"

CMD ["/bin/bash"]



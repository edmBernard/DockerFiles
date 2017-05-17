FROM ubuntu:16.04
MAINTAINER Erwan BERNARD

# Pick up some dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        build-essential cmake git nano \
        curl wget rsync unzip \
        libboost-all-dev \
        pkg-config \
        libgtk2.0-dev \
        # image codec
        libfreetype6-dev \
        libpng-dev \
        libzmq3-dev \
        libjpeg-dev \
        libjpeg8-dev \
        libtiff-dev \
        libjasper-dev \
        # library for video format convertion YUV ...
        libv4l-dev v4l-utils \
        # camera control
        libdc1394-22 libdc1394-22-dev \
        # Lapack
        libatlas-base-dev \
        # python
        python \
        python-dev \
        python-numpy \
        python-scipy \
        python-tk \
        python3 \
        python3-dev \
        python3-numpy \
        python3-scipy \
        python3-tk \
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
        matplotlib \
        scipy \
        scikit-image \
        docopt \
        schema \
        path.py \
        request \
        bottle \
        tornado \
        ipython \
        ipykernel \
        jupyter \
        && \
    python2 -m ipykernel install

# install python3 tools
RUN pip3 --no-cache-dir install \
        numpy \
        matplotlib \
        scipy \
        scikit-image \
        docopt \
        schema \
        path.py \
        addict \
        request \
        bottle \
        tornado \
        ipython \
        ipykernel \
        jupyter \
        && \
    python3 -m ipykernel install

RUN ldconfig

# configuration
RUN mkdir /home/dev
WORKDIR /home/dev/host
ENV HOME /home/dev
# RUN useradd dev && chown -R dev: /home/dev
# USER dev

RUN ln -snf /bin/bash /bin/sh
RUN cp /root/.bashrc /home/dev/.bashrc && \
    sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' ~/.bashrc

CMD ["/bin/bash"]

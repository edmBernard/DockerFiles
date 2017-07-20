FROM redis:latest
MAINTAINER Erwan BERNARD

RUN mkdir -p "/home/dev/lib"
ENV MXNET_DIR /home/dev/lib/mxnet

# Install git and other dependencies
RUN apt-get update && apt-get install -y \
  libopenblas-dev

# install python2 tools
RUN pip2 --no-cache-dir install -U \
    easydict

# install python3 tools
RUN pip3 --no-cache-dir install -U \
    easydict

# Clone MXNet repo and move into it
RUN cd /home/dev/lib && git clone --recursive https://github.com/dmlc/mxnet && cd mxnet && \
# Copy config.mk
    cp make/config.mk config.mk && \
# Set OpenBLAS
    sed -i 's/USE_BLAS = atlas/USE_BLAS = openblas/g' config.mk && \
# Make 
    make -j"$(nproc)"

# fix setup.py for gluon installation
RUN cd /home/dev/lib/mxnet/python && \
    sed -i "s/'mxnet._cy2', 'mxnet._cy3', 'mxnet.notebook', 'mxnet.contrib'/'mxnet._cy2', 'mxnet._cy3', 'mxnet.notebook', 'mxnet.contrib', 'mxnet.gluon', 'mxnet.gluon.nn', 'mxnet.gluon.rnn'/g" setup.py

# Install Python package
RUN cd /home/dev/lib/mxnet/python && python2 setup.py install
RUN cd /home/dev/lib/mxnet/python && python3 setup.py install

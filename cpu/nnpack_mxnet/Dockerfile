FROM redis:latest
MAINTAINER Erwan BERNARD

RUN mkdir -p "/home/dev/lib"
#ENV NNPACK_DIR /home/dev/lib/NNPACK

# Install git and other dependencies
RUN apt-get update && apt-get install -y \
  libopenblas-dev \
  ninja-build

# install python2 tools
RUN pip2 --no-cache-dir install -U \
    easydict \
    ninja-syntax

# install python3 tools
RUN pip3 --no-cache-dir install -U \
    easydict

# Install Peach
RUN cd /home/dev/lib && git clone https://github.com/Maratyszcza/PeachPy.git && cd PeachPy && \
    pip2 install --upgrade -r requirements.txt && \
    python2 setup.py generate && \
    pip2 install --upgrade .

# Build NNPack shared library
# Latest NNPACK do not support building NNPACK as shared library using --enable-shared flag
# Reset to commit that supports it.
RUN cd /home/dev/lib && git clone --recursive https://github.com/Maratyszcza/NNPACK.git && cd NNPACK && \
    git reset --hard 9c6747d7b80051b40e6f92d6828e2ed997529cd2 && \
    git submodule init && git submodule update --recursive && \
    python ./configure.py --enable-shared && \
    ninja

# ENV LD_LIBRARY_PATH "/home/dev/lib/NNPACK/lib:${LD_LIBRARY_PATH}"
RUN /bin/bash -c 'echo "/home/dev/lib/NNPACK/lib" > /etc/ld.so.conf.d/nnpack.conf'
RUN ldconfig

# Clone MXNet repo and move into it
RUN cd /home/dev/lib && git clone --recursive https://github.com/dmlc/mxnet && cd mxnet && \
# Copy config.mk
    cp make/config.mk config.mk && \
# Set OpenBLAS
    sed -i 's/USE_BLAS = atlas/USE_BLAS = openblas/g' config.mk && \
# Set NNPACK 
    sed -i 's/ADD_CFLAGS =/ADD_CFLAGS = -I\/home\/dev\/lib\/NNPACK\/include\/ -I\/home\/dev\/lib\/NNPACK\/third-party\/pthreadpool\/include\//g' config.mk && \
    sed -i 's/ADD_LDFLAGS =/ADD_LDFLAGS = -L\/home\/dev\/lib\/NNPACK\/lib/g' config.mk && \
    sed -i 's/USE_NNPACK = 0/USE_NNPACK = 1/g' config.mk && \
# Make
    make -j"$(nproc)"

# Install Python package
RUN cd /home/dev/lib/mxnet/python && python2 setup.py install
RUN cd /home/dev/lib/mxnet/python && python3 setup.py install

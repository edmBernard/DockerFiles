# Start with cuDNN base image
FROM cuda75_cudnn5_opencv3:latest

# Install git and other dependencies
RUN apt-get update && apt-get install -y \
  libopenblas-dev

# install python2 tools
RUN pip2 --no-cache-dir install -U \
    scikit-image \
    easydict \

# install python3 tools
RUN pip3 --no-cache-dir install -U \
    scikit-image \
    easydict

# Clone MXNet repo and move into it
RUN cd /root && git clone --recursive https://github.com/dmlc/mxnet && cd mxnet && \
# Copy config.mk
    cp make/config.mk config.mk && \
# Set OpenBLAS
    sed -i 's/USE_BLAS = atlas/USE_BLAS = openblas/g' config.mk && \
# Set CUDA flag
    sed -i 's/USE_CUDA = 0/USE_CUDA = 1/g' config.mk && \
    sed -i 's/USE_CUDA_PATH = NONE/USE_CUDA_PATH = \/usr\/local\/cuda/g' config.mk && \
# Set cuDNN flag
    sed -i 's/USE_CUDNN = 0/USE_CUDNN = 1/g' config.mk && \
# Make 
    make -j"$(nproc)"

# Install Python package
RUN cd /root/mxnet/python && python setup.py install

# Jupyter
EXPOSE 8888

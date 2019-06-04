FROM redis_gpu:latest
LABEL maintainer="Erwan BERNARD https://github.com/edmBernard/DockerFiles"

# install python3 tools
RUN pip3 --no-cache-dir install -U \
    pandas \
    sklearn \
    h5py \
    onnx protobuf

# tensorflow 1.13 does not support cuda 10.1 : https://www.tensorflow.org/install/source#linux
RUN pip3 --no-cache-dir install tf-nightly-gpu

# Keras
RUN pip3 --no-cache-dir install git+https://github.com/fchollet/keras.git

# Set Tensorflow backend for Keras
ENV KERAS_BACKEND=tensorflow

CMD ["/bin/bash"]

FROM redis_cpu:latest
LABEL maintainer="Erwan BERNARD https://github.com/edmBernard/DockerFiles"

RUN pip3 --no-cache-dir install https://download.pytorch.org/whl/cpu/torch-1.1.0-cp36-cp36m-linux_x86_64.whl
RUN pip3 --no-cache-dir install https://download.pytorch.org/whl/cpu/torchvision-0.3.0-cp36-cp36m-linux_x86_64.whl
RUN pip3 --no-cache-dir install onnx protobuf future

CMD ["/bin/bash"]

# Build from source
# /!\ I was not able to activte mkl integration in compilation from source

# ENV PYTORCH_DIR "$LIB_DIR/pytorch"
# ENV PYTORCHVISION_DIR "$LIB_DIR/vision"

# # Install git and other dependencies
# RUN apt-get update && apt-get install -y \
#     libopenblas-dev

# # install python2 tools
# RUN pip2 --no-cache-dir install -U \
#     pyyaml mkl cffi

# # install python3 tools
# RUN pip3 --no-cache-dir install -U \
#     pyyaml mkl cffi

# # Clone Pytorch repo and move into it
# RUN cd "$LIB_DIR" && git clone --recursive https://github.com/pytorch/pytorch

# # Install Python package
# RUN cd "$PYTORCH_DIR" && python3 setup.py install

# # Install pytorch_vision
# RUN cd "$LIB_DIR" && git clone https://github.com/pytorch/vision.git

# RUN cd "$PYTORCHVISION_DIR" && python3 setup.py install

# CMD ["/bin/bash"]

FROM mxnet_cpu:latest
LABEL maintainer="Erwan BERNARD https://github.com/edmBernard/DockerFiles"

ENV NNVM_DIR "$LIB_DIR/nnvm"

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-5.0 main" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    llvm-5.0 \
    llvm-5.0-dev \
    llvm-5.0-doc \
    llvm-5.0-examples \
    llvm-5.0-runtime \
    clang-5.0 \
    clang-5.0-doc \
    libclang-common-5.0-dev \
    libclang-5.0-dev \
    libclang1-5.0 \
    libclang1-5.0-dbg \
    libllvm5.0 \
    libllvm5.0-dbg \
    lldb-5.0 \
    clang-format-5.0 \
    python-clang-5.0 \
    libfuzzer-4.0-dev \
    opencl-headers \
    beignet beignet-dev

# Clone NNVM repo and compile
RUN cd "$LIB_DIR" && git clone --recursive https://github.com/dmlc/nnvm

RUN cd  "$LIB_DIR/nnvm/tvm" && \
    cp make/config.mk config.mk && \
    sed -i "s|# LLVM_CONFIG = llvm-config|LLVM_CONFIG = llvm-config-5.0|g" config.mk && \
    sed -i "s|USE_BLAS = none|USE_BLAS = openblas|g" config.mk && \
    sed -i "s|USE_OPENCL = 0|USE_OPENCL = 1|g" config.mk && \
    make -j"$(nproc)" && \
    make install

RUN cd  "$LIB_DIR/nnvm" && \
    cp make/config.mk config.mk && \
    make -j"$(nproc)"

# Install Python package
RUN cd "$LIB_DIR/nnvm/tvm/topi/python" && python2 setup.py install
RUN cd "$LIB_DIR/nnvm/tvm/topi/python" && python3 setup.py install
RUN cd "$LIB_DIR/nnvm/tvm/python" && python2 setup.py install
RUN cd "$LIB_DIR/nnvm/tvm/python" && python3 setup.py install
RUN cd "$LIB_DIR/nnvm/python" && python2 setup.py install
RUN cd "$LIB_DIR/nnvm/python" && python3 setup.py install

CMD ["/bin/bash"]

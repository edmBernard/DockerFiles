FROM mxnet_cpu:latest
LABEL maintainer="Erwan BERNARD https://github.com/edmBernard/DockerFiles"

ENV NNVM_DIR "$LIB_DIR/nnvm"

RUN echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    clang-4.0 \
    clang-4.0-doc \
    libclang-common-4.0-dev \
    libclang-4.0-dev \
    libclang1-4.0 \
    libclang1-4.0-dbg \
    libllvm-4.0-ocaml-dev \
    libllvm4.0 \
    libllvm4.0-dbg \
    lldb-4.0 \
    llvm-4.0 \
    llvm-4.0-dev \
    llvm-4.0-doc \
    llvm-4.0-examples \
    llvm-4.0-runtime \
    clang-format-4.0 \
    python-clang-4.0 \
    libfuzzer-4.0-dev \ 
    opencl-headers \
    beignet beignet-dev \

# Clone NNVM repo and compile
RUN cd "$LIB_DIR" && git clone --recursive https://github.com/dmlc/nnvm

RUN cd  "$LIB_DIR/nnvm/tvm" && \
    cp make/config.mk config.mk && \
    sed -i "s|LLVM_CONFIG=|LLVM_CONFIG=llvm-config-4.0|g" config.mk && \
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

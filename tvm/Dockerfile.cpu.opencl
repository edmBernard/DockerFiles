FROM redis_cpu:latest
LABEL maintainer="Erwan BERNARD https://github.com/edmBernard/DockerFiles"

ENV TVM_DIR "$LIB_DIR/tvm"

RUN apt-get update && apt-get install -y \
        libopenblas-dev \
        llvm-6.0 \
        llvm-6.0-dev \
        llvm-6.0-doc \
        llvm-6.0-examples \
        llvm-6.0-runtime \
        clang-6.0 \
        clang-6.0-doc \
        libclang-common-6.0-dev \
        libclang-6.0-dev \
        libclang1-6.0 \
        libclang1-6.0-dbg \
        libllvm6.0 \
        libllvm6.0-dbg \
        lldb-6.0 \
        clang-format-6.0 \
        python-clang-6.0 \
        libfuzzer-4.0-dev \
        opencl-headers \
        beignet beignet-dev \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone tvm repo and compile
RUN cd "$LIB_DIR" && git clone --recursive https://github.com/dmlc/tvm

# cmake options were not options but variable in config file
RUN cd  "$TVM_DIR" && \
    mkdir build && cd build && \
    cp ../cmake/config.cmake config.cmake && \
    sed -i 's/USE_LLVM OFF/USE_LLVM ON/' config.cmake && \
    sed -i 's/USE_BLAS none/USE_BLAS openblas/' config.cmake && \
    sed -i 's/USE_OPENCL OFF/USE_OPENCL ON/' config.cmake && \
    cmake .. && \
    make -j"$(nproc)"

RUN pip3 --no-cache-dir install onnx psutil xgboost

ENV PYTHONPATH $TVM_DIR/python:$TVM_DIR/topi/python:$TVM_DIR/nnvm/python:${PYTHONPATH}

CMD ["/bin/bash"]

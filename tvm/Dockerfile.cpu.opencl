FROM redis_cpu:latest
LABEL maintainer="Erwan BERNARD https://github.com/edmBernard/DockerFiles"

ENV TVM_DIR "$LIB_DIR/tvm"

RUN apt-get update && apt-get install -y \
        libopenblas-dev \
        llvm-12 \
        llvm-12-dev \
        llvm-12-runtime \
        clang-12 \
        clang-12-doc \
        libclang-common-12-dev \
        libclang-12-dev \
        libllvm12 \
        lldb-12 \
        clang-format-12 \
        libfuzzer-12-dev \
        opencl-headers \
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

ENV PYTHONPATH $TVM_DIR/python:${PYTHONPATH}

CMD ["/bin/bash"]

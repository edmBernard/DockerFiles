FROM redis:latest
MAINTAINER Erwan BERNARD

ENV NDK_VERSION "android-ndk-r14b"
ENV NDK_TOOLCHAIN_DIR "$LIB_DIR/arm7-toolchain"
ENV OPENBLAS_DIR "$LIB_DIR/OpenBLAS_build"
ENV MXNET_DIR "$LIB_DIR/mxnet"

RUN apt-get update && apt-get upgrade && \
    apt-get install -y \
        openjdk-8-jre \
        openjdk-8-jdk

# Create toolchain
RUN cd "$LIB_DIR" && \ 
    wget https://dl.google.com/android/repository/${NDK_VERSION}-linux-x86_64.zip && \
    unzip ${NDK_VERSION}-linux-x86_64.zip && \
    rm ${NDK_VERSION}-linux-x86_64.zip

RUN $LIB_DIR/${NDK_VERSION}/build/tools/make_standalone_toolchain.py \
    --arch arm --api 21 --install-dir $NDK_TOOLCHAIN_DIR --stl=libc++

# Compile OpenBLAS
ENV PATH "${PATH}:$NDK_TOOLCHAIN_DIR/bin"
RUN cd "$LIB_DIR" && git clone https://github.com/xianyi/OpenBLAS.git && cd OpenBLAS && \
    make -j"$(nproc)" TARGET=ARMV7 HOSTCC=gcc CC=arm-linux-androideabi-gcc NOFORTRAN=1 libs && \ 
    make -j"$(nproc)" PREFIX=$OPENBLAS_DIR; exit 0

# Compile MXNet Amalgamation
ENV PATH "${PATH}:$NDK_TOOLCHAIN_DIR/bin"
ENV CC arm-linux-androideabi-clang  
ENV CXX arm-linux-androideabi-clang++ 

RUN cd "$LIB_DIR" && git clone --recursive https://github.com/dmlc/mxnet && cd mxnet/amalgamation && \
    sed -i "s|/usr/local/opt/openblas|/home/dev/lib/OpenBLAS_build|g" Makefile && \
    sed -i '130i #define fopen64 std::fopen' amalgamation.py && \
    sed -i '1i DEFS += -DMSHADOW_USE_CUDA=0 -DMSHADOW_USE_MKL=0 -DMSHADOW_RABIT_PS=0 -DMSHADOW_DIST_PS=0 -DMSHADOW_USE_SSE=0 -DDMLC_LOG_STACK_TRACE=0 -DMSHADOW_FORCE_STREAM -DMXNET_USE_OPENCV=0 -DMXNET_PREDICT_ONLY=1 -DDISABLE_OPENMP=1' ../nnvm/amalgamation/Makefile && \
    sed -i '4i CFLAGS = -std=c++11 -Wall -O3 -Wno-unknown-pragmas -funroll-loops -Iinclude -fPIC $(DEFS)' ../nnvm/amalgamation/Makefile && \
    make clean && \
    # We can't use multiprocess compilation 
    make ANDROID=1

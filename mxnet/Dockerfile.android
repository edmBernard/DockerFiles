FROM pythonlib_cpu:latest
LABEL maintainer="Erwan BERNARD https://github.com/edmBernard/DockerFiles"

ENV OPENCV_DIR "$LIB_DIR/opencv"
RUN mkdir -p "$OPENCV_DIR"

ENV NDK_VERSION "android-ndk-r14b"
ENV NDK_TOOLCHAIN_DIR "$LIB_DIR/arm7-toolchain"
ENV OPENBLAS_DIR "$LIB_DIR/OpenBLAS_build"
ENV MXNET_DIR "$LIB_DIR/mxnet"
# ENV ANDROID_STANDALONE_TOOLCHAIN "$NDK_TOOLCHAIN_DIR"
ENV ANDROID_NDK "$LIB_DIR/$NDK_VERSION"

RUN apt-get update && \
    apt-get install -y \
        openjdk-8-jre \
        openjdk-8-jdk \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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
    git checkout tags/v0.2.19 && \
    make TARGET=ARMV7 HOSTCC=gcc CC=arm-linux-androideabi-gcc NOFORTRAN=1 && \
    make PREFIX=$OPENBLAS_DIR install

# Compile MXNet Amalgamation
ENV PATH "${PATH}:$NDK_TOOLCHAIN_DIR/bin"
ENV CC arm-linux-androideabi-clang
ENV CXX arm-linux-androideabi-clang++

RUN cd "$LIB_DIR" && git clone --recursive https://github.com/dmlc/mxnet && cd mxnet/amalgamation && \
    git checkout c8f7dce0eb49ab1a62ddc2c7e37b93e9b92c2ae4 && \
    git submodule update --init --recursive && \
    sed -i "s|/usr/local/opt/openblas|$OPENBLAS_DIR|g" Makefile && \
    sed  -i -e 's/\(#if defined(__MACH__)\)/#define fopen64 std::fopen\n\1/' amalgamation.py && \
    sed -i '1i DEFS += -DMSHADOW_USE_CUDA=0 -DMSHADOW_USE_MKL=0 -DMSHADOW_RABIT_PS=0 -DMSHADOW_DIST_PS=0 -DMSHADOW_USE_SSE=0 -DDMLC_LOG_STACK_TRACE=0 -DMSHADOW_FORCE_STREAM -DMXNET_USE_OPENCV=0 -DMXNET_PREDICT_ONLY=1 -DDISABLE_OPENMP=1' ../nnvm/amalgamation/Makefile && \
    sed -i '4i CFLAGS = -std=c++11 -Wall -O3 -Wno-unknown-pragmas -funroll-loops -Iinclude -fPIC $(DEFS)' ../nnvm/amalgamation/Makefile && \
    make clean && \
    make ANDROID=1
    # We can't use multiprocess compilation

# download opencv3
RUN cd "$OPENCV_DIR" && \
    wget https://github.com/opencv/opencv/archive/master.zip && \
    unzip master.zip && \
    rm master.zip
    # git clone https://github.com/opencv/opencv.git  <-- don't work anymore : GnuTLS recv error

# download opencv3 contrib
RUN cd "$OPENCV_DIR" && \
    wget https://github.com/opencv/opencv_contrib/archive/master.zip && \
    unzip master.zip && \
    rm master.zip
    # git clone https://github.com/opencv/opencv_contrib.git  <-- don't work anymore : GnuTLS recv error

# Compile opencv3
RUN cd "$OPENCV_DIR/opencv-master/platforms/scripts" && \
    sh cmake_android_arm.sh -DANDROID_NATIVE_API_LEVEL=21 -DBUILD_SHARED_LIBS=OFF -DBUILD_opencv_world=ON && \
    cd ../build_android_arm && \
    make -j$(nproc) && \
    make install

CMD ["/bin/bash"]

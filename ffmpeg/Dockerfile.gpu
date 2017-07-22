FROM gpu_python_lib:latest
MAINTAINER Erwan BERNARD

# follow almost the tutoriel from : https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

ENV FFMPEG_DIR "$LIB_DIR/ffmpeg"
RUN mkdir -p "$FFMPEG_DIR/ffmpeg_sources"

# Pick up some dependencies
RUN apt-get update && \
    apt-get install -y \
        wget \
        autoconf automake \
        cmake mercurial \ 
        build-essential \
        libass-dev \ 
        libfreetype6-dev \
        libsdl2-dev \
        libtheora-dev \
        libtool \
        libva-dev \
        libvdpau-dev \
        libvorbis-dev \
        libxcb1-dev \
        libxcb-shm0-dev \
        libxcb-xfixes0-dev \ 
        pkg-config \ 
        texinfo \
        zlib1g-dev \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install yasm
RUN cd "$FFMPEG_DIR/ffmpeg_sources" && \
    wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz && \
    tar xzvf yasm-1.3.0.tar.gz && \ 
    rm yasm-1.3.0.tar.gz && \
    cd yasm-1.3.0 && \
    ./configure --prefix="$FFMPEG_DIR/ffmpeg_build" --bindir="$FFMPEG_DIR/bin" && \
    make -j"$(nproc)" && \
    make install

# install nasm
RUN cd "$FFMPEG_DIR/ffmpeg_sources" && \
    wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.bz2 && \
    tar xjvf nasm-2.13.01.tar.bz2 && \
    cd nasm-2.13.01 && \
    ./autogen.sh && \
    PATH="$FFMPEG_DIR/bin:$PATH" ./configure --prefix="$FFMPEG_DIR/ffmpeg_build" --bindir="$FFMPEG_DIR/bin" && \
    PATH="$FFMPEG_DIR/bin:$PATH" make -j"$(nproc)" && \
    make install

# install x264
RUN cd "$FFMPEG_DIR/ffmpeg_sources" && \
    wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2 && \
    tar xjvf last_x264.tar.bz2 && \
    rm last_x264.tar.bz2 && \
    cd x264-snapshot* && \
    PATH="$FFMPEG_DIR/bin:$PATH" ./configure --prefix="$FFMPEG_DIR/ffmpeg_build" --bindir="$FFMPEG_DIR/bin" --enable-static --enable-shared --disable-opencl && \
    PATH="$FFMPEG_DIR/bin:$PATH" make -j"$(nproc)" && \
    make install

# install x265
RUN cd "$FFMPEG_DIR/ffmpeg_sources" && \
    hg clone https://bitbucket.org/multicoreware/x265 && \
    cd "$FFMPEG_DIR/ffmpeg_sources/x265/build/linux" && \
    PATH="$FFMPEG_DIR/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$FFMPEG_DIR/ffmpeg_build" -DENABLE_SHARED:bool=on ../../source && \
    make -j"$(nproc)" && \
    make install

# install ffmpeg
RUN cd "$FFMPEG_DIR/ffmpeg_sources" && \
    wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
    tar xjvf ffmpeg-snapshot.tar.bz2 && \
    rm ffmpeg-snapshot.tar.bz2 && \
    cd ffmpeg && \
    PATH="$FFMPEG_DIR/bin:$PATH" PKG_CONFIG_PATH="$FFMPEG_DIR/ffmpeg_build/lib/pkgconfig" ./configure \
        --prefix="$FFMPEG_DIR/ffmpeg_build" \
        --pkg-config-flags="--static" \
        --extra-cflags="-I$FFMPEG_DIR/ffmpeg_build/include" \
        --extra-ldflags="-L$FFMPEG_DIR/ffmpeg_build/lib" \
        --bindir="$FFMPEG_DIR/bin" \
        --enable-gpl \
        --enable-libass \
        #--enable-libfdk-aac \
        --enable-libfreetype \
        #--enable-libmp3lame \
        #--enable-libopus \
        --enable-libtheora \
        --enable-libvorbis \
        #--enable-libvpx \
        --enable-libx264 \
        --enable-libx265 \
        --enable-nonfree \
        --enable-shared \ 
        && \
    PATH="$FFMPEG_DIR/bin:$PATH" make -j"$(nproc)" && \
    make install && \
    hash -r

RUN /bin/bash -c 'echo "$FFMPEG_DIR/ffmpeg_build/lib" > /etc/ld.so.conf.d/ffmpeg.conf'
RUN ldconfig

ENV PATH "$FFMPEG_DIR/bin:${PATH}"
ENV PKG_CONFIG_PATH "$FFMPEG_DIR/ffmpeg_build/lib/pkgconfig:${PKG_CONFIG_PATH}"

# define environnement variable in .bashrc don't work in dockerfile as docker file don't use .bashrc 
# RUN echo 'export PATH="$FFMPEG_DIR/bin:$PATH"' >> ~/.bashrc
# RUN echo 'export PKG_CONFIG_PATH="$FFMPEG_DIR/ffmpeg_build/lib/pkgconfig:$PKG_CONFIG_PATH"' >> ~/.bashrc
# RUN /bin/bash -c "source ~/.bashrc"

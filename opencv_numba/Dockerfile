FROM opencv_only:latest
MAINTAINER Erwan BERNARD

# install numba (JIT compiler for python)
# current version are llvm-3.8, clang-3.8, llvmlite-0.14.0, numba-0.29
RUN apt-get update && \
    apt-get install -y llvm clang && \
    pip2 install llvmlite==0.14.0 numba && \
    pip3 install llvmlite==0.14.0 numba

# configure bash
RUN ln -snf /bin/bash /bin/sh
RUN echo 'force_color_prompt=yes' >> /home/dev/.bashrc && \
    cat /root/.bashrc >> /home/dev/.bashrc && \
    echo 'PS1="\[\033[31;1m\]$BOX_NAME\[\033[00m\] $PS1" ' >> /home/dev/.bashrc

CMD ["/bin/bash"]

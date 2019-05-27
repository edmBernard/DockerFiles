FROM tensorflow_gpu:latest
LABEL maintainer="Erwan BERNARD https://github.com/edmBernard/DockerFiles"

RUN apt-get update && \
    apt-get install -y \
        openmpi-bin \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# CNTK
RUN pip3 --no-cache-dir install cntk-gpu

# Set CNTK backend for Keras
ENV KERAS_BACKEND=cntk

CMD ["/bin/bash"]

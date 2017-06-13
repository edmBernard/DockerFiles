FROM tensorflow:latest
MAINTAINER Erwan BERNARD

# CNTK
RUN pip3 install https://cntk.ai/PythonWheel/CPU-Only/cntk-2.0-cp35-cp35m-linux_x86_64.whl

# Set CNTK backend for Keras
ENV KERAS_BACKEND=cntk

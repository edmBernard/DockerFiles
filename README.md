# DockerFiles

Some Dockerfiles to install Opencv3 with python2, python3 and Deeplearning framework

## Building images

```sudo nvidia-docker build -t <image_name> -f <dockerfile_name> .```

## Create container

```
NV_GPU='0,1' \
sudo nvidia-docker run -it --name container_name -p 0.0.0.0:7000:6006 -p 0.0.0.0:8000:8888 \ 
-v shared/path/on/host:/shared/path/in/container images_name:latest /bin/bash
```


# DockerFiles

Some Dockerfiles to install Opencv3 with Python2, Python3 and Deeplearning framework

## Requirement

Most of these docker use the [Nvidia-docker][1] plugin for [Docker][2]

[1]: https://github.com/NVIDIA/nvidia-docker
[2]: https://www.docker.com/

## Building images

```bash
sudo nvidia-docker build -t image_name -f dockerfile_name .
```

## Building images from racine repos

```bash
sudo docker build -t image_name -f folder_name/Dockerfile folder_name
```

## Create container

```bash
sudo docker run -it --name container_name -p 0.0.0.0:6000:7000 -p 0.0.0.0:8000:9000 -v shared/path/on/host:/shared/path/in/container image_name:latest /bin/bash
```

##### Unfold

```bash
sudo docker run -it             # -it option allow interaction with the container
--name container_name           # Name of the created container
-p 0.0.0.0:6000:7000            # Port redirection for Tensorboard (redirect host port 6000 to container port 7000)
-p 0.0.0.0:8000:9000            # Port redirection for Jupyter notebook (redirect host port 8000 to container port 9000)
-v shared/path/on/host:/shared/path/in/container    # Configure a shared directory between host and container
image_name:latest               # Image name to use for container creation
/bin/bash                       # Command to execute
```

## Create container (with GPU support)

```bash
NV_GPU='0' sudo nvidia-docker run -it --name container_name -p 0.0.0.0:6000:7000 -p 0.0.0.0:8000:9000 -v shared/path/on/host:/shared/path/in/container image_name:latest /bin/bash
```

##### Unfold

```bash
NV_GPU='0'                      # GPU id give by nvidia-smi ('0', '1' or '0,1' for GPU0, GPU2 or both)
sudo nvidia-docker run -it      # -it option allow interaction with the container
--name container_name           # Name of the created container
-p 0.0.0.0:6000:7000            # Port redirection for Tensorboard (redirect host port 6000 to container port 7000)
-p 0.0.0.0:8000:9000            # Port redirection for Jupyter notebook (redirect host port 8000 to container port 9000)
-v shared/path/on/host:/shared/path/in/container    # Configure a shared directory between host and container
image_name:latest               # Image name to use for container creation
/bin/bash                       # Command to execute
```

## Open terminal in container

```bash
sudo docker exec -it container_name /bin/bash
```

### Some strange bug I encounter that disappear alone

* Sometimes Cudnn was unlink

    if you got this error

    ```bash
    tensorflow/stream_executor/cuda/cuda_dnn.cc:204] could not find cudnnCreate in cudnn DSO; dlerror: /usr/local/lib/python2.7/dist-packages/tensorflow/python/_pywrap_tensorflow.so: undefined symbol: cudnnCreate
    ```

    that can be solve by
    ```bash
    rm /usr/lib/x86_64-linux-gnu/libcudnn.so
    ln -s /usr/lib/x86_64-linux-gnu/libcudnn.so.4 /usr/lib/x86_64-linux-gnu/libcudnn.so
    ```

* IPPICV

    if you got `incorrect hash` in cmake `ippicv` when installing [like this issue][1]

    [1]: https://github.com/opencv/opencv/issues/5973

    just try again ^^

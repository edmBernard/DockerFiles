# DockerFiles

Some Dockerfiles to install Opencv3 with Python2, Python3 and Deeplearning framework

## Requirement

Most of these docker use the [Nvidia-docker][1] plugin for [Docker][2]

[1]: https://github.com/NVIDIA/nvidia-docker
[2]: https://www.docker.com/

## Building images

### With docker api

```bash
sudo nvidia-docker build -t image_name -f dockerfile_name .
```

### With Make

I made a `Makefile` to automate the build process.

```bash
make IMAGE_NAME:TAG
```

*Note:* make accept `NOCACHE=ON` argument to force the rebuild of all images

#### Images with CPU Only:
| Image name | TAG | Description |  |  
|:-- |:-- |:-- |:-- |
| `all` | <br> `cpu` <br> `gpu` | all images <br> all cpu images <br> all gpu images |
| `python_lib` | `cpu` <br> `gpu` | my standard configuration |
| `ffmpeg` | `cpu` <br> `gpu` | with [ffmpeg](https://ffmpeg.org/) compiled from source |
| `opencv` | `cpu` <br> `gpu` | with [opencv](http://opencv.org/) compiled from source |
| `redis` | `cpu` <br> `gpu` | with [redis](https://redis.io/) compiled from source |
| `mxnet` | `cpu` <br> `gpu` <br> `cpu.nnpack` <br> `android`| with [mxnet](http://mxnet.io/) compiled from source <br> with gpu support <br> with [NNPACK](https://github.com/Maratyszcza/NNPACK) <br> [mxnet](http://mxnet.io/) with amalgamation compiled for android |
| `tensorflow` | `cpu` <br> `gpu` | with [tensoflow](https://www.tensorflow.org/) and [keras](https://keras.io/)|
| `cntk` | `cpu` <br> `gpu` | with [cntk](http://cntk.ai) and [keras](https://keras.io/)|
| `numba` | `cpu` <br> `gpu` | with [numba](http://numba.pydata.org/) |
| `jupyter` | `cpu` <br> `gpu` | a [jupyter](http://jupyter.org/) server with `pass` as password |
| `python36` | `ubuntu` <br> `alpine` | regular ubuntu installation with python3.6 <br> [alpine](https://alpinelinux.org/) with python 3.6 |

\* As image depends from each other `make` will automatically build images dependency. (ex: if you build `opencv` image,  `python_lib` and `ffmpeg` will by create as well by the command `make opencv:cpu`)

## Create container (with CPU Only)

```
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

```
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

## Advance use

### Open new terminal in existing container

```bash
sudo docker exec -it container_name /bin/bash
```

### Alias to create Jupyter server
#### CPU version

```bash
    alias jupserver='docker run -it -d -p 0.0.0.0:5000:8888 -v $PWD:/home/dev/host jupyter:latest'
```

#### GPU version

```bash
    alias jupserver='docker run -it -d -p 0.0.0.0:5000:8888 -v $PWD:/home/dev/host gpu_jupyter:latest'
```

### Alias to create a isolated devbox
```bash
    alias devbox='docker run -it --rm -v $PWD:/home/dev/host numba:latest'
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

    if you got `incorrect hash` in cmake `ippicv` when installing [like this issue](https://github.com/opencv/opencv/issues/5973)

    just try again ^^

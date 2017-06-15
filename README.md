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

```bash
make <IMAGE_NAME>
```

<IMAGE_NAME> choice : 

| <IMAGE_NAME> | Description | Images depend from each other* |  
|:-- |:-- |:-- |
| `all` | all cpu images | `python_lib ffmpeg opencv redis mxnet numba jupyter`| 
| `python_lib` | my standard conf | |
| `ffmpeg` | with [ffmpeg](https://ffmpeg.org/) | `python_lib` |
| `opencv` | with [opencv](http://opencv.org/) | `python_lib ffmpeg` |
| `redis` | with [redis](https://redis.io/)| `python_lib ffmpeg opencv` |
| `mxnet` | with [mxnet](http://mxnet.io/)| `python_lib ffmpeg opencv redis` |
| `nnpack_mxnet` | with [mxnet](http://mxnet.io/) and [NNPACK](https://github.com/Maratyszcza/NNPACK)| `python_lib ffmpeg opencv redis` |
| `tensorflow` | with [tensoflow](https://www.tensorflow.org/) and [keras](https://keras.io/)| `python_lib ffmpeg opencv redis` |
| `cntk` | with [cntk](http://cntk.ai) and [keras](https://keras.io/)| `python_lib ffmpeg opencv redis tensorflow` |
| `numba` | with [numba](http://numba.pydata.org/) | `python_lib ffmpeg opencv redis mxnet` |
| `jupyter` | a [jupyter](http://jupyter.org/) server with `pass` as password | `python_lib ffmpeg opencv redis mxnet numba` |
| `gpu_all` | all gpu images |  `gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis gpu_mxnet gpu_numba gpu_jupyter`|
| `gpu_python_lib`  | my standard conf | |
| `gpu_ffmpeg`  | with [ffmpeg](https://ffmpeg.org/) | `gpu_python_lib` |
| `gpu_opencv`  | with [opencv](http://opencv.org/) | `gpu_python_lib gpu_ffmpeg` |
| `gpu_redis`  | with [redis](https://redis.io/)| `gpu_python_lib gpu_ffmpeg gpu_opencv` |
| `gpu_mxnet`  | with [mxnet](http://mxnet.io/)| `gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis` |
| `gpu_tensorflow`  | with [tensoflow](https://www.tensorflow.org/) and [keras](https://keras.io/)| `gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis` |
| `gpu_cntk`  |  with [cntk](http://cntk.ai) and [keras](https://keras.io/)| `gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis gpu_tensorflow` |
| `gpu_numba` | with [numba](http://numba.pydata.org/) | `gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis gpu_mxnet` |
| `gpu_jupyter`  | a [jupyter](http://jupyter.org/) server with `pass` as password | `gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis gpu_mxnet gpu_numba` |
| `python36` | [alpine](https://alpinelinux.org/) with python 3.6 | |

\* `make` automatically build images dependency. (ex: if you build `opencv` image,  `python_lib` and `ffmpeg` will by create as well by the command `make opencv`)

*Note:* make accept `NOCACHE=ON` argument to force the rebuild of all images

## Create container

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

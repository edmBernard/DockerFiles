# DockerFiles

Some Dockerfiles to install Opencv3 with Python2, Python3 and Deeplearning framework. I also use them as a reminder to complicated framework installation.

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
make IMAGE_NAME
```
The image is the concatenation of the Library name and the tag (ex: `opencv` and `_gpu` is create by `make opencv_gpu`) 

*Note1:* `make` accept `NOCACHE=ON` argument to force the rebuild of all images<br>
*Note2:* As image depends from each other, `make` will automatically build images dependency. (ex: if you build `opencv_cpu` image,  `pythonlib_cpu` and `ffmpeg_cpu` will be create as well by the command `make opencv:cpu`)

#### Images with CPU Only:
| Library | Tag | Description | 
|:-- |:-- |:-- |
| `all` | <br> `_cpu` <br> `_gpu` | all images <br> all cpu images <br> all gpu images |
| `pythonlib` | `_cpu` <br> `_gpu` | my standard configuration |
| `ffmpeg` | `_cpu` <br> `_gpu` | with [ffmpeg](https://ffmpeg.org/) compiled from source |
| `opencv` | `_cpu` <br> `_gpu` | with [opencv](http://opencv.org/) compiled from source |
| `redis` | `_cpu` <br> `_gpu` | with [redis](https://redis.io/) compiled from source |
| `mxnet` | `_cpu` <br> `_gpu` <br> `_cpu_nnpack` <br> `_android`| with [mxnet](http://mxnet.io/) compiled from source <br> with [mxnet](http://mxnet.io/)  compiled from source and gpu support <br> with [mxnet](http://mxnet.io/) and [NNPACK](https://github.com/Maratyszcza/NNPACK) compiled from source  <br> [mxnet](http://mxnet.io/) amalgamation compiled for android (ndk-14b) |
| `tensorflow` | `_cpu` <br> `_gpu` | with [tensoflow](https://www.tensorflow.org/) and [keras](https://keras.io/)|
| `cntk` | `_cpu` <br> `_gpu` | with [cntk](http://cntk.ai) and [keras](https://keras.io/)|
| `numba` | `_cpu` <br> `_gpu` | with [numba](http://numba.pydata.org/) |
| `jupyter` | `_cpu` <br> `_gpu` | a [jupyter](http://jupyter.org/) server with `pass` as password |
| `python36` | `_ubuntu` <br> `_alpine` | regular ubuntu installation with python3.6 <br> [alpine](https://alpinelinux.org/) with python 3.6 |


## Create container (with CPU Only)

```
sudo docker run -it --name container_name -p 0.0.0.0:6000:7000 -p 0.0.0.0:8000:9000 -v shared/path/on/host:/shared/path/in/container image_name:latest /bin/bash
```

##### Unfold

```bash
sudo docker run -it             # -it option allow interaction with the container
--name container_name           # Name of the created container
-p 0.0.0.0:6000:7000            # Port redirection (redirect host port 6000 to container port 7000)
-p 0.0.0.0:8000:9000            # Port redirection (redirect host port 8000 to container port 9000)
-v shared/path/on/host:/shared/path/in/container    # Configure a shared directory between host and container
image_name:latest               # Image name to use for container creation
/bin/bash                       # Command to execute
```
***Note***: Don't specify ports if you don't use them. As you can't have containers listenning the same host port. (cf. "Alias to create Jupyter server" for random port assignation).


## Create container (with GPU support)

```
NV_GPU='0' sudo nvidia-docker run -it --name container_name -p 0.0.0.0:6000:7000 -p 0.0.0.0:8000:9000 -v shared/path/on/host:/shared/path/in/container image_name:latest /bin/bash
```

##### Unfold

```bash
NV_GPU='0'                      # GPU id give by nvidia-smi ('0', '1' or '0,1' for GPU0, GPU2 or both)
sudo nvidia-docker run -it      # -it option allow interaction with the container
--name container_name           # Name of the created container
-p 0.0.0.0:6000:7000            # Port redirection (redirect host port 6000 to container port 7000)
-p 0.0.0.0:8000:9000            # Port redirection (redirect host port 8000 to container port 9000)
-v shared/path/on/host:/shared/path/in/container    # Configure a shared directory between host and container
image_name:latest               # Image name to use for container creation
/bin/bash                       # Command to execute
```
***Note***: Don't specify ports if you don't use them. As you can't have containers listenning the same host port. (cf. "Alias to create Jupyter server" for random port assignation in a range).


## Advance use

### Open new terminal in existing container

```bash
sudo docker exec -it container_name /bin/bash
```

### Alias to create Jupyter server
#### CPU version

```bash
    alias jupserver='docker run -it -d -p 0.0.0.0:5000-5010:8888 -v $PWD:/home/dev/host jupyter_cpu:latest'
```

***Note***: If host port is a range of ports and container port a single one, docker will choose a random free port in the specified range.

#### GPU version

```bash
    alias jupserver='docker run -it -d -p 0.0.0.0:5000-5010:8888 -v $PWD:/home/dev/host jupyter_gpu:latest'
```

***Note***: If host port is a range of ports and container port a single one, docker will choose a random free port in the specified range.

### Alias to create a isolated devbox
```bash
    alias devbox='docker run -it --rm -v $PWD:/home/dev/host mxnet:latest'
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

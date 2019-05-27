# DockerFiles

Some Dockerfiles to install Opencv, ffmpeg and Deeplearning framework. I also use them as a reminder to complicated framework installation.

## Requirements

Most of these docker use the [Nvidia][1] runtime for [Docker][2]

[1]: https://github.com/NVIDIA/nvidia-docker
[2]: https://www.docker.com/

to Use Nvidia runtime as default runtime add this in `/etc/docker/daemon.json`
```javascript
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
```

## Building images

### With docker api

```bash
sudo docker build --runtime=nvidia -t image_name -f dockerfile_name .
```

or (if nvidia is the default runtime)

```bash
sudo docker build -t image_name -f dockerfile_name .
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
| `all` | <br> `_cpu` <br> `_gpu` <br> `_alpine`| all images <br> all cpu images <br> all gpu images <br> all alpine images|
| `pythonlib` | `_cpu` <br> `_gpu` | my standard configuration |
| `ffmpeg` | `_cpu` <br> `_gpu` | with [ffmpeg](https://ffmpeg.org/) compiled from source |
| `opencv` | `_cpu` <br> `_gpu` | with [opencv](http://opencv.org/) compiled from source |
| `redis` | `_cpu` <br> `_gpu` | with [redis](https://redis.io/) compiled from source |
| `mxnet` | `_cpu` <br> `_gpu` <br> `_cpu_mkl` <br> `_cpu_nnpack` <br> `_android`| with [mxnet](http://mxnet.io/) compiled from source <br> with [mxnet](http://mxnet.io/)  compiled from source and gpu support <br> with [mxnet](http://mxnet.io/) and [mkl](https://software.intel.com/en-us/mkl) <br> with [mxnet](http://mxnet.io/) and [NNPACK](https://github.com/Maratyszcza/NNPACK) compiled from source  <br> [mxnet](http://mxnet.io/) amalgamation compiled for android (ndk-14b) |
| `nnvm` | `_cpu` <br> `_gpu_opencl` <br> `_cpu_opencl`| with [nnvm](https://github.com/dmlc/nnvm), [tvm](https://github.com/dmlc/tvm) compiled from source <br> with [nnvm](https://github.com/dmlc/nnvm), [tvm](https://github.com/dmlc/tvm) and [opencl](https://fr.wikipedia.org/wiki/OpenCL) compiled from source and gpu support <br> with [nnvm](https://github.com/dmlc/nnvm), [tvm](https://github.com/dmlc/tvm) and [opencl](https://fr.wikipedia.org/wiki/OpenCL) compiled from source|
| `tensorflow` | `_cpu` <br> `_gpu` | with [tensoflow](https://www.tensorflow.org/) and [keras](https://keras.io/)|
| `cntk` | `_cpu` <br> `_gpu` | with [cntk](http://cntk.ai) and [keras](https://keras.io/)|
| `pytorch` | `_cpu` <br> `_gpu` | with [pytorch](http://pytorch.org/) and [pytorch/vision](https://github.com/pytorch/vision)|
| `chainer` | `_cpu` <br> `_gpu` | with [chainer](https://chainer.org/), [chainerRL](https://github.com/chainer/chainerrl) and [chainerCV](https://github.com/chainer/chainercv)|
| `numba` | `_cpu` <br> `_gpu` | with [numba](http://numba.pydata.org/) |
| `jupyter` | `_cpu` <br> `_gpu` | a [jupyter](http://jupyter.org/) server with `pass` as password |
| `alpine` | `_redis` <br> `_pythonlib` <br> `_node` <br> `_dotnet` | some usefull image based on [alpine](https://alpinelinux.org/) to have small memory footprint |


## Create container (with CPU Only)

```
docker run -it --name container_name -p 0.0.0.0:6000:7000 -p 0.0.0.0:8000:9000 -v shared/path/on/host:/shared/path/in/container image_name:latest /bin/bash
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
NV_GPU='0' docker run -it --runtime=nvidia --name container_name -p 0.0.0.0:6000:7000 -p 0.0.0.0:8000:9000 -v shared/path/on/host:/shared/path/in/container image_name:latest /bin/bash
```

##### Unfold

```bash
NV_GPU='0'                      # GPU id give by nvidia-smi ('0', '1' or '0,1' for GPU0, GPU2 or both)
sudo docker run -it             # -it option allow interaction with the container
--runtime=nvidia                # Allow docker to run with nvidia runtime to support GPU
--name container_name           # Name of the created container
-p 0.0.0.0:6000:7000            # Port redirection (redirect host port 6000 to container port 7000)
-p 0.0.0.0:8000:9000            # Port redirection (redirect host port 8000 to container port 9000)
-v shared/path/on/host:/shared/path/in/container    # Configure a shared directory between host and container
image_name:latest               # Image name to use for container creation
/bin/bash                       # Command to execute
```
***Note***: Don't specify ports if you don't use them. As you can't have containers listenning the same host port. (cf. "Alias to create Jupyter server" for random port assignation in a range).


## Advance use

### Open new terminal in running container

```bash
docker exec -it container_name /bin/bash
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

## Fixed version

Sometime update in library can break compatibility with other module.
In certain Dockerfile there is fixed version to keep older version.
Other tools can be download with last version so I need to change manually version at each update.
Most of the time, I try to keep last version for all tools.
In some case last version fix bug or the reason I fixed the version without I know it.

| Tools | version | Docker image | Description |
| -- | -- | -- | -- |
| cuda | 10.1 | all gpu images | -- |
| cudnn | 7 | all gpu images | -- |
| opencv | 4.1 | opencv | -- |
| pytorch | 1.1.0 | pytorch | -- |
| llvmlite | 0.14.0 | numba | -- |

## Script

The `generate.py` script available in script folder allow three things.
* `generate.py amalgamation`: generate Dockerfile for each end image without dependency. It generate a dockerfile with all depency expanded.
* `generate.py makefile`: update makefile with all images found in folders. Useful after amalgamation generation.
* `generate.py concatenate`: allow to concatenate dockerfile. For example, if you want to add jupyter support on pytorch images. `generate.py concatenate --filename ../super/pytorch/Dockerfile.jupyter --base pytorch_cpu -- jupyter_cpu` will generate a new dockerfile that depends of pytorch_cpu and add jupyter_cpu installation. This image will be available - after makefile update - via `make pytorch_jupyter`

### Example :
```bash
./generate.py concatenate --filename ../super/jupyter/Dockerfile.mxnet --base mxnet_cpu_mkl -- jupyter_cpu
./generate.py concatenate --filename ../super/jupyter/Dockerfile.opencv --base opencv_cpu -- jupyter_cpu
./generate.py concatenate --filename ../super/jupyter/Dockerfile.pythonlib --base pythonlib_cpu -- jupyter_cpu
```

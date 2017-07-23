NOCACHE=OFF

ifeq ($(NOCACHE),ON)
	arg_nocache=--no-cache
else
	arg_nocache=
endif


.PHONY: all all\:cpu all\:gpu clean clean\:cpu clean\:gpu jupyter\:cpu jupyter\:gpu cntk\:cpu cntk\:gpu numba\:cpu numba\:gpu mxnet\:android mxnet\:cpu mxnet\:cpu.nnpack mxnet\:gpu tensorflow\:cpu tensorflow\:gpu redis\:cpu redis\:gpu opencv\:cpu opencv\:gpu ffmpeg\:cpu ffmpeg\:gpu python36\:alpine python36\:ubuntu python_lib\:cpu python_lib\:gpu


all: all\:cpu all\:gpu

all\:cpu: python_lib\:cpu ffmpeg\:cpu opencv\:cpu redis\:cpu tensorflow\:cpu mxnet\:cpu.nnpack mxnet\:cpu numba\:cpu cntk\:cpu jupyter\:cpu

all\:gpu: python_lib\:gpu ffmpeg\:gpu opencv\:gpu redis\:gpu tensorflow\:gpu mxnet\:gpu numba\:gpu cntk\:gpu jupyter\:gpu


clean:
	docker rmi jupyter\:cpu jupyter\:gpu cntk\:cpu cntk\:gpu numba\:cpu numba\:gpu mxnet\:android mxnet\:cpu mxnet\:cpu.nnpack mxnet\:gpu tensorflow\:cpu tensorflow\:gpu redis\:cpu redis\:gpu opencv\:cpu opencv\:gpu ffmpeg\:cpu ffmpeg\:gpu python36\:alpine python36\:ubuntu python_lib\:cpu python_lib\:gpu

clean\:cpu:
	docker rmi jupyter\:cpu cntk\:cpu numba\:cpu mxnet\:cpu mxnet\:cpu.nnpack tensorflow\:cpu redis\:cpu opencv\:cpu ffmpeg\:cpu python_lib\:cpu

clean\:gpu:
	docker rmi jupyter\:gpu cntk\:gpu numba\:gpu mxnet\:gpu tensorflow\:gpu redis\:gpu opencv\:gpu ffmpeg\:gpu python_lib\:gpu


jupyter\:cpu: numba\:cpu mxnet\:cpu redis\:cpu opencv\:cpu ffmpeg\:cpu python_lib\:cpu
	docker build $(arg_nocache) -t jupyter\:cpu -f jupyter/Dockerfile.cpu jupyter

jupyter\:gpu: numba\:gpu mxnet\:gpu redis\:gpu opencv\:gpu ffmpeg\:gpu python_lib\:gpu
	nvidia-docker build $(arg_nocache) -t jupyter\:gpu -f jupyter/Dockerfile.gpu jupyter

cntk\:cpu: tensorflow\:cpu redis\:cpu opencv\:cpu ffmpeg\:cpu python_lib\:cpu
	docker build $(arg_nocache) -t cntk\:cpu -f cntk/Dockerfile.cpu cntk

cntk\:gpu: tensorflow\:gpu redis\:gpu opencv\:gpu ffmpeg\:gpu python_lib\:gpu
	nvidia-docker build $(arg_nocache) -t cntk\:gpu -f cntk/Dockerfile.gpu cntk

numba\:cpu: mxnet\:cpu redis\:cpu opencv\:cpu ffmpeg\:cpu python_lib\:cpu
	docker build $(arg_nocache) -t numba\:cpu -f numba/Dockerfile.cpu numba

numba\:gpu: mxnet\:gpu redis\:gpu opencv\:gpu ffmpeg\:gpu python_lib\:gpu
	nvidia-docker build $(arg_nocache) -t numba\:gpu -f numba/Dockerfile.gpu numba

mxnet\:android: redis\:cpu opencv\:cpu ffmpeg\:cpu python_lib\:cpu
	docker build $(arg_nocache) -t mxnet\:android -f mxnet/Dockerfile.android mxnet

mxnet\:cpu: redis\:cpu opencv\:cpu ffmpeg\:cpu python_lib\:cpu
	docker build $(arg_nocache) -t mxnet\:cpu -f mxnet/Dockerfile.cpu mxnet

mxnet\:cpu.nnpack: redis\:cpu opencv\:cpu ffmpeg\:cpu python_lib\:cpu
	docker build $(arg_nocache) -t mxnet\:cpu.nnpack -f mxnet/Dockerfile.cpu.nnpack mxnet

mxnet\:gpu: redis\:gpu opencv\:gpu ffmpeg\:gpu python_lib\:gpu
	nvidia-docker build $(arg_nocache) -t mxnet\:gpu -f mxnet/Dockerfile.gpu mxnet

tensorflow\:cpu: redis\:cpu opencv\:cpu ffmpeg\:cpu python_lib\:cpu
	docker build $(arg_nocache) -t tensorflow\:cpu -f tensorflow/Dockerfile.cpu tensorflow

tensorflow\:gpu: redis\:gpu opencv\:gpu ffmpeg\:gpu python_lib\:gpu
	nvidia-docker build $(arg_nocache) -t tensorflow\:gpu -f tensorflow/Dockerfile.gpu tensorflow

redis\:cpu: opencv\:cpu ffmpeg\:cpu python_lib\:cpu
	docker build $(arg_nocache) -t redis\:cpu -f redis/Dockerfile.cpu redis

redis\:gpu: opencv\:gpu ffmpeg\:gpu python_lib\:gpu
	nvidia-docker build $(arg_nocache) -t redis\:gpu -f redis/Dockerfile.gpu redis

opencv\:cpu: ffmpeg\:cpu python_lib\:cpu
	docker build $(arg_nocache) -t opencv\:cpu -f opencv/Dockerfile.cpu opencv

opencv\:gpu: ffmpeg\:gpu python_lib\:gpu
	nvidia-docker build $(arg_nocache) -t opencv\:gpu -f opencv/Dockerfile.gpu opencv

ffmpeg\:cpu: python_lib\:cpu
	docker build $(arg_nocache) -t ffmpeg\:cpu -f ffmpeg/Dockerfile.cpu ffmpeg

ffmpeg\:gpu: python_lib\:gpu
	nvidia-docker build $(arg_nocache) -t ffmpeg\:gpu -f ffmpeg/Dockerfile.gpu ffmpeg

python36\:alpine: 
	docker build $(arg_nocache) -t python36\:alpine -f python36/Dockerfile.alpine python36

python36\:ubuntu: 
	docker build $(arg_nocache) -t python36\:ubuntu -f python36/Dockerfile.ubuntu python36

python_lib\:cpu: 
	docker build $(arg_nocache) -t python_lib\:cpu -f python_lib/Dockerfile.cpu python_lib

python_lib\:gpu: 
	nvidia-docker build $(arg_nocache) -t python_lib\:gpu -f python_lib/Dockerfile.gpu python_lib


NOCACHE=OFF

ifeq ($(NOCACHE),ON)
	arg_nocache=--no-cache
else
	arg_nocache=
endif


.PHONY: all all_cpu all_gpu clean clean_cpu clean_gpu jupyter_cpu jupyter_gpu cntk_cpu cntk_gpu numba_cpu numba_gpu mxnet_android mxnet_cpu mxnet_cpu_nnpack mxnet_gpu tensorflow_cpu tensorflow_gpu redis_cpu redis_gpu opencv_cpu opencv_gpu ffmpeg_cpu ffmpeg_gpu python36_alpine python36_ubuntu pythonlib_cpu pythonlib_gpu


all: all_cpu all_gpu

all_cpu: pythonlib_cpu ffmpeg_cpu opencv_cpu redis_cpu tensorflow_cpu mxnet_cpu_nnpack mxnet_cpu numba_cpu cntk_cpu jupyter_cpu

all_gpu: pythonlib_gpu ffmpeg_gpu opencv_gpu redis_gpu tensorflow_gpu mxnet_gpu numba_gpu cntk_gpu jupyter_gpu


clean:
	docker rmi jupyter_cpu jupyter_gpu cntk_cpu cntk_gpu numba_cpu numba_gpu mxnet_android mxnet_cpu mxnet_cpu_nnpack mxnet_gpu tensorflow_cpu tensorflow_gpu redis_cpu redis_gpu opencv_cpu opencv_gpu ffmpeg_cpu ffmpeg_gpu python36_alpine python36_ubuntu pythonlib_cpu pythonlib_gpu

clean_cpu:
	docker rmi jupyter_cpu cntk_cpu numba_cpu mxnet_cpu mxnet_cpu_nnpack tensorflow_cpu redis_cpu opencv_cpu ffmpeg_cpu pythonlib_cpu

clean_gpu:
	docker rmi jupyter_gpu cntk_gpu numba_gpu mxnet_gpu tensorflow_gpu redis_gpu opencv_gpu ffmpeg_gpu pythonlib_gpu


jupyter_cpu: numba_cpu mxnet_cpu redis_cpu opencv_cpu ffmpeg_cpu pythonlib_cpu
	docker build $(arg_nocache) -t jupyter_cpu -f jupyter/Dockerfile.cpu jupyter

jupyter_gpu: numba_gpu mxnet_gpu redis_gpu opencv_gpu ffmpeg_gpu pythonlib_gpu
	nvidia-docker build $(arg_nocache) -t jupyter_gpu -f jupyter/Dockerfile.gpu jupyter

cntk_cpu: tensorflow_cpu redis_cpu opencv_cpu ffmpeg_cpu pythonlib_cpu
	docker build $(arg_nocache) -t cntk_cpu -f cntk/Dockerfile.cpu cntk

cntk_gpu: tensorflow_gpu redis_gpu opencv_gpu ffmpeg_gpu pythonlib_gpu
	nvidia-docker build $(arg_nocache) -t cntk_gpu -f cntk/Dockerfile.gpu cntk

numba_cpu: mxnet_cpu redis_cpu opencv_cpu ffmpeg_cpu pythonlib_cpu
	docker build $(arg_nocache) -t numba_cpu -f numba/Dockerfile.cpu numba

numba_gpu: mxnet_gpu redis_gpu opencv_gpu ffmpeg_gpu pythonlib_gpu
	nvidia-docker build $(arg_nocache) -t numba_gpu -f numba/Dockerfile.gpu numba

mxnet_android: redis_cpu opencv_cpu ffmpeg_cpu pythonlib_cpu
	docker build $(arg_nocache) -t mxnet_android -f mxnet/Dockerfile.android mxnet

mxnet_cpu: redis_cpu opencv_cpu ffmpeg_cpu pythonlib_cpu
	docker build $(arg_nocache) -t mxnet_cpu -f mxnet/Dockerfile.cpu mxnet

mxnet_cpu_nnpack: redis_cpu opencv_cpu ffmpeg_cpu pythonlib_cpu
	docker build $(arg_nocache) -t mxnet_cpu_nnpack -f mxnet/Dockerfile.cpu.nnpack mxnet

mxnet_gpu: redis_gpu opencv_gpu ffmpeg_gpu pythonlib_gpu
	nvidia-docker build $(arg_nocache) -t mxnet_gpu -f mxnet/Dockerfile.gpu mxnet

tensorflow_cpu: redis_cpu opencv_cpu ffmpeg_cpu pythonlib_cpu
	docker build $(arg_nocache) -t tensorflow_cpu -f tensorflow/Dockerfile.cpu tensorflow

tensorflow_gpu: redis_gpu opencv_gpu ffmpeg_gpu pythonlib_gpu
	nvidia-docker build $(arg_nocache) -t tensorflow_gpu -f tensorflow/Dockerfile.gpu tensorflow

redis_cpu: opencv_cpu ffmpeg_cpu pythonlib_cpu
	docker build $(arg_nocache) -t redis_cpu -f redis/Dockerfile.cpu redis

redis_gpu: opencv_gpu ffmpeg_gpu pythonlib_gpu
	nvidia-docker build $(arg_nocache) -t redis_gpu -f redis/Dockerfile.gpu redis

opencv_cpu: ffmpeg_cpu pythonlib_cpu
	docker build $(arg_nocache) -t opencv_cpu -f opencv/Dockerfile.cpu opencv

opencv_gpu: ffmpeg_gpu pythonlib_gpu
	nvidia-docker build $(arg_nocache) -t opencv_gpu -f opencv/Dockerfile.gpu opencv

ffmpeg_cpu: pythonlib_cpu
	docker build $(arg_nocache) -t ffmpeg_cpu -f ffmpeg/Dockerfile.cpu ffmpeg

ffmpeg_gpu: pythonlib_gpu
	nvidia-docker build $(arg_nocache) -t ffmpeg_gpu -f ffmpeg/Dockerfile.gpu ffmpeg

python36_alpine: 
	docker build $(arg_nocache) -t python36_alpine -f python36/Dockerfile.alpine python36

python36_ubuntu: 
	docker build $(arg_nocache) -t python36_ubuntu -f python36/Dockerfile.ubuntu python36

pythonlib_cpu: 
	docker build $(arg_nocache) -t pythonlib_cpu -f pythonlib/Dockerfile.cpu pythonlib

pythonlib_gpu: 
	nvidia-docker build $(arg_nocache) -t pythonlib_gpu -f pythonlib/Dockerfile.gpu pythonlib


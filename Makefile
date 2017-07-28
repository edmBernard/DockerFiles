NOCACHE=OFF

ifeq ($(NOCACHE),ON)
	arg_nocache=--no-cache
else
	arg_nocache=
endif


.PHONY: all all_cpu all_gpu clean clean_cpu clean_gpu jupyter_cpu jupyter_gpu cntk_cpu cntk_gpu numba_cpu numba_gpu mxnet_android mxnet_cpu mxnet_cpu_nnpack mxnet_gpu tensorflow_cpu tensorflow_gpu redis_cpu redis_gpu opencv_cpu opencv_gpu ffmpeg_cpu ffmpeg_gpu python36_alpine python36_ubuntu pythonlib_cpu pythonlib_gpu clean_jupyter_cpu clean_jupyter_gpu clean_cntk_cpu clean_cntk_gpu clean_numba_cpu clean_numba_gpu clean_mxnet_android clean_mxnet_cpu clean_mxnet_cpu_nnpack clean_mxnet_gpu clean_tensorflow_cpu clean_tensorflow_gpu clean_redis_cpu clean_redis_gpu clean_opencv_cpu clean_opencv_gpu clean_ffmpeg_cpu clean_ffmpeg_gpu clean_python36_alpine clean_python36_ubuntu clean_pythonlib_cpu clean_pythonlib_gpu


all: all_cpu all_gpu

all_cpu: pythonlib_cpu ffmpeg_cpu opencv_cpu redis_cpu tensorflow_cpu mxnet_cpu_nnpack mxnet_cpu numba_cpu cntk_cpu jupyter_cpu

all_gpu: pythonlib_gpu ffmpeg_gpu opencv_gpu redis_gpu tensorflow_gpu mxnet_gpu numba_gpu cntk_gpu jupyter_gpu


clean: clean_jupyter_cpu clean_jupyter_gpu clean_cntk_cpu clean_cntk_gpu clean_numba_cpu clean_numba_gpu clean_mxnet_android clean_mxnet_cpu clean_mxnet_cpu_nnpack clean_mxnet_gpu clean_tensorflow_cpu clean_tensorflow_gpu clean_redis_cpu clean_redis_gpu clean_opencv_cpu clean_opencv_gpu clean_ffmpeg_cpu clean_ffmpeg_gpu clean_python36_alpine clean_python36_ubuntu clean_pythonlib_cpu clean_pythonlib_gpu

clean_cpu: clean_jupyter_cpu clean_cntk_cpu clean_numba_cpu clean_mxnet_cpu clean_mxnet_cpu_nnpack clean_tensorflow_cpu clean_redis_cpu clean_opencv_cpu clean_ffmpeg_cpu clean_pythonlib_cpu

clean_gpu: clean_jupyter_gpu clean_cntk_gpu clean_numba_gpu clean_mxnet_gpu clean_tensorflow_gpu clean_redis_gpu clean_opencv_gpu clean_ffmpeg_gpu clean_pythonlib_gpu


jupyter_cpu: numba_cpu
	docker build $(arg_nocache) -t jupyter_cpu -f jupyter/Dockerfile.cpu jupyter

clean_jupyter_cpu: 
	if [ "$$(docker images -q --filter=reference='jupyter_cpu')" != "" ]; then docker rmi jupyter_cpu; else echo "0"; fi

jupyter_gpu: numba_gpu
	nvidia-docker build $(arg_nocache) -t jupyter_gpu -f jupyter/Dockerfile.gpu jupyter

clean_jupyter_gpu: 
	if [ "$$(docker images -q --filter=reference='jupyter_gpu')" != "" ]; then docker rmi jupyter_gpu; else echo "0"; fi

cntk_cpu: tensorflow_cpu
	docker build $(arg_nocache) -t cntk_cpu -f cntk/Dockerfile.cpu cntk

clean_cntk_cpu: 
	if [ "$$(docker images -q --filter=reference='cntk_cpu')" != "" ]; then docker rmi cntk_cpu; else echo "0"; fi

cntk_gpu: tensorflow_gpu
	nvidia-docker build $(arg_nocache) -t cntk_gpu -f cntk/Dockerfile.gpu cntk

clean_cntk_gpu: 
	if [ "$$(docker images -q --filter=reference='cntk_gpu')" != "" ]; then docker rmi cntk_gpu; else echo "0"; fi

numba_cpu: mxnet_cpu
	docker build $(arg_nocache) -t numba_cpu -f numba/Dockerfile.cpu numba

clean_numba_cpu: clean_jupyter_cpu
	if [ "$$(docker images -q --filter=reference='numba_cpu')" != "" ]; then docker rmi numba_cpu; else echo "0"; fi

numba_gpu: mxnet_gpu
	nvidia-docker build $(arg_nocache) -t numba_gpu -f numba/Dockerfile.gpu numba

clean_numba_gpu: clean_jupyter_gpu
	if [ "$$(docker images -q --filter=reference='numba_gpu')" != "" ]; then docker rmi numba_gpu; else echo "0"; fi

mxnet_android: redis_cpu
	docker build $(arg_nocache) -t mxnet_android -f mxnet/Dockerfile.android mxnet

clean_mxnet_android: 
	if [ "$$(docker images -q --filter=reference='mxnet_android')" != "" ]; then docker rmi mxnet_android; else echo "0"; fi

mxnet_cpu: redis_cpu
	docker build $(arg_nocache) -t mxnet_cpu -f mxnet/Dockerfile.cpu mxnet

clean_mxnet_cpu: clean_numba_cpu
	if [ "$$(docker images -q --filter=reference='mxnet_cpu')" != "" ]; then docker rmi mxnet_cpu; else echo "0"; fi

mxnet_cpu_nnpack: redis_cpu
	docker build $(arg_nocache) -t mxnet_cpu_nnpack -f mxnet/Dockerfile.cpu.nnpack mxnet

clean_mxnet_cpu_nnpack: 
	if [ "$$(docker images -q --filter=reference='mxnet_cpu_nnpack')" != "" ]; then docker rmi mxnet_cpu_nnpack; else echo "0"; fi

mxnet_gpu: redis_gpu
	nvidia-docker build $(arg_nocache) -t mxnet_gpu -f mxnet/Dockerfile.gpu mxnet

clean_mxnet_gpu: clean_numba_gpu
	if [ "$$(docker images -q --filter=reference='mxnet_gpu')" != "" ]; then docker rmi mxnet_gpu; else echo "0"; fi

tensorflow_cpu: redis_cpu
	docker build $(arg_nocache) -t tensorflow_cpu -f tensorflow/Dockerfile.cpu tensorflow

clean_tensorflow_cpu: clean_cntk_cpu
	if [ "$$(docker images -q --filter=reference='tensorflow_cpu')" != "" ]; then docker rmi tensorflow_cpu; else echo "0"; fi

tensorflow_gpu: redis_gpu
	nvidia-docker build $(arg_nocache) -t tensorflow_gpu -f tensorflow/Dockerfile.gpu tensorflow

clean_tensorflow_gpu: clean_cntk_gpu
	if [ "$$(docker images -q --filter=reference='tensorflow_gpu')" != "" ]; then docker rmi tensorflow_gpu; else echo "0"; fi

redis_cpu: opencv_cpu
	docker build $(arg_nocache) -t redis_cpu -f redis/Dockerfile.cpu redis

clean_redis_cpu: clean_tensorflow_cpu
	if [ "$$(docker images -q --filter=reference='redis_cpu')" != "" ]; then docker rmi redis_cpu; else echo "0"; fi

redis_gpu: opencv_gpu
	nvidia-docker build $(arg_nocache) -t redis_gpu -f redis/Dockerfile.gpu redis

clean_redis_gpu: clean_tensorflow_gpu
	if [ "$$(docker images -q --filter=reference='redis_gpu')" != "" ]; then docker rmi redis_gpu; else echo "0"; fi

opencv_cpu: ffmpeg_cpu
	docker build $(arg_nocache) -t opencv_cpu -f opencv/Dockerfile.cpu opencv

clean_opencv_cpu: clean_redis_cpu
	if [ "$$(docker images -q --filter=reference='opencv_cpu')" != "" ]; then docker rmi opencv_cpu; else echo "0"; fi

opencv_gpu: ffmpeg_gpu
	nvidia-docker build $(arg_nocache) -t opencv_gpu -f opencv/Dockerfile.gpu opencv

clean_opencv_gpu: clean_redis_gpu
	if [ "$$(docker images -q --filter=reference='opencv_gpu')" != "" ]; then docker rmi opencv_gpu; else echo "0"; fi

ffmpeg_cpu: pythonlib_cpu
	docker build $(arg_nocache) -t ffmpeg_cpu -f ffmpeg/Dockerfile.cpu ffmpeg

clean_ffmpeg_cpu: clean_opencv_cpu
	if [ "$$(docker images -q --filter=reference='ffmpeg_cpu')" != "" ]; then docker rmi ffmpeg_cpu; else echo "0"; fi

ffmpeg_gpu: pythonlib_gpu
	nvidia-docker build $(arg_nocache) -t ffmpeg_gpu -f ffmpeg/Dockerfile.gpu ffmpeg

clean_ffmpeg_gpu: clean_opencv_gpu
	if [ "$$(docker images -q --filter=reference='ffmpeg_gpu')" != "" ]; then docker rmi ffmpeg_gpu; else echo "0"; fi

python36_alpine: 
	docker build $(arg_nocache) -t python36_alpine -f python36/Dockerfile.alpine python36

clean_python36_alpine: 
	if [ "$$(docker images -q --filter=reference='python36_alpine')" != "" ]; then docker rmi python36_alpine; else echo "0"; fi

python36_ubuntu: 
	docker build $(arg_nocache) -t python36_ubuntu -f python36/Dockerfile.ubuntu python36

clean_python36_ubuntu: 
	if [ "$$(docker images -q --filter=reference='python36_ubuntu')" != "" ]; then docker rmi python36_ubuntu; else echo "0"; fi

pythonlib_cpu: 
	docker build $(arg_nocache) -t pythonlib_cpu -f pythonlib/Dockerfile.cpu pythonlib

clean_pythonlib_cpu: clean_ffmpeg_cpu
	if [ "$$(docker images -q --filter=reference='pythonlib_cpu')" != "" ]; then docker rmi pythonlib_cpu; else echo "0"; fi

pythonlib_gpu: 
	nvidia-docker build $(arg_nocache) -t pythonlib_gpu -f pythonlib/Dockerfile.gpu pythonlib

clean_pythonlib_gpu: clean_ffmpeg_gpu
	if [ "$$(docker images -q --filter=reference='pythonlib_gpu')" != "" ]; then docker rmi pythonlib_gpu; else echo "0"; fi


NOCACHE=OFF

ifeq ($(NOCACHE),ON)
	arg_nocache=--no-cache
else
	arg_nocache=
endif


.PHONY: script_amalgamation script_makefile all all_cpu all_gpu clean clean_cpu clean_gpu jupyter_cpu jupyter_gpu cntk_cpu cntk_gpu nnvm_cpu nnvm_cpu_nnpack nnvm_cpu_opencl nnvm_gpu_opencl numba_cpu numba_gpu chainer_cpu chainer_gpu mxnet_cpu mxnet_cpu_mkl mxnet_cpu_nnpack mxnet_gpu pytorch_cpu pytorch_gpu tensorflow_cpu tensorflow_gpu redis_cpu redis_gpu opencv_cpu opencv_gpu ffmpeg_cpu ffmpeg_gpu mxnet_android alpine_dotnet alpine_dotnet_sdk alpine_nginx alpine_node alpine_pythonlib alpine_redis pythonlib_cpu pythonlib_gpu clean_jupyter_cpu clean_jupyter_gpu clean_cntk_cpu clean_cntk_gpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_nnvm_gpu_opencl clean_numba_cpu clean_numba_gpu clean_chainer_cpu clean_chainer_gpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_mxnet_gpu clean_pytorch_cpu clean_pytorch_gpu clean_tensorflow_cpu clean_tensorflow_gpu clean_redis_cpu clean_redis_gpu clean_opencv_cpu clean_opencv_gpu clean_ffmpeg_cpu clean_ffmpeg_gpu clean_mxnet_android clean_alpine_dotnet clean_alpine_dotnet_sdk clean_alpine_nginx clean_alpine_node clean_alpine_pythonlib clean_alpine_redis clean_pythonlib_cpu clean_pythonlib_gpu


script_makefile:
	cd script && python3 generate.py makefile

script_amalgamation:
	cd script && python3 generate.py amalgamation

all: all_cpu all_gpu

all_cpu: pythonlib_cpu ffmpeg_cpu opencv_cpu redis_cpu tensorflow_cpu pytorch_cpu mxnet_cpu_nnpack mxnet_cpu_mkl mxnet_cpu chainer_cpu numba_cpu nnvm_cpu_opencl nnvm_cpu_nnpack nnvm_cpu cntk_cpu jupyter_cpu

all_gpu: pythonlib_gpu ffmpeg_gpu opencv_gpu redis_gpu tensorflow_gpu pytorch_gpu mxnet_gpu chainer_gpu numba_gpu nnvm_gpu_opencl cntk_gpu jupyter_gpu

all_alpine: alpine_redis alpine_pythonlib alpine_node alpine_nginx alpine_dotnet_sdk alpine_dotnet


clean: clean_jupyter_cpu clean_jupyter_gpu clean_cntk_cpu clean_cntk_gpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_nnvm_gpu_opencl clean_numba_cpu clean_numba_gpu clean_chainer_cpu clean_chainer_gpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_mxnet_gpu clean_pytorch_cpu clean_pytorch_gpu clean_tensorflow_cpu clean_tensorflow_gpu clean_redis_cpu clean_redis_gpu clean_opencv_cpu clean_opencv_gpu clean_ffmpeg_cpu clean_ffmpeg_gpu clean_mxnet_android clean_alpine_dotnet clean_alpine_dotnet_sdk clean_alpine_nginx clean_alpine_node clean_alpine_pythonlib clean_alpine_redis clean_pythonlib_cpu clean_pythonlib_gpu

clean_cpu: clean_jupyter_cpu clean_cntk_cpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_numba_cpu clean_chainer_cpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_pytorch_cpu clean_tensorflow_cpu clean_redis_cpu clean_opencv_cpu clean_ffmpeg_cpu clean_pythonlib_cpu

clean_gpu: clean_jupyter_gpu clean_cntk_gpu clean_nnvm_gpu_opencl clean_numba_gpu clean_chainer_gpu clean_mxnet_gpu clean_pytorch_gpu clean_tensorflow_gpu clean_redis_gpu clean_opencv_gpu clean_ffmpeg_gpu clean_pythonlib_gpu


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

nnvm_cpu: mxnet_cpu
	docker build $(arg_nocache) -t nnvm_cpu -f nnvm/Dockerfile.cpu nnvm

clean_nnvm_cpu: 
	if [ "$$(docker images -q --filter=reference='nnvm_cpu')" != "" ]; then docker rmi nnvm_cpu; else echo "0"; fi

nnvm_cpu_nnpack: mxnet_cpu
	docker build $(arg_nocache) -t nnvm_cpu_nnpack -f nnvm/Dockerfile.cpu.nnpack nnvm

clean_nnvm_cpu_nnpack: 
	if [ "$$(docker images -q --filter=reference='nnvm_cpu_nnpack')" != "" ]; then docker rmi nnvm_cpu_nnpack; else echo "0"; fi

nnvm_cpu_opencl: mxnet_cpu
	docker build $(arg_nocache) -t nnvm_cpu_opencl -f nnvm/Dockerfile.cpu.opencl nnvm

clean_nnvm_cpu_opencl: 
	if [ "$$(docker images -q --filter=reference='nnvm_cpu_opencl')" != "" ]; then docker rmi nnvm_cpu_opencl; else echo "0"; fi

nnvm_gpu_opencl: mxnet_gpu
	nvidia-docker build $(arg_nocache) -t nnvm_gpu_opencl -f nnvm/Dockerfile.gpu.opencl nnvm

clean_nnvm_gpu_opencl: 
	if [ "$$(docker images -q --filter=reference='nnvm_gpu_opencl')" != "" ]; then docker rmi nnvm_gpu_opencl; else echo "0"; fi

numba_cpu: mxnet_cpu
	docker build $(arg_nocache) -t numba_cpu -f numba/Dockerfile.cpu numba

clean_numba_cpu: clean_jupyter_cpu
	if [ "$$(docker images -q --filter=reference='numba_cpu')" != "" ]; then docker rmi numba_cpu; else echo "0"; fi

numba_gpu: mxnet_gpu
	nvidia-docker build $(arg_nocache) -t numba_gpu -f numba/Dockerfile.gpu numba

clean_numba_gpu: clean_jupyter_gpu
	if [ "$$(docker images -q --filter=reference='numba_gpu')" != "" ]; then docker rmi numba_gpu; else echo "0"; fi

chainer_cpu: redis_cpu
	docker build $(arg_nocache) -t chainer_cpu -f chainer/Dockerfile.cpu chainer

clean_chainer_cpu: 
	if [ "$$(docker images -q --filter=reference='chainer_cpu')" != "" ]; then docker rmi chainer_cpu; else echo "0"; fi

chainer_gpu: redis_gpu
	nvidia-docker build $(arg_nocache) -t chainer_gpu -f chainer/Dockerfile.gpu chainer

clean_chainer_gpu: 
	if [ "$$(docker images -q --filter=reference='chainer_gpu')" != "" ]; then docker rmi chainer_gpu; else echo "0"; fi

mxnet_cpu: redis_cpu
	docker build $(arg_nocache) -t mxnet_cpu -f mxnet/Dockerfile.cpu mxnet

clean_mxnet_cpu: clean_jupyter_cpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_numba_cpu
	if [ "$$(docker images -q --filter=reference='mxnet_cpu')" != "" ]; then docker rmi mxnet_cpu; else echo "0"; fi

mxnet_cpu_mkl: redis_cpu
	docker build $(arg_nocache) -t mxnet_cpu_mkl -f mxnet/Dockerfile.cpu.mkl mxnet

clean_mxnet_cpu_mkl: 
	if [ "$$(docker images -q --filter=reference='mxnet_cpu_mkl')" != "" ]; then docker rmi mxnet_cpu_mkl; else echo "0"; fi

mxnet_cpu_nnpack: redis_cpu
	docker build $(arg_nocache) -t mxnet_cpu_nnpack -f mxnet/Dockerfile.cpu.nnpack mxnet

clean_mxnet_cpu_nnpack: 
	if [ "$$(docker images -q --filter=reference='mxnet_cpu_nnpack')" != "" ]; then docker rmi mxnet_cpu_nnpack; else echo "0"; fi

mxnet_gpu: redis_gpu
	nvidia-docker build $(arg_nocache) -t mxnet_gpu -f mxnet/Dockerfile.gpu mxnet

clean_mxnet_gpu: clean_jupyter_gpu clean_nnvm_gpu_opencl clean_numba_gpu
	if [ "$$(docker images -q --filter=reference='mxnet_gpu')" != "" ]; then docker rmi mxnet_gpu; else echo "0"; fi

pytorch_cpu: redis_cpu
	docker build $(arg_nocache) -t pytorch_cpu -f pytorch/Dockerfile.cpu pytorch

clean_pytorch_cpu: 
	if [ "$$(docker images -q --filter=reference='pytorch_cpu')" != "" ]; then docker rmi pytorch_cpu; else echo "0"; fi

pytorch_gpu: redis_gpu
	nvidia-docker build $(arg_nocache) -t pytorch_gpu -f pytorch/Dockerfile.gpu pytorch

clean_pytorch_gpu: 
	if [ "$$(docker images -q --filter=reference='pytorch_gpu')" != "" ]; then docker rmi pytorch_gpu; else echo "0"; fi

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

clean_redis_cpu: clean_jupyter_cpu clean_cntk_cpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_numba_cpu clean_chainer_cpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_pytorch_cpu clean_tensorflow_cpu
	if [ "$$(docker images -q --filter=reference='redis_cpu')" != "" ]; then docker rmi redis_cpu; else echo "0"; fi

redis_gpu: opencv_gpu
	nvidia-docker build $(arg_nocache) -t redis_gpu -f redis/Dockerfile.gpu redis

clean_redis_gpu: clean_jupyter_gpu clean_cntk_gpu clean_nnvm_gpu_opencl clean_numba_gpu clean_chainer_gpu clean_mxnet_gpu clean_pytorch_gpu clean_tensorflow_gpu
	if [ "$$(docker images -q --filter=reference='redis_gpu')" != "" ]; then docker rmi redis_gpu; else echo "0"; fi

opencv_cpu: ffmpeg_cpu
	docker build $(arg_nocache) -t opencv_cpu -f opencv/Dockerfile.cpu opencv

clean_opencv_cpu: clean_jupyter_cpu clean_cntk_cpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_numba_cpu clean_chainer_cpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_pytorch_cpu clean_tensorflow_cpu clean_redis_cpu
	if [ "$$(docker images -q --filter=reference='opencv_cpu')" != "" ]; then docker rmi opencv_cpu; else echo "0"; fi

opencv_gpu: ffmpeg_gpu
	nvidia-docker build $(arg_nocache) -t opencv_gpu -f opencv/Dockerfile.gpu opencv

clean_opencv_gpu: clean_jupyter_gpu clean_cntk_gpu clean_nnvm_gpu_opencl clean_numba_gpu clean_chainer_gpu clean_mxnet_gpu clean_pytorch_gpu clean_tensorflow_gpu clean_redis_gpu
	if [ "$$(docker images -q --filter=reference='opencv_gpu')" != "" ]; then docker rmi opencv_gpu; else echo "0"; fi

ffmpeg_cpu: pythonlib_cpu
	docker build $(arg_nocache) -t ffmpeg_cpu -f ffmpeg/Dockerfile.cpu ffmpeg

clean_ffmpeg_cpu: clean_jupyter_cpu clean_cntk_cpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_numba_cpu clean_chainer_cpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_pytorch_cpu clean_tensorflow_cpu clean_redis_cpu clean_opencv_cpu
	if [ "$$(docker images -q --filter=reference='ffmpeg_cpu')" != "" ]; then docker rmi ffmpeg_cpu; else echo "0"; fi

ffmpeg_gpu: pythonlib_gpu
	nvidia-docker build $(arg_nocache) -t ffmpeg_gpu -f ffmpeg/Dockerfile.gpu ffmpeg

clean_ffmpeg_gpu: clean_jupyter_gpu clean_cntk_gpu clean_nnvm_gpu_opencl clean_numba_gpu clean_chainer_gpu clean_mxnet_gpu clean_pytorch_gpu clean_tensorflow_gpu clean_redis_gpu clean_opencv_gpu
	if [ "$$(docker images -q --filter=reference='ffmpeg_gpu')" != "" ]; then docker rmi ffmpeg_gpu; else echo "0"; fi

mxnet_android: pythonlib_cpu
	docker build $(arg_nocache) -t mxnet_android -f mxnet/Dockerfile.android mxnet

clean_mxnet_android: 
	if [ "$$(docker images -q --filter=reference='mxnet_android')" != "" ]; then docker rmi mxnet_android; else echo "0"; fi

alpine_dotnet: 
	docker build $(arg_nocache) -t alpine_dotnet -f alpine/Dockerfile.dotnet alpine

clean_alpine_dotnet: 
	if [ "$$(docker images -q --filter=reference='alpine_dotnet')" != "" ]; then docker rmi alpine_dotnet; else echo "0"; fi

alpine_dotnet_sdk: 
	docker build $(arg_nocache) -t alpine_dotnet_sdk -f alpine/Dockerfile.dotnet.sdk alpine

clean_alpine_dotnet_sdk: 
	if [ "$$(docker images -q --filter=reference='alpine_dotnet_sdk')" != "" ]; then docker rmi alpine_dotnet_sdk; else echo "0"; fi

alpine_nginx: 
	docker build $(arg_nocache) -t alpine_nginx -f alpine/Dockerfile.nginx alpine

clean_alpine_nginx: 
	if [ "$$(docker images -q --filter=reference='alpine_nginx')" != "" ]; then docker rmi alpine_nginx; else echo "0"; fi

alpine_node: 
	docker build $(arg_nocache) -t alpine_node -f alpine/Dockerfile.node alpine

clean_alpine_node: 
	if [ "$$(docker images -q --filter=reference='alpine_node')" != "" ]; then docker rmi alpine_node; else echo "0"; fi

alpine_pythonlib: 
	docker build $(arg_nocache) -t alpine_pythonlib -f alpine/Dockerfile.pythonlib alpine

clean_alpine_pythonlib: 
	if [ "$$(docker images -q --filter=reference='alpine_pythonlib')" != "" ]; then docker rmi alpine_pythonlib; else echo "0"; fi

alpine_redis: 
	docker build $(arg_nocache) -t alpine_redis -f alpine/Dockerfile.redis alpine

clean_alpine_redis: 
	if [ "$$(docker images -q --filter=reference='alpine_redis')" != "" ]; then docker rmi alpine_redis; else echo "0"; fi

pythonlib_cpu: 
	docker build $(arg_nocache) -t pythonlib_cpu -f pythonlib/Dockerfile.cpu pythonlib

clean_pythonlib_cpu: clean_jupyter_cpu clean_cntk_cpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_numba_cpu clean_chainer_cpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_pytorch_cpu clean_tensorflow_cpu clean_redis_cpu clean_opencv_cpu clean_ffmpeg_cpu clean_mxnet_android
	if [ "$$(docker images -q --filter=reference='pythonlib_cpu')" != "" ]; then docker rmi pythonlib_cpu; else echo "0"; fi

pythonlib_gpu: 
	nvidia-docker build $(arg_nocache) -t pythonlib_gpu -f pythonlib/Dockerfile.gpu pythonlib

clean_pythonlib_gpu: clean_jupyter_gpu clean_cntk_gpu clean_nnvm_gpu_opencl clean_numba_gpu clean_chainer_gpu clean_mxnet_gpu clean_pytorch_gpu clean_tensorflow_gpu clean_redis_gpu clean_opencv_gpu clean_ffmpeg_gpu
	if [ "$$(docker images -q --filter=reference='pythonlib_gpu')" != "" ]; then docker rmi pythonlib_gpu; else echo "0"; fi


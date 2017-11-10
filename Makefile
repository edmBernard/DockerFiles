NOCACHE=OFF

ifeq ($(NOCACHE),ON)
	arg_nocache=--no-cache
else
	arg_nocache=
endif


.PHONY: script_amalgamation script_makefile all all_cpu all_gpu clean clean_cpu clean_gpu jupyter_cpu jupyter_gpu chainer_cpu_jupyter cntk_cpu cntk_gpu nnvm_cpu nnvm_cpu_nnpack nnvm_cpu_opencl nnvm_gpu_opencl numba_cpu numba_gpu chainer_cpu chainer_gpu mxnet_cpu mxnet_cpu_mkl mxnet_cpu_nnpack mxnet_gpu pytorch_cpu pytorch_cpu_pip pytorch_gpu pytorch_gpu_pip tensorflow_cpu tensorflow_gpu redis_cpu redis_gpu opencv_cpu opencv_gpu ffmpeg_cpu ffmpeg_gpu mxnet_android python36_alpine python36_ubuntu pythonlib_cpu pythonlib_gpu tensorflow_cpu_src_py2 tensorflow_cpu_src_py3 tensorflow_gpu_src_py2 tensorflow_gpu_src_py3 clean_jupyter_cpu clean_jupyter_gpu clean_chainer_cpu_jupyter clean_cntk_cpu clean_cntk_gpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_nnvm_gpu_opencl clean_numba_cpu clean_numba_gpu clean_chainer_cpu clean_chainer_gpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_mxnet_gpu clean_pytorch_cpu clean_pytorch_cpu_pip clean_pytorch_gpu clean_pytorch_gpu_pip clean_tensorflow_cpu clean_tensorflow_gpu clean_redis_cpu clean_redis_gpu clean_opencv_cpu clean_opencv_gpu clean_ffmpeg_cpu clean_ffmpeg_gpu clean_mxnet_android clean_python36_alpine clean_python36_ubuntu clean_pythonlib_cpu clean_pythonlib_gpu clean_tensorflow_cpu_src_py2 clean_tensorflow_cpu_src_py3 clean_tensorflow_gpu_src_py2 clean_tensorflow_gpu_src_py3


script_makefile:
	cd script && python3 generate.py makefile

script_amalgamation:
	cd script && python3 generate.py amalgamation

all: all_cpu all_gpu

all_cpu: tensorflow_cpu_src_py3 tensorflow_cpu_src_py2 pythonlib_cpu ffmpeg_cpu opencv_cpu redis_cpu tensorflow_cpu pytorch_cpu_pip pytorch_cpu mxnet_cpu_nnpack mxnet_cpu_mkl mxnet_cpu chainer_cpu numba_cpu nnvm_cpu_opencl nnvm_cpu_nnpack nnvm_cpu cntk_cpu chainer_cpu_jupyter jupyter_cpu

all_gpu: tensorflow_gpu_src_py3 tensorflow_gpu_src_py2 pythonlib_gpu ffmpeg_gpu opencv_gpu redis_gpu tensorflow_gpu pytorch_gpu_pip pytorch_gpu mxnet_gpu chainer_gpu numba_gpu nnvm_gpu_opencl cntk_gpu jupyter_gpu


clean: clean_jupyter_cpu clean_jupyter_gpu clean_chainer_cpu_jupyter clean_cntk_cpu clean_cntk_gpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_nnvm_gpu_opencl clean_numba_cpu clean_numba_gpu clean_chainer_cpu clean_chainer_gpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_mxnet_gpu clean_pytorch_cpu clean_pytorch_cpu_pip clean_pytorch_gpu clean_pytorch_gpu_pip clean_tensorflow_cpu clean_tensorflow_gpu clean_redis_cpu clean_redis_gpu clean_opencv_cpu clean_opencv_gpu clean_ffmpeg_cpu clean_ffmpeg_gpu clean_mxnet_android clean_python36_alpine clean_python36_ubuntu clean_pythonlib_cpu clean_pythonlib_gpu clean_tensorflow_cpu_src_py2 clean_tensorflow_cpu_src_py3 clean_tensorflow_gpu_src_py2 clean_tensorflow_gpu_src_py3

clean_cpu: clean_jupyter_cpu clean_chainer_cpu_jupyter clean_cntk_cpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_numba_cpu clean_chainer_cpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_pytorch_cpu clean_pytorch_cpu_pip clean_tensorflow_cpu clean_redis_cpu clean_opencv_cpu clean_ffmpeg_cpu clean_pythonlib_cpu clean_tensorflow_cpu_src_py2 clean_tensorflow_cpu_src_py3

clean_gpu: clean_jupyter_gpu clean_cntk_gpu clean_nnvm_gpu_opencl clean_numba_gpu clean_chainer_gpu clean_mxnet_gpu clean_pytorch_gpu clean_pytorch_gpu_pip clean_tensorflow_gpu clean_redis_gpu clean_opencv_gpu clean_ffmpeg_gpu clean_pythonlib_gpu clean_tensorflow_gpu_src_py2 clean_tensorflow_gpu_src_py3


jupyter_cpu: numba_cpu
	docker build $(arg_nocache) -t jupyter_cpu -f jupyter/Dockerfile.cpu jupyter

clean_jupyter_cpu: 
	if [ "$$(docker images -q --filter=reference='jupyter_cpu')" != "" ]; then docker rmi jupyter_cpu; else echo "0"; fi

jupyter_gpu: numba_gpu
	nvidia-docker build $(arg_nocache) -t jupyter_gpu -f jupyter/Dockerfile.gpu jupyter

clean_jupyter_gpu: 
	if [ "$$(docker images -q --filter=reference='jupyter_gpu')" != "" ]; then docker rmi jupyter_gpu; else echo "0"; fi

chainer_cpu_jupyter: chainer_cpu
	docker build $(arg_nocache) -t chainer_cpu_jupyter -f super/chainer/Dockerfile.cpu.jupyter super

clean_chainer_cpu_jupyter: 
	if [ "$$(docker images -q --filter=reference='chainer_cpu_jupyter')" != "" ]; then docker rmi chainer_cpu_jupyter; else echo "0"; fi

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

clean_chainer_cpu: clean_chainer_cpu_jupyter
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

pytorch_cpu_pip: redis_cpu
	docker build $(arg_nocache) -t pytorch_cpu_pip -f pytorch/Dockerfile.cpu.pip pytorch

clean_pytorch_cpu_pip: 
	if [ "$$(docker images -q --filter=reference='pytorch_cpu_pip')" != "" ]; then docker rmi pytorch_cpu_pip; else echo "0"; fi

pytorch_gpu: redis_gpu
	nvidia-docker build $(arg_nocache) -t pytorch_gpu -f pytorch/Dockerfile.gpu pytorch

clean_pytorch_gpu: 
	if [ "$$(docker images -q --filter=reference='pytorch_gpu')" != "" ]; then docker rmi pytorch_gpu; else echo "0"; fi

pytorch_gpu_pip: redis_gpu
	nvidia-docker build $(arg_nocache) -t pytorch_gpu_pip -f pytorch/Dockerfile.gpu.pip pytorch

clean_pytorch_gpu_pip: 
	if [ "$$(docker images -q --filter=reference='pytorch_gpu_pip')" != "" ]; then docker rmi pytorch_gpu_pip; else echo "0"; fi

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

clean_redis_cpu: clean_jupyter_cpu clean_chainer_cpu_jupyter clean_cntk_cpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_numba_cpu clean_chainer_cpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_pytorch_cpu clean_pytorch_cpu_pip clean_tensorflow_cpu
	if [ "$$(docker images -q --filter=reference='redis_cpu')" != "" ]; then docker rmi redis_cpu; else echo "0"; fi

redis_gpu: opencv_gpu
	nvidia-docker build $(arg_nocache) -t redis_gpu -f redis/Dockerfile.gpu redis

clean_redis_gpu: clean_jupyter_gpu clean_cntk_gpu clean_nnvm_gpu_opencl clean_numba_gpu clean_chainer_gpu clean_mxnet_gpu clean_pytorch_gpu clean_pytorch_gpu_pip clean_tensorflow_gpu
	if [ "$$(docker images -q --filter=reference='redis_gpu')" != "" ]; then docker rmi redis_gpu; else echo "0"; fi

opencv_cpu: ffmpeg_cpu
	docker build $(arg_nocache) -t opencv_cpu -f opencv/Dockerfile.cpu opencv

clean_opencv_cpu: clean_jupyter_cpu clean_chainer_cpu_jupyter clean_cntk_cpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_numba_cpu clean_chainer_cpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_pytorch_cpu clean_pytorch_cpu_pip clean_tensorflow_cpu clean_redis_cpu
	if [ "$$(docker images -q --filter=reference='opencv_cpu')" != "" ]; then docker rmi opencv_cpu; else echo "0"; fi

opencv_gpu: ffmpeg_gpu
	nvidia-docker build $(arg_nocache) -t opencv_gpu -f opencv/Dockerfile.gpu opencv

clean_opencv_gpu: clean_jupyter_gpu clean_cntk_gpu clean_nnvm_gpu_opencl clean_numba_gpu clean_chainer_gpu clean_mxnet_gpu clean_pytorch_gpu clean_pytorch_gpu_pip clean_tensorflow_gpu clean_redis_gpu
	if [ "$$(docker images -q --filter=reference='opencv_gpu')" != "" ]; then docker rmi opencv_gpu; else echo "0"; fi

ffmpeg_cpu: pythonlib_cpu
	docker build $(arg_nocache) -t ffmpeg_cpu -f ffmpeg/Dockerfile.cpu ffmpeg

clean_ffmpeg_cpu: clean_jupyter_cpu clean_chainer_cpu_jupyter clean_cntk_cpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_numba_cpu clean_chainer_cpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_pytorch_cpu clean_pytorch_cpu_pip clean_tensorflow_cpu clean_redis_cpu clean_opencv_cpu
	if [ "$$(docker images -q --filter=reference='ffmpeg_cpu')" != "" ]; then docker rmi ffmpeg_cpu; else echo "0"; fi

ffmpeg_gpu: pythonlib_gpu
	nvidia-docker build $(arg_nocache) -t ffmpeg_gpu -f ffmpeg/Dockerfile.gpu ffmpeg

clean_ffmpeg_gpu: clean_jupyter_gpu clean_cntk_gpu clean_nnvm_gpu_opencl clean_numba_gpu clean_chainer_gpu clean_mxnet_gpu clean_pytorch_gpu clean_pytorch_gpu_pip clean_tensorflow_gpu clean_redis_gpu clean_opencv_gpu
	if [ "$$(docker images -q --filter=reference='ffmpeg_gpu')" != "" ]; then docker rmi ffmpeg_gpu; else echo "0"; fi

mxnet_android: pythonlib_cpu
	docker build $(arg_nocache) -t mxnet_android -f mxnet/Dockerfile.android mxnet

clean_mxnet_android: 
	if [ "$$(docker images -q --filter=reference='mxnet_android')" != "" ]; then docker rmi mxnet_android; else echo "0"; fi

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

clean_pythonlib_cpu: clean_jupyter_cpu clean_chainer_cpu_jupyter clean_cntk_cpu clean_nnvm_cpu clean_nnvm_cpu_nnpack clean_nnvm_cpu_opencl clean_numba_cpu clean_chainer_cpu clean_mxnet_cpu clean_mxnet_cpu_mkl clean_mxnet_cpu_nnpack clean_pytorch_cpu clean_pytorch_cpu_pip clean_tensorflow_cpu clean_redis_cpu clean_opencv_cpu clean_ffmpeg_cpu clean_mxnet_android
	if [ "$$(docker images -q --filter=reference='pythonlib_cpu')" != "" ]; then docker rmi pythonlib_cpu; else echo "0"; fi

pythonlib_gpu: 
	nvidia-docker build $(arg_nocache) -t pythonlib_gpu -f pythonlib/Dockerfile.gpu pythonlib

clean_pythonlib_gpu: clean_jupyter_gpu clean_cntk_gpu clean_nnvm_gpu_opencl clean_numba_gpu clean_chainer_gpu clean_mxnet_gpu clean_pytorch_gpu clean_pytorch_gpu_pip clean_tensorflow_gpu clean_redis_gpu clean_opencv_gpu clean_ffmpeg_gpu
	if [ "$$(docker images -q --filter=reference='pythonlib_gpu')" != "" ]; then docker rmi pythonlib_gpu; else echo "0"; fi

tensorflow_cpu_src_py2: 
	docker build $(arg_nocache) -t tensorflow_cpu_src_py2 -f super/tensorflow/Dockerfile.cpu.src.py2 super

clean_tensorflow_cpu_src_py2: 
	if [ "$$(docker images -q --filter=reference='tensorflow_cpu_src_py2')" != "" ]; then docker rmi tensorflow_cpu_src_py2; else echo "0"; fi

tensorflow_cpu_src_py3: 
	docker build $(arg_nocache) -t tensorflow_cpu_src_py3 -f super/tensorflow/Dockerfile.cpu.src.py3 super

clean_tensorflow_cpu_src_py3: 
	if [ "$$(docker images -q --filter=reference='tensorflow_cpu_src_py3')" != "" ]; then docker rmi tensorflow_cpu_src_py3; else echo "0"; fi

tensorflow_gpu_src_py2: 
	nvidia-docker build $(arg_nocache) -t tensorflow_gpu_src_py2 -f super/tensorflow/Dockerfile.gpu.src.py2 super

clean_tensorflow_gpu_src_py2: 
	if [ "$$(docker images -q --filter=reference='tensorflow_gpu_src_py2')" != "" ]; then docker rmi tensorflow_gpu_src_py2; else echo "0"; fi

tensorflow_gpu_src_py3: 
	nvidia-docker build $(arg_nocache) -t tensorflow_gpu_src_py3 -f super/tensorflow/Dockerfile.gpu.src.py3 super

clean_tensorflow_gpu_src_py3: 
	if [ "$$(docker images -q --filter=reference='tensorflow_gpu_src_py3')" != "" ]; then docker rmi tensorflow_gpu_src_py3; else echo "0"; fi


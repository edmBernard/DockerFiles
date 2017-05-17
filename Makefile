
define create_image
	docker build -t $(1) -f $(2)/$(1)/Dockerfile $(2)/$(1)
endef

define create_image_gpu
        nvidia-docker build -t $(1) -f $(2)/$(1)/Dockerfile $(2)/$(1)
endef

.PHONY: all python_lib ffmpeg opencv redis mxnet nnpack_mxnet numba jupyter gpu_all gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis gpu_mxnet gpu_numba gpu_jupyter

all: mxnet nnpack_mxnet jupyter

# build CPU images
python_lib:
	$(call create_image,$@,cpu)

ffmpeg: python_lib
	$(call create_image,$@,cpu)

opencv: ffmpeg
	$(call create_image,$@,cpu)

redis: opencv
	$(call create_image,$@,cpu)

mxnet: redis
	$(call create_image,$@,cpu)

nnpack_mxnet: redis
	$(call create_image,$@,cpu)

numba: mxnet
	$(call create_image,$@,cpu)

jupyter: numba
	$(call create_image,$@,cpu)

clean:
	docker rmi jupyter numba mxnet redis opencv ffmpeg python_lib

# build GPU images
gpu_python_lib:
	$(call create_image_gpu,$@,gpu)

gpu_ffmpeg: gpu_python_lib 
	$(call create_image_gpu,$@,gpu)

gpu_opencv: gpu_python_lib gpu_ffmpeg
	$(call create_image_gpu,$@,gpu)

gpu_redis: gpu_python_lib gpu_ffmpeg gpu_opencv 
	$(call create_image_gpu,$@,gpu)

gpu_mxnet: gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis 
	$(call create_image_gpu,$@,gpu)

gpu_numba: gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis gpu_mxnet 
	$(call create_image_gpu,$@,gpu)

gpu_jupyter: gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis gpu_mxnet gpu_numba gpu_jupyter 
	$(call create_image_gpu,$@,gpu)

gpu_all: gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis gpu_mxnet gpu_numba gpu_jupyter 

clean_gpu:
	docker rmi gpu_jupyter gpu_numba gpu_mxnet gpu_redis gpu_opencv gpu_ffmpeg gpu_python_lib

# build small image with python3.6
python36:
	docker build -t alpine_python3.6 -f python36/Dockerfile_alpine python36

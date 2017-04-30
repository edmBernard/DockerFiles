
define create_image
	docker build -t $(1) -f $(2)/$(1)/Dockerfile $(2)/$(1)
endef

.PHONY: all python_lib ffmpeg opencv redis mxnet numba jupyter gpu_all gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis gpu_mxnet gpu_numba gpu_jupyter 

# build CPU images
python_lib:
	$(call create_image,$@,cpu)

ffmpeg: python_lib
	$(call create_image,$@,cpu)

opencv: python_lib ffmpeg
	$(call create_image,$@,cpu)

redis: python_lib ffmpeg opencv
	$(call create_image,$@,cpu)

mxnet: python_lib ffmpeg opencv redis
	$(call create_image,$@,cpu)

numba: python_lib ffmpeg opencv redis mxnet
	$(call create_image,$@,cpu)

jupyter: python_lib ffmpeg opencv redis mxnet numba
	$(call create_image,$@,cpu)

all: python_lib ffmpeg opencv redis mxnet numba jupyter


# build GPU images
gpu_python_lib:
	$(call create_image,$@,gpu)

gpu_ffmpeg: gpu_python_lib 
	$(call create_image,$@,gpu)

gpu_opencv: gpu_python_lib gpu_ffmpeg
	$(call create_image,$@,gpu)

gpu_redis: gpu_python_lib gpu_ffmpeg gpu_opencv 
	$(call create_image,$@,gpu)

gpu_mxnet: gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis 
	$(call create_image,$@,gpu)

gpu_numba: gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis gpu_mxnet 
	$(call create_image,$@,gpu)

gpu_jupyter: gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis gpu_mxnet gpu_numba gpu_jupyter 
	$(call create_image,$@,gpu)

gpu_all: gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis gpu_mxnet gpu_numba gpu_jupyter 


# build small image with python3.6
python36:
	docker build -t alpine_python3.6 -f python36/Dockerfile_alpine python36

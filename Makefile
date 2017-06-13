
NOCACHE=OFF

ifeq ($(NOCACHE),ON)
	arg_nocache=--no-cache
else
	arg_nocache=
endif

define create_image
$(if $(filter $(2),gpu),
    nvidia-docker build $(arg_nocache) -t $(1) -f $(2)/$(1)/Dockerfile $(2)/$(1),
    docker build $(arg_nocache) -t $(1) -f $(2)/$(1)/Dockerfile $(2)/$(1)
)
endef


.PHONY: all python_lib ffmpeg opencv redis mxnet nnpack_mxnet tensorflow numba jupyter gpu_all gpu_python_lib gpu_ffmpeg gpu_opencv gpu_redis gpu_mxnet gpu_tensorflow gpu_numba gpu_jupyter

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

tensorflow: redis
	$(call create_image,$@,cpu)

numba: mxnet
	$(call create_image,$@,cpu)

jupyter: numba
	$(call create_image,$@,cpu)

clean:
	docker rmi jupyter numba tensorflow mxnet nnpack_mxnet redis opencv ffmpeg python_lib

# build GPU images
gpu_python_lib:
	$(call create_image,$@,gpu)

gpu_ffmpeg: gpu_python_lib
	$(call create_image,$@,gpu)

gpu_opencv: gpu_ffmpeg
	$(call create_image,$@,gpu)

gpu_redis: gpu_opencv
	$(call create_image,$@,gpu)

gpu_mxnet: gpu_redis
	$(call create_image,$@,gpu)

gpu_tensorflow: gpu_redis
	$(call create_image,$@,gpu)

gpu_numba: gpu_mxnet
	$(call create_image,$@,gpu)

gpu_jupyter: gpu_numba
	$(call create_image,$@,gpu)

gpu_all: gpu_mxnet gpu_jupyter

clean_gpu:
	docker rmi gpu_jupyter gpu_numba gpu_tensorflow gpu_mxnet gpu_redis gpu_opencv gpu_ffmpeg gpu_python_lib

# build small image with python3.6
python36:
	docker build -t alpine_python3.6 -f python36/Dockerfile_alpine python36

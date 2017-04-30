
define create_image
	docker build -t $(1) -f $(2)/$(1)/Dockerfile $(2)/$(1)
endef

.PHONY: all python_lib ffmpeg opencv redis mxnet numba jupyter

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

# cuda:
# 	docker build -t cuda80_cudnn5_opencv3 -f cuda80_cudnn5_opencv/Dockerfile cuda80_cudnn5_opencv

# mxnet: cuda
# 	docker build -t opencv_mxnet -f opencv_mxnet/Dockerfile opencv_mxnet

# opencv: 
# 	docker build -t opencv_only -f opencv_only/Dockerfile opencv_only

# numba: opencv
# 	docker build -t opencv_numba -f opencv_numba/Dockerfile opencv_numba

# jupyter: numba
# 	docker build -t jupyter_server -f jupyter_server/Dockerfile jupyter_server

# tensorflow:
# 	docker build -t tensorflow_opencv -f tensorflow_opencv/Dockerfile tensorflow_opencv

# python36:
# 	docker build -t alpine_python3.6 -f python36/Dockerfile_alpine python36

# all: cuda mxnet opencv numba jupyter python36 tensorflow

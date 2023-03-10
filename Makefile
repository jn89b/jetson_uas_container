#
# Usage:
#   make <target> <arg-name>=<arg-value>
#
# Examples:
#   make term
#   make demo-world USE_GPU=true
#   make demo-behavior USE_GPU=false TARGET_COLOR=green BT_TYPE=queue

# Command-line arguments
TARGET_COLOR ?= blue    # Target color for behavior tree demo (red | green | blue)
USE_GPU ?= True        # Use GPU devices (set to true if you have an NVIDIA GPU)
BT_TYPE ?= queue        # Behavior tree type (naive | queue)

# Docker variables
IMAGE_NAME = uas
CORE_DOCKERFILE = ${PWD}/docker/dockerfile_nvidia_ros2_foxy
BASE_DOCKERFILE = ${PWD}/docker/dockerfile_uas_base
OVERLAY_DOCKERFILE = ${PWD}/docker/dockerfile_afrl_overlay

CORE_NANO_DOCKERFILE = ${PWD}/docker/dockerfile_nvidia_nano_ros2_foxy


# Set Docker volumes and environment variables
DOCKER_VOLUMES = \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"
DOCKER_ENV_VARS = \
	--env="NVIDIA_DRIVER_CAPABILITIES=all" \
	--env="DISPLAY" \
	--env="QT_X11_NO_MITSHM=1"
ifeq ("${USE_GPU}", "true")
DOCKER_GPU_ARGS = "--gpus all"
endif
DOCKER_ARGS = ${DOCKER_VOLUMES} ${DOCKER_ENV_VARS} ${DOCKER_GPU_VARS}


###########
#  SETUP  #
###########
# Build the core image
.PHONY: build-core
build-core:
	@docker build -f ${CORE_DOCKERFILE} -t nvidia_ros2_foxy .

.PHONY: build-base
build-base: build-core
	@docker build -f ${BASE_DOCKERFILE} -t ${IMAGE_NAME}_base .

# # Build the overlay image (depends on base image build)
# .PHONY: build
# build: build-base
# 	@docker build -f ${OVERLAY_DOCKERFILE} -t ${IMAGE_NAME}_overlay .

#Build Nano Image
.PHONY: build-nano
build-nano:
	@docker build -f ${CORE_NANO_DOCKERFILE} -t nvidia_ros2_foxy .


# Kill any running Docker containers
.PHONY: kill
kill:
	@echo "Closing all running Docker containers:"
	@docker kill $(shell docker ps -q --filter ancestor=${IMAGE_NAME}_overlay)


###########
#  TASKS  #
###########
#

# # Start a terminal inside the Docker container
# .PHONY: term
# term:
# 	@docker run -i --net=host \
# 		--device=/dev/ttyUSB0 \
# 		${DOCKER_ARGS} ${IMAGE_NAME}_overlay \
# 		bash

.PHONY: term
term:
	@docker run -it --net=host \
		${DOCKER_ARGS} nvidia_ros2_foxy 


# .PHONY: test
# test:
# 	@docker run -i --net=host \
# 		--device=/dev/ttyUSB0 \
# 		${DOCKER_ARGS} ${IMAGE_NAME}_overlay \
# 		roslaunch mavros px4.launch

# .PHONY: sim
# sim:
# 	@docker run -it --net=host \
#  		${DOCKER_ARGS} ${IMAGE_NAME}_overlay 

#example to build dockerfile
FROM dustynv/ros:foxy-ros-base-l4t-r35.2.1


#make workspace and directory for source code
RUN mkdir -p /catkin_ws/src && \
    cd /catkin_ws/src && \
    git clone https://github.com/jn89b/mpc_ros.git && \
    git clone https://github.com/jn89b/drone_ros.git

 # Set the working directory to /catkin_ws
WORKDIR /catkin_ws


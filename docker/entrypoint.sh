#!/bin/bash
# Basic entrypoint for ROS / Colcon Docker containers

# Source ROS 2 foxy
source ../opt/ros/foxy/setup.bash >> ~/.bashrc
echo "Sourced ROS 2 foxy"

# # Source the base workspace, if built
# if [ -f /drone_ws/install/setup.bash ]
# then
#   echo "$PWD"
#   echo "source install/setup.bash" >> ~/.bashrc
#   source install/setup.bash
#   echo "Sourced base workspace"
# fi
# echo "searching"

# Source the overlay workspace, if built
if [ -f /develop_ws/install/setup.bash ]
then
  echo "source /develop_ws/install/setup.bash" >> ~/.bashrc
  source /develop_ws/install/setup.bash
  echo "Sourced ROS developer workspace"
fi

# # Source the overlay workspace, if built
# if [ -f /overlay_ws/install/setup.bash ]
# then
#   echo "source /overlay_ws/install/setup.bash" >> ~/.bashrc
#   source /overlay_ws/install/setup.bash
#   export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$(ros2 pkg prefix tb3_worlds)/share/tb3_worlds/models
#   echo "Sourced autonomy overlay workspace"
# fi

# Execute the command passed into this entrypoint
exec "$@"

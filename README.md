# bruce_docker
Docker container for running ubuntu 18, ros melodic, and gazebo environment with python 2.

## Install docker: 

https://docs.docker.com/engine/install/ubuntu/

sudo apt-get install -y nvidia-container-toolkit

## To run: 

sudo docker build -t bruce-melodic -f bruce-melodic.Dockerfile 

xhost +

sudo docker run --rm -it --net=host -v /tmp/.X11-unix:/tmp/.X11-unix:rw -e DISPLAY="$DISPLAY" --privileged -v /dev/bus/usb:/dev/bus/usb  -v "/home/rfal/.ros/:/root/.ros/" -v "/home/rfal/ivana/PlanningWithVMExperiments/:/root/PlanningWithVMExperiments/" -e XDG_RUNTIME_DIR="/root/PlanningWithVMExperiments/" bruce-melodic bash

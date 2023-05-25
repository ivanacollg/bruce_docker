ARG ROS_DISTRO=melodic
FROM ros:${ROS_DISTRO}

ARG DEBIAN_FRONTEND=noninteractive 

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    nvidia-driver-515 \
    ros-melodic-nav-core \
    ros-melodic-cv-bridge \
    ros-melodic-tf2-geometry-msgs \
    ros-melodic-rviz \
    ros-melodic-rviz-imu-plugin \
    ros-melodic-rviz-plugin-tutorials \
    ros-melodic-grid-map-rviz-plugin \
    python-pip \
    python3-catkin-tools \
    socat \ 
    minicom \ 
    ros-melodic-move-base \
    ros-melodic-joy \
    ros-melodic-cv-bridge \
    ros-melodic-navfn \
    ros-melodic-teb-local-planner \
    ros-melodic-grid-map-ros \
    ros-melodic-move-base-msgs \
    ros-melodic-ros-numpy \ 
    ros-melodic-pybind11-catkin \
    libpcl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install mavproxy pymavlink tqdm numpy scipy matplotlib catkin-tools tqdm scikit-learn shapely cython pybind11\
	&& rm -rf /var/lib/apt/lists/*

# RUN mkdir -p catkin_ws/src && \
#    git clone "https://github.com/ivanacollg/uuv_simulator.git" "catkin_ws/src/uuv_simulator" --branch feature_sim_rov

COPY package_xml_batch catkin_ws/src

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    rosdep install -iy --from-paths "catkin_ws/src/uuv_simulator" \
    "catkin_ws/src/libnabo" \
    && rm -rf /var/lib/apt/lists/*

#COPY PlanningWithVMExperiments .
COPY uuv_simulator catkin_ws/src/uuv_simulator
COPY Argonaut catkin_ws/src/Argonaut
COPY libnabo catkin_ws/src/libnabo

RUN /ros_entrypoint.sh catkin build --workspace catkin_ws

COPY libpointmatcher catkin_ws/src/libpointmatcher
COPY gtsam catkin_ws/src/gtsam
RUN /ros_entrypoint.sh catkin build --workspace catkin_ws

COPY bruce catkin_ws/src/bruce
RUN /ros_entrypoint.sh catkin build --workspace catkin_ws


RUN sed -i "$(wc -l < /ros_entrypoint.sh)i\\source \"/catkin_ws/devel/setup.bash\"\\" /ros_entrypoint.sh

ENTRYPOINT [ "/ros_entrypoint.sh" ]

#sudo docker build -t bruce-melodic -f bruce-melodic.Dockerfile .
#xhost +
#sudo docker run --rm -it --net=host -v /tmp/.X11-unix:/tmp/.X11-unix:rw -e DISPLAY="$DISPLAY" --privileged -v /dev/bus/usb:/dev/bus/usb  -v "/home/rfal/.ros/:/root/./ros/" -v "/home/rfal/ivana/PlanningWithVMExperiments/:/root/PlanningWithVMExperiments/" bruce-melodic bash


#!/usr/bin/env bash
set -euo pipefail

SPAWN_X=${1:--1.0}
SPAWN_Y=${2:--1.0}
SPAWN_YAW=${3:-1.57}

# Start the first roslaunch in a new tab
gnome-terminal --tab -- bash -lc "roslaunch squeeze_navigation hydrus_bringup.launch headless:=false simulation:=true real_machine:=false spawn_x:=$SPAWN_X spawn_y:=$SPAWN_Y spawn_yaw:=$SPAWN_YAW; exec bash"

sleep 8

# Start keyboard command in a new tab
gnome-terminal --tab --title="keyboard" -- bash -lc "expect <<'EOF'
spawn rosrun aerial_robot_base keyboard_command.py
sleep 2
send \"r\r\"
sleep 1
send \"t\r\"
sleep 1
exit
EOF
"

sleep 20

# Start the planning launch in a new tab
gnome-terminal --tab -- bash -lc "roslaunch squeeze_navigation hydrus_passing_planning.launch start_squeeze_path_from_real_state:=true simulation:=true; exec bash"

sleep 10

# Publish the topic in a new tab
gnome-terminal --tab -- bash -lc "rostopic pub -1 /hydrus/plan_start std_msgs/Empty '{}'"

sleep 60

# Shut down all
pkill -f roslaunch
pkill -f rosrun
pkill -f rostopic

echo "Simulation completed."

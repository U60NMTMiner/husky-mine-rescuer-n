_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${_dir}/builder.sh
source ${_dir}/../ros/catkin_ws/devel/setup.zsh

export ROS_MASTER_URI="http://$(getip husky):11311"
export ROS_MASTER_IP="$(getip husky)"
export HUSKY_LOGITECH=1

# generated from catkin/cmake/template/pkgConfig.cmake.in

# append elements to a list and remove existing duplicates from the list
# copied from catkin/cmake/list_append_deduplicate.cmake to keep pkgConfig
# self contained
macro(_list_append_deduplicate listname)
  if(NOT "${ARGN}" STREQUAL "")
    if(${listname})
      list(REMOVE_ITEM ${listname} ${ARGN})
    endif()
    list(APPEND ${listname} ${ARGN})
  endif()
endmacro()

# append elements to a list if they are not already in the list
# copied from catkin/cmake/list_append_unique.cmake to keep pkgConfig
# self contained
macro(_list_append_unique listname)
  foreach(_item ${ARGN})
    list(FIND ${listname} ${_item} _index)
    if(_index EQUAL -1)
      list(APPEND ${listname} ${_item})
    endif()
  endforeach()
endmacro()

# pack a list of libraries with optional build configuration keywords
# copied from catkin/cmake/catkin_libraries.cmake to keep pkgConfig
# self contained
macro(_pack_libraries_with_build_configuration VAR)
  set(${VAR} "")
  set(_argn ${ARGN})
  list(LENGTH _argn _count)
  set(_index 0)
  while(${_index} LESS ${_count})
    list(GET _argn ${_index} lib)
    if("${lib}" MATCHES "^(debug|optimized|general)$")
      math(EXPR _index "${_index} + 1")
      if(${_index} EQUAL ${_count})
        message(FATAL_ERROR "_pack_libraries_with_build_configuration() the list of libraries '${ARGN}' ends with '${lib}' which is a build configuration keyword and must be followed by a library")
      endif()
      list(GET _argn ${_index} library)
      list(APPEND ${VAR} "${lib}${CATKIN_BUILD_CONFIGURATION_KEYWORD_SEPARATOR}${library}")
    else()
      list(APPEND ${VAR} "${lib}")
    endif()
    math(EXPR _index "${_index} + 1")
  endwhile()
endmacro()

# unpack a list of libraries with optional build configuration keyword prefixes
# copied from catkin/cmake/catkin_libraries.cmake to keep pkgConfig
# self contained
macro(_unpack_libraries_with_build_configuration VAR)
  set(${VAR} "")
  foreach(lib ${ARGN})
    string(REGEX REPLACE "^(debug|optimized|general)${CATKIN_BUILD_CONFIGURATION_KEYWORD_SEPARATOR}(.+)$" "\\1;\\2" lib "${lib}")
    list(APPEND ${VAR} "${lib}")
  endforeach()
endmacro()


if(husky_bringup_CONFIG_INCLUDED)
  return()
endif()
set(husky_bringup_CONFIG_INCLUDED TRUE)

# set variables for source/devel/install prefixes
if("TRUE" STREQUAL "TRUE")
  set(husky_bringup_SOURCE_PREFIX /home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/husky_bringup)
  set(husky_bringup_DEVEL_PREFIX /home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel)
  set(husky_bringup_INSTALL_PREFIX "")
  set(husky_bringup_PREFIX ${husky_bringup_DEVEL_PREFIX})
else()
  set(husky_bringup_SOURCE_PREFIX "")
  set(husky_bringup_DEVEL_PREFIX "")
  set(husky_bringup_INSTALL_PREFIX /home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/install)
  set(husky_bringup_PREFIX ${husky_bringup_INSTALL_PREFIX})
endif()

# warn when using a deprecated package
if(NOT "" STREQUAL "")
  set(_msg "WARNING: package 'husky_bringup' is deprecated")
  # append custom deprecation text if available
  if(NOT "" STREQUAL "TRUE")
    set(_msg "${_msg} ()")
  endif()
  message("${_msg}")
endif()

# flag project as catkin-based to distinguish if a find_package()-ed project is a catkin project
set(husky_bringup_FOUND_CATKIN_PROJECT TRUE)

if(NOT " " STREQUAL " ")
  set(husky_bringup_INCLUDE_DIRS "")
  set(_include_dirs "")
  if(NOT "https://github.com/husky/husky_robot/issues " STREQUAL " ")
    set(_report "Check the issue tracker 'https://github.com/husky/husky_robot/issues' and consider creating a ticket if the problem has not been reported yet.")
  elseif(NOT "http://ros.org/wiki/husky_bringup " STREQUAL " ")
    set(_report "Check the website 'http://ros.org/wiki/husky_bringup' for information and consider reporting the problem.")
  else()
    set(_report "Report the problem to the maintainer 'Tony Baltovski <tbaltovski@clearpathrobotics.com>' and request to fix the problem.")
  endif()
  foreach(idir ${_include_dirs})
    if(IS_ABSOLUTE ${idir} AND IS_DIRECTORY ${idir})
      set(include ${idir})
    elseif("${idir} " STREQUAL "include ")
      get_filename_component(include "${husky_bringup_DIR}/../../../include" ABSOLUTE)
      if(NOT IS_DIRECTORY ${include})
        message(FATAL_ERROR "Project 'husky_bringup' specifies '${idir}' as an include dir, which is not found.  It does not exist in '${include}'.  ${_report}")
      endif()
    else()
      message(FATAL_ERROR "Project 'husky_bringup' specifies '${idir}' as an include dir, which is not found.  It does neither exist as an absolute directory nor in '/home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/src/husky_bringup/${idir}'.  ${_report}")
    endif()
    _list_append_unique(husky_bringup_INCLUDE_DIRS ${include})
  endforeach()
endif()

set(libraries "")
foreach(library ${libraries})
  # keep build configuration keywords, target names and absolute libraries as-is
  if("${library}" MATCHES "^(debug|optimized|general)$")
    list(APPEND husky_bringup_LIBRARIES ${library})
  elseif(${library} MATCHES "^-l")
    list(APPEND husky_bringup_LIBRARIES ${library})
  elseif(${library} MATCHES "^-")
    # This is a linker flag/option (like -pthread)
    # There's no standard variable for these, so create an interface library to hold it
    if(NOT husky_bringup_NUM_DUMMY_TARGETS)
      set(husky_bringup_NUM_DUMMY_TARGETS 0)
    endif()
    # Make sure the target name is unique
    set(interface_target_name "catkin::husky_bringup::wrapped-linker-option${husky_bringup_NUM_DUMMY_TARGETS}")
    while(TARGET "${interface_target_name}")
      math(EXPR husky_bringup_NUM_DUMMY_TARGETS "${husky_bringup_NUM_DUMMY_TARGETS}+1")
      set(interface_target_name "catkin::husky_bringup::wrapped-linker-option${husky_bringup_NUM_DUMMY_TARGETS}")
    endwhile()
    add_library("${interface_target_name}" INTERFACE IMPORTED)
    if("${CMAKE_VERSION}" VERSION_LESS "3.13.0")
      set_property(
        TARGET
        "${interface_target_name}"
        APPEND PROPERTY
        INTERFACE_LINK_LIBRARIES "${library}")
    else()
      target_link_options("${interface_target_name}" INTERFACE "${library}")
    endif()
    list(APPEND husky_bringup_LIBRARIES "${interface_target_name}")
  elseif(TARGET ${library})
    list(APPEND husky_bringup_LIBRARIES ${library})
  elseif(IS_ABSOLUTE ${library})
    list(APPEND husky_bringup_LIBRARIES ${library})
  else()
    set(lib_path "")
    set(lib "${library}-NOTFOUND")
    # since the path where the library is found is returned we have to iterate over the paths manually
    foreach(path /home/ndev/Documents/husky-mine-rescuer/ros/catkin_ws/devel/lib;/nix/store/vl6ivsya2jp4nvz49awxg0z10f1mfwcn-ros-noetic-rviz-1.14.20-r1/lib;/nix/store/7fgb8hv7dnbr7i9rzmrrh6br463lh0ni-ros-noetic-geometry-msgs-1.13.1-r1/lib;/nix/store/hm2jg4n4dppkhm0lp7yhp5npp6r70wsx-ros-noetic-message-runtime-0.4.13-r1/lib;/nix/store/1pgaajyl117f38siikf2q3g1jd0nzy57-ros-noetic-cpp-common-0.7.2-r1/lib;/nix/store/i2gask1x5681npy26w5xr78m5qnl8vaa-ros-noetic-genpy-0.6.15-r1/lib;/nix/store/gkaz2spvm6jnlxjcdyjq8gdk9a9dplj4-ros-noetic-genmsg-0.6.0-r1/lib;/nix/store/y2dbjs0hpkdmra1jcnvih069nq27j9ka-ros-noetic-catkin-0.8.10-r1/lib;/nix/store/p0pv66dhnlgxvigh797jby2id4wsfaci-ros-noetic-roscpp-serialization-0.7.2-r1/lib;/nix/store/yc5bwr4zfpnc8cqjx912yw89kafa765z-ros-noetic-roscpp-traits-0.7.2-r1/lib;/nix/store/r027djrmaphh60dz3g4x2l8g10r65ldk-ros-noetic-rostime-0.7.2-r1/lib;/nix/store/bm2yplw7cxfdhdiqpmqc4zjx64y42sxp-ros-noetic-std-msgs-0.5.13-r1/lib;/nix/store/1jjmja8xwqczzqcif6f4n5n3d3x43f8i-ros-noetic-image-transport-1.12.0-r1/lib;/nix/store/nxhad117h49slla7s6paq3j3grxngla4-ros-noetic-message-filters-1.16.0-r1/lib;/nix/store/r2xsnvcq03yknx27a25g7j1jn9ahg6jf-ros-noetic-rosconsole-1.14.3-r1/lib;/nix/store/7nana361rx8rnl08cg7r2w0ajipkbpsb-ros-noetic-rosbuild-1.15.8-r1/lib;/nix/store/bpin4lizbj3wds3395v6fr4rjsb915sd-ros-noetic-message-generation-0.4.1-r1/lib;/nix/store/v53nqqbsmijrm13nib54g1hgbdrm3nvp-ros-noetic-gencpp-0.7.0-r1/lib;/nix/store/afdybxw6rjyrmf84wiss52fp4zzi4m46-ros-noetic-geneus-3.0.0-r1/lib;/nix/store/cm4apvzjb6pvwx1dah39b71m0m098isd-ros-noetic-genlisp-0.4.18-r1/lib;/nix/store/3mz6mharz0ny3ilmlvfsk89npbincy43-ros-noetic-gennodejs-2.0.2-r1/lib;/nix/store/wa1ss4aapssimxawgknbkzf2mvdi2x65-ros-noetic-roscpp-1.16.0-r1/lib;/nix/store/4j332dcf5xf01cyfkfhpnnz6k8gkh427-ros-noetic-rosgraph-msgs-1.11.3-r1/lib;/nix/store/d9ciz5dksan42gxnyp079c6p09r3l17m-ros-noetic-xmlrpcpp-1.16.0-r1/lib;/nix/store/cdq9d3bd87mzqfvympvnrxn4cwh8bs9d-ros-noetic-pluginlib-1.13.0-r1/lib;/nix/store/95dkfrzbvg5brc68l3zxq6wqn8sksqm7-ros-noetic-class-loader-0.5.0-r1/lib;/nix/store/ch91hrxq1pg2sc1y62ddyfm49qcnkv4d-ros-noetic-roslib-1.15.8-r1/lib;/nix/store/kwqlvdlbg880kpb6psvz358jp893g54h-ros-noetic-ros-environment-1.3.2-r1/lib;/nix/store/2iq9cdkdqnwq4ii12zbkimys3yiyacw8-ros-noetic-rospack-2.6.2-r1/lib;/nix/store/dc999786msa73p8lfjr02jiki6nz1ckv-ros-noetic-sensor-msgs-1.13.1-r1/lib;/nix/store/cnmsk2rnigqyff2ykwgm32x0ra3rkl6l-ros-noetic-interactive-markers-1.12.0-r1/lib;/nix/store/hiir900khg9m3c5rk1s4754vr57zk0is-ros-noetic-rospy-1.16.0-r1/lib;/nix/store/1607vbi1p9pvw3dk4zbnbdnajgdw7c2l-ros-noetic-rosgraph-1.16.0-r1/lib;/nix/store/xidyhi24bjirblify7c55iibsc4ja9dq-ros-noetic-rostest-1.16.0-r1/lib;/nix/store/yj83nhhvdf59zvcd0j62ni7q3z0av0p3-ros-noetic-roslaunch-1.16.0-r1/lib;/nix/store/jm5gvk5i83cx0k24krmgsfwqwn45s4mm-ros-noetic-rosclean-1.15.8-r1/lib;/nix/store/4d448y3ag54jxda283fbf9alw6lv9x5s-ros-noetic-rosmaster-1.16.0-r1/lib;/nix/store/kgh3g44j8nspj6qmqara4y8lphhmb720-ros-noetic-rosout-1.16.0-r1/lib;/nix/store/h24jpmzycqn3y0fd3ydpnssnzb1q8isk-ros-noetic-rosparam-1.16.0-r1/lib;/nix/store/xsc1z0dqj7mix8jzyd75l0azybi3nr52-ros-noetic-rosunit-1.15.8-r1/lib;/nix/store/b3w5qdw4hjnzacwl7ymjvsx7km5mw87s-ros-noetic-tf2-geometry-msgs-0.7.6-r1/lib;/nix/store/0ghywwvyp41bc4qhrrsq001qdkrhd326-ros-noetic-tf2-0.7.6-r1/lib;/nix/store/w52il33mcd70dwmz84rfmqakp5hfgj3p-ros-noetic-tf2-msgs-0.7.6-r1/lib;/nix/store/cq8lfylks6fls11fsb71fa0pn9zh7r7v-ros-noetic-actionlib-msgs-1.13.1-r1/lib;/nix/store/s8n9ylrkcbwgj3byk7h6rz8wv6y9j008-ros-noetic-tf2-ros-0.7.6-r1/lib;/nix/store/xggsqlc4201kfmqxfcpwsmcyv1ppwc21-ros-noetic-actionlib-1.14.0-r1/lib;/nix/store/da6wyc8j9qm0b40jn5g4y8yc63mzwkvg-ros-noetic-tf2-py-0.7.6-r1/lib;/nix/store/0w4hslg5fk10wir8iwwa639kyvxb2ldc-ros-noetic-visualization-msgs-1.13.1-r1/lib;/nix/store/mj3x5p6fj1mafh5ycnicg89m60lhsgw0-ros-noetic-laser-geometry-1.6.7-r1/lib;/nix/store/k7fnirc7m29wl0w5kxnllhcp9hjj1jdh-ros-noetic-angles-1.9.13-r1/lib;/nix/store/rll2dkpanxsy7m8fpbchlvn6vj8rawxb-ros-noetic-tf-1.13.2-r1/lib;/nix/store/54ghg0cr3zaw0man7ia3ih6jhrxk4snh-ros-noetic-roswtf-1.16.0-r1/lib;/nix/store/964rava39rdvb98fv03360rhg85n10kg-ros-noetic-rosnode-1.16.0-r1/lib;/nix/store/9587crxh9llk7h13zzb4qf7p439w93v4-ros-noetic-rostopic-1.16.0-r1/lib;/nix/store/ziq38356g0fz7wfl4glsa9428ndi9g91-ros-noetic-rosbag-1.16.0-r1/lib;/nix/store/f1dbj08c0c0x8dyp72aj60vb6x91n7zg-ros-noetic-rosbag-storage-1.16.0-r1/lib;/nix/store/8rvd7x92015xvyw18qlcl8nmxir8f069-ros-noetic-roslz4-1.16.0-r1/lib;/nix/store/1v7lv5yapgr4w62cq1zs6nxj2rvwzg6r-ros-noetic-std-srvs-1.11.3-r1/lib;/nix/store/53m0y4b11avrw959wjhk97jl74myxlcx-ros-noetic-topic-tools-1.16.0-r1/lib;/nix/store/r8rnc5750xp8d80s4s98gk2z086ihhq8-ros-noetic-rosservice-1.16.0-r1/lib;/nix/store/33x3ilg6k1kbm677z4r6w8p71g909231-ros-noetic-rosmsg-1.16.0-r1/lib;/nix/store/qr9cdy4ckkspx3zmarsn69pmfwmirjm4-ros-noetic-map-msgs-1.14.1-r1/lib;/nix/store/v91x0cz32rg61davhhm1miaxjw0fwrb8-ros-noetic-nav-msgs-1.13.1-r1/lib;/nix/store/ix717iin8cfapn6azwfi031m4hrn4z2i-ros-noetic-media-export-0.3.0-r1/lib;/nix/store/mcqlnw2x1ca4ikr6hcj5wl2c9pi4azn1-ros-noetic-python-qt-binding-0.4.4-r1/lib;/nix/store/iwpj8d976rcij3yr5lknpjm4af7iiw20-ros-noetic-resource-retriever-1.12.7-r1/lib;/nix/store/rrsc2f159cd8412ycvyfyxjkgvx7z5f6-ros-noetic-urdf-1.13.2-r1/lib;/nix/store/x9wvr3j6g6phs7x80a56d3i4h5g8p6yc-ros-noetic-rosconsole-bridge-0.5.4-r1/lib;/nix/store/gimjz2k8rmpmmrbggh1s0880yarm5580-ros-env/lib)
      find_library(lib ${library}
        PATHS ${path}
        NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
      if(lib)
        set(lib_path ${path})
        break()
      endif()
    endforeach()
    if(lib)
      _list_append_unique(husky_bringup_LIBRARY_DIRS ${lib_path})
      list(APPEND husky_bringup_LIBRARIES ${lib})
    else()
      # as a fall back for non-catkin libraries try to search globally
      find_library(lib ${library})
      if(NOT lib)
        message(FATAL_ERROR "Project '${PROJECT_NAME}' tried to find library '${library}'.  The library is neither a target nor built/installed properly.  Did you compile project 'husky_bringup'?  Did you find_package() it before the subdirectory containing its code is included?")
      endif()
      list(APPEND husky_bringup_LIBRARIES ${lib})
    endif()
  endif()
endforeach()

set(husky_bringup_EXPORTED_TARGETS "")
# create dummy targets for exported code generation targets to make life of users easier
foreach(t ${husky_bringup_EXPORTED_TARGETS})
  if(NOT TARGET ${t})
    add_custom_target(${t})
  endif()
endforeach()

set(depends "")
foreach(depend ${depends})
  string(REPLACE " " ";" depend_list ${depend})
  # the package name of the dependency must be kept in a unique variable so that it is not overwritten in recursive calls
  list(GET depend_list 0 husky_bringup_dep)
  list(LENGTH depend_list count)
  if(${count} EQUAL 1)
    # simple dependencies must only be find_package()-ed once
    if(NOT ${husky_bringup_dep}_FOUND)
      find_package(${husky_bringup_dep} REQUIRED NO_MODULE)
    endif()
  else()
    # dependencies with components must be find_package()-ed again
    list(REMOVE_AT depend_list 0)
    find_package(${husky_bringup_dep} REQUIRED NO_MODULE ${depend_list})
  endif()
  _list_append_unique(husky_bringup_INCLUDE_DIRS ${${husky_bringup_dep}_INCLUDE_DIRS})

  # merge build configuration keywords with library names to correctly deduplicate
  _pack_libraries_with_build_configuration(husky_bringup_LIBRARIES ${husky_bringup_LIBRARIES})
  _pack_libraries_with_build_configuration(_libraries ${${husky_bringup_dep}_LIBRARIES})
  _list_append_deduplicate(husky_bringup_LIBRARIES ${_libraries})
  # undo build configuration keyword merging after deduplication
  _unpack_libraries_with_build_configuration(husky_bringup_LIBRARIES ${husky_bringup_LIBRARIES})

  _list_append_unique(husky_bringup_LIBRARY_DIRS ${${husky_bringup_dep}_LIBRARY_DIRS})
  _list_append_deduplicate(husky_bringup_EXPORTED_TARGETS ${${husky_bringup_dep}_EXPORTED_TARGETS})
endforeach()

set(pkg_cfg_extras "")
foreach(extra ${pkg_cfg_extras})
  if(NOT IS_ABSOLUTE ${extra})
    set(extra ${husky_bringup_DIR}/${extra})
  endif()
  include(${extra})
endforeach()

#!/nix/store/6qk2ybm2yx2dxmx9h4dikr1shjhhbpfr-python3-3.10.11/bin/python3
# -*- coding: utf-8 -*-

# Software License Agreement (BSD License)
#
# Copyright (c) 2012, Willow Garage, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above
#    copyright notice, this list of conditions and the following
#    disclaimer in the documentation and/or other materials provided
#    with the distribution.
#  * Neither the name of Willow Garage, Inc. nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

"""This file generates shell code for the setup.SHELL scripts to set environment variables."""

from __future__ import print_function

import argparse
import copy
import errno
import os
import platform
import sys

CATKIN_MARKER_FILE = '.catkin'

system = platform.system()
IS_DARWIN = (system == 'Darwin')
IS_WINDOWS = (system == 'Windows')

PATH_TO_ADD_SUFFIX = ['bin']
if IS_WINDOWS:
    # while catkin recommends putting dll's into bin, 3rd party packages often put dll's into lib
    # since Windows finds dll's via the PATH variable, prepend it with path to lib
    PATH_TO_ADD_SUFFIX.extend([['lib', os.path.join('lib', 'x86_64-linux-gnu')]])

# subfolder of workspace prepended to CMAKE_PREFIX_PATH
ENV_VAR_SUBFOLDERS = {
    'CMAKE_PREFIX_PATH': '',
    'LD_LIBRARY_PATH' if not IS_DARWIN else 'DYLD_LIBRARY_PATH': ['lib', os.path.join('lib', 'x86_64-linux-gnu')],
    'PATH': PATH_TO_ADD_SUFFIX,
    'PKG_CONFIG_PATH': [os.path.join('lib', 'pkgconfig'), os.path.join('lib', 'x86_64-linux-gnu', 'pkgconfig')],
    'PYTHONPATH': 'lib/python3/dist-packages',
}


def rollback_env_variables(environ, env_var_subfolders):
    """
    Generate shell code to reset environment variables.

    by unrolling modifications based on all workspaces in CMAKE_PREFIX_PATH.
    This does not cover modifications performed by environment hooks.
    """
    lines = []
    unmodified_environ = copy.copy(environ)
    for key in sorted(env_var_subfolders.keys()):
        subfolders = env_var_subfolders[key]
        if not isinstance(subfolders, list):
            subfolders = [subfolders]
        value = _rollback_env_variable(unmodified_environ, key, subfolders)
        if value is not None:
            environ[key] = value
            lines.append(assignment(key, value))
    if lines:
        lines.insert(0, comment('reset environment variables by unrolling modifications based on all workspaces in CMAKE_PREFIX_PATH'))
    return lines


def _rollback_env_variable(environ, name, subfolders):
    """
    For each catkin workspace in CMAKE_PREFIX_PATH remove the first entry from env[NAME] matching workspace + subfolder.

    :param subfolders: list of str '' or subfoldername that may start with '/'
    :returns: the updated value of the environment variable.
    """
    value = environ[name] if name in environ else ''
    env_paths = [path for path in value.split(os.pathsep) if path]
    value_modified = False
    for subfolder in subfolders:
        if subfolder:
            if subfolder.startswith(os.path.sep) or (os.path.altsep and subfolder.startswith(os.path.altsep)):
                subfolder = subfolder[1:]
            if subfolder.endswith(os.path.sep) or (os.path.altsep and subfolder.endswith(os.path.altsep)):
                subfolder = subfolder[:-1]
        for ws_path in _get_workspaces(environ, include_fuerte=True, include_non_existing=True):
            path_to_find = os.path.join(ws_path, subfolder) if subfolder else ws_path
            path_to_remove = None
            for env_path in env_paths:
                env_path_clean = env_path[:-1] if env_path and env_path[-1] in [os.path.sep, os.path.altsep] else env_path
                if env_path_clean == path_to_find:
                    path_to_remove = env_path
                    break
            if path_to_remove:
                env_paths.remove(path_to_remove)
                value_modified = True
    new_value = os.pathsep.join(env_paths)
    return new_value if value_modified else None


def _get_workspaces(environ, include_fuerte=False, include_non_existing=False):
    """
    Based on CMAKE_PREFIX_PATH return all catkin workspaces.

    :param include_fuerte: The flag if paths starting with '/opt/ros/fuerte' should be considered workspaces, ``bool``
    """
    # get all cmake prefix paths
    env_name = 'CMAKE_PREFIX_PATH'
    value = environ[env_name] if env_name in environ else ''
    paths = [path for path in value.split(os.pathsep) if path]
    # remove non-workspace paths
    workspaces = [path for path in paths if os.path.isfile(os.path.join(path, CATKIN_MARKER_FILE)) or (include_fuerte and path.startswith('/opt/ros/fuerte')) or (include_non_existing and not os.path.exists(path))]
    return workspaces


def prepend_env_variables(environ, env_var_subfolders, workspaces):
    """Generate shell code to prepend environment variables for the all workspaces."""
    lines = []
    lines.append(comment('prepend folders of workspaces to environment variables'))

    paths = [path for path in workspaces.split(os.pathsep) if path]

    prefix = _prefix_env_variable(environ, 'CMAKE_PREFIX_PATH', paths, '')
    lines.append(prepend(environ, 'CMAKE_PREFIX_PATH', prefix))

    for key in sorted(key for key in env_var_subfolders.keys() if key != 'CMAKE_PREFIX_PATH'):
        subfolder = env_var_subfolders[key]
        prefix = _prefix_env_variable(environ, key, paths, subfolder)
        lines.append(prepend(environ, key, prefix))
    return lines


def _prefix_env_variable(environ, name, paths, subfolders):
    """
    Return the prefix to prepend to the environment variable NAME.

    Adding any path in NEW_PATHS_STR without creating duplicate or empty items.
    """
    value = environ[name] if name in environ else ''
    environ_paths = [path for path in value.split(os.pathsep) if path]
    checked_paths = []
    for path in paths:
        if not isinstance(subfolders, list):
            subfolders = [subfolders]
        for subfolder in subfolders:
            path_tmp = path
            if subfolder:
                path_tmp = os.path.join(path_tmp, subfolder)
            # skip nonexistent paths
            if not os.path.exists(path_tmp):
                continue
            # exclude any path already in env and any path we already added
            if path_tmp not in environ_paths and path_tmp not in checked_paths:
                checked_paths.append(path_tmp)
    prefix_str = os.pathsep.join(checked_paths)
    if prefix_str != '' and environ_paths:
        prefix_str += os.pathsep
    return prefix_str


def assignment(key, value):
    if not IS_WINDOWS:
        return 'export %s="%s"' % (key, value)
    else:
        return 'set %s=%s' % (key, value)


def comment(msg):
    if not IS_WINDOWS:
        return '# %s' % msg
    else:
        return 'REM %s' % msg


def prepend(environ, key, prefix):
    if key not in environ or not environ[key]:
        return assignment(key, prefix)
    if not IS_WINDOWS:
        return 'export %s="%s$%s"' % (key, prefix, key)
    else:
        return 'set %s=%s%%%s%%' % (key, prefix, key)


def find_env_hooks(environ, cmake_prefix_path):
    """Generate shell code with found environment hooks for the all workspaces."""
    lines = []
    lines.append(comment('found environment hooks in workspaces'))

    generic_env_hooks = []
    generic_env_hooks_workspace = []
    specific_env_hooks = []
    specific_env_hooks_workspace = []
    generic_env_hooks_by_filename = {}
    specific_env_hooks_by_filename = {}
    generic_env_hook_ext = 'bat' if IS_WINDOWS else 'sh'
    specific_env_hook_ext = environ['CATKIN_SHELL'] if not IS_WINDOWS and 'CATKIN_SHELL' in environ and environ['CATKIN_SHELL'] else None
    # remove non-workspace paths
    workspaces = [path for path in cmake_prefix_path.split(os.pathsep) if path and os.path.isfile(os.path.join(path, CATKIN_MARKER_FILE))]
    for workspace in reversed(workspaces):
        env_hook_dir = os.path.join(workspace, 'etc', 'catkin', 'profile.d')
        if os.path.isdir(env_hook_dir):
            for filename in sorted(os.listdir(env_hook_dir)):
                if filename.endswith('.%s' % generic_env_hook_ext):
                    # remove previous env hook with same name if present
                    if filename in generic_env_hooks_by_filename:
                        i = generic_env_hooks.index(generic_env_hooks_by_filename[filename])
                        generic_env_hooks.pop(i)
                        generic_env_hooks_workspace.pop(i)
                    # append env hook
                    generic_env_hooks.append(os.path.join(env_hook_dir, filename))
                    generic_env_hooks_workspace.append(workspace)
                    generic_env_hooks_by_filename[filename] = generic_env_hooks[-1]
                elif specific_env_hook_ext is not None and filename.endswith('.%s' % specific_env_hook_ext):
                    # remove previous env hook with same name if present
                    if filename in specific_env_hooks_by_filename:
                        i = specific_env_hooks.index(specific_env_hooks_by_filename[filename])
                        specific_env_hooks.pop(i)
                        specific_env_hooks_workspace.pop(i)
                    # append env hook
                    specific_env_hooks.append(os.path.join(env_hook_dir, filename))
                    specific_env_hooks_workspace.append(workspace)
                    specific_env_hooks_by_filename[filename] = specific_env_hooks[-1]
    env_hooks = generic_env_hooks + specific_env_hooks
    env_hooks_workspace = generic_env_hooks_workspace + specific_env_hooks_workspace
    count = len(env_hooks)
    lines.append(assignment('_CATKIN_ENVIRONMENT_HOOKS_COUNT', count))
    for i in range(count):
        lines.append(assignment('_CATKIN_ENVIRONMENT_HOOKS_%d' % i, env_hooks[i]))
        lines.append(assignment('_CATKIN_ENVIRONMENT_HOOKS_%d_WORKSPACE' % i, env_hooks_workspace[i]))
    return lines


def _parse_arguments(args=None):
    parser = argparse.ArgumentParser(description='Generates code blocks for the setup.SHELL script.')
    parser.add_argument('--extend', action='store_true', help='Skip unsetting previous environment variables to extend context')
    parser.add_argument('--local', action='store_true', help='Only consider this prefix path and ignore other prefix path in the environment')
    return parser.parse_known_args(args=args)[0]


if __name__ == '__main__':
    try:
        try:
            args = _parse_arguments()
        except Exception as e:
            print(e, file=sys.stderr)
            sys.exit(1)

        if not args.local:
            # environment at generation time
            CMAKE_PREFIX_PATH = r'/nix/store/agbimdar6al0bpjgkdpznnml1bkgq71d-python3.10-cffi-1.15.1;/nix/store/bp05amgjb89pxxg3558crk0l3s9lcdh4-python3.10-pycparser-2.21;/nix/store/6qk2ybm2yx2dxmx9h4dikr1shjhhbpfr-python3-3.10.11;/nix/store/pfv5zpb2wy893ym5jqsinw83yqyf6a3s-python3.10-sip-4.19.25;/nix/store/w4v9s4ifgcxf60w1hfn410x4h3fx4lh3-lndir-1.0.4;/nix/store/lgapq71q5prr2b8ksz43wyxmk2bg83j9-patchelf-0.15.0;/nix/store/frxg2hvacachpkv3ywdpmfl5pl2yg5y6-gcc-wrapper-12.3.0;/nix/store/vrhv7hg2jqvj78zd8xk42n70bf17i6hb-binutils-wrapper-2.40;/nix/store/5bmmghbg39ia615z5bl3q0bj3vraqfnw-clang-wrapper-11.1.0;/nix/store/p3jcivn7gg00ng8bgygpcygppkfzzcan-binutils-wrapper-2.40;/nix/store/w0kn1gy5z28j1dj1fq85r594wn02x8yl-gnumake-4.4.1;/nix/store/kl4d35hwmyj55irsmvg73lhlxm83wygl-git-2.40.1;/nix/store/b4f20qjdvqvv2cd40qd674brs5xix184-tmux-3.3a;/nix/store/ayj178m8ki0hlw4yqvqrsslqlakni10y-python3.10-catkin_tools-0.9.0;/nix/store/bb07jb7p17gm1m733sjc9dv4c2yhnn77-python3.10-setuptools-67.4.0;/nix/store/8wca79f3y9d8nqzn5359nnqxcd4aqbg5-python3.10-osrf_pycommon-2.0.2;/nix/store/1hi0rxm0ifd5ka74qswh5xa7r6wplwqr-python3.10-pyyaml-6.0;/nix/store/12v09r1kmlmsxirg0c8dlgwxq135lhjh-python3.10-catkin_pkg-0.5.2;/nix/store/0wyz82a3mpkz7jsj2qr42kc5lgrm2h9r-python3.10-python-dateutil-2.8.2;/nix/store/q810mayd6r806ywklhymwwg3fbpzdl01-python3.10-six-1.16.0;/nix/store/fhraysjy7q3jgb549b0w9j3c3sg91hh2-python3.10-docutils-0.19;/nix/store/g7jbrwy7dw9407bk2f58pr4skyf3fxqz-python3.10-pyparsing-3.0.9;/nix/store/9izn7d580gfz2m7fdbxil0q18qkhn3iz-python3.10-rosdep-0.22.1;/nix/store/xpmynrh6i0l9ci8w68az3j1qhmw12k27-python3.10-rospkg-1.4.0;/nix/store/7bfvi6krqp027vpp066h13dfixb7ks2l-python3.10-distro-1.8.0;/nix/store/dcydrwd40w0i4339c3szmmfixiciqs24-python3.10-rosdistro-0.9.0;/nix/store/gf3v4s65f1m0a64ck4mr9zsnshba10kz-eigen-3.4.0;/nix/store/y562pmsdj0i8s2dl0qrsqqqgyhmajxkn-glibc-locales-2.37-8;/nix/store/x6i1ii97qznqwimhlhiqb6v5hk9c4fyd-pcl-1.13.0;/nix/store/xi7ssfy3b75yr5js2vqi22ldss51vlxa-boost-1.79.0-dev;/nix/store/bxh2ddzfavrqn1yy95z4xlmksvfnvq8z-boost-1.79.0;/nix/store/kzhbvfy53gjbg2arhw64qlzlf1gc7w92-flann-1.9.1;/nix/store/4af5clf6jz0m1lpbh4jzvvh3ccfzmsxn-lz4-1.9.4-dev;/nix/store/q6fhryk1c8q5gi495bcg01axy3cyb69s-lz4-1.9.4-bin;/nix/store/y605py6gwhwwm6n85wi0x7a62mb2jll0-lz4-1.9.4;/nix/store/fnj41s59bfjqlxpnmj7xw636hhr4vr6m-libpng-apng-1.6.39-dev;/nix/store/chfcpqz4s4y3khd85ngfs65a2q9wcd51-zlib-1.2.13-dev;/nix/store/k54w79m79x2hkc1i8ps7l4fry576dpvs-zlib-1.2.13;/nix/store/ycmidfcy668xcg1z3s4y1bf91yhww0dp-libpng-apng-1.6.39;/nix/store/0sl5kcmqnik436s2v2wm5i3m6jm3zzgp-libtiff-4.5.0-dev;/nix/store/jr3mh3kifbi9ajsk6v0bb2br7r7b39y5-libdeflate-1.18;/nix/store/a0dg8ajzl7x58lci26742xwsnl2497db-libjpeg-turbo-2.1.5.1-dev;/nix/store/63qan6kabcjjjm9a5531mlplhaaximzd-libjpeg-turbo-2.1.5.1-bin;/nix/store/5qr2rb1gcbxd1wf87a6677bqc8m8mm35-libjpeg-turbo-2.1.5.1;/nix/store/5aa85hq44zhrk880yc78zaj05dbrjknn-xz-5.4.3-dev;/nix/store/iwm337bvpvqk8lbijszc6l92n928s3rd-xz-5.4.3-bin;/nix/store/vaz5x08kr132jcws790vrrr4lpflb2pb-xz-5.4.3;/nix/store/icnxv92nczd6g3cz8hq1giaigwqsws37-libtiff-4.5.0-bin;/nix/store/kap249b8lr0si1xhj8yf4hpc4qsqc2fd-libtiff-4.5.0;/nix/store/0crv4wjr1mpjaq888jhhz4vzsxlxx1sr-qhull-2020.2;/nix/store/1jlymf98kc9xxvcrdrsbzf4h5988yghg-vtk-9.2.6;/nix/store/r7zf54pwakyvirwl3z868mqbniggfwgw-libX11-1.8.4-dev;/nix/store/xrpp2qqfkkzwsc2kwf0lwgsb45qkw8vw-xorgproto-2021.5;/nix/store/88qn9vl1dpjb3wy34bxjcjmmsscrc4gk-libxcb-1.14-dev;/nix/store/sdm5rg74z2rwzp9a84q5x7xgwqxddyyd-libxcb-1.14;/nix/store/wcqi0dshizby7qpabjv2axgyvv7x2arl-libX11-1.8.4;/nix/store/234pnqsg835bnpwpvvcc6sra2ln5db2i-libGL-1.6.0-dev;/nix/store/cw3vvzl0ql7s4hb7cw0fw1y60pz7wmlp-libGL-1.6.0;/nix/store/g05rad0jjmz4r7n0c2pdz6ckqfajbs7h-libglvnd-1.6.0;/nix/store/p5mjfg87999bgss9693cjy61c2br4467-libglvnd-1.6.0-dev;/nix/store/vlxkw14my4r22r5jifaqf1dh44dyrs1z-libyaml-0.2.5-dev;/nix/store/0ip3w1s8qaq4c29zicx31jgmk24dmsm7-libyaml-0.2.5;/nix/store/4w6kskk3rv3glb1gjxyd5fg6f7my407z-python3.10-scipy-1.10.1;/nix/store/b7kiy1c75f7f3lvg05qm913k17f8gdn4-python3.10-numpy-1.24.2;/nix/store/vl6ivsya2jp4nvz49awxg0z10f1mfwcn-ros-noetic-rviz-1.14.20-r1;/nix/store/m31606saahfrw3kamgqmncvqsybyrdw2-assimp-5.2.5-dev;/nix/store/bq5fyl49shkfnjqzrhd0064j6k6hw470-assimp-5.2.5-lib;/nix/store/9ip588w50j1gja95xln7ywb9wf2na8qf-assimp-5.2.5;/nix/store/7fgb8hv7dnbr7i9rzmrrh6br463lh0ni-ros-noetic-geometry-msgs-1.13.1-r1;/nix/store/hm2jg4n4dppkhm0lp7yhp5npp6r70wsx-ros-noetic-message-runtime-0.4.13-r1;/nix/store/1pgaajyl117f38siikf2q3g1jd0nzy57-ros-noetic-cpp-common-0.7.2-r1;/nix/store/mq6gy9ma7qird4f9syvadq82zpnbdcn4-boost-1.79.0-dev;/nix/store/9pnccbcdpgc4gz0grk0nzmr1854l1mkh-boost-1.79.0;/nix/store/dm3vk6qspb1zi7lqlyngkb4jc6j3bc1j-console-bridge-1.0.2;/nix/store/i2gask1x5681npy26w5xr78m5qnl8vaa-ros-noetic-genpy-0.6.15-r1;/nix/store/gkaz2spvm6jnlxjcdyjq8gdk9a9dplj4-ros-noetic-genmsg-0.6.0-r1;/nix/store/y2dbjs0hpkdmra1jcnvih069nq27j9ka-ros-noetic-catkin-0.8.10-r1;/nix/store/bnmxyb30n6b5fq1gj3f4jzwxf7z8b4ls-cmake-3.25.3;/nix/store/3w2g1ghn37k7b1ws8j0c3b23iphy6pl3-catkin-setup-hook;/nix/store/5avw4aqawv7bx1c7kj4p6nf1wqgpvfqj-wrap-python-hook;/nix/store/zdnrid1nlxqg78g6yy7n90l34rlqmlna-make-shell-wrapper-hook;/nix/store/rxiqzbv027a3nfcczfls040xj77rgczc-die-hook;/nix/store/f2jsinacdv8dsghg64an46b7ifm2fdzf-gtest-1.12.1-dev;/nix/store/n536z9czs11j5rcd752cggv2ws2jb4zg-gtest-1.12.1;/nix/store/2ay8jvp3b5l6b99hcxq2lpwbd8ir3p84-python3.10-empy-3.3.4;/nix/store/3j8y41cw5gzzvazv53qhk4dsyhcqdbd2-python3.10-nose-1.3.7;/nix/store/gnbwqg6q587601q56z5fwhvwcgir1hwj-python3.10-coverage-7.2.1;/nix/store/p0pv66dhnlgxvigh797jby2id4wsfaci-ros-noetic-roscpp-serialization-0.7.2-r1;/nix/store/yc5bwr4zfpnc8cqjx912yw89kafa765z-ros-noetic-roscpp-traits-0.7.2-r1;/nix/store/r027djrmaphh60dz3g4x2l8g10r65ldk-ros-noetic-rostime-0.7.2-r1;/nix/store/bm2yplw7cxfdhdiqpmqc4zjx64y42sxp-ros-noetic-std-msgs-0.5.13-r1;/nix/store/1jjmja8xwqczzqcif6f4n5n3d3x43f8i-ros-noetic-image-transport-1.12.0-r1;/nix/store/nxhad117h49slla7s6paq3j3grxngla4-ros-noetic-message-filters-1.16.0-r1;/nix/store/r2xsnvcq03yknx27a25g7j1jn9ahg6jf-ros-noetic-rosconsole-1.14.3-r1;/nix/store/rdjrij2i2yhi1zxpnf8kb7i9frnjl1dz-apr-1.7.4-dev;/nix/store/c63clg9y091d15rvz6g3hvkbd7javy4g-apr-1.7.4;/nix/store/2x6q06i6gh247sc5sa21l25n65g8vfyb-log4cxx-1.1.0;/nix/store/7nana361rx8rnl08cg7r2w0ajipkbpsb-ros-noetic-rosbuild-1.15.8-r1;/nix/store/bpin4lizbj3wds3395v6fr4rjsb915sd-ros-noetic-message-generation-0.4.1-r1;/nix/store/v53nqqbsmijrm13nib54g1hgbdrm3nvp-ros-noetic-gencpp-0.7.0-r1;/nix/store/afdybxw6rjyrmf84wiss52fp4zzi4m46-ros-noetic-geneus-3.0.0-r1;/nix/store/cm4apvzjb6pvwx1dah39b71m0m098isd-ros-noetic-genlisp-0.4.18-r1;/nix/store/3mz6mharz0ny3ilmlvfsk89npbincy43-ros-noetic-gennodejs-2.0.2-r1;/nix/store/wa1ss4aapssimxawgknbkzf2mvdi2x65-ros-noetic-roscpp-1.16.0-r1;/nix/store/4j332dcf5xf01cyfkfhpnnz6k8gkh427-ros-noetic-rosgraph-msgs-1.11.3-r1;/nix/store/d9ciz5dksan42gxnyp079c6p09r3l17m-ros-noetic-xmlrpcpp-1.16.0-r1;/nix/store/cdq9d3bd87mzqfvympvnrxn4cwh8bs9d-ros-noetic-pluginlib-1.13.0-r1;/nix/store/95dkfrzbvg5brc68l3zxq6wqn8sksqm7-ros-noetic-class-loader-0.5.0-r1;/nix/store/sng3s3ah7qdyyp5b970k2g9pwfz77k36-poco-1.12.4-dev;/nix/store/lh49mh46b5ak1qcwgyaq69z4bpg27cdy-pcre2-10.42-dev;/nix/store/q1ni1zkfbqx3xkf1cz8nlfqzys06ldir-pcre2-10.42-bin;/nix/store/fz42p8ap25rxlxhxdyr4lc794lx0nsk3-pcre2-10.42;/nix/store/2gk7dlw82lhwkmw9n6py6fpr7qamfyxh-expat-2.5.0-dev;/nix/store/f0zd16dwbv7picwnvxvd8iif91n0biwm-expat-2.5.0;/nix/store/22qdacs8dqqz0h3fq6x8fypz77sg4csv-sqlite-3.42.0-dev;/nix/store/8imm8b0qj7lqw9jly31ms9injyvdg0zs-sqlite-3.42.0-bin;/nix/store/cc6xrbwk9rinln42n1jlhd9qjmkbv6zb-sqlite-3.42.0;/nix/store/gx7946h9y6qwcdil01ibf4hvm8vfc823-openssl-3.0.9-dev;/nix/store/j7ian2yg5lnyjbfwgx4as68vrwlhk738-openssl-3.0.9-bin;/nix/store/v26fhrqvdxmd8f846y6jha0y104xdy96-openssl-3.0.9;/nix/store/77swp0sqi9vjrrs0vhgq3yglf3891khs-poco-1.12.4;/nix/store/ch91hrxq1pg2sc1y62ddyfm49qcnkv4d-ros-noetic-roslib-1.15.8-r1;/nix/store/kwqlvdlbg880kpb6psvz358jp893g54h-ros-noetic-ros-environment-1.3.2-r1;/nix/store/2iq9cdkdqnwq4ii12zbkimys3yiyacw8-ros-noetic-rospack-2.6.2-r1;/nix/store/hfh0z67fbyk5g2qn9b1n962s5gmxmkqi-pkg-config-wrapper-0.29.2;/nix/store/z14yc27zr39ix6qjmfhzswpgq6f9w9bw-tinyxml-2-9.0.0;/nix/store/dc999786msa73p8lfjr02jiki6nz1ckv-ros-noetic-sensor-msgs-1.13.1-r1;/nix/store/cnmsk2rnigqyff2ykwgm32x0ra3rkl6l-ros-noetic-interactive-markers-1.12.0-r1;/nix/store/hiir900khg9m3c5rk1s4754vr57zk0is-ros-noetic-rospy-1.16.0-r1;/nix/store/1607vbi1p9pvw3dk4zbnbdnajgdw7c2l-ros-noetic-rosgraph-1.16.0-r1;/nix/store/0r6ylizqrq1555p18qq9k2qgm5ak5660-python3.10-netifaces-0.11.0;/nix/store/xidyhi24bjirblify7c55iibsc4ja9dq-ros-noetic-rostest-1.16.0-r1;/nix/store/yj83nhhvdf59zvcd0j62ni7q3z0av0p3-ros-noetic-roslaunch-1.16.0-r1;/nix/store/p7rd81kcnx4hakcf6k0x2w811zhr3ggp-python3.10-paramiko-2.11.0;/nix/store/fw15lxvkc4mjm7k7ffrxpyqdvw768qb2-python3.10-bcrypt-4.0.1;/nix/store/l8syrq2h94p6wyphn015hs9r7a050rp5-python3.10-cryptography-40.0.1;/nix/store/3cvazqd9k08m22byrbsx2n870mzjbsvf-python3.10-pyasn1-0.5.0;/nix/store/x6rh9khjw598l1v91c3qljc91gib35wa-python3.10-pynacl-1.5.0;/nix/store/jm5gvk5i83cx0k24krmgsfwqwn45s4mm-ros-noetic-rosclean-1.15.8-r1;/nix/store/4d448y3ag54jxda283fbf9alw6lv9x5s-ros-noetic-rosmaster-1.16.0-r1;/nix/store/8ic7q0s43v7ifbpvm3dgym2psb8lh8zr-python3.10-defusedxml-0.7.1;/nix/store/kgh3g44j8nspj6qmqara4y8lphhmb720-ros-noetic-rosout-1.16.0-r1;/nix/store/h24jpmzycqn3y0fd3ydpnssnzb1q8isk-ros-noetic-rosparam-1.16.0-r1;/nix/store/xsc1z0dqj7mix8jzyd75l0azybi3nr52-ros-noetic-rosunit-1.15.8-r1;/nix/store/b3w5qdw4hjnzacwl7ymjvsx7km5mw87s-ros-noetic-tf2-geometry-msgs-0.7.6-r1;/nix/store/wkp2qpd4id2nwabb6js0kc74qn9y5kz7-orocos-kdl-1.5.1;/nix/store/d6m05hpcisac9xz3f0f2x90ygs5glwpa-pykdl-1.5.1;/nix/store/0ghywwvyp41bc4qhrrsq001qdkrhd326-ros-noetic-tf2-0.7.6-r1;/nix/store/w52il33mcd70dwmz84rfmqakp5hfgj3p-ros-noetic-tf2-msgs-0.7.6-r1;/nix/store/cq8lfylks6fls11fsb71fa0pn9zh7r7v-ros-noetic-actionlib-msgs-1.13.1-r1;/nix/store/s8n9ylrkcbwgj3byk7h6rz8wv6y9j008-ros-noetic-tf2-ros-0.7.6-r1;/nix/store/xggsqlc4201kfmqxfcpwsmcyv1ppwc21-ros-noetic-actionlib-1.14.0-r1;/nix/store/da6wyc8j9qm0b40jn5g4y8yc63mzwkvg-ros-noetic-tf2-py-0.7.6-r1;/nix/store/0w4hslg5fk10wir8iwwa639kyvxb2ldc-ros-noetic-visualization-msgs-1.13.1-r1;/nix/store/mj3x5p6fj1mafh5ycnicg89m60lhsgw0-ros-noetic-laser-geometry-1.6.7-r1;/nix/store/k7fnirc7m29wl0w5kxnllhcp9hjj1jdh-ros-noetic-angles-1.9.13-r1;/nix/store/rll2dkpanxsy7m8fpbchlvn6vj8rawxb-ros-noetic-tf-1.13.2-r1;/nix/store/v9f2nvwl35maqwx9fdzn4w5n5cfwx9hi-graphviz-7.1.0;/nix/store/54ghg0cr3zaw0man7ia3ih6jhrxk4snh-ros-noetic-roswtf-1.16.0-r1;/nix/store/964rava39rdvb98fv03360rhg85n10kg-ros-noetic-rosnode-1.16.0-r1;/nix/store/9587crxh9llk7h13zzb4qf7p439w93v4-ros-noetic-rostopic-1.16.0-r1;/nix/store/ziq38356g0fz7wfl4glsa9428ndi9g91-ros-noetic-rosbag-1.16.0-r1;/nix/store/d48avgdqxmhdk3iplx13yrz40zf5qawr-python3.10-pycryptodome-3.17.0;/nix/store/h6zl5cd43cprlyx56wdda5bsqmshjvy0-python3.10-python-gnupg-0.5.0;/nix/store/f1dbj08c0c0x8dyp72aj60vb6x91n7zg-ros-noetic-rosbag-storage-1.16.0-r1;/nix/store/nlnm1gclhsidc663kj19h2skz5dbrb51-bzip2-1.0.8-dev;/nix/store/jniy9n8nlcl8qr3c5gyhf0a4zr50373g-bzip2-1.0.8-bin;/nix/store/hiyfgknrcqdkr4py2x8scfn3qya807dn-bzip2-1.0.8;/nix/store/n5znnfvb1wgmz7cb8sfjr0x78k69xp7k-gpgme-1.20.0-dev;/nix/store/wr7fslsrvl1ihnhdagp7hsb5sii3iwha-glib-2.76.2-dev;/nix/store/npq2ab5xrlfdal3fa6a0v5aalc9jg4b2-libffi-3.4.4-dev;/nix/store/ddwa4irajwmi69qjbkd0k4gj4cyn5xsc-libffi-3.4.4;/nix/store/w3c52mgsr6did9d4xcff3rdl8w9hdbjx-gettext-0.21.1;/nix/store/y5qbvcd02l03dzbq524vlkjw0b1ak7is-glibc-iconv-2.37;/nix/store/kxm6ikh9p3931w8409nc1iis9wkhmqaf-glib-2.76.2-bin;/nix/store/sxzpfcldisjqlgq8mm7435yz4bmbaalb-glib-2.76.2;/nix/store/6sn8q4xr4a1iw90c6dkrs8shqbp2qla9-libassuan-2.5.5-dev;/nix/store/p5k24b34453dxjmr6c89ix44v9kb6d5x-libassuan-2.5.5;/nix/store/vaj3vs87fligvv3grnci65hprlbnh87i-libgpg-error-1.47-dev;/nix/store/v37i4li10z5z79k9fgkm97i626iyka1s-libgpg-error-1.47;/nix/store/dsdzf18vk178ckmpj12qcyq7hcgf704h-pth-2.0.7;/nix/store/gr5d1dmi9wnz236iqwjr4khydhfvk3zy-gpgme-1.20.0;/nix/store/8rvd7x92015xvyw18qlcl8nmxir8f069-ros-noetic-roslz4-1.16.0-r1;/nix/store/1v7lv5yapgr4w62cq1zs6nxj2rvwzg6r-ros-noetic-std-srvs-1.11.3-r1;/nix/store/53m0y4b11avrw959wjhk97jl74myxlcx-ros-noetic-topic-tools-1.16.0-r1;/nix/store/r8rnc5750xp8d80s4s98gk2z086ihhq8-ros-noetic-rosservice-1.16.0-r1;/nix/store/33x3ilg6k1kbm677z4r6w8p71g909231-ros-noetic-rosmsg-1.16.0-r1;/nix/store/j3hl41lb725vrq0c8lmhfl34y4vpcn72-glu-9.0.2-dev;/nix/store/fbyqw23d7kdjgrci9f9g6ms5mxisdr8i-glu-9.0.2;/nix/store/0ggn12zamb4fa9vhh894rismaskngzdc-yaml-cpp-0.7.0;/nix/store/qr9cdy4ckkspx3zmarsn69pmfwmirjm4-ros-noetic-map-msgs-1.14.1-r1;/nix/store/v91x0cz32rg61davhhm1miaxjw0fwrb8-ros-noetic-nav-msgs-1.13.1-r1;/nix/store/ix717iin8cfapn6azwfi031m4hrn4z2i-ros-noetic-media-export-0.3.0-r1;/nix/store/39cs65ckv4hrgj0i5ipqbkrkyxg0i8fm-ogre-1.10.11;/nix/store/mcqlnw2x1ca4ikr6hcj5wl2c9pi4azn1-ros-noetic-python-qt-binding-0.4.4-r1;/nix/store/pinn3vblvgz1v0fm8bd71sz58m2zxs2f-python3.10-PyQt5-5.15.9-dev;/nix/store/qmma5l5qhm5x8f2zslpdb9i6xdpsvcbs-python3.10-dbus-python-1.2.18-dev;/nix/store/9qn3dbkjkngxi381vswzxvlwiz3ymag3-python3.10-dbus-python-1.2.18;/nix/store/p1c1i8zprydb2ak73xrf66ibxljjg28r-python3.10-pyqt5-sip-12.11.0;/nix/store/20gq713ppn06rxdxlarqhf6crwxydmcb-qtbase-5.15.9-bin;/nix/store/wp032cs2sni0qmmrvzm3mjfw22iny34k-qtsvg-5.15.9-bin;/nix/store/wi1rgxlwa1zd9svrabmcgv87c5wzpiar-qtdeclarative-5.15.9-bin;/nix/store/fh82bj240gf8f194yhzrvcx6s92372ak-python3.10-PyQt5-5.15.9;/nix/store/x2k6w40lsxsa5qajwkwqpp2jcnxgyfmz-qtbase-5.15.9-dev;/nix/store/mz3s0gwdhbp7gpxd3hig8nf07vq05vp6-libxml2-2.10.4-dev;/nix/store/9kc71mrr8llf4razdbmj493vpcpbjqzm-find-xml-catalogs-hook;/nix/store/8zmjjk46jpb6pfdq5iskslhkv1ha0iqi-libxml2-2.10.4-bin;/nix/store/56m1a8i1lmjc15ybkaq6vinq7j2977hv-libxml2-2.10.4;/nix/store/zch5xdsq24wb0kdanzgvqr8ij1nlcpbg-libxslt-1.1.37-dev;/nix/store/z9sbz59l209cmgsny0iabzwc7bswhswr-libxslt-1.1.37-bin;/nix/store/cdgfvvvv6v365alnsn6zcr4l4xhl05hy-libxslt-1.1.37;/nix/store/sw5iz13q07rpjk4daf2c6fz6kvhc0w4p-harfbuzz-7.3.0-dev;/nix/store/32bjn123jlg291nwcrdirxpg6y666xhh-graphite2-1.3.14-dev;/nix/store/mcbfr7f8yf1d1yazbgllxss94gq07xzk-graphite2-1.3.14;/nix/store/spl44ld2dp295p5y2s5c63lmaciz3x5l-harfbuzz-7.3.0;/nix/store/kdah7i2ba8dd5z4hvijvg2l08kzgqimw-icu4c-73.1-dev;/nix/store/sbmlx3lfc9m12qka9hl1069hpwhfc9na-icu4c-73.1;/nix/store/7vqy5m58iz9kpds2xswjx2gknbq3bvps-dbus-1.14.6-dev;/nix/store/zfq6zbas8iwmhrvhnm58nj8z3n574ddh-dbus-1.14.6-lib;/nix/store/jvadwgpvasy07pid8kg9ksszyrjdk03p-dbus-1.14.6;/nix/store/3j411mqlnk4a56cgvs706f5jsxayknc1-systemd-253.3-dev;/nix/store/8pbr7x6wh765mg43zs0p70gsaavmbbh7-systemd-253.3;/nix/store/c2nk2wjgmqj5dilf46fxsrx6kabb33p1-fontconfig-2.14.0-dev;/nix/store/zyspah33ds936rrnbyd6xjibrmihbr7l-freetype-2.13.0-dev;/nix/store/3n46hmdr1knn4kss7py3vi73q4b24pfs-brotli-1.0.9-dev;/nix/store/lkd8wzdvyyppxxvb5332kkcjscbmwxgq-brotli-1.0.9-lib;/nix/store/ws7n0v5x3m91b88ww6cicaw750hjn7jh-brotli-1.0.9;/nix/store/rnrl4zcjcfxqmm982364hlpf3m83nx2m-freetype-2.13.0;/nix/store/mab120ipchq3kg8sb8nn9pwjcz9g0dv8-fontconfig-2.14.0-bin;/nix/store/gvhgdpg4xx3zxpkyxaxcmxhxz9nm26yq-fontconfig-2.14.0-lib;/nix/store/ss7jjw2kl3w1k803hcjg98vkzysrq0zs-libdrm-2.4.115-dev;/nix/store/cprbdvxmsv1zwsrn58d13fgcwja93kn8-libdrm-2.4.115-bin;/nix/store/8mnhabg3pn8wdav75k0dfq1c79qr3asp-libdrm-2.4.115;/nix/store/6h8l57gdylr0yb8lijn0d3j8s30i7hhb-libXcomposite-0.4.5-dev;/nix/store/4vdzi3z0nz3rg91zgxh08zj71rx7h77r-libXfixes-6.0.0-dev;/nix/store/fj33xyjc6ik97r1cb3qawyf1p9pqmg9j-libXfixes-6.0.0;/nix/store/9c2c736yc33z0n206dvr9zrgk4cly1cz-libXcomposite-0.4.5;/nix/store/2igfz5860v3fvrxlpdk5apzpbkhc7x2p-libXext-1.3.4-dev;/nix/store/raffinidbldy0d0sy72wh202x24qhikm-libXau-1.0.9-dev;/nix/store/5k557nwng8ml8g2jdnp2pr5ris9ca8n0-libXau-1.0.9;/nix/store/zdhrf49df04hh209hw4m8pwbddhp5vyb-libXext-1.3.4;/nix/store/8y9xb6j8z4bk4q15wiq0giyvkxa8sr61-libXi-1.8-dev;/nix/store/bb8jqjvjpi3dalyk9mf5kqrq2cdv80x5-libXi-1.8;/nix/store/4cq1iiv8fzyjzhcxg258525fwardm8mv-libXrender-0.9.10-dev;/nix/store/40ga418idbllr0py41wkm725ancryrxw-libXrender-0.9.10;/nix/store/57qnl8k77n50n1rwbv99b7zy0nrgilnl-libxkbcommon-1.5.0-dev;/nix/store/yfkcwkmxr0xgvqzrd0k507zq7ix3m68d-libxkbcommon-1.5.0;/nix/store/3msz3d14yvwizkifp3raqlm3hwayrx1j-xcb-util-0.4.1-dev;/nix/store/vbvlb00dqa8i6zbwc2clqnji39bf1qss-xcb-util-0.4.1;/nix/store/wzifxlm7m7shvs6ghjx3gahbadwm4f3z-xcb-util-image-0.4.1-dev;/nix/store/44d3h1qbi3v63mysa24lzl67qa869mn8-xcb-util-image-0.4.1;/nix/store/p7ivfvnyrsmaj9x4vagsbc2dfc01ncw0-xcb-util-keysyms-0.4.1-dev;/nix/store/jm3fzg0knvw130f5nsp2rl91rim9x2mz-xcb-util-keysyms-0.4.1;/nix/store/gj7xms2pamv0jr66c51s9kzaqj1a6bgb-xcb-util-renderutil-0.3.10-dev;/nix/store/vwfpga0r9a5jpdyi5v6i48g41sx2v5wv-xcb-util-renderutil-0.3.10;/nix/store/22mxm1c4ayrqbspppzv4w8wsn61kx1iz-xcb-util-wm-0.4.2-dev;/nix/store/k12q8kw9lxj9kf6jss2z0kg6msyvdjw5-xcb-util-wm-0.4.2;/nix/store/snh4vhjkrchr4i4a7rj2xq6nc7gl1pl9-qtbase-5.15.9;/nix/store/iwpj8d976rcij3yr5lknpjm4af7iiw20-ros-noetic-resource-retriever-1.12.7-r1;/nix/store/ag0nhrldrar1nw55m680cp2l8fgicd4m-curl-8.1.1-dev;/nix/store/9nrnz9fjn7nlkf5wq3858qbvq85df54y-libkrb5-1.20.1-dev;/nix/store/3wbi8cm8gpv6iv6p2r5l64mf9ixflbl8-libkrb5-1.20.1;/nix/store/r3xdg6c28aqn7yhn8hjzi3y9ccajrca5-nghttp2-1.51.0-dev;/nix/store/0vzxscs3syny54gfiynqwy1rnzlzg3k5-nghttp2-1.51.0-bin;/nix/store/p8zvqnsdxxl63qqgjy0fmfk4gvcrwq1x-nghttp2-1.51.0-lib;/nix/store/v9a7xh79ryrw3nbx239nzqd6lswh3lnz-libidn2-2.3.4-dev;/nix/store/zs2a4iz4yzkdkqcdn3vbil459qppzbin-libidn2-2.3.4-bin;/nix/store/4b3rnvq1cl5ihavg96gkwjr61857d67g-libidn2-2.3.4;/nix/store/kbilbx2fcyfjlwx2l19xyrky1pvmr027-libssh2-1.11.0-dev;/nix/store/l4jh5c7bcyinkzb6dvizy9xhqznikcmw-libssh2-1.11.0;/nix/store/2vr713q0pmv1jz7k197fb892pz6hrbyj-zstd-1.5.5-dev;/nix/store/8dp01zn29kxkm0221mk5wixmdvva0pqz-zstd-1.5.5-bin;/nix/store/3aa7v2ikmmlr3wka6m55dw60xg7ia21j-zstd-1.5.5;/nix/store/4azqi4cask2sa6j764kd3isj1pz24mgi-curl-8.1.1-bin;/nix/store/n8wdk200hi7s2czq25ihdgq2kd8879aa-curl-8.1.1;/nix/store/rrsc2f159cd8412ycvyfyxjkgvx7z5f6-ros-noetic-urdf-1.13.2-r1;/nix/store/x9wvr3j6g6phs7x80a56d3i4h5g8p6yc-ros-noetic-rosconsole-bridge-0.5.4-r1;/nix/store/53i3yp2psp6ciqhqsj8zc52dwwlv67qp-tinyxml-2.6.2;/nix/store/2fsx393c5kbnng4jdf29ia7l68v19cy0-urdfdom-3.1.1;/nix/store/v6pj2q8xgahixngpp6j89j4kxg6vdd3x-urdfdom-headers-1.1.0;/nix/store/gimjz2k8rmpmmrbggh1s0880yarm5580-ros-env;/nix/store/yjkfjvclh06dcqdy4mh2yj7v32fvf28k-daemontools-0.76;/nix/store/n91qwln64x64bsgm97vizjgpya2xy3i5-net-tools-2.10;/nix/store/zgpx1n7lzicy3xx4aza6xd051yqlq0gn-util-linux-2.39-dev;/nix/store/rhmf511xbnbwp6azz08wmsn75i88ql1f-util-linux-2.39-bin;/nix/store/y6brzir45m54v6fwyp5vg9m9b3ymrqxd-util-linux-2.39-lib;/nix/store/zp5nv86d9xbxlpcz13ry4j2iw96zx1di-geographiclib-2.1.1;/nix/store/wb6qvdvnxkrz70rqw0w0dd8xsgb7py7i-linuxconsoletools-1.6.1;/nix/store/f8l0cmvxj2ljv195916illiilfa4cafk-opencv-4.7.0;/nix/store/x20yl3iy0ygls8msyylvsx5x8gmykki6-hddtemp-0.3-beta15;/nix/store/xl3wqw2mgwdfgh6rp96x38w6g30vy6d2-lm-sensors-3.6.0;/nix/store/mwrzj6g25a7wwbwwqc6mw9dnl71g7xk0-libpcap-1.10.4;/nix/store/d8acwg9prg0pcb7khsk7b430fji0rhcx-tango-icon-theme-0.8.90;/nix/store/igyvdjmg4kwdfif3378x2rzzjbw5kyy9-gnome-icon-theme-3.12.0;/nix/store/783q7889q6mygf2hym9nb15wz6hc6klv-hicolor-icon-theme-0.17;/nix/store/xj3sjw155p94cd38kplql738z13857zx-compiler-rt-libc-11.1.0-dev;/nix/store/bq41klp836cscm1ki6k6gwmyfll5ka98-compiler-rt-libc-11.1.0'.split(';')
        else:
            # don't consider any other prefix path than this one
            CMAKE_PREFIX_PATH = []
        # prepend current workspace if not already part of CPP
        base_path = os.path.dirname(__file__)
        # CMAKE_PREFIX_PATH uses forward slash on all platforms, but __file__ is platform dependent
        # base_path on Windows contains backward slashes, need to be converted to forward slashes before comparison
        if os.path.sep != '/':
            base_path = base_path.replace(os.path.sep, '/')

        if base_path not in CMAKE_PREFIX_PATH:
            CMAKE_PREFIX_PATH.insert(0, base_path)
        CMAKE_PREFIX_PATH = os.pathsep.join(CMAKE_PREFIX_PATH)

        environ = dict(os.environ)
        lines = []
        if not args.extend:
            lines += rollback_env_variables(environ, ENV_VAR_SUBFOLDERS)
        lines += prepend_env_variables(environ, ENV_VAR_SUBFOLDERS, CMAKE_PREFIX_PATH)
        lines += find_env_hooks(environ, CMAKE_PREFIX_PATH)
        print('\n'.join(lines))

        # need to explicitly flush the output
        sys.stdout.flush()
    except IOError as e:
        # and catch potential "broken pipe" if stdout is not writable
        # which can happen when piping the output to a file but the disk is full
        if e.errno == errno.EPIPE:
            print(e, file=sys.stderr)
            sys.exit(2)
        raise

    sys.exit(0)

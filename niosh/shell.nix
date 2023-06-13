{ pkgs ? import (fetchTarball "https://github.com/lopsided98/nix-ros-overlay/archive/master.tar.gz") {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.curl
    pkgs.ros-noetic-desktop-full
    pkgs.which
    pkgs.htop
    pkgs.zlib
  ];
}

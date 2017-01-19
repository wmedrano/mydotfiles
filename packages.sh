#!/bin/bash

# Install Packages

## Window Manager and Stuff
sudo pacman -S numix-reborn-icon-themes numix-themes-archblue --needed
sudo pacman -S awesome compton deepin-gtk-theme deepin-icon-theme vicious --needed

## Themes
sudo pacman -S adobe-source-code-pro-fonts ttf-ubuntu-font-family --needed

## Apps
sudo pacman -S chromium hexchat lxtask-gtk3 qjackctl --needed

## Utilities
sudo pacman -S arandr aspell-en markdown pandoc scrot xclip --needed
yaourt -S chromium-pepper-flash chromium-widevine redshift --needed

## Audio
sudo pacman -S audacity portaudio portmidi --needed

# General Devtools
sudo pacman -S emacs kcov rxvt-unicode --needed

# C/C++ Devtools
sudo pacman -S clang cmake --needed

# Clojure Devtools
yaourt -S boot leiningen2-git --needed

# Latex
sudo pacman -S latex-most --needed

## Python Devtools
sudo pacman -S cython --needed
sudo pacman -S ipython python-jedi python-virtualenv --needed
sudo pacman -S python-matplotlib python-scikit-learn python-pandas--needed
sudo pacman -S jupyter jupyterlab-git jupyter-notebook --needed

# Rust Devtools
sudo pacman -S cargo rust --needed
yaourt -S rust-src --needed
cargo install cargo-check
cargo install racer
cargo install ripgrep
cargo install rust-fmt

# DB
sudo pacman -S elasticsearch sqlite redis --needed

## Fix game controllers
sudo pacman -R xf86-input-joystick

# Update all
yaourt -Syu

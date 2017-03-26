#!/bin/bash

# Install Packages

## Window Manager and Stuff
sudo pacman -S awesome compton vicious --needed

## Themes & Fonts
sudo pacman -S arc-gtk-theme arc-icon-theme --needed
sudo pacman -S ttf-fira-mono ttf-fira-sans --needed

## Apps
sudo pacman -S chromium lxtask-gtk3 qjackctl --needed

## Multimedia
sudo pacman -S rhythmbox

## Utilities
sudo pacman -S arandr aspell-en markdown pandoc pinta scrot xclip --needed
yaourt -S chromium-pepper-flash chromium-widevine redshift --needed

## Audio
sudo pacman -S audacity portaudio portmidi --needed

# General Devtools
sudo pacman -S emacs kcov rxvt-unicode --needed
yaourt -S alacritty-git --needed

# C Related Devtools
sudo pacman -S clang cmake emscripten gdb lldb llvm llvm-libs --needed

# Clojure Devtools
yaourt -S boot leiningen2-git --needed

# Go
sudo pacman -S go --needed

# Latex
sudo pacman -S latex-most --needed

## Python Devtools
sudo pacman -S cython --needed
sudo pacman -S ipython python-jedi python-virtualenv --needed
sudo pacman -S python-matplotlib python-scikit-learn python-pandas --needed
sudo pacman -S python-pytables --needed
sudo pacman -S jupyter jupyterlab-git jupyter-notebook --needed

# Rust Devtools
sudo pacman -S cargo rust --needed
yaourt -S rust-src --needed
cargo install cargo-check
cargo install cargo-outdated
cargo install racer
cargo install ripgrep
cargo install rust-fmt

# Scheme
sudo pacman -S guile

# DB
sudo pacman -S elasticsearch sqlite redis --needed

## Fix game controllers
sudo pacman -R xf86-input-joystick

# Update all
yaourt -Syu

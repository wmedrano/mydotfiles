# Install Packages

## Window Manager and Stuff
sudo pacman -S awesome compton demnu vicious xmobar xmonad xmonad-contrib --needed

## Themes
sudo pacman -S noto-fonts numix-reborn-icon-themes ttf-ubuntu-font-family --needed
yaourt -S sky-gtk-theme --needed

## Apps
sudo pacman -S banshee chromium hexchat lxtask-gtk3 lxterminal-gtk3 qjackctl --needed

## Utilities
sudo pacman -S arandr aspell-en pandoc scrot --needed
yaourt -S chromium-pepper-flash redshift --needed

## Audio
sudo pacman -S portaudio portmidi --needed

# General Devtools
sudo pacman -S the_silver_searcher --needed
yaourt -S emacs25-git --needed

# C/C++ Devtools
sudo pacman -S clang cmake --needed

# Clojure Devtools
yaourt -S boot leiningen2-git --needed

# Go Devtools
sudo pacman -S go go-tools --needed
yaourt -S gocode-git --needed

# Haskell Devtools
sudo pacman -S cabal-install ghc ghc-mod hoogle --needed

## Python Devtools
sudo pacman -S ipython python-jedi python-matplotlib python-scikit-learn --needed
sudo pacman -S python-pandas python-virtualenv jupyter --needed

# Rust Devtools
sudo pacman -S cargo rust --needed
yaourt -S rust-racer rust-src --needed

## Fix game controllers
sudo pacman -R xf86-input-joystick

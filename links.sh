# Link home files
rm ~/.bashrc ~/.bash_profile ~/.xinitrc ~/.gtkrc-2.0 ~/.Xresources
ln -s `pwd`/bashrc ~/.bashrc
ln -s `pwd`/bash_profile ~/.bash_profile
ln -s `pwd`/xinitrc ~/.xinitrc
ln -s `pwd`/gtkrc-2.0 ~/.gtkrc-2.0
ln -s `pwd`/Xresources ~/.Xresources

# Link .config files
rm ~/.config/compton.conf  ~/.config/redshift.conf
ln -sf `pwd`/compton.conf ~/.config/compton.conf
ln -sf `pwd`/redshift.conf ~/.config/redshift.conf

# awesome
rm -r ~/.config/awesome ~/.config/gtk-3.0
ln -s `pwd`/awesome ~/.config # awesome tiling window manager
ln -s `pwd`/gtk-3.0 ~/.config # gtk3 theming

# emacs
rm -r ~/.emacs.d
ln -s `pwd`/emacs.d ~/ # editing environment
mv ~/emacs.d ~/.emacs.d

# Other
rm -r ~/.config/hexchat
ln -s `pwd`/hexchat ~/.config # irc client

# Clojure
rm -r ~/.boot ~/.lein
ln -s `pwd`/boot ~/.boot # clojure build tool
ln -s `pwd`/lein ~/.lein # clojure build tool

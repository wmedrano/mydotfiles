# Link home files
rm ~/.bashrc ~/.xinitrc ~/.gtkrc-2.0
ln -s `pwd`/bashrc ~/.bashrc
ln -s `pwd`/xinitrc ~/.xinitrc
ln -s `pwd`/gtkrc-2.0 ~/.gtkrc-2.0

# Link other files
rm ~/.config/compton.conf  ~/.config/redshift.conf
ln -sf `pwd`/compton.conf ~/.config/compton.conf
ln -sf `pwd`/redshift.conf ~/.config/redshift.conf

# Link Directories
rm -r ~/.boot ~/.emacs.d ~/.xmonad
rm -r ~/.config/awesome ~/.config/gtk-3.0 ~/.config/hexchat ~/.config/lxterminal ~/.config/xmobar
ln -s `pwd`/boot ~/.boot # clojure build tool
ln -s `pwd`/emacs.d ~/ # editing environment
mv ~/emacs.d ~/.emacs.d
ln -s `pwd`/xmonad ~/ # xmonad tiling window manager
mv ~/xmonad ~/.xmonad
ln -s `pwd`/awesome ~/.config # awesome tiling window manager
ln -s `pwd`/gtk-3.0 ~/.config # gtk3 theming
ln -s `pwd`/hexchat ~/.config # irc client
ln -s `pwd`/lxterminal ~/.config # terminal
ln -s `pwd`/xmobar ~/.config # xmobar

# install emacs packages
emacs -nw -f my-install-packages --kill

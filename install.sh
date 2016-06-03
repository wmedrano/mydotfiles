./packages.sh
./links.sh

# install rust programs
cargo install bindgen
cargo install racer
cargo install cargo-watch

# install emacs packages
emacs -nw -f my-install-packages --kill

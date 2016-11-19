#! /bin/bash

./packages.sh
./links.sh

# install rust programs
cargo install bindgen
cargo install cargo-watch
cargo install racer
cargo install rustfmt

# install emacs packages
emacs -nw -f my-install-packages --kill

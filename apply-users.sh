#!/bin/sh
pushd ~/.dotfiles
home-manager switch -f ./users/pmccallum/home.nix
popd

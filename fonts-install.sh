#!/bin/bash

mkdir -p ~/.local/share/fonts

mkdir -p ~/temp-fonts
for f in ./*.tar.gz; do
    tar -xzf "$f" -C ~/temp-fonts
done

find ~/temp-fonts -type f \( -iname "*.ttf" -o -iname "*.otf" -o -iname "*.fon" \) -exec cp {} ~/.local/share/fonts/ \;

fc-cache -fv

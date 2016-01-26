#!/bin/bash
echo "Pip"
pip list
echo
echo "Pacman"
pacman -Q | grep -E "python(2?)-" | sed -r "s/python(2?)-(.*) (([0-9]+.?)+)/\2 \(\3\)/"

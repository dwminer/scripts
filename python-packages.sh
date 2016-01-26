#!/bin/bash
echo "Python 2"
echo "Pip"
pip2 list
echo
echo "Pacman"
pacman -Q | grep -E "python2-" | sed -r "s/python2-(.*) (([0-9]+.?)+)/\1 \(\2\)/"

echo
echo "Python 3"
echo "Pip"
pip3 list
echo
echo "Pacman"
pacman -Q | grep -E "python-" | sed -r "s/python-(.*) (([0-9]+.?)+)/\1 \(\2\)/"

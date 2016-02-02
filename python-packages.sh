#!/bin/bash
declare -a pacman2_packages
declare -a pip2_packages
declare -a pacman3_packages
declare -a pip3_packages

oldifs=$IFS
IFS=$'\n'

echo "Python 2"

echo "Pip"
i=$(expr 0)
for pkg in $(pip2 list); do
	echo $pkg
	pip2_packages[$i]="$pkg"
	i=$(expr $i + 1)
done

echo $'\nPacman'
i=$(expr 0)
for pkg in $(pacman -Q | grep -E "python2-" | sed -r "s/python2-(.*) (([0-9]+.?)+)/\1 \(\2\)/"); do
	echo $pkg
	pacman2_packages[$i]="$pkg"
	i=$(expr $i + 1)
done

echo $'\n----------------------------------------\n\nPython 3'

echo "Pip"
i=$(expr 0)
for pkg in $(pip3 list); do
	echo $pkg
	pip3_packages[$i]="$pkg"
	i=$(expr $i + 1)
done

echo $'\nPacman'
i=$(expr 0)
for pkg in $(pacman -Q | grep -E "python-" | sed -r "s/python-(.*) (([0-9]+.?)+)/\1 \(\2\)/"); do
	echo $pkg
	pacman3_packages[$i]="$pkg"
	i=$(expr $i + 1)
done

echo $'\n------------------------------------------\n\nDuplicates'

echo "Python 2"
i=$(expr 0)
j=$(expr 0)
while [ -n "${pacman2_packages[$i]}" -a -n "${pip2_packages[$j]}" ]; do
	pacman_name=$(echo ${pacman2_packages[$i]} | sed -r "s/((\w|-)+) .*/\1/")
	pip_name=$(echo ${pip2_packages[$j]} | sed -r "s/((\w|-)+) .*/\1/")
	if [ "$pacman_name" ==  "$pip_name" ]; then
		echo $pacman_name
		i=$(expr $i + 1)
		j=$(expr $j + 1)
	fi
	if [[ "$pacman_name" < "$pip_name" ]]; then
		i=$(expr $i + 1)
	fi
	if [[ "$pacman_name" > "$pip_name" ]]; then
		j=$(expr $j + 1)
	fi
done

#DRY DRY DRY DRY DRY
echo $'\nPython 3'
i=$(expr 0)
j=$(expr 0)
while [ -n "${pacman3_packages[$i]}" -a -n "${pip3_packages[$j]}" ]; do
	pacman_name=$(echo ${pacman3_packages[$i]} | sed -r "s/((\w|-)+) .*/\1/")
	pip_name=$(echo ${pip3_packages[$j]} | sed -r "s/((\w|-)+) .*/\1/")
	if [ "$pacman_name" ==  "$pip_name" ]; then
		echo $pacman_name
		i=$(expr $i + 1)
		j=$(expr $j + 1)
	fi
	if [[ "$pacman_name" < "$pip_name" ]]; then
		i=$(expr $i + 1)
	fi
	if [[ "$pacman_name" > "$pip_name" ]]; then
		j=$(expr $j + 1)
	fi
done

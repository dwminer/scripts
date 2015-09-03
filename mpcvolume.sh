#!/bin/bash
mpc volume -q $(expr $(mpc volume | grep -oE [0-9]+) + $1)

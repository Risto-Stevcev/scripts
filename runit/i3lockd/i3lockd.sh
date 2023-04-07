#!/bin/sh -e
#DISPLAY=:0
#XAUTHORITY=/run/user/1000/gdm/Xauthority

echo "Running i3lockd..."
trap "echo The script is terminated; exit" 2
xss-lock --transfer-sleep-lock -- i3lock

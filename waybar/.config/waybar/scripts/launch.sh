#!/bin/bash

killall -9 waybar
killall -9 swaync

waybar &
swaync &

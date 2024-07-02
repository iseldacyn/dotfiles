#!/bin/bash
# Get volume of current default sink

volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -n 1)
echo "Volume: $volume%"

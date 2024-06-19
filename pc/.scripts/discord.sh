#!/bin/bash
# Makes Discord screen share work in Wayland

env XDG_SESSION_TYPE=x11 discord &
if [[ -z $(ps -A | grep xwayland) ]]; then
    xwaylandvideobridge &
fi

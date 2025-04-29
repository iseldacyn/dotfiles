#!/bin/sh

export GRIM_DEFAULT_DIR=/home/iselda/pictures/screenshots

case $1 in
    0) # perform whole screen screenshot
        grim - | wl-copy -t image/png
        ;;

    1) # perform selection screenshot
        grim -g "$(slurp)" - | wl-copy -t image/png
        ;;
esac
zenity --notification --text="Screenshot saved to clipboard!"

# prompt and write to screenshot dir
if zenity --text="Would you like to save to a file?" --question; then
    default_name=$GRIM_DEFAULT_DIR/$(date '+%Y%m%d_%Hh%Mm%Ss')_grim.png
    output_name=$(zenity --entry --text="Where would you like to save to?" --entry-text="$default_name")
    wl-paste >$output_name
fi

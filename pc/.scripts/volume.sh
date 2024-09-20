#!/bin/bash

# Get volume of current default sink
function volume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -n 1
}
function is_muted {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po "yes"
}

case $1 in
    "percent")
        while :
        do
            if [ "$(is_muted)" = "yes" ] ; then
                echo ""
            else
                volume=$(volume)
                if [ "$volume" -ge 30 ] ; then
                    echo " $volume%"
                else
                    echo " $volume%"
                fi
            fi
        done
        ;;

    "speakers")
        pactl set-default-sink alsa_output.usb-Razer_Razer_Nommo_Chroma-02.analog-stereo
        ;;
    "headphones")
        pactl set-default-sink alsa_output.usb-Jieli_Technology_UACDemoV1.0_1120022606020701-01.analog-stereo
        ;;

    "mute")
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
	"up_1")
		if [ $(volume) -ge 100 ] ; then
			:
        else
            pactl set-sink-volume @DEFAULT_SINK@ +1%
        fi
		;;
	"up_5")
        if [ "$(volume)" -ge 96 ] ; then
            pactl set-sink-volume @DEFAULT_SINK@ +"$((100-$(volume)))"%
        else
            pactl set-sink-volume @DEFAULT_SINK@ +5%
        fi
		;;
esac

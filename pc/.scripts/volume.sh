#!/bin/bash

# Get volume of current default sink
function volume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -n 1
}
function is_muted {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po "yes"
}

case $1 in
    # real-time update of percentage
    "percent")
        # only want to print each command once
        volume_old=$(volume)
        muted_prev="n"
        # initial print of volume
        if [ "$(is_muted)" = "yes" ] && [ "$muted_prev" = "n" ] ; then
            echo ""
            muted_prev="y"
        elif [ "$volume_old" -ge 30 ] ; then
            echo " $volume_old%"
        else
            echo " $volume_old%"
        fi
        while :
        do
            volume=$(volume)
            # only print muted volume once
            if [ "$(is_muted)" = "yes" ] && [ "$muted_prev" = "n" ] ; then
                echo ""
                muted_prev="y"
            # only print when updated volume OR when volume is unmuted
            elif [ "$volume" -eq "$volume_old" ] && [ "$muted_prev" = "n" ] ;  then
                :
            elif [ "$volume" -ge 30 ] || [ "$muted_prev" = "y" ] ; then
                # only print when not muted
                if [ -z "$(is_muted)" ] ; then
                    echo " $volume%"
                    volume_old=$volume
                    muted_prev="n"
                fi
            elif [ "$volume" -lt 31 ] || [ "$muted_prev" = "y"  ] ; then
                # only print when not muted
                if [ -z "$(is_muted)" ] ; then
                    echo " $volume%"
                    volume_old=$volume
                    muted_prev="n"
                fi
            fi
        done
        ;;

    # switch output device
    "speakers")
        pactl set-default-sink alsa_output.usb-Razer_Razer_Nommo_Chroma-02.analog-stereo
        ;;
    "headphones")
        pactl set-default-sink alsa_output.usb-Jieli_Technology_UACDemoV1.0_1120022606020701-01.analog-stereo
        ;;

    # utility options
    "mute")
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
	"up_1")
        # do NOT go over 100% volume
		if [ $(volume) -ge 100 ] ; then
			:
        else
            pactl set-sink-volume @DEFAULT_SINK@ +1%
        fi
		;;
	"up_5")
        # do NOT go over 100% volume
        if [ "$(volume)" -ge 96 ] ; then
            pactl set-sink-volume @DEFAULT_SINK@ +"$((100-$(volume)))"%
        else
            pactl set-sink-volume @DEFAULT_SINK@ +5%
        fi
		;;
esac

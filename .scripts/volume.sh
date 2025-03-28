#!/bin/bash

# gets volume from pulse-audio
function volume {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -n 1
}

# gets mute status from pulse-audio
# returns "yes" if unmuted, "" otherwise
function is_muted {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po "yes"
}

# gets microphone mute status from pulse-audio
# returns "yes" if unmuted, "" otherwise
function mic_is_mute {
	pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}' | grep 'yes'
}

# uses dunstify to display volume status
# volume:	current volume level
# bar:		string of "bars" representing volume level
# uses different icons depending on audio level
function send_notification {
	volume=$(volume)
	bar=$(seq -s "-" $(($volume / 5)) | sed 's/[0-9]//g')
	bar+="-"
	if [ "$volume" -ge 70 ] ; then
		dunstify -i /home/iselda/Pictures/volume/full-audio.png -t 3000 -r 2593 -u normal "    $bar  $volume"
	elif [ "$volume" -ge 40 ] ; then
		dunstify -i /home/iselda/Pictures/volume/med-audio.png -t 3000 -r 2593 -u normal "    $bar  $volume"
	elif [ "$volume" -gt 0 ] ; then
		dunstify -i /home/iselda/Pictures/volume/low-audio.png -t 3000 -r 2593 -u normal "    $bar  $volume"
	else
		dunstify -i /home/iselda/Pictures/volume/no-audio.png -t 3000 -r 2593 -u normal "      $volume"
	fi
}

case $1 in

    # raise volume hotkey
	up)
		# unmute if muted
		if [ "$(is_muted)" = "yes" ] ; then
			pactl set-sink-mute @DEFAULT_SINK@ off
		# DO NOT go above 100 volume
		elif [ "$(volume)" -ge 100 ] ; then
			:
		# unmute, raise volume, display
		else
			pactl set-sink-volume @DEFAULT_SINK@ +5%
		fi
		send_notification
		;;

    # raise volume hotkey
	down)
		# lower volume, display
		pactl set-sink-volume @DEFAULT_SINK@ -5%
		# if muted, use muted icon
		if [ "$(is_muted)" = "yes" ] && [ "$(volume)" -gt 0 ] ; then
			dunstify -i /home/iselda/Pictures/volume/mute-audio.png -t 3000 -r 2593 -u normal "    -$(seq -s "-" $(($(volume) / 5)) | sed 's/[0-9]//g')  $(volume)"
		elif [ "$(is_muted)" = "yes" ] && [ "$(volume)" -eq 0 ] ; then
			dunstify -i /home/iselda/Pictures/volume/mute-audio.png -t 3000 -r 2593 -u normal "      $(volume)"
		else
			send_notification
		fi
		;;

    # mute volume hotkey
	mute)
		# toggle mute status
		pactl set-sink-mute @DEFAULT_SINK@ toggle
		# if unmuted, show current volume status
		if [ -z "$(is_muted)" ] ; then
			send_notification
		# show audio muted icon
		else
			dunstify -i /home/iselda/Pictures/volume/mute-audio.png -t 3000 -r 2593 -u normal ""
		fi
		;;

    # mute mic hotkey
	mic_mute)
		# toggle microphone mute status
		pactl set-source-mute @DEFAULT_SOURCE@ toggle
		# if unmuted, show microphone on icon
		if [ -z "$(mic_is_mute)" ] ; then
			dunstify -i /home/iselda/Pictures/volume/play-mic.png -t 3000 -r 2594 -u normal ""
		# show microphone muted icon
		else
			dunstify -i /home/iselda/Pictures/volume/mute-mic.png -t 3000 -r 2594 -u normal ""
		fi
		;;

    # real-time update of percentage
    percent)
        # only want to print each command once
        volume_old=$(volume)
        muted_prev="n"
        # initial print of volume
        if [ "$(is_muted)" = "yes" ] ; then
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

    # utilities for waybar
    mute_no_notif)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
	up_no_notif_1)
        # do NOT go above 100% volume
		if [ "$(volume)" -ge 100 ] ; then
			:
        else
            pactl set-sink-volume @DEFAULT_SINK@ +1%
        fi
		;;
	up_no_notif_5)
        # do NOT go above 100% volume
        if [ "$(volume)" -ge 96 ] ; then
            pactl set-sink-volume @DEFAULT_SINK@ +"$((100-$(volume)))"%
        else
            pactl set-sink-volume @DEFAULT_SINK@ +5%
        fi
		;;

    # FOR PC USE
    # switch output device
    "speakers")
        pactl set-default-sink alsa_output.usb-Razer_Razer_Nommo_Chroma-02.analog-stereo
        ;;
    "headphones")
        pactl set-default-sink alsa_output.usb-Jieli_Technology_UACDemoV1.0_1120022606020701-01.analog-stereo
        ;;

esac

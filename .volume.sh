#!/bin/bash

# usage:
# /path/to/.volume.sh up		- raise volume
# /path/to/.volume.sh down		- lower volume
# /path/to/.volume.sh mute		- mute volume
# /path/to/.volume.sh mic_mute	- mute microphone

# gets volume from pulse-audio
function get_volume {
	pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n 1 | cut -d '%' -f 1
}

# gets mute status from pulse-audio
# returns "yes" if unmuted, "" otherwise
function is_mute {
	pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}' | grep 'yes'
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
	volume=$(get_volume)
	bar=$(seq -s "-" $(($volume / 5)) | sed 's/[0-9]//g')
	bar+="-"
	if [ "$volume" -ge 70 ] ; then
		dunstify -i /home/iselda/Pictures/full-audio.png -t 3000 -r 2593 -u normal "    $bar  $volume"
	elif [ "$volume" -ge 40 ] ; then
		dunstify -i /home/iselda/Pictures/med-audio.png -t 3000 -r 2593 -u normal "    $bar  $volume"
	elif [ "$volume" -gt 0 ] ; then
		dunstify -i /home/iselda/Pictures/low-audio.png -t 3000 -r 2593 -u normal "    $bar  $volume"
	else
		dunstify -i /home/iselda/Pictures/no-audio.png -t 3000 -r 2593 -u normal "      $volume"
	fi
}

case $1 in

	up)
		# unmute if muted
		if [ $(is_mute) = "yes" ] ; then
			pactl set-sink-mute @DEFAULT_SINK@ off
		# DO NOT go above 100 volume
		elif [ $(get_volume) -ge 100 ] ; then
			:
		# unmute, raise volume, display
		else
			pactl set-sink-volume @DEFAULT_SINK@ +5%
		fi
		send_notification
		;;
		
	down)
		# unmute if muted
		if [ $(is_mute) = "yes" ] ; then
			pactl set-sink-mute @DEFAULT_SINK@ off
		# lower volume, display
		else
			echo "test"
			pactl set-sink-volume @DEFAULT_SINK@ -5%
		fi
		send_notification
		;;
		
	mute)
		# toggle mute status
		pactl set-sink-mute @DEFAULT_SINK@ toggle
		# if unmuted, show current volume status
		if [ -z $(is_mute) ] ; then
			send_notification
		# show audio muted icon
		else
			dunstify -i /home/iselda/Pictures/mute-audio.png -t 3000 -r 2593 -u normal ""
		fi
		;;

	mic_mute)
		# toggle microphone mute status
		pactl set-source-mute @DEFAULT_SOURCE@ toggle
		# if unmuted, show microphone on icon
		if [ -z $(mic_is_mute) ] ; then
			dunstify -i /home/iselda/Pictures/play-mic.png -t 3000 -r 2594 -u normal ""
		# show microphone muted icon
		else
			dunstify -i /home/iselda/Pictures/mute-mic.png -t 3000 -r 2594 -u normal ""
		fi
		;;
esac

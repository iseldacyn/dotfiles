#!/bin/sh
#!/.xinitrc

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# start some programs

# since pc likes to set hdmi as primary
# xrandr --output DP-2 --primary --left-of HDMI-A-2

unclutter --timeout 3 &
nitrogen --restore &
picom &
# xss-lock --transfer-sleep-lock -- i3lock -S 0 -c 000000 -k --time-color=ffffff --date-color=999999 --ring-color=d3b3ff --keyhl-color=f5f67e --bshl-color=e1ffc7  --insidever-color=ffc7ef --ringver-color=ffc7ef --insidewrong-color=ff9690 --ringwrong-color=ff9690 --indicator -e -f --nofork &
# oneko -sakura &
# battery_notif_daemon

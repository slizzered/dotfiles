#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx or SLIM (run your window manager from here)
#
#
# Write an error-log to a file...
exec  >> ~/.xsession.log 2>&1

# get the right monitor
#/home/carli/scripts/monitor_autoselect.sh

#
#/usr/bin/xmodmap -e "clear mod4"
#/usr/bin/xmodmap -e "clear lock"
#/usr/bin/xmodmap -e "remove control = Control_R"
## Set the right CTRL-button as the new modifier4-key
#/usr/bin/xmodmap -e "add mod4 = Control_R"
#/usr/bin/xmodmap -e "keysym Caps_Lock = Super_L Caps_Lock"
#/usr/bin/xmodmap -e "add mod4 = Super_L"
#/usr/bin/xmodmap -e "keysym Caps_Lock = Escape Caps_Lock"

# Remapping of keys: Caps-Lock is a mod4-key (and a ESC-key?!).
# Right Control-Key is a mod4-key
# adding SHIFT to one of those keypresses restores original behaviour
#
# remove all keys that work as a mod4-key
/usr/bin/xmodmap -e "clear mod4"
# remove all keys that work as a capslock-key
/usr/bin/xmodmap -e "clear lock"
# remove original behaviour of Control_R as a control-key
/usr/bin/xmodmap -e "remove control = Control_R"
# Set the right CTRL-button to resemble super_L
/usr/bin/xmodmap -e "keysym Control_R = Super_L Control_R"
# Set the right Caps_Lock-button to resemble super_L
/usr/bin/xmodmap -e "keysym Caps_Lock = Super_L Caps_Lock"
# use super_L as the new mod4 key
/usr/bin/xmodmap -e "add mod4 = Super_L"
# somehow magically works to use caps_lock both as escape(i.e. in VIM) and as mod4 (in awesome)...
/usr/bin/xmodmap -e "keysym Caps_Lock = Escape Caps_Lock"

#
# scrensaver daemon
/usr/bin/xscreensaver -no-splash &

#
# does the magic to make some java-applications
# display correctly
/usr/bin/wmname LG3D

if [ "$(hostname)" = "vaio" ] ; then

amixer set Master unmute 7
amixer set Headphone unmute 27,25
amixer set Speaker unmute 26
amixer set PCM unmute 230
amixer set Mic\ Boost 0
amixer set Mic unmute 20

/tmp/scripts/battery_warning.sh &

fi

eval "$(ssh-agent -s)" > /dev/null

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

# xsetroot -cursor_name left_ptr
# setxkbmap us -variant altgr-intl
# xmonad

# dwm
#exec awesome >>~/.awesome.log 2>&1
exec awesome


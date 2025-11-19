obs_running=$(pgrep -fa obs)
while [[ -n $obs_running ]]; do
    window=$(xdotool getwindowfocus getwindowclassname);
    if [[ "$window" == "kitty" ]]; then
        cmd=enable
    else
        cmd=disable
    fi

    obs-cmd scene-item $cmd Scene Code

    last=$window
done

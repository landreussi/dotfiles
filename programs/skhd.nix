super@{ pkgs, ... }:
{
    enable = true;
    skhdConfig = ''
        # focus window
        alt - h : yabai -m window --focus west
        alt - j : yabai -m window --focus south
        alt - k : yabai -m window --focus north
        alt - l : yabai -m window --focus east
        
        # move managed window
        shift + alt - h : yabai -m window --warp west
        shift + alt - j : yabai -m window --warp south
        shift + alt - k : yabai -m window --warp north
        shift + alt - l : yabai -m window --warp east
        
        # # balance size of windows
        # shift + alt - 0 : yabai -m space --balance
        # 
        # # make floating window fill screen
        shift + alt - up     : yabai -m window --grid 1:1:0:0:1:1
        # 
        # # make floating window fill left-half of screen
        shift + alt - left   : yabai -m window --grid 1:2:0:0:1:1
        # 
        # # create desktop, move window and follow focus - uses jq for parsing json (brew install jq)
        # shift + alt - n : yabai -m space --create && \
        #                   index="$(yabai -m query --spaces --display | jq 'map(select(."is-native-fullscreen" == false))[-1].index')" && \
        #                   yabai -m window --space "''${index}" && \
        #                   yabai -m space --focus "''${index}"
        # 
        # # fast focus desktop
        # cmd + alt - x : yabai -m space --focus recent
        # cmd + alt - 1 : yabai -m space --focus 1
        # 
        # # send window to desktop and follow focus
        # shift + cmd - z : yabai -m window --space next; yabai -m space --focus next
        # shift + cmd - 2 : yabai -m window --space  2; yabai -m space --focus 2
        # 
        # # focus monitor
        # ctrl + alt - z  : yabai -m display --focus prev
        # ctrl + alt - 3  : yabai -m display --focus 3
        
        # change into screens index
        alt + cmd - 1  : yabai -m window --display 1; yabai -m display --focus 1
        alt + cmd - 2  : yabai -m window --display 2; yabai -m display --focus 2
        alt + cmd - 3  : yabai -m window --display 3; yabai -m display --focus 3

        # change into screens relative
        alt + cmd - h  : yabai -m window --display next; yabai -m display --focus next
        alt + cmd - l  : yabai -m window --display prev; yabai -m display --focus prev

        # focus screens index
        ctrl + cmd - 1 : yabai -m display --focus 1
        ctrl + cmd - 2 : yabai -m display --focus 2
        ctrl + cmd - 3 : yabai -m display --focus 3

        # focus screens relative
        ctrl + cmd - h : yabai -m display --focus next
        ctrl + cmd - l : yabai -m display --focus prev
        
        # # move floating window
        # shift + ctrl - a : yabai -m window --move rel:-20:0
        # shift + ctrl - s : yabai -m window --move rel:0:20
        # 
        # # increase window size
        # shift + alt - a : yabai -m window --resize left:-20:0
        # shift + alt - w : yabai -m window --resize top:0:-20
        # 
        # # decrease window size
        # shift + cmd - s : yabai -m window --resize bottom:0:-20
        # shift + cmd - w : yabai -m window --resize top:0:20
        # 
        # # set insertion point in focused container
        # ctrl + alt - h : yabai -m window --insert west
        
        # toggle window zoom
        alt - f : yabai -m window --toggle zoom-fullscreen
        
        # # toggle window split type
        alt - e : yabai -m window --toggle split
        # 
        # # float / unfloat window and center on screen
        alt - t : yabai -m window --toggle float --grid 4:4:1:1:2:2
        # 
        # # toggle sticky(+float), topmost, picture-in-picture
        alt - p : yabai -m window --toggle sticky --toggle topmost --toggle pip
    '';
}


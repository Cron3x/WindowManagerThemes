## Change screen on awesome start

put xprofiles-rs in .config folder


- used config language RON (Rust Object Notification)
- identify the screens: 
```sh 
xrandr --prop | grep -A2 EDID
```

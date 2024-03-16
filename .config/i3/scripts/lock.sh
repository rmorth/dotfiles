img=/tmp/i3lock.png

scrot -o $img
convert $img -scale 2% -scale 10000% $img

i3lock -ei $img

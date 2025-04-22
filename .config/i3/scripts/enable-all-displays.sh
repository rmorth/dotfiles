#!/bin/bash

# List all connected outputs
outputs=($(xrandr | grep " connected" | awk '{ print $1 }'))

# Start at 0 for leftmost display
pos_x=0

# Loop through each output and enable it
for output in "${outputs[@]}"; do
    # Get preferred mode (first available mode line after the output name)
    mode=$(xrandr | grep -A1 "^$output connected" | tail -n1 | awk '{ print $1 }')

    # Skip if no mode found
    [ -z "$mode" ] && continue

    # Apply settings
    xrandr --output "$output" --mode "$mode" --pos "${pos_x}x0" --rotate normal

    # Update x position (assumes 1920 width if we can't get real width)
    width=$(xrandr | grep -A1 "^$output connected" | tail -n1 | awk '{ print $1 }' | cut -d'x' -f1)
    pos_x=$((pos_x + ${width:-1920}))
done


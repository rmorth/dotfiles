#!/usr/bin/env bash

if [ -z $1 ]
then
	echo "Missing path for the theme."
	exit 1
fi

echo "Using $1..."
rm ~/.config/kitty/theme.conf && ln -s $1 ~/.config/kitty/theme.conf

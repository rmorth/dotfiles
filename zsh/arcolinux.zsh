if [ "$(command -v hostnamectl)" ]; then
	if hostnamectl | grep -q 'arcolinux'; then
		#pacman unlock
		alias unlock="sudo rm /var/lib/pacman/db.lck"
		alias rmpacmanlock="sudo rm /var/lib/pacman/db.lck"

		#which graphical card is working
		alias whichvga="/usr/local/bin/arcolinux-which-vga"

		#Cleanup orphaned packages
		alias pacman-cleanup='sudo pacman -Rns $(pacman -Qtdq)'

		# Recent installed packages
		alias pacman-recent="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

		# Sort installed packages according to size in MB
		alias pacman-big="expac -H M '%m\t%n' | sort -h | nl"
	fi
fi

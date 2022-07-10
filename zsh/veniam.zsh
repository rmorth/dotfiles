if hostnamectl | grep -q 'veniam'; then
	getpass() {
		if [ -z "$1" ]
		then
			echo Needs DEVICE_ID
			return
		fi

		p=$(obu-pass "$1")
		echo $p | xclip
		echo $p
	}

	acc() {
		if [ -z "$1" ]
		then
			echo Needs DEVICE_ID
			return
		fi
		obu-pass "$1" | xclip
		obu-ssh  "$1"
	}

	obu() {
		if [ "$1" = "-p" ]
		then
			getpass $2
			return
		fi

		obu-ssh $1
	}
fi


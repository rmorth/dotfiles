if [ "$(command -v hostnamectl)" ]; then
	if hostnamectl | grep -q 'rmorgado-nx'; then
		if [ ! -z $MWYL_WORKSPACE ]; then
			export MWYL_SCRATCH_DIR=$MWYL_WORKSPACE/_tmp/scratches
			# source ~/.nexar-auth.zsh

			scratch() {
				vim $MWYL_SCRATCH_DIR/$(basename $(msepoch))
			}
		fi
	fi
fi

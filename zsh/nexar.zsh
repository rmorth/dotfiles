if [ "$(command -v hostnamectl)" ]; then
	if hostnamectl | grep -q 'rmorgado-nx'; then
		if [ ! -z $MWYL_WORKSPACE ]; then
			alias serial='(ls /dev/ttyUSB0 && minicom --color=on -D /dev/ttyUSB0) || echo '\''Serial device not detected'\'''
			alias serial2='(ls /dev/ttyUSB1 && minicom --color=on -D /dev/ttyUSB1) || echo '\''Serial device not detected'\'''
            alias pssh="sshpass -p 3690 ssh -o ConnectTimeout=2"
            alias pscp="sshpass -p 3690 scp -o ConnectTimeout=2"

            #alias make='make_helper'

			export MWYL_SCRATCH_DIR=$MWYL_WORKSPACE/tmp/scratches
            mkdir -p $MWYL_SCRATCH_DIR || echo "Failed to create $MWYL_SCRATCH_DIR"
			scratch() {
				vim $MWYL_SCRATCH_DIR/$(basename $(msepoch))
			}

            export MWYL_BUILD_DIR=$MWYL_WORKSPACE/tmp/builds
            mkdir -p $MWYL_BUILD_DIR || echo "Failed to create $MWYL_BUILD_DIR"

            aws-login() {
                local profile=$1
                local token_files=$(find $HOME/.aws/sso/cache/ -iname '*.json')

                while IFS= read -r file; do
                    if [[ -f "$file" ]]; then
                        local expiry=$(jq -r '.expiresAt' "$file" 2>/dev/null)
                        if [[ $? -eq 0 && $(date -d "$expiry" +%s) -gt $(date +%s) ]]; then
                            is_logged_in=$(aws sts get-caller-identity --profile "$profile" --query "Account" 2>/dev/null)
                            if [[ -z "$is_logged_in" ]]; then
                                echo "Logging in to $profile"
                                aws sso login --sso-session nx-session
                                return
                            else
                                echo "Already logged in to $profile"
                                return
                            fi
                        fi
                    fi
                done < <(find $HOME/.aws/sso/cache/ -iname '*.json')

                echo "Logging in to $profile"
                aws sso login --sso-session nx-session
            }

            aws-ops() {
                export AWS_PROFILE=fw-ops
                aws-login $AWS_PROFILE
            }

            aws-bfr() {
                export AWS_PROFILE=fw-bfr
                aws-login $AWS_PROFILE
            }

            make_helper() {
                UUID=$(uuidgen)
                export LAST_BUILD_UUID=$UUID

echo """
Build information:
-- BASIC --
- ID: ${UUID}
- Hostname: $(hostname)
- User: $(whoami)
- Start time: $(date)
- PWD: $(pwd)
- Command: make ${@}

-- GIT --
- Branch: $(git rev-parse --abbrev-ref HEAD)
- Commit: $(git rev-parse HEAD)
- Commit message: $(git log -1 --pretty=%B)
- Untracked Files: $(git ls-files --others --exclude-standard)
- Changed Files: $(git diff --name-only)
- Staged Files: $(git diff --name-only --cached)
- Submodules:
$(git submodule status)
----

""" | tee $MWYL_BUILD_DIR/$UUID.log

                make "$@"; local EXIT_CODE=$?
                if [ $EXIT_CODE -eq 0 ]; then
                    local icon="/usr/share/icons/Adwaita/64x64/status/software-update-urgent-symbolic.symbolic.png"
                    notify-send -u normal -i ${icon} -t 120000 "Build ${UUID}" "Build succeeded!"; sbell
                elif [ $EXIT_CODE -ne 0 ]; then
                    local icon="/usr/share/icons/Adwaita/64x64/emotes/face-sick-symbolic.symbolic.png"
                    notify-send -u critical -i ${icon} -t 120000 "Build ${UUID}" "Build failed!"; sbell
                fi

echo """
-- BUILD END --
- ID: ${UUID}
- End time: $(date)
- Exit code: ${EXIT_CODE}
----
""" | tee -a $MWYL_BUILD_DIR/$UUID.log
}

gzlogsOpenAt() {
	find $1 -type f -iname "*log*.gz" -exec sh -c 'cd $(dirname {}) && gzip -fd $(basename {})' \;
}
                return $EXIT_CODE
		fi
	fi
fi


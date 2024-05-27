if [ ! "$(command -v hostnamectl)" ]; then
    return
fi


if ! hostnamectl | grep -q 'rmorgado-nx'; then
    return
fi

if [ -z $MWYL_WORKSPACE ]; then
    echo "MWYL_WORKSPACE not set or empty, using default env variables"
    export MWYL_SCRATCH_DIR=/tmp/scratches
    export MWYL_BUILD_DIR=/tmp/builds
else
    export MWYL_SCRATCH_DIR=$MWYL_WORKSPACE/tmp/scratches
    export MWYL_BUILD_DIR=$MWYL_WORKSPACE/tmp/builds
fi

mkdir -p $MWYL_SCRATCH_DIR || echo "Failed to create $MWYL_SCRATCH_DIR"
mkdir -p $MWYL_BUILD_DIR || echo "Failed to create $MWYL_BUILD_DIR"

alias serial='(ls /dev/ttyUSB0 && tio usb0) || echo '\''Serial device not detected'\'''
alias serial2='(ls /dev/ttyUSB1 && usb1) || echo '\''Serial device not detected'\'''
alias pssh="sshpass -p 3690 ssh -o ConnectTimeout=2"
alias pscp="sshpass -p 3690 scp -o ConnectTimeout=2"

alias bmake='make_helper'
alias lastbuild='cat $LAST_BUILD_FILE'

scratch() {
    vim $MWYL_SCRATCH_DIR/$(basename $(msepoch))
}

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

gzlogsOpenAt() {
	find $1 -type f -iname "*log*.gz" -exec sh -c 'cd $(dirname {}) && gzip -fd $(basename {})' \;
}

make_helper() {
    local UUID=$(uuidgen)
    export LAST_BUILD_UUID=$UUID
    export LAST_BUILD_FILE=$MWYL_BUILD_DIR/$LAST_BUILD_UUID.log
    touch $LAST_BUILD_FILE || echo "Failed to create $LAST_BUILD_FILE"

    _build_start_info "$@"

    # Run make and capture its output to a temp file, while preserving the exit code
    local TMP_FILE="tmp_build.txt"
    make "$@" | tee $TMP_FILE
    local EXIT_CODE=${pipestatus[1]} # Captures the exit code of the make command, not tee
    echo "Exit code: $EXIT_CODE"

    # Grep for errors or warnings and append them to a file
    grep --after-context=2 -iE "error|warning" $TMP_FILE >> $LAST_BUILD_FILE
    rm $TMP_FILE > /dev/null 2>&1 || echo "Failed to remove $TMP_FILE"

    if [ $EXIT_CODE -eq 0 ]; then
        local icon="/usr/share/icons/Adwaita/64x64/status/software-update-urgent-symbolic.symbolic.png"
        notify-send -u normal -i ${icon} -t 120000 "Build ${UUID}" "Build succeeded!"; sbell
    elif [ $EXIT_CODE -ne 0 ]; then
        local icon="/usr/share/icons/Adwaita/64x64/emotes/face-sick-symbolic.symbolic.png"
        notify-send -u critical -i ${icon} -t 120000 "Build ${UUID}" "Build failed!"; sbell
    fi

    _build_end_info

    return $EXIT_CODE
}

_build_start_info() {
echo """
Build information:
-- BASIC --
- ID: ${LAST_BUILD_UUID}
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

""" | tee -a $LAST_BUILD_FILE
}

_build_end_info() {
echo """
-- BUILD END --
- ID: ${LAST_BUILD_UUID}
- End time: $(date)
- Exit code: ${EXIT_CODE}
----
""" | tee -a $LAST_BUILD_FILE
}

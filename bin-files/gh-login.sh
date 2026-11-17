#!/usr/bin/env bash
# gh-login: log the GitHub CLI in with a token kept in an age-encrypted file, and log
# out again automatically after a while. Run `gh-login --help` for the options.
set -euo pipefail

usage() {
    cat <<'EOF'
Usage: gh-login [MINUTES]
       gh-login --setup
       gh-login --cancel
       gh-login --help

Log the GitHub CLI (gh) in with a token stored in an encrypted file, then log out
automatically after MINUTES minutes.

Options:
  MINUTES   how long to stay logged in, in whole minutes (default: 10)
  --setup   encrypt a GitHub token into ~/.config/gh-token.age. Asks for the token
            (hidden as you paste) and a passphrase to protect it. If the file
            already exists, asks before replacing it.
  --cancel  cancel the scheduled automatic logout; you stay logged in until you
            run `gh auth logout`
  --help    show this help

Logging in asks for the passphrase, logs gh in, shows `gh auth status`, and starts
a background timer that runs `gh auth logout` when time is up. Logging in again
replaces the earlier timer with a new one. Log out early with:
  gh auth logout --hostname github.com

Note: logging out only deletes this computer's copy of the token. Anything that
copied it while you were logged in can keep using it until the token expires or
you revoke it on GitHub (Settings > Developer settings > Personal access tokens).

Needs: gh and age.
EOF
}

die() {
    echo "gh-login: $*" >&2
    exit 1
}

require() {
    command -v "$1" >/dev/null || die "$1 is not installed"
}

setup() {
    local token_file=$1
    require age

    if [ -e "$token_file" ]; then
        local answer
        read -rp "$token_file already exists. Replace it? [y/N] " answer
        [[ $answer == [yY]* ]] || die "kept the existing token file"
    fi

    local token
    read -rsp "Paste the GitHub token (hidden): " token
    echo
    [ -n "$token" ] || die "no token entered"

    mkdir -p "$(dirname "$token_file")"
    # write to a temporary file first, so a failed or cancelled run never leaves a
    # broken token file behind; umask keeps it readable only by you
    local temp_file
    temp_file=$(umask 077 && mktemp "$token_file.XXXXXX")
    echo "Choose a passphrase to protect the token:"
    if ! printf %s "$token" | age --passphrase --output "$temp_file"; then
        rm -f "$temp_file"
        die "encryption failed; nothing was changed"
    fi
    unset token
    mv "$temp_file" "$token_file"
    chmod 600 "$token_file"
    echo "Saved the encrypted token to $token_file"
}

cancel_logout() {
    local pid_file=$1
    if [ -f "$pid_file" ] && kill "$(cat "$pid_file")" 2>/dev/null; then
      echo "Cancelled scheduled logout";
    else
      echo "No scheduled logout to cancel";
    fi
    rm -f "$pid_file"
}

login() {
    local token_file=$1
    local minutes=$2
    local pid_file=$3
    require gh
    require age
    [ -f "$token_file" ] || die "no token file at $token_file; run: gh-login --setup"

    local secret
    secret=$(age -d "$token_file") || die "could not decrypt $token_file"
    printf %s "$secret" | gh auth login --with-token
    unset secret
    gh auth status

    # log out in the background when time is up; this script returns right away
    nohup sh -c "sleep $((minutes * 60)); gh auth logout --hostname github.com; rm -f $pid_file" \
        >/dev/null 2>&1 &
    local current_pid="$!"
    cancel_logout "$pid_file" > /dev/null
    echo "$current_pid" > "$pid_file"
    echo "Logged in. gh will log out automatically in $minutes minutes (or run: gh auth logout)"
}

main() {
    local token_file="$HOME/.config/gh-token.age"
    local pid_file="${XDG_RUNTIME_DIR:-$HOME/.cache}/gh-login-logout.pid"

    if [ $# -gt 1 ]; then
        usage >&2
        exit 2
    fi

    case "${1:-10}" in
        --help | -h)
            usage
            ;;
        --setup)
            setup "$token_file"
            ;;
        --cancel)
            cancel_logout "$pid_file"
            ;;
        *[!0-9]* | 0*)
            echo "gh-login: not a number of minutes or an option: $1" >&2
            usage >&2
            exit 2
            ;;
        *)
            login "$token_file" "${1:-10}" "$pid_file"
            ;;
    esac
}

main "$@"

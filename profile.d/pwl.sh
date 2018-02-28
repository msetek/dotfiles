
pwl() {
    local -r TERM="$1"
    if [[ -z "$TERM" ]]; then
        echo "no term given" >&2
        return
    fi

    pwsafe --list -l | egrep -i $TERM
}

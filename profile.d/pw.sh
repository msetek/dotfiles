
pw() {
    local -r ENTRY="$1"
    if [[ -z "$ENTRY" ]]; then
        echo "no entry given" >&2
        return
    fi

    pwsafe --quiet --password --echo "$ENTRY" | pbcopy
}
